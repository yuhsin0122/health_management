import 'package:flutter/material.dart';

class MedicationLogScreen extends StatelessWidget {
  final List<Map<String, dynamic>> logData;

  const MedicationLogScreen({required this.logData, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '用藥日誌',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF4A90E2)),
      ),
      body: logData.isEmpty
          ? const Center(
              child: Text(
                '尚無用藥紀錄',
                style: TextStyle(fontSize: 18, color: Color(0xFF999999)),
              ),
            )
          : ListView.separated(
              itemCount: logData.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              itemBuilder: (context, index) {
                final log = logData[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                    border: Border.all(color: const Color(0xFFE0E0E0), width: 1.2),
                  ),
                  child: Row(
                    children: [
                      log['taken']
                          ? const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 30)
                          : const Icon(Icons.cancel, color: Color(0xFFFF6B6B), size: 30),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${log['name']} ${log['dosage']}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '時間：${log['time']}',
                              style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '狀態：${log['taken'] ? "已服用" : "未服用"}',
                              style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Text('日期', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
                          Text('${log['date']}', style: const TextStyle(fontSize: 13, color: Color(0xFF4A90E2))),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
