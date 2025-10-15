import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";

const db = admin.firestore();

/**
 * 當用戶透過第三方登入時自動建立資料
 */
export const onUserCreate = functions.auth.user().onCreate(async (user: admin.auth.UserRecord) => {
  try {
    const userId = user.uid;

    // 檢查是否已經有資料
    const userDoc = await db.collection("users").doc(userId).get();

    if (!userDoc.exists) {
      console.log(`初始化第三方登入用戶: ${userId}`);

      await db.collection("users").doc(userId).set({
        email: user.email || "",
        name: user.displayName || "",
        phone: user.phoneNumber || "",
        user_id: userId,
        gmail: user.email || "",
        password: "",
        photo: user.photoURL || "",
        birthday: null,
        gender: "",
        address: "",
        id_card_num: "",

        emergency_name: "",
        emergency_relationship: "",
        emergency_phone: "",

        created_at: admin.firestore.FieldValue.serverTimestamp(),
        updated_at: admin.firestore.FieldValue.serverTimestamp(),
        last_login: admin.firestore.FieldValue.serverTimestamp(),
        account_status: "active",
        email_verified: user.emailVerified || false,

        notification_settings: {
          all_enabled: true,
          activity_alerts: true,
          health_reminders: true,
          family_alerts: true,
          app_updates: true,
        },

        privacy_settings: {
          data_sharing_enabled: false,
          location_access: false,
        },

        security: {
          biometric_enabled: false,
          two_factor_enabled: false,
        },

        fcm_tokens: [],
      });

      // 初始化健康資料
      await db.collection("users").doc(userId).collection("healthy").doc("profile").set({
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

      console.log(`用戶 ${userId} 資料初始化完成`);
    }
  } catch (error) {
    console.error("初始化用戶資料錯誤:", error);
  }
});

/**
 * 當用戶刪除帳號時清理資料
 */
export const onUserDelete = functions.auth.user().onDelete(async (user: admin.auth.UserRecord) => {
  try {
    const userId = user.uid;
    console.log(`開始清理用戶資料: ${userId}`);

    await db.collection("users").doc(userId).delete();

    console.log(`用戶 ${userId} 資料清理完成`);
  } catch (error) {
    console.error("清理用戶資料錯誤:", error);
  }
});