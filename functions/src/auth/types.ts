/**
 * 用戶註冊請求資料
 */
export interface RegisterRequest {
  email: string;
  password: string;
  name?: string;
  phone?: string;
}

/**
 * 用戶登入請求資料
 */
export interface LoginRequest {
  email: string;
  password: string;
}

/**
 * API 回應格式
 */
export interface ApiResponse {
  success: boolean;
  message: string;
  userId?: string;
  data?: any;
}