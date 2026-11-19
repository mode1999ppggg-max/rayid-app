
"use strict";

const express = require("express");
const helmet = require("helmet");
const crypto = require("crypto");

const {
  initializeApp,
  cert,
  getApps
} = require("firebase-admin/app");

const {
  getFirestore,
  Timestamp
} = require("firebase-admin/firestore");

const { getAuth } = require("firebase-admin/auth");

const app = express();

app.disable("x-powered-by");
app.set("trust proxy", 1);

app.use(helmet());
app.use(express.json({ limit: "10kb" }));

const PORT = process.env.PORT || 3000;

const OTP_LIFETIME = 60 * 1000;
const RESEND_COOLDOWN = 60 * 1000;
const OTP_MAX_ATTEMPTS = 5;
const OTP_MAX_PER_HOUR = 5;
const IP_MAX_PER_HOUR = 30;
const GRANT_LIFETIME = 5 * 60 * 1000;

function requiredEnv(name) {
  const value = process.env[name];
  if (!value) throw new Error(`Missing environment variable: ${name}`);
  return value;
}

const OTP_HMAC_SECRET = requiredEnv("OTP_HMAC_SECRET");
const RESEND_API_KEY = requiredEnv("RESEND_API_KEY");
const RESEND_FROM_EMAIL = requiredEnv("RESEND_FROM_EMAIL");

if (OTP_HMAC_SECRET.length < 32) {
  throw new Error("OTP_HMAC_SECRET must be at least 32 characters");
}

let serviceAccount;

if (process.env.FIREBASE_SERVICE_ACCOUNT_JSON) {
  serviceAccount = JSON.parse(
    process.env.FIREBASE_SERVICE_ACCOUNT_JSON
  );
} else {
  serviceAccount = {
    projectId: requiredEnv("FIREBASE_PROJECT_ID"),
    clientEmail: requiredEnv("FIREBASE_CLIENT_EMAIL"),
    privateKey: requiredEnv("FIREBASE_PRIVATE_KEY").replace(/\\n/g, "\n")
  };
}

if (!getApps().length) {
  initializeApp({
    credential: cert(serviceAccount)
  });
}

const db = getFirestore();
const auth = getAuth();

function hashValue(value) {
  return crypto
    .createHmac("sha256", OTP_HMAC_SECRET)
    .update(value)
    .digest("hex");
}

function safeEqual(a, b) {
  const first = Buffer.from(a, "hex");
  const second = Buffer.from(b, "hex");

  return first.length === second.length &&
    crypto.timingSafeEqual(first, second);
}

function normalizeEmail(email) {
  if (typeof email !== "string") {
    const error = new Error("البريد الإلكتروني غير صالح");
    error.status = 400;
    throw error;
  }

  const value = email.trim().toLowerCase();

  if (
    value.length > 254 ||
    !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)
  ) {
    const error = new Error("البريد الإلكتروني غير صالح");
    error.status = 400;
    throw error;
  }

  return value;
}

function generateOtp() {
  return crypto.randomInt(0, 1000000)
    .toString()
    .padStart(6, "0");
}

async function sendOtpEmail(email, otp) {
  const response = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${RESEND_API_KEY}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      from: RESEND_FROM_EMAIL,
      to: [email],
      subject: "RAYID PAY - رمز استعادة كلمة المرور",
      text:
        `رمز التحقق الخاص بك هو: ${otp}\n\n` +
        "صلاحية الرمز 60 ثانية. لا تشاركه مع أي شخص."
    })
  });

  if (!response.ok) {
    throw new Error("Email delivery failed");
  }
}

function asyncRoute(handler) {
  return (req, res, next) => {
    Promise.resolve(handler(req, res, next)).catch(next);
  };
}

// فحص صحة الخادم
app.get("/health", (req, res) => {
  res.status(200).json({
    success: true,
    service: "RAYID PAY Backend",
    status: "healthy"
  });
});

// طلب رمز استعادة كلمة المرور
app.post(
  "/auth/request-password-reset-otp",
  asyncRoute(async (req, res) => {
    const email = normalizeEmail(req.body?.email);
    const emailHash = hashValue(`email:${email}`);

    const ip = req.ip || "unknown";
    const ipHash = hashValue(`ip:${ip}`);

    const otpRef = db.collection("passwordResetOtps").doc(emailHash);
    const emailRateRef = db.collection("passwordResetEmailLimits").doc(emailHash);
    const ipRateRef = db.collection("passwordResetIpLimits").doc(ipHash);

    const now = Date.now();
    const otp = generateOtp();
    const challengeId = crypto.randomUUID();
    const otpHash = hashValue(`otp:${email}:${otp}`);

    const genericResponse = {
      success: true,
      message: "إذا كان البريد مسجلاً، فستصلك تعليمات التحقق."
    };

    let userRecord = null;

    try {
      userRecord = await auth.getUserByEmail(email);
    } catch (error) {
      if (error.code !== "auth/user-not-found") {
        throw error;
      }
    }

    const rateResult = await db.runTransaction(async (transaction) => {
      const emailSnapshot = await transaction.get(emailRateRef);
      const ipSnapshot = await transaction.get(ipRateRef);

      const emailData = emailSnapshot.exists ? emailSnapshot.data() : {};
      const ipData = ipSnapshot.exists ? ipSnapshot.data() : {};

      const emailStart = emailData.windowStart?.toMillis?.() || 0;
      const ipStart = ipData.windowStart?.toMillis?.() || 0;

      const emailCount = now - emailStart < 60 * 60 * 1000
        ? (emailData.count || 0)
        : 0;

      const ipCount = now - ipStart < 60 * 60 * 1000
        ? (ipData.count || 0)
        : 0;

      const lastSent = emailData.lastSentAt?.toMillis?.() || 0;

      if (
        emailCount >= OTP_MAX_PER_HOUR ||
        ipCount >= IP_MAX_PER_HOUR ||
        now - lastSent < RESEND_COOLDOWN
      ) {
        return false;
      }

      transaction.set(emailRateRef, {
        count: emailCount + 1,
        windowStart: Timestamp.fromMillis(
          emailCount === 0 ? now : emailStart
        ),
        lastSentAt: Timestamp.fromMillis(now)
      });

      transaction.set(ipRateRef, {
        count: ipCount + 1,
        windowStart: Timestamp.fromMillis(
          ipCount === 0 ? now : ipStart
        )
      });

      if (userRecord) {
        transaction.set(otpRef, {
          uid: userRecord.uid,
          otpHash,
          challengeId,
          attempts: 0,
          expiresAt: Timestamp.fromMillis(now + OTP_LIFETIME)
        });
      }

      return true;
    });

    if (!rateResult || !userRecord) {
      return res.status(200).json(genericResponse);
    }

    try {
      await sendOtpEmail(email, otp);
      return res.status(200).json(genericResponse);
    } catch (error) {
      const snapshot = await otpRef.get();

      if (
        snapshot.exists &&
        snapshot.data().challengeId === challengeId
      ) {
        await otpRef.delete();
      }

      return res.status(503).json({
        success: false,
        message: "تعذر إرسال الرمز حالياً. حاول لاحقاً."
      });
    }
  })
);

// التحقق من رمز OTP
app.post(
  "/auth/verify-password-reset-otp",
  asyncRoute(async (req, res) => {
    const email = normalizeEmail(req.body?.email);
    const otp = req.body?.otp;

    if (typeof otp !== "string" || !/^\d{6}$/.test(otp)) {
      return res.status(400).json({
        success: false,
        message: "رمز التحقق غير صالح"
      });
    }

    const emailHash = hashValue(`email:${email}`);
    const otpRef = db.collection("passwordResetOtps").doc(emailHash);

    const resetToken = crypto.randomBytes(32).toString("hex");
    const grantHash = hashValue(`grant:${resetToken}`);
    const grantRef = db.collection("passwordResetGrants").doc(grantHash);

    const now = Date.now();
    const submittedHash = hashValue(`otp:${email}:${otp}`);

    const result = await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(otpRef);

      if (!snapshot.exists) return "missing";

      const data = snapshot.data();

      if (data.expiresAt.toMillis() <= now) {
        transaction.delete(otpRef);
        return "expired";
      }

      if (data.attempts >= OTP_MAX_ATTEMPTS) {
        transaction.delete(otpRef);
        return "locked";
      }

      if (!safeEqual(submittedHash, data.otpHash)) {
        const nextAttempts = data.attempts + 1;

        if (nextAttempts >= OTP_MAX_ATTEMPTS) {
          transaction.delete(otpRef);
          return "locked";
        }

        transaction.update(otpRef, {
          attempts: nextAttempts
        });

        return "wrong";
      }

      transaction.create(grantRef, {
        uid: data.uid,
        emailHash,
        expiresAt: Timestamp.fromMillis(now + GRANT_LIFETIME)
      });

      transaction.delete(otpRef);
      return "verified";
    });

    if (result !== "verified") {
      const message = result === "expired"
        ? "انتهت صلاحية الرمز"
        : result === "locked"
          ? "تجاوزت عدد المحاولات"
          : "رمز التحقق غير صحيح أو غير صالح";

      return res.status(403).json({
        success: false,
        message
      });
    }

    return res.status(200).json({
      success: true,
      resetToken,
      expiresInSeconds: 300
    });
  })
);

// إكمال تغيير كلمة المرور
app.post(
  "/auth/complete-password-reset",
  asyncRoute(async (req, res) => {
    const email = normalizeEmail(req.body?.email);
    const resetToken = req.body?.resetToken;
    const newPassword = req.body?.newPassword;

    if (
      typeof resetToken !== "string" ||
      !/^[a-f0-9]{64}$/.test(resetToken)
    ) {
      return res.status(400).json({
        success: false,
        message: "التصريح غير صالح"
      });
    }

    if (
      typeof newPassword !== "string" ||
      newPassword.length < 8 ||
      newPassword.length > 128
    ) {
      return res.status(400).json({
        success: false,
        message: "كلمة المرور يجب أن تكون 8 أحرف على الأقل"
      });
    }

    const emailHash = hashValue(`email:${email}`);
    const grantHash = hashValue(`grant:${resetToken}`);
    const grantRef = db.collection("passwordResetGrants").doc(grantHash);

    const uid = await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(grantRef);

      if (!snapshot.exists) return null;

      const grant = snapshot.data();

      if (
        grant.emailHash !== emailHash ||
        grant.expiresAt.toMillis() <= Date.now()
      ) {
        transaction.delete(grantRef);
        return null;
      }

      transaction.delete(grantRef);
      return grant.uid;
    });

    if (!uid) {
      return res.status(403).json({
        success: false,
        message: "التصريح غير صالح أو منتهي"
      });
    }

    const user = await auth.getUser(uid);

    if (user.email?.toLowerCase() !== email) {
      return res.status(403).json({
        success: false,
        message: "تعذر التحقق من الحساب"
      });
    }

    await auth.updateUser(uid, {
      password: newPassword
    });

    await auth.revokeRefreshTokens(uid);

    return res.status(200).json({
      success: true,
      message: "تم تغيير كلمة المرور بنجاح"
    });
  })
);

// معالجة الأخطاء
app.use((error, req, res, next) => {
  console.error("RAYID API error:", error.message);

  const status = Number.isInteger(error.status)
    ? error.status
    : 500;

  res.status(status).json({
    success: false,
    message: status >= 500
      ? "حدث خطأ في الخادم. حاول لاحقاً."
      : error.message
  });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`RAYID PAY backend listening on port ${PORT}`);
});
