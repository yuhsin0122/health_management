import 'package:flutter/material.dart';

// =================================================================
// NotificationSettingScreen Widget
// 這是「通知設定」頁面
// =================================================================
class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  // 模擬通知開關的狀態
  bool _isAllNotificationsEnabled = true; // 總開關
  bool _isActivityAlertsEnabled = true; // 活動/步數通知
  bool _isHealthRemindersEnabled = true; // 健康提醒 (如服藥、測量)
  bool _isFamilyAlertsEnabled = false; // 家人關係通知
  bool _isAppUpdatesEnabled = true; // 應用程式更新通知

 // 處理開關狀態變更
  void _onSwitchChanged(String setting, bool newValue) {
    setState(() {
      switch (setting) {
        case 'all':
          _isAllNotificationsEnabled = newValue;
          
          // *** 修正邏輯：如果總開關狀態改變，同步修改所有子開關 ***
          if (newValue) {
            // 如果總開關開啟，且子開關目前是關閉的，則開啟
            // (注意：這裡可以選擇只開啟那些之前使用者關閉的，但為簡化，這裡選擇全部開啟)
            _isActivityAlertsEnabled = true;
            _isHealthRemindersEnabled = true;
            _isFamilyAlertsEnabled = true; // 即使之前是 false，也建議同步開啟
            _isAppUpdatesEnabled = true;
          } else {
            // 如果總開關關閉，則關閉所有子開關
            _isActivityAlertsEnabled = false;
            _isHealthRemindersEnabled = false;
            _isFamilyAlertsEnabled = false;
            _isAppUpdatesEnabled = false;
          }
          break;
        case 'activity':
          _isActivityAlertsEnabled = newValue;
          break;
        case 'health':
          _isHealthRemindersEnabled = newValue;
          break;
        case 'family':
          _isFamilyAlertsEnabled = newValue;
          break;
        case 'updates':
          _isAppUpdatesEnabled = newValue;
          break;
      }
      // 可以在這裡加入儲存設定到本地或伺服器的邏輯
      _showSnackbar('「$setting」通知已' + (newValue ? '開啟' : '關閉'));
    });
  }
  // 顯示操作結果的 SnackBar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
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

  // 建立設定項目，使用 SwitchListTile
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

  // =================================================================
  // build 函式 (主 UI 結構)
  // =================================================================
  @override
  Widget build(BuildContext context) {
    // 判斷是否所有子項目都關閉 (用於總開關的輔助判斷)
    final bool isAnyChildEnabled = _isActivityAlertsEnabled ||
        _isHealthRemindersEnabled ||
        _isFamilyAlertsEnabled ||
        _isAppUpdatesEnabled;

    return Scaffold(
      appBar: AppBar(
        title: const Text('通知設定',
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
            // --- 區塊 1: 總開關 ---
            _buildSectionTitle('主要控制'),
            _buildSwitchItem(
              icon: Icons.notifications_active_rounded,
              title: '接收所有通知',
              subtitle: '一鍵開啟或關閉所有應用程式通知',
              value: _isAllNotificationsEnabled,
              onChanged: (newValue) => _onSwitchChanged('all', newValue), // 這裡沒有問題，因為總是傳入一個函數
            ),
            
            // --- 區塊 2: 重要提醒 ---
            _buildSectionTitle('健康與生活提醒'),
            _buildSwitchItem(
              icon: Icons.directions_run_rounded,
              title: '活動提醒',
              subtitle: '關於每日步數達標、久坐提醒、運動活動等通知',
              value: _isActivityAlertsEnabled && _isAllNotificationsEnabled,
              onChanged: _isAllNotificationsEnabled
                  ? (newValue) => _onSwitchChanged('activity', newValue)
                  : (_) {}, // <<< 修正點 1: 用 (_) {} 替代 null
            ),
            _buildSwitchItem(
              icon: Icons.medical_services_rounded,
              title: '健康提醒',
              subtitle: '服藥、量測血壓/血糖、預約回診等重要提醒',
              value: _isHealthRemindersEnabled && _isAllNotificationsEnabled,
              onChanged: _isAllNotificationsEnabled
                  ? (newValue) => _onSwitchChanged('health', newValue)
                  : (_) {}, // <<< 修正點 2: 用 (_) {} 替代 null
            ),
            _buildSwitchItem(
              icon: Icons.family_restroom_rounded,
              title: '家人關係通知',
              subtitle: '家人健康數據異常、緊急警報等通知',
              value: _isFamilyAlertsEnabled && _isAllNotificationsEnabled,
              onChanged: _isAllNotificationsEnabled
                  ? (newValue) => _onSwitchChanged('family', newValue)
                  : (_) {}, // <<< 修正點 3: 用 (_) {} 替代 null
            ),
            
            // --- 區塊 3: 系統與行銷 ---
            _buildSectionTitle('系統與其他'),
            _buildSwitchItem(
              icon: Icons.system_update_alt_rounded,
              title: '應用程式更新',
              subtitle: '新版本發布和功能更新提示',
              value: _isAppUpdatesEnabled && _isAllNotificationsEnabled,
              onChanged: _isAllNotificationsEnabled
                  ? (newValue) => _onSwitchChanged('updates', newValue)
                  : (_) {}, // <<< 修正點 4: 用 (_) {} 替代 null
            ),
            
            const SizedBox(height: 30),
            // 提示訊息
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '您可以在系統設定中管理應用程式的整體通知權限。',
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