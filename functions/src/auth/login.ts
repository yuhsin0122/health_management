import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const db = admin.firestore();

/**
 * 用戶登入 Cloud Function
 */
export const loginUser = functions.https.onCall(async (data: any, context: any) => {
  try {
    // 檢查是否已認證
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "用戶未登入"
      );
    }

    const userId = context.auth.uid;

    // 更新最後登入時間
    await db.collection("users").doc(userId).update({
      last_login: admin.firestore.FieldValue.serverTimestamp(),
      updated_at: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`用戶登入: ${userId}`);

    return {
      success: true,
      message: "登入成功",
    };
  } catch (error: any) {
    console.error("登入錯誤:", error);
    throw new functions.https.HttpsError("internal", error.message);
  }
});