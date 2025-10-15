import * as admin from "firebase-admin";

// 初始化 Firebase Admin SDK
admin.initializeApp();

// 匯出所有 Cloud Functions
export {registerUser} from "./auth/register";
export {loginUser} from "./auth/login";
export {onUserCreate, onUserDelete} from "./auth/triggers";