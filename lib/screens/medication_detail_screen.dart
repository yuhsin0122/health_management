import 'package:flutter/material.dart';
import '../models/medication_model.dart';

class MedicationDetailScreen extends StatefulWidget {
  final Medication medication;
  final ValueChanged<Medication> onUpdate;
  final VoidCallback onDelete;

  const MedicationDetailScreen({
    required this.medication,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  _MedicationDetailScreenState createState() => _MedicationDetailScreenState();
}

class _MedicationDetailScreenState extends State<MedicationDetailScreen> {
  late Medication med;
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    // 使用現有的 medication 物件，不要重新建立
    med = widget.medication;
    
    try {
      // 嘗試解析時間來設定 selectedTime
      final timeParts = med.time.split(':');
      if (timeParts.length == 2) {
        selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    } catch (e) {
      selectedTime = TimeOfDay.now();
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF4A90E2),
            colorScheme: const ColorScheme.light(primary: Color(0xFF4A90E2)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        med.time = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '用藥詳情',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF4A90E2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFFF6B6B)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('確認刪除'),
                  content: const Text('確定要刪除此用藥紀錄嗎?'),
                  actions: [
                    TextButton(
                      child: const Text('取消'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('刪除', style: TextStyle(color: Color(0xFFFF6B6B))),
                      onPressed: () {
                        widget.onDelete();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              )
            ],
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFancyField(
                    label: '用藥名稱',
                    value: med.name,
                    icon: Icons.medication_rounded,
                    onChanged: (val) => setState(() => med.name = val),
                  ),
                  const SizedBox(height: 14),
                  _buildFancyField(
                    label: '劑量',
                    value: med.dosage, // 使用 getter
                    icon: Icons.scale,
                    onChanged: (val) {
                      // 簡單的劑量更新邏輯
                      setState(() {
                        if (val.contains('mg')) {
                          med.dose = val.replaceAll('mg', '').trim();
                          med.unit = 'mg';
                        } else if (val.contains('ml')) {
                          med.dose = val.replaceAll('ml', '').trim();
                          med.unit = 'ml';
                        } else if (val.contains('IU')) {
                          med.dose = val.replaceAll('IU', '').trim();
                          med.unit = 'IU';
                        } else {
                          // 嘗試提取數字和單位
                          final regex = RegExp(r'(\d+)\s*(\D*)');
                          final match = regex.firstMatch(val);
                          if (match != null) {
                            med.dose = match.group(1)!;
                            med.unit = match.group(2)!.trim().isEmpty ? '顆' : match.group(2)!.trim();
                          } else {
                            med.dose = val;
                            med.unit = '顆';
                          }
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () => _selectTime(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '服藥時間',
                          prefixIcon: const Icon(Icons.access_time, color: Color(0xFF4A90E2)),
                          suffixIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4A90E2)),
                          helperText: '請選擇服藥時間',
                          filled: true,
                          fillColor: const Color(0xFFF5F7FA),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        controller: TextEditingController(text: med.time),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    value: med.taken,
                    title: const Text('今日已服用', style: TextStyle(fontSize: 17)),
                    activeColor: const Color(0xFF10B981),
                    inactiveThumbColor: const Color(0xFFFF6B6B),
                    onChanged: (val) => setState(() => med.taken = val),
                  ),
                  const SizedBox(height: 14),
                  _buildFancyField(
                    label: '剩餘天數',
                    value: med.remaining.toString(),
                    icon: Icons.event_note,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() {
                      med.remaining = int.tryParse(val) ?? med.remaining;
                      med.duration = med.remaining; // 同步更新 duration
                    }),
                  ),
                  const SizedBox(height: 14),
                  _buildFancyField(
                    label: '服用頻率',
                    value: med.frequency, // 使用 getter
                    icon: Icons.schedule,
                    onChanged: (val) => setState(() => med.timesPerDay = val),
                  ),
                  const SizedBox(height: 14),
                  _buildFancyField(
                    label: '服用指示',
                    value: med.instruction,
                    icon: Icons.info_outline,
                    onChanged: (val) => setState(() => med.instruction = val),
                  ),
                  const SizedBox(height: 14),
                  _buildFancyField(
                    label: '每次服用劑量',
                    value: med.dosePerIntake, // 使用 getter
                    icon: Icons.local_pharmacy,
                    onChanged: (val) {
                      // 簡單的劑量更新邏輯
                      setState(() {
                        if (val.contains('mg')) {
                          med.dose = val.replaceAll('mg', '').trim();
                          med.unit = 'mg';
                        } else if (val.contains('ml')) {
                          med.dose = val.replaceAll('ml', '').trim();
                          med.unit = 'ml';
                        } else if (val.contains('IU')) {
                          med.dose = val.replaceAll('IU', '').trim();
                          med.unit = 'IU';
                        } else {
                          // 嘗試提取數字和單位
                          final regex = RegExp(r'(\d+)\s*(\D*)');
                          final match = regex.firstMatch(val);
                          if (match != null) {
                            med.dose = match.group(1)!;
                            med.unit = match.group(2)!.trim().isEmpty ? '顆' : match.group(2)!.trim();
                          } else {
                            med.dose = val;
                            med.unit = '顆';
                          }
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('儲存編輯', style: TextStyle(fontSize: 18)),
                      onPressed: () {
                        widget.onUpdate(med);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFancyField({
    required String label,
    required String value,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: value,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF4A90E2)),
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
