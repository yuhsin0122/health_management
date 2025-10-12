import 'package:flutter/material.dart';

// =================================================================
// TwoFactorAuthScreen Widget
// 這是「兩步驟驗證設定」頁面
// =================================================================
class TwoFactorAuthScreen extends StatelessWidget {
  const TwoFactorAuthScreen({Key? key}) : super(key: key);

  // 建立認證方式的 ListTile
  Widget _buildAuthMethodItem(BuildContext context, {
    required String title, 
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // <<< 修正點：移除 SnackBar 提示 >>>
          // 實際應用中，點擊這裡會導航到該方法的設定流程頁面
          
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('啟動 $title 認證設定流程...'),
          //     duration: const Duration(milliseconds: 800), 
          //   ),
          // );
          
          // 可以在這裡加入一個簡單的 Log，但在 UI 上不會有黑色提示條
          debugPrint('導航至 $title 設定頁面...');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('兩步驟驗證設定',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                '兩步驟驗證能為您的帳戶提供額外的保護。請選擇您偏好的驗證方式：',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            
            // --- 認證選項 ---
            _buildAuthMethodItem(
              context,
              title: '電子郵件認證 (Email OTP)',
              subtitle: '透過電子郵件接收一次性密碼。',
              icon: Icons.email_rounded,
              color: const Color(0xFFE84F39), // 紅色系
            ),
            _buildAuthMethodItem(
              context,
              title: '簡訊驗證 (SMS OTP)',
              subtitle: '透過手機簡訊接收驗證碼。',
              icon: Icons.sms_rounded,
              color: const Color(0xFF5CB85C), // 綠色系
            ),
            _buildAuthMethodItem(
              context,
              title: '身份驗證器 App (TOTP)',
              subtitle: '使用 Google Authenticator 等 App 產生驗證碼，安全性最高。',
              icon: Icons.security_rounded,
              color: const Color(0xFF4A90E2), // 藍色系
            ),

            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '建議啟用至少一種兩步驟驗證方式，以確保您的帳號安全。',
                style: TextStyle(color: Color(0xFF999999), fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
