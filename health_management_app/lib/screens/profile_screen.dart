import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 15),
              const Text(
                '王小明',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                '65歲 · 糖尿病患者',
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 30),
              _buildSettingSection('個人資料', [
                _buildSettingItem(Icons.edit_rounded, '編輯個人資料', () {}),
                _buildSettingItem(
                  Icons.health_and_safety_rounded,
                  '健康檔案',
                  () {},
                ),
              ]),
              _buildSettingSection('家人管理', [
                _buildSettingItem(
                  Icons.family_restroom_rounded,
                  '家人關係綁定',
                  () {},
                ),
                _buildSettingItem(
                  Icons.notifications_active_rounded,
                  '通知設定',
                  () {},
                ),
              ]),
              _buildSettingSection('其他', [
                _buildSettingItem(Icons.privacy_tip_rounded, '隱私權政策', () {}),
                _buildSettingItem(Icons.info_rounded, '關於我們', () {}),
                _buildSettingItem(
                  Icons.logout_rounded,
                  '登出',
                  () {},
                  isDestructive: true,
                ),
              ]),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: items),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isDestructive
                      ? const Color(0xFFFF6B6B)
                      : const Color(0xFF4A90E2),
              size: 24,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color:
                      isDestructive ? const Color(0xFFFF6B6B) : Colors.black87,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
