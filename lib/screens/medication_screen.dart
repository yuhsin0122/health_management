import 'package:flutter/material.dart';
import '../models/medication_model.dart';
import 'medication_add_screen.dart';
import 'medication_detail_screen.dart';
import 'medication_log_screen.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({Key? key}) : super(key: key);

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  List<Medication> medicationList = [
    Medication.fromLegacy(
      name: '糖尿病用藥',
      dosage: 'Metformin 500mg',
      time: '08:00',
      taken: true,
      remaining: 30,
      frequency: '每天1次',
      instruction: '飯後服用',
    ),
    Medication.fromLegacy(
      name: '高血壓用藥',
      dosage: 'Amlodipine 5mg',
      time: '14:00',
      taken: false,
      remaining: 25,
      frequency: '每天1次',
      instruction: '早上服用',
    ),
    Medication.fromLegacy(
      name: '維生素D',
      dosage: 'Vitamin D3 1000IU',
      time: '20:00',
      taken: true,
      remaining: 45,
      frequency: '每天1次',
      instruction: '隨餐服用',
    ),
    Medication.fromLegacy(
      name: '魚油',
      dosage: 'Omega-3 1000mg',
      time: '08:00',
      taken: false,
      remaining: 60,
      frequency: '每天1次',
      instruction: '飯後服用',
    ),
  ];

  // 儲存每個藥品卡片 hover 狀態的 Map，key: index
  final Map<int, bool> hoverMap = {};
  
  // 鼓勵訊息列表
  final List<String> encouragementMessages = [
    '太棒了！您剛剛完成了今日的用藥，健康又向前邁進了一步！🎉',
    '用藥完成！您的堅持是健康的基石，繼續保持！💪',
    '恭喜！您已成功完成用藥，為自己的健康負責，真了不起！🌟',
    '用藥完成！每一次的堅持都在為健康加分，做得很好！⭐',
    '太優秀了！按時用藥是維持健康的重要習慣，您做得很好！🏆',
    '用藥完成！您的自律讓健康更有保障，繼續保持這個好習慣！🌈',
  ];

  void _addMedication(Medication medication) {
    setState(() {
      medicationList.add(medication);
    });
  }

  void _updateMedication(int index, Medication medication) {
    setState(() {
      medicationList[index] = medication;
    });
  }

  void _deleteMedication(int index) {
    setState(() {
      medicationList.removeAt(index);
    });
  }

  // 切換用藥狀態並顯示鼓勵訊息
  void _toggleMedicationStatus(int index) {
    setState(() {
      medicationList[index].taken = !medicationList[index].taken;
    });

    // 如果標記為已用藥，顯示鼓勵訊息
    if (medicationList[index].taken) {
      _showEncouragementMessage(index);
    }
  }

  // 顯示鼓勵訊息
  void _showEncouragementMessage(int index) {
    final randomMessage = encouragementMessages[index % encouragementMessages.length];
    
    // 顯示精美的 SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // 成功圖標
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              // 訊息內容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '用藥完成！',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      randomMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.zero,
      ),
    );

    // 可選：播放成功音效或觸發其他動畫
    _triggerCelebrationAnimation(index);
  }

  // 觸發慶祝動畫效果
  void _triggerCelebrationAnimation(int index) {
    // 這裡可以添加更複雜的動畫效果
    // 例如：Confetti 動畫、按鈕脈衝效果等
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題區域，包含標題和右側按鈕（ToolTip用）
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '我的用藥',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      Tooltip(
                        message: '用藥記錄',
                        child: IconButton(
                          icon: const Icon(Icons.menu_book, color: Color(0xFF4A90E2)),
                          onPressed: () {
                            final takenLogs = medicationList
                                .where((med) => med.taken)
                                .map((med) => {
                                      "name": med.name,
                                      "dosage": med.dosage,
                                      "time": med.time,
                                      "date": "2025/10/09",
                                      "taken": med.taken,
                                    })
                                .toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MedicationLogScreen(logData: takenLogs),
                              ),
                            );
                          },
                        ),
                      ),
                      Tooltip(
                        message: '新增用藥',
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_circle_rounded,
                            size: 28,
                            color: Color(0xFF4A90E2),
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MedicationAddScreen(),
                              ),
                            );
                            if (result is Medication) {
                              _addMedication(result);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 今日用藥統計
            _buildMedicationStats(),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '今日用藥',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: medicationList.length,
                itemBuilder: (context, index) {
                  final med = medicationList[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => hoverMap[index] = true),
                    onExit: (_) => setState(() => hoverMap[index] = false),
                    child: AnimatedScale(
                      scale: (hoverMap[index] ?? false) ? 1.02 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MedicationDetailScreen(
                                medication: med,
                                onUpdate: (editedMed) => _updateMedication(index, editedMed),
                                onDelete: () => _deleteMedication(index),
                              ),
                            ),
                          );
                        },
                        child: _buildMedicationCard(med, index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 構建用藥統計卡片
  Widget _buildMedicationStats() {
    final totalMeds = medicationList.length;
    final takenMeds = medicationList.where((med) => med.taken).length;
    final progress = totalMeds > 0 ? takenMeds / totalMeds : 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '今日用藥進度',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$takenMeds/$totalMeds 已完成',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: progress == 1.0 ? Color(0xFF10B981) : Color(0xFF4A90E2),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // 進度條
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: 8,
                width: MediaQuery.of(context).size.width * 0.8 * progress,
                decoration: BoxDecoration(
                  color: progress == 1.0 ? Color(0xFF10B981) : Color(0xFF4A90E2),
                  borderRadius: BorderRadius.circular(4),
                  gradient: progress == 1.0 ? LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF34D399)],
                  ) : null,
                ),
              ),
            ],
          ),
          if (progress == 1.0) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.celebration, color: Color(0xFFF59E0B), size: 16),
                SizedBox(width: 4),
                Text(
                  '恭喜！今日所有用藥已完成 🎉',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFF59E0B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicationCard(Medication med, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: med.taken ? Color(0xFF10B981) : const Color(0xFFE0E0E0), 
          width: med.taken ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第一行：藥品名稱和服用狀態圖標
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  med.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: med.taken ? Color(0xFF10B981) : Colors.black87,
                    decoration: med.taken ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
              ),
              // 可點擊的狀態圖標
              GestureDetector(
                onTap: () => _toggleMedicationStatus(index),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: med.taken ? const Color(0xFFD1FAE5) : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: med.taken ? const Color(0xFF10B981) : const Color(0xFFE0E0E0),
                      width: 2,
                    ),
                    boxShadow: med.taken ? [
                      BoxShadow(
                        color: Color(0xFF10B981).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      )
                    ] : null,
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: med.taken 
                          ? Icon(
                              Icons.check_circle,
                              color: const Color(0xFF10B981),
                              size: 24,
                              key: ValueKey('checked'),
                            )
                          : Icon(
                              Icons.radio_button_unchecked,
                              color: const Color(0xFF9CA3AF),
                              size: 24,
                              key: ValueKey('unchecked'),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // 第二行：劑量和用法資訊標籤
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.scale,
                text: '${med.dose}${med.unit}',
                color: const Color(0xFF4A90E2),
                isCompleted: med.taken,
              ),
              SizedBox(width: 8),
              _buildInfoChip(
                icon: Icons.medical_services,
                text: med.usage,
                color: const Color(0xFF10B981),
                isCompleted: med.taken,
              ),
            ],
          ),
          SizedBox(height: 8),
          
          // 第三行：頻率和用藥指導資訊標籤
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.schedule,
                text: '${med.timesPerDay}',
                color: const Color(0xFFFF6B00),
                isCompleted: med.taken,
              ),
              SizedBox(width: 8),
              _buildInfoChip(
                icon: Icons.assignment,
                text: med.instruction,
                color: const Color(0xFF9C27B0),
                isCompleted: med.taken,
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // 第四行：用藥時間和剩餘天數
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time, 
                      size: 16, 
                      color: med.taken ? Color(0xFF10B981) : Color(0xFF666666)
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '用藥時間: ${med.time}',
                        style: TextStyle(
                          fontSize: 14, 
                          color: med.taken ? Color(0xFF10B981) : Color(0xFF666666),
                          decoration: med.taken ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '剩餘 ${med.remaining} 天',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: med.taken ? Color(0xFF10B981) : 
                         (med.remaining < 7 ? const Color(0xFFFF6B00) : const Color(0xFF666666)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
    bool isCompleted = false,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted ? color.withOpacity(0.2) : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? color : color.withOpacity(0.3), 
          width: isCompleted ? 1.5 : 1
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isCompleted ? color : color.withOpacity(0.8),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isCompleted ? color : color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
              decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}