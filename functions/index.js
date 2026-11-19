
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, Timestamp } = require("firebase-admin/firestore");
const { getAuth } = require("firebase-admin/auth");
const crypto = require("crypto");

initializeApp();

const db = getFirestore();
const auth = getAuth();

const RESEND_API_KEY = defineSecret("RESEND_API_KEY");
const RESEND_FROM_EMAIL = defineSecret("RESEND_FROM_EMAIL");
const OTP_HMAC_SECRET = defineSecret("OTP_HMAC_SECRET");

const OTP_LIFETIME = 60 * 1000;
const RESEND_COOLDOWN = 60 * 1000;
const OTP_MAX_ATTEMPTS = 5;
const OTP_MAX_PER_HOUR = 5;
const IP_MAX_PER_HOUR = 30;
const GRANT_LIFETIME = 5 * 60 * 1000;

function requireUser(request) {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "يجب تسجيل الدخول أولاً");
  }
  return request.auth.uid;
}

function generateOtp() {
  return crypto.randomInt(0, 1000000).toString().padStart(6, "0");
}

function hashValue(value) {
  return crypto
    .createHmac("sha256", OTP_HMAC_SECRET.value())
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
    throw new HttpsError("invalid-argument", "البريد الإلكتروني غير صالح");
  }

  const value = email.trim().toLowerCase();

  if (
    value.length > 254 ||
    !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)
  ) {
    throw new HttpsError("invalid-argument", "البريد الإلكتروني غير صالح");
  }

  return value;
}

async function sendOtpEmail(email, otp) {
  const response = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${RESEND_API_KEY.value()}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      from: RESEND_FROM_EMAIL.value(),
      to: [email],
      subject: "RAYID PAY - رمز استعادة كلمة المرور",
      text:
        `رمز التحقق الخاص بك هو: ${otp}\n\n` +
        "صلاحية الرمز 60 ثانية. لا تشاركه مع أي شخص."
    })
  });

  if (!response.ok) {
    throw new Error("Resend email delivery failed");
  }
}

// طلب رمز استعادة كلمة المرور
exports.requestPasswordResetOtp = onCall(
  {
    secrets: [
      RESEND_API_KEY,
      RESEND_FROM_EMAIL,
      OTP_HMAC_SECRET
    ],
    maxInstances: 10
  },
  async (request) => {
    const email = normalizeEmail(request.data?.email);
    const emailHash = hashValue(`email:${email}`);

    const ip = request.rawRequest?.ip || "unknown";
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
        throw new HttpsError("internal", "تعذر معالجة الطلب");
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
      return genericResponse;
    }

    try {
      await sendOtpEmail(email, otp);
      return genericResponse;
    } catch (error) {
      const snapshot = await otpRef.get();

      if (
        snapshot.exists &&
        snapshot.data().challengeId === challengeId
      ) {
        await otpRef.delete();
      }

      throw new HttpsError(
        "unavailable",
        "تعذر إرسال الرمز حالياً. حاول لاحقاً."
      );
    }
  }
);

// التحقق من الرمز وإصدار تصريح مؤقت
exports.verifyPasswordResetOtp = onCall(
  {
    secrets: [OTP_HMAC_SECRET],
    maxInstances: 10
  },
  async (request) => {
    const email = normalizeEmail(request.data?.email);
    const otp = request.data?.otp;

    if (typeof otp !== "string" || !/^\d{6}$/.test(otp)) {
      throw new HttpsError("invalid-argument", "رمز التحقق غير صالح");
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

      if (!snapshot.exists) {
        return "missing";
      }

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
      throw new HttpsError(
        "permission-denied",
        result === "expired"
          ? "انتهت صلاحية الرمز"
          : result === "locked"
            ? "تجاوزت عدد المحاولات"
            : "رمز التحقق غير صحيح أو غير صالح"
      );
    }

    return {
      success: true,
      resetToken,
      expiresInSeconds: 300
    };
  }
);

// تغيير كلمة المرور بعد التحقق
exports.completePasswordReset = onCall(
  {
    secrets: [OTP_HMAC_SECRET],
    maxInstances: 10
  },
  async (request) => {
    const email = normalizeEmail(request.data?.email);
    const resetToken = request.data?.resetToken;
    const newPassword = request.data?.newPassword;

    if (
      typeof resetToken !== "string" ||
      !/^[a-f0-9]{64}$/.test(resetToken)
    ) {
      throw new HttpsError("invalid-argument", "التصريح غير صالح");
    }

    if (
      typeof newPassword !== "string" ||
      newPassword.length < 8 ||
      newPassword.length > 128
    ) {
      throw new HttpsError(
        "invalid-argument",
        "كلمة المرور يجب أن تكون 8 أحرف على الأقل"
      );
    }

    const emailHash = hashValue(`email:${email}`);
    const grantHash = hashValue(`grant:${resetToken}`);
    const grantRef = db.collection("passwordResetGrants").doc(grantHash);

    const uid = await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(grantRef);

      if (!snapshot.exists) {
        return null;
      }

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
      throw new HttpsError("permission-denied", "التصريح غير صالح أو منتهي");
    }

    try {
      const user = await auth.getUser(uid);

      if (user.email?.toLowerCase() !== email) {
        throw new HttpsError("permission-denied", "تعذر التحقق من الحساب");
      }

      await auth.updateUser(uid, {
        password: newPassword
      });

      return {
        success: true,
        message: "تم تغيير كلمة المرور بنجاح"
      };
    } catch (error) {
      if (error instanceof HttpsError) throw error;
      throw new HttpsError("internal", "تعذر تغيير كلمة المرور");
    }
  }
);

// قراءة النقاط من الخادم
exports.getMyPoints = onCall(async (request) => {
  const uid = requireUser(request);

  const userRef = db.collection("users").doc(uid);
  const snapshot = await userRef.get();

  if (!snapshot.exists) {
    throw new HttpsError("not-found", "الحساب غير موجود");
  }

  const points = snapshot.get("points");

  return {
    points: Number.isSafeInteger(points) && points >= 0
      ? points
      : 0
  };
});
