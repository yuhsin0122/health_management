import 'package:flutter/material.dart';
import 'change_password_screen.dart'; 
import 'two_factor_auth_screen.dart'; 
import 'data_export_screen.dart'; // 確保這裡有導入

// =================================================================
// PrivacySecurityScreen Widget
// 這是「隱私與安全性」頁面
// =================================================================
class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({Key? key}) : super(key: key);

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  // 模擬設定狀態
  bool _isBiometricEnabled = false; // 生物識別/指紋/Face ID 登入
  bool _isDataSharingEnabled = true; // 數據匿名分享 (用於研究或優化)
  bool _isLocationAccessEnabled = true; // 位置存取權限 (用於活動追蹤)
  // 由於 2FA 已改為導航頁面，其狀態變數已移除

  // 處理開關狀態變更 (只處理 SwitchListTile 項目)
  void _onSwitchChanged(String setting, bool newValue) {
    setState(() {
      switch (setting) {
        case 'biometric':
          _isBiometricEnabled = newValue;
          break;
        case 'data_sharing':
          _isDataSharingEnabled = newValue;
          break;
        case 'location_access':
          _isLocationAccessEnabled = newValue;
          break;
        // case '2fa' 的邏輯已移除，因為它現在是 ActionItem
      }
      _showSnackbar('「$setting」已' + (newValue ? '開啟' : '關閉'));
    });
  }

  // 顯示操作結果的 SnackBar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        // 修正 1: 縮短 SnackBar 顯示時間
        duration: const Duration(milliseconds: 800), 
      ),
    );
  }

  // 建立設定區塊標題
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  // 建立開關設定項目 (使用 SwitchListTile)
  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: const Color(0xFF4A90E2)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF4A90E2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  // 建立導航/操作設定項目 (使用 ListTile)
  Widget _buildActionItem({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon, 
          color: isDestructive ? const Color(0xFFFF6B6B) : const Color(0xFF4A90E2)
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDestructive ? const Color(0xFFFF6B6B) : Colors.black87,
          ),
        ),
        trailing: isDestructive ? null : const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
    );
  }

  // 模擬彈出刪除帳號確認對話框
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('確認刪除帳號？'),
        content: const Text('刪除後所有資料將無法復原。您確定要繼續嗎？'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackbar('帳號刪除流程已啟動...');
              // 實際應用中，這裡應執行刪除 API
            },
            child: const Text('確認刪除', style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // build 函式 (主 UI 結構)
  // =================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('隱私與安全性',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: const Color(0xFFF5F7FA), // 與 ProfileScreen 背景一致
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- 區塊 1: 安全設定 ---
            _buildSectionTitle('帳號安全'),
            _buildSwitchItem(
              icon: Icons.fingerprint_rounded,
              title: '生物識別 (指紋/Face ID) 登入',
              subtitle: '在登入時使用您的生物識別資訊來提供額外的保護。',
              value: _isBiometricEnabled,
              onChanged: (newValue) => _onSwitchChanged('biometric', newValue),
            ),
            
            // 修正 2: 兩步驟驗證 (2FA) 改為 ActionItem
            _buildActionItem( 
              icon: Icons.vpn_key_rounded,
              title: '兩步驟驗證 (2FA) 設定', 
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TwoFactorAuthScreen()),
                );
              },
            ),
            
            // 更改密碼
            _buildActionItem(
              icon: Icons.lock_reset_rounded,
              title: '更改密碼',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                );
              },
            ),

            // --- 區塊 2: 資料隱私 ---
            _buildSectionTitle('數據與隱私控制'),
            _buildSwitchItem(
              icon: Icons.share_rounded,
              title: '匿名數據分享',
              subtitle: '允許我們將您的健康數據用於匿名研究和產品優化。',
              value: _isDataSharingEnabled,
              onChanged: (newValue) => _onSwitchChanged('data_sharing', newValue),
            ),
            _buildSwitchItem(
              icon: Icons.location_on_rounded,
              title: '位置存取權限',
              subtitle: '用於精確追蹤運動軌跡和活動數據。',
              value: _isLocationAccessEnabled,
              onChanged: (newValue) => _onSwitchChanged('location_access', newValue),
            ),
            
            // 查看並匯出我的數據
            _buildActionItem(
              icon: Icons.folder_delete_rounded,
              title: '查看並匯出我的數據',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DataExportScreen()),
                );
              },
            ),
            
            // --- 區塊 3: 帳號管理 ---
            _buildSectionTitle('帳號管理'),
            _buildActionItem(
              icon: Icons.delete_forever_rounded,
              title: '刪除我的帳號',
              isDestructive: true,
              onTap: _showDeleteAccountDialog,
            ),

            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '我們嚴格遵守隱私政策，您的個人健康資料會被安全加密儲存。',
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