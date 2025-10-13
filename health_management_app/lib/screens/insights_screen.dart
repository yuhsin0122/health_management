import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'clinics_screen.dart';
import 'share_report_screen.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  /// 0 = 日、1 = 週、2 = 月
  int _chartRange = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  '健康分析',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // ===== AI 健康建議 =====
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.psychology_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'AI 健康建議',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      '根據您近期數據分析:',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    _buildAIInsightItem('✅ 血壓控制良好', '本週平均 128/82，維持穩定', false),
                    const SizedBox(height: 10),
                    _buildAIInsightItem('⚠️ 血糖需要關注', '最近3天平均 142 mg/dL，建議減少糖分攝取', true),
                    const SizedBox(height: 10),
                    _buildAIInsightItem('✅ 用藥遵從良好', '本週用藥遵從率 100%，請繼續保持', false),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lightbulb_rounded, color: Colors.yellow, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '建議每週運動 3 次，每次 30 分鐘以上',
                              style: TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ===== 血壓趨勢（切換 日/週/月） =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '📈 血壓趨勢',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[700],
                      selectedColor: Colors.white,
                      fillColor: Colors.blueAccent,
                      isSelected: [
                        _chartRange == 0,
                        _chartRange == 1,
                        _chartRange == 2,
                      ],
                      onPressed: (index) => setState(() => _chartRange = index),
                      children: const [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('日')),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('週')),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('月')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // 圖表：血壓
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                height: 250,
                child: Builder(
                  builder: (context) {
                    // 依視圖組裝資料 + X軸標籤（不重複）
                    List<double> sysData, diaData;
                    List<String> labels;

                    switch (_chartRange) {
                      case 0: // 日：早/中/晚 3點
                        sysData = [128, 130, 127];
                        diaData = [82, 81, 80];
                        labels = ['早', '中', '晚'];
                        break;
                      case 1: // 週：一~日 7點
                        sysData = [126, 127, 128, 129, 130, 129, 127];
                        diaData = [80, 81, 81, 82, 81, 80, 79];
                        labels = ['一', '二', '三', '四', '五', '六', '日'];
                        break;
                      case 2: // 月：1~12月 12點
                        sysData = [125, 126, 127, 128, 129, 130, 131, 132, 131, 130, 129, 128];
                        diaData = [78, 79, 80, 81, 82, 81, 80, 81, 82, 81, 80, 79];
                        labels = List.generate(12, (i) => '${i + 1}');
                        break;
                      default:
                        sysData = [];
                        diaData = [];
                        labels = [];
                    }

                    final sysSpots = List.generate(
                      sysData.length,
                      (i) => FlSpot(i.toDouble(), sysData[i]),
                    );
                    final diaSpots = List.generate(
                      diaData.length,
                      (i) => FlSpot(i.toDouble(), diaData[i]),
                    );

                    return LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 20,
                          getDrawingHorizontalLine: (value) =>
                              FlLine(color: const Color(0xFFE0E0E0), strokeWidth: 1),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style:
                                    const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1, // 只在整數位置顯示
                              getTitlesWidget: (value, meta) {
                                final i = value.toInt();
                                if (value != i.toDouble()) return const SizedBox.shrink();
                                if (i < 0 || i >= labels.length) {
                                  return const SizedBox.shrink();
                                }
                                return Text(
                                  labels[i],
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF666666)),
                                );
                              },
                            ),
                          ),
                          topTitles:
                              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles:
                              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: (labels.length - 1).toDouble(),
                        minY: 60,
                        maxY: 160,
                        lineBarsData: [
                          // 收縮壓
                          LineChartBarData(
                            spots: sysSpots,
                            isCurved: true,
                            color: const Color(0xFFFF6B6B),
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFFFF6B6B).withOpacity(0.1),
                            ),
                          ),
                          // 舒張壓
                          LineChartBarData(
                            spots: diaSpots,
                            isCurved: true,
                            color: const Color(0xFF4A90E2),
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFF4A90E2).withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 圖例
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegend(const Color(0xFFFF6B6B), '收縮壓'),
                    const SizedBox(width: 20),
                    _buildLegend(const Color(0xFF4A90E2), '舒張壓'),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ===== 血糖趨勢（跟著同一個切換） =====
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '📊 血糖趨勢',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 圖表：血糖
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                height: 250,
                child: Builder(
                  builder: (context) {
                    List<double> gluData;
                    List<String> labels;

                    switch (_chartRange) {
                      case 0: // 日：早/中/晚
                        gluData = [138, 142, 136];
                        labels = ['早', '中', '晚'];
                        break;
                      case 1: // 週：一~日
                        gluData = [138, 145, 142, 148, 140, 136, 142];
                        labels = ['一', '二', '三', '四', '五', '六', '日'];
                        break;
                      case 2: // 月：1~12月
                        gluData = [140, 141, 143, 145, 144, 146, 147, 148, 146, 144, 143, 142];
                        labels = List.generate(12, (i) => '${i + 1}');
                        break;
                      default:
                        gluData = [];
                        labels = [];
                    }

                    final spots =
                        List.generate(gluData.length, (i) => FlSpot(i.toDouble(), gluData[i]));

                    return LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 20,
                          getDrawingHorizontalLine: (v) =>
                              FlLine(color: const Color(0xFFE0E0E0), strokeWidth: 1),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (v, _) => Text(
                                v.toInt().toString(),
                                style:
                                    const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (v, _) {
                                final i = v.toInt();
                                if (v != i.toDouble()) return const SizedBox.shrink();
                                if (i < 0 || i >= labels.length) {
                                  return const SizedBox.shrink();
                                }
                                return Text(
                                  labels[i],
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF666666)),
                                );
                              },
                            ),
                          ),
                          topTitles:
                              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles:
                              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: (labels.length - 1).toDouble(),
                        minY: 80,
                        maxY: 180,
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: const Color(0xFFFF9800),
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFFFF9800).withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ===== 底部按鈕 =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ClinicsScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_hospital_rounded, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              '我的診所',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ShareReportScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share_rounded, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              '分享報告',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIInsightItem(String title, String description, bool isWarning) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: isWarning ? Colors.yellow : Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
        ),
      ],
    );
  }
}
