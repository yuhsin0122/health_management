import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const db = admin.firestore();
const auth = admin.auth();

/**
 * 用戶註冊 Cloud Function
 */
export const registerUser = functions.https.onCall(async (data: any) => {
  try {
    const {email, password, name, phone} = data;

    // 1. 驗證輸入
    if (!email || !password) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Email 和密碼為必填欄位"
      );
    }

    // 驗證 Email 格式
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Email 格式不正確"
      );
    }

    // 驗證密碼長度
    if (password.length < 6) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "密碼長度至少 6 個字元"
      );
    }

    // 2. 建立 Firebase Auth 用戶
    const userRecord = await auth.createUser({
      email: email,
      password: password,
      displayName: name || "",
    });

    // 3. 在 Firestore 建立用戶資料
    await db.collection("users").doc(userRecord.uid).set({
      // 基本資料
      email: email,
      name: name || "",
      phone: phone || "",
      user_id: userRecord.uid,
      gmail: email,
      password: "",
      photo: "",
      birthday: null,
      gender: "",
      address: "",
      id_card_num: "",

      // 緊急聯絡人
      emergency_name: "",
      emergency_relationship: "",
      emergency_phone: "",

      // 帳號狀態
      created_at: admin.firestore.FieldValue.serverTimestamp(),
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
      last_login: null,
      account_status: "active",
      email_verified: false,

      // 通知設定
      notification_settings: {
        all_enabled: true,
        activity_alerts: true,
        health_reminders: true,
        family_alerts: true,
        app_updates: true,
      },

      // 隱私設定
      privacy_settings: {
        data_sharing_enabled: false,
        location_access: false,
      },

      // 安全設定
      security: {
        biometric_enabled: false,
        two_factor_enabled: false,
      },

      // FCM Tokens
      fcm_tokens: [],
    });

    // 4. 初始化健康資料
    await db.collection("users").doc(userRecord.uid).collection("healthy").doc("profile").set({
      blood_type: "",
      disease: [],
      allergy: [],
      family_medical_history: [],
      surgical_history: [],
      current_medications: [],
      doctor_info: {
        doctor_name: "",
        hospital: "",
        department: "",
        phone: "",
      },
      bmi: 0,
      last_checkup_date: null,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`用戶註冊成功: ${userRecord.uid}`);

    return {
      success: true,
      userId: userRecord.uid,
      message: "註冊成功!",
    };
  } catch (error: any) {
    console.error("註冊錯誤:", error);

    if (error.code === "auth/email-already-exists") {
      throw new functions.https.HttpsError(
        "already-exists",
        "此 Email 已被註冊"
      );
    }

    if (error.code === "auth/invalid-email") {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Email 格式不正確"
      );
    }

    throw new functions.https.HttpsError("internal", error.message);
  }
});