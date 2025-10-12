// lib/screens/health_record_screen.dart

import 'package:flutter/material.dart';

// 假設這裡引入了一個用於繪製圖表的套件，例如 fl_chart
// 為了簡化，這裡只用一個佔位符號 (Placeholder)
// import 'package:fl_chart/fl_chart.dart'; 

class HealthRecordScreen extends StatelessWidget {
  const HealthRecordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('健康檔案', 
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 1, // 讓 AppBar 有點陰影
      ),
      backgroundColor: const Color(0xFFF5F7FA), // 與 profile_screen 背景色一致
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- 數據概覽區塊 ---
              _buildSectionTitle('關鍵生理數據 (最近 7 天)'),
              const SizedBox(height: 10),
              
              // 數據卡片列
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildDataCard(
                    context, 
                    icon: Icons.bloodtype_rounded, 
                    title: '平均血糖', 
                    value: '135', 
                    unit: 'mg/dL',
                    color: const Color(0xFF4A90E2), // 藍色
                  ),
                  _buildDataCard(
                    context, 
                    icon: Icons.monitor_heart_rounded, 
                    title: '平均血壓', 
                    value: '130/85', 
                    unit: 'mmHg',
                    color: const Color(0xFF7ED321), // 綠色
                  ),
                ],
              ),
              const SizedBox(height: 15),
              
              // --- 趨勢圖表區塊 ---
              _buildSectionTitle('血糖趨勢 (月)'),
              const SizedBox(height: 10),
              _buildChartCard(
                '血糖變化圖 (Placeholder)', 
                Colors.orangeAccent,
              ),
              const SizedBox(height: 20),

              _buildSectionTitle('體重趨勢 (月)'),
              const SizedBox(height: 10),
              _buildChartCard(
                '體重變化圖 (Placeholder)', 
                Colors.purpleAccent,
              ),
              const SizedBox(height: 20),
              
              // --- 紀錄清單入口 ---
              _buildSectionTitle('歷史紀錄快速查看'),
              const SizedBox(height: 10),
              _buildRecordListTile(
                icon: Icons.auto_stories_rounded,
                title: '所有測量紀錄 (血糖/血壓)',
                subtitle: '查看您所有的歷史數據點',
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('導航至詳細紀錄清單...')));
                },
              ),
              _buildRecordListTile(
                icon: Icons.history_edu_rounded,
                title: '醫療檢查報告 (PDF/圖片)',
                subtitle: '查看和管理您的病理報告',
                onTap: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('導航至報告管理頁面...')));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget: 區塊標題
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  // Helper Widget: 數據卡片 (例如血糖、血壓)
  Widget _buildDataCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 2.0),
                  child: Text(
                    unit,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: 圖表佔位卡片
  Widget _buildChartCard(String placeholderText, Color color) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        // 這裡未來會放置 fl_chart 或其他圖表組件
        child: Text(
          placeholderText,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  // Helper Widget: 紀錄清單項目
  Widget _buildRecordListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: const Color(0xFF4A90E2), size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF999999)),
      ),
    );
  }
}