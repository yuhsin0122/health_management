import 'package:flutter/material.dart';

// =================================================================
// 關於你的帳號詳細頁面 (精美正式版 - 移除修改密碼與登出)
// =================================================================
class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

  // 模擬用戶資料
  static const String _userName = '健康管理小幫手';
  static const String _userEmail = 'user.example@email.com';
  static const String _userId = 'UID-98765-ABCDEF';
  static const String _accountCreationDate = '2023 年 01 月 15 日';

  // 輔助方法：建構資訊清單項目 (優化設計：使用顏色標籤區分)
  Widget _buildInfoItem({required String label, required String value, IconData? icon, Color? color}) {
    // 為了讓帳號詳細資訊更漂亮，我們在 trailing 加上淺色背景，使其更像一個標籤
    return ListTile(
      leading: icon != null
          ? Icon(icon, color: const Color(0xFF4A90E2), size: 24)
          : null,
      title: Text(
        label,
        style: const TextStyle(fontSize: 15, color: Colors.black54),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.black87,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      dense: false, // 恢復到正常間距，提高視覺舒適度
    );
  }

  // 輔助方法：建構操作按鈕 (ListTile 樣式) - 僅保留刪除帳號
  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
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
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(color: iconColor, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
    );
  }

  // 新增：顯示刪除帳號確認對話框
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('確認刪除帳號？', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          content: const Text(
            '刪除帳號是不可逆的動作。您的所有健康數據和記錄將永久移除。您確定要繼續嗎？',
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            // 取消按鈕
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 關閉對話框
              },
              child: const Text('取消', style: TextStyle(color: Colors.black54)),
            ),
            // 確認刪除按鈕
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 關閉對話框
                // 模擬執行刪除操作
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('模擬：正在執行帳號刪除流程...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('確定刪除', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的帳號詳情', 
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
            // --- 1. 帳號頭部總覽卡片 (不變) ---
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20, left: 16, right: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 圓形頭像
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF4A90E2).withOpacity(0.1),
                      border: Border.all(color: const Color(0xFF4A90E2), width: 2),
                    ),
                    child: const Icon(Icons.fitness_center_rounded, size: 40, color: Color(0xFF4A90E2)),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userEmail,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- 2. 帳號詳細資訊區塊 (美化) ---
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
              child: Text(
                '帳號詳細資訊',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildInfoItem(
                    label: '用戶 ID (UID)',
                    value: _userId,
                    icon: Icons.fingerprint_rounded,
                    color: Colors.blueGrey,
                  ),
                  const Divider(indent: 16, endIndent: 16, height: 1),
                  _buildInfoItem(
                    label: '註冊信箱',
                    value: _userEmail,
                    icon: Icons.email_outlined,
                    color: Colors.green,
                  ),
                  const Divider(indent: 16, endIndent: 16, height: 1),
                  _buildInfoItem(
                    label: '帳號創建日期',
                    value: _accountCreationDate,
                    icon: Icons.calendar_today_outlined,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            // --- 3. 隱私與安全操作區塊 (移除密碼和登出) ---
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 5),
              child: Text(
                '隱私與安全操作',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            // 刪除帳號按鈕 (連結到確認對話框)
            _buildActionButton(
              title: '刪除帳號',
              icon: Icons.delete_forever_outlined,
              iconColor: Colors.red.shade700,
              onTap: () {
                _showDeleteConfirmationDialog(context); // 彈出確認對話框
              },
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
