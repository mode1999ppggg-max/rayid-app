
"use strict";

const express = require("express");
const helmet = require("helmet");
const crypto = require("crypto");

const { initializeApp, cert, getApps } = require("firebase-admin/app");
const { getFirestore, Timestamp } = require("firebase-admin/firestore");
const { getAuth } = require("firebase-admin/auth");

const app = express();

app.disable("x-powered-by");
app.set("trust proxy", 1);
app.use(helmet());
app.use(express.json({ limit: "10kb", strict: true }));

app.use((req, res, next) => {
  if (req.path.startsWith("/auth/")) {
    res.set("Cache-Control", "no-store, no-cache, must-revalidate, private");
    res.set("Pragma", "no-cache");
  }
  next();
});

const PORT = Number.parseInt(process.env.PORT || "3000", 10);

const OTP_LIFETIME_MS = 60 * 1000;
const RESEND_COOLDOWN_MS = 60 * 1000;
const OTP_MAX_ATTEMPTS = 5;
const OTP_MAX_PER_HOUR = 5;
const IP_MAX_PER_HOUR = 30;
const GRANT_LIFETIME_MS = 5 * 60 * 1000;
const GRANT_PROCESSING_MS = 60 * 1000;

function requiredEnv(name) {
  const value = process.env[name];

  if (typeof value !== "string" || value.trim() === "") {
    throw new Error(`Missing environment variable: ${name}`);
  }

  return value;
}

const OTP_HMAC_SECRET = requiredEnv("OTP_HMAC_SECRET");
const RESEND_API_KEY = requiredEnv("RESEND_API_KEY");
const RESEND_FROM_EMAIL = requiredEnv("RESEND_FROM_EMAIL");

if (Buffer.byteLength(OTP_HMAC_SECRET, "utf8") < 32) {
  throw new Error("OTP_HMAC_SECRET must contain at least 32 bytes");
}

if (!/^\S+@\S+\.\S+$/.test(RESEND_FROM_EMAIL)) {
  throw new Error("RESEND_FROM_EMAIL must be a valid email address");
}

if (!Number.isInteger(PORT) || PORT < 1 || PORT > 65535) {
  throw new Error("PORT is invalid");
}

let serviceAccount;

try {
  if (process.env.FIREBASE_SERVICE_ACCOUNT_JSON) {
    const parsed = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_JSON);

    serviceAccount = {
      projectId: parsed.projectId || parsed.project_id,
      clientEmail: parsed.clientEmail || parsed.client_email,
      privateKey: parsed.privateKey || parsed.private_key
    };
  } else {
    serviceAccount = {
      projectId: requiredEnv("FIREBASE_PROJECT_ID"),
      clientEmail: requiredEnv("FIREBASE_CLIENT_EMAIL"),
      privateKey: requiredEnv("FIREBASE_PRIVATE_KEY")
    };
  }
} catch {
  throw new Error("Firebase service account configuration is invalid");
}

if (
  !serviceAccount ||
  typeof serviceAccount.projectId !== "string" ||
  typeof serviceAccount.clientEmail !== "string" ||
  typeof serviceAccount.privateKey !== "string" ||
  !serviceAccount.projectId ||
  !serviceAccount.clientEmail ||
  !serviceAccount.privateKey
) {
  throw new Error("Firebase service account fields are missing");
}

serviceAccount.privateKey = serviceAccount.privateKey.replace(/\\n/g, "\n");

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

function safeEqualHex(firstHex, secondHex) {
  if (
    typeof firstHex !== "string" ||
    typeof secondHex !== "string" ||
    !/^[a-f0-9]{64}$/i.test(firstHex) ||
    !/^[a-f0-9]{64}$/i.test(secondHex)
  ) {
    return false;
  }

  const first = Buffer.from(firstHex, "hex");
  const second = Buffer.from(secondHex, "hex");

  return crypto.timingSafeEqual(first, second);
}

function httpError(status, message) {
  const error = new Error(message);
  error.status = status;
  return error;
}

function normalizeEmail(email) {
  if (typeof email !== "string") {
    throw httpError(400, "البريد الإلكتروني غير صالح");
  }

  const value = email.trim().toLowerCase();

  if (
    value.length > 254 ||
    !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)
  ) {
    throw httpError(400, "البريد الإلكتروني غير صالح");
  }

  return value;
}

function generateOtp() {
  return crypto.randomInt(0, 1000000).toString().padStart(6, "0");
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

  const result = await response.json();

  if (!response.ok) {
    console.error("Resend API error:", {
      status: response.status,
      message: result.message,
      name: result.name
    });

    throw new Error("Email delivery failed");
  }

  console.log("RAYID email accepted by Resend:", result.id);
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
// فحص اتصال Firestore
app.get("/health/firestore", asyncRoute(async (req, res) => {
  await db.collection("_healthChecks").limit(1).get();

  res.status(200).json({
    success: true,
    firestore: "connected"
  });
}));

// طلب رمز استعادة كلمة المرور
app.post(
  "/auth/request-password-reset-otp",
  asyncRoute(async (req, res) => {
    const email = normalizeEmail(req.body?.email);
    const emailHash = hashValue(`email:${email}`);

    const ip = req.ip || req.socket.remoteAddress || "unknown";
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

    const allowed = await db.runTransaction(async (transaction) => {
      const [emailSnapshot, ipSnapshot] = await Promise.all([
        transaction.get(emailRateRef),
        transaction.get(ipRateRef)
      ]);

      const emailData = emailSnapshot.exists ? emailSnapshot.data() : {};
      const ipData = ipSnapshot.exists ? ipSnapshot.data() : {};

      const emailStart = emailData.windowStart?.toMillis?.() || 0;
      const ipStart = ipData.windowStart?.toMillis?.() || 0;

      const emailActive = now - emailStart < 60 * 60 * 1000;
      const ipActive = now - ipStart < 60 * 60 * 1000;

      const emailCount = emailActive ? (emailData.count || 0) : 0;
      const ipCount = ipActive ? (ipData.count || 0) : 0;
      const lastSent = emailData.lastSentAt?.toMillis?.() || 0;

      if (
        emailCount >= OTP_MAX_PER_HOUR ||
        ipCount >= IP_MAX_PER_HOUR ||
        now - lastSent < RESEND_COOLDOWN_MS
      ) {
        return false;
      }

      transaction.set(emailRateRef, {
        count: emailCount + 1,
        windowStart: Timestamp.fromMillis(emailCount === 0 ? now : emailStart),
        lastSentAt: Timestamp.fromMillis(now)
      });

      transaction.set(ipRateRef, {
        count: ipCount + 1,
        windowStart: Timestamp.fromMillis(ipCount === 0 ? now : ipStart)
      });

      if (userRecord) {
        transaction.set(otpRef, {
          uid: userRecord.uid,
          otpHash,
          challengeId,
          attempts: 0,
          expiresAt: Timestamp.fromMillis(now + OTP_LIFETIME_MS)
        });
      }

      return true;
    });

    if (!allowed || !userRecord) {
      return res.status(200).json(genericResponse);
    }

    try {
      await sendOtpEmail(email, otp);
      return res.status(200).json(genericResponse);
    } catch {
      const snapshot = await otpRef.get();

      if (snapshot.exists && snapshot.data().challengeId === challengeId) {
        await otpRef.delete();
      }

      console.error("RAYID email delivery failed");

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

      if (!data.expiresAt || data.expiresAt.toMillis() <= now) {
        transaction.delete(otpRef);
        return "expired";
      }

      if (!Number.isInteger(data.attempts) || data.attempts >= OTP_MAX_ATTEMPTS) {
        transaction.delete(otpRef);
        return "locked";
      }

      if (!safeEqualHex(submittedHash, data.otpHash)) {
        const nextAttempts = data.attempts + 1;

        if (nextAttempts >= OTP_MAX_ATTEMPTS) {
          transaction.delete(otpRef);
          return "locked";
        }

        transaction.update(otpRef, { attempts: nextAttempts });
        return "wrong";
      }

      transaction.create(grantRef, {
        uid: data.uid,
        emailHash,
        status: "pending",
        createdAt: Timestamp.fromMillis(now),
        expiresAt: Timestamp.fromMillis(now + GRANT_LIFETIME_MS)
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

    const now = Date.now();
    const claimId = crypto.randomUUID();

    // حجز التصريح مؤقتاً لمنع الطلبات المتزامنة
    const uid = await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(grantRef);

      if (!snapshot.exists) return null;

      const grant = snapshot.data();

      if (
        grant.emailHash !== emailHash ||
        !grant.expiresAt ||
        grant.expiresAt.toMillis() <= now
      ) {
        transaction.delete(grantRef);
        return null;
      }

      const processingUntil = grant.processingUntil?.toMillis?.() || 0;

      if (
        grant.status === "processing" &&
        processingUntil > now
      ) {
        return null;
      }

      if (grant.status !== "pending" && grant.status !== "processing") {
        return null;
      }

      transaction.update(grantRef, {
        status: "processing",
        claimId,
        processingUntil: Timestamp.fromMillis(now + GRANT_PROCESSING_MS)
      });

      return grant.uid;
    });

    if (!uid) {
      return res.status(403).json({
        success: false,
        message: "التصريح غير صالح أو مستخدم حالياً"
      });
    }

    try {
      const user = await auth.getUser(uid);

      if (!user.email || user.email.toLowerCase() !== email) {
        throw httpError(403, "تعذر التحقق من الحساب");
      }

      await auth.updateUser(uid, {
        password: newPassword
      });

      // حذف التصريح بعد نجاح تغيير كلمة المرور
      await db.runTransaction(async (transaction) => {
        const snapshot = await transaction.get(grantRef);

        if (
          snapshot.exists &&
          snapshot.data().claimId === claimId
        ) {
          transaction.delete(grantRef);
        }
      });

      let sessionsRevoked = true;

      try {
        await auth.revokeRefreshTokens(uid);
      } catch {
        sessionsRevoked = false;
        console.error("RAYID password changed; session revocation failed");
      }

      return res.status(200).json({
        success: true,
        message: "تم تغيير كلمة المرور بنجاح",
        sessionsRevoked
      });
    } catch (error) {
      // إعادة التصريح إلى الحالة السابقة إذا فشل التحديث
      await db.runTransaction(async (transaction) => {
        const snapshot = await transaction.get(grantRef);

        if (
          snapshot.exists &&
          snapshot.data().claimId === claimId
        ) {
          transaction.update(grantRef, {
            status: "pending",
            claimId: null,
            processingUntil: null
          });
        }
      });

      throw error;
    }
  })
);

// المسارات غير الموجودة
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: "المسار غير موجود"
  });
});

// معالجة الأخطاء
app.use((error, req, res, next) => {
  const status = Number.isInteger(error.status) ? error.status : 500;

  if (status >= 500) {
    console.error("RAYID API request failed");
  }

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
