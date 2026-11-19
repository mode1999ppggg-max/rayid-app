const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const crypto = require("crypto");
initializeApp();

const db = getFirestore();

// فحص هوية المستخدم وتسجيل الدخول
function requireUser(request) {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "يجب تسجيل الدخول أولاً"
    );
  }

  return request.auth.uid;
}

// قراءة رصيد النقاط من الخادم فقط
exports.getMyPoints = onCall(async (request) => {
  const uid = requireUser(request);

  const userRef = db.collection("users").doc(uid);
 // إنشاء رمز تحقق عشوائي من 6 أرقام
function generateOtp() {
  return crypto.randomInt(0, 1000000)
    .toString()
    .padStart(6, "0");
}
  const snapshot = await userRef.get();

  if (!snapshot.exists) {
    throw new HttpsError(
      "not-found",
      "الحساب غير موجود"
    );
  }

  const points = snapshot.get("points");

  return {
    points: Number.isSafeInteger(points) && points >= 0
      ? points
      : 0
  };
});

// لا توجد حالياً دالة تمنح نقاطاً من طلب الهاتف.
// سنضيف منح المكافآت بعد ربط إثبات الإعلانات والتحقق منه خادمياً.
