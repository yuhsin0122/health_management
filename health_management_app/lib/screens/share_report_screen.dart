import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareReportScreen extends StatelessWidget {
  const ShareReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '分享健康報告',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '選擇分享內容',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            _buildOptionCard(
              icon: Icons.description_rounded,
              title: '簡易版報告',
              description: '包含基本資料與近7天記錄',
              color: const Color(0xFF4A90E2),
              onTap: () {
                _shareSimpleReport(context);
              },
            ),
            _buildOptionCard(
              icon: Icons.insert_chart_rounded,
              title: '完整版報告',
              description: '包含圖表與AI分析建議',
              color: const Color(0xFF10B981),
              onTap: () {
                _shareFullReport(context);
              },
            ),
            const SizedBox(height: 30),
            const Text(
              '報告預覽',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      '王小明 健康記錄',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      '2024年10月 健康摘要',
                      style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 15),
                  _buildSectionTitle('📊 基本資料'),
                  const SizedBox(height: 10),
                  _buildInfoItem('姓名', '王小明'),
                  _buildInfoItem('年齡', '65歲'),
                  _buildInfoItem('身高', '175 cm'),
                  _buildInfoItem('體重', '72.5 kg'),
                  _buildInfoItem('BMI', '23.7 (正常)'),
                  _buildInfoItem('病史', '糖尿病、高血壓'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('📈 近7日記錄'),
                  const SizedBox(height: 10),
                  _buildRecordItem('血壓 (10/8)', '128/82 mmHg', false),
                  _buildRecordItem('血糖 (10/8)', '142 mg/dL', true),
                  _buildRecordItem('體重 (10/7)', '72.5 kg', false),
                  const SizedBox(height: 20),
                  _buildSectionTitle('💊 用藥記錄'),
                  const SizedBox(height: 10),
                  _buildMedicationItem('降血糖藥', '已按時服用'),
                  _buildMedicationItem('降血壓藥', '已按時服用'),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      '由「慢性病管理App」生成',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ),
                  const Center(
                    child: Text(
                      '2024/10/08 10:35',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordItem(String title, String value, bool isWarning) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                      isWarning
                          ? const Color(0xFFFF6B00)
                          : const Color(0xFF059669),
                ),
              ),
              if (isWarning) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.warning_rounded,
                  size: 16,
                  color: Color(0xFFFF9800),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationItem(String name, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Color(0xFF10B981)),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const Spacer(),
          Text(
            status,
            style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  void _shareSimpleReport(BuildContext context) {
    final reportText = '''
【健康記錄分享】
王小明 - 2024/10/08

━━━━━━━━━━━━
📊 基本資料
年齡: 65歲
身高: 175 cm
體重: 72.5 kg
BMI: 23.7 (正常)
病史: 糖尿病、高血壓

━━━━━━━━━━━━
📈 近7日記錄

血壓 (10/8): 128/82 mmHg ✓
血糖 (10/8): 142 mg/dL ⚠️
體重 (10/7): 72.5 kg

━━━━━━━━━━━━
💊 用藥記錄
✓ 降血糖藥 (已按時服用)
✓ 降血壓藥 (已按時服用)

━━━━━━━━━━━━
由「慢性病管理App」生成
2024/10/08 10:35
''';

    Clipboard.setData(ClipboardData(text: reportText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('報告已複製到剪貼簿,可貼到Line/Messenger分享'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareFullReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('完整版報告功能開發中...'),
        backgroundColor: Color(0xFF4A90E2),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
