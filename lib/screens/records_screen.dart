import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Record {
  final String emoji;
  final String category;
  final String title;
  final String value;
  final String time;
  final bool isWarning;

  Record({
    required this.emoji,
    required this.category,
    required this.title,
    required this.value,
    required this.time,
    required this.isWarning,
  });
}

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({Key? key}) : super(key: key);

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  String? hoveredCategory;
  String selectedCategory = '全部';
  int hoveredIndex = -1;

  List<Record> records = [
    Record(
      emoji: '❤️',
      category: '血壓',
      title: '血壓記錄',
      value: '128/82 mmHg',
      time: '今天 09:30',
      isWarning: false,
    ),
    Record(
      emoji: '🩸',
      category: '血糖',
      title: '血糖記錄',
      value: '142 mg/dL',
      time: '今天 07:15',
      isWarning: true,
    ),
    Record(
      emoji: '⚖️',
      category: '體重',
      title: '體重記錄',
      value: '72.5 kg',
      time: '昨天 08:00',
      isWarning: false,
    ),
    Record(
      emoji: '🛌',
      category: '睡眠',
      title: '睡眠記錄',
      value: '7 小時',
      time: '昨天 23:00',
      isWarning: false,
    ),
  ];

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _deleteRecord(int index) {
    setState(() {
      records.removeAt(index);
    });
  }

  String _formatSmartTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time).inDays;

    if (difference == 0) {
      return '今天 ${DateFormat('HH:mm').format(time)}';
    } else if (difference == 1) {
      return '昨天 ${DateFormat('HH:mm').format(time)}';
    } else if (difference == 2) {
      return '前天 ${DateFormat('HH:mm').format(time)}';
    } else {
      return DateFormat('MM/dd HH:mm').format(time);
    }
  }

  Map<String, String> _getDefaultValueParts(String category) {
    switch (category) {
      case '血壓':
        return {'value': '120/80', 'unit': 'mmHg'};
      case '血糖':
        return {'value': '100', 'unit': 'mg/dL'};
      case '體重':
        return {'value': '70', 'unit': 'kg'};
      case '睡眠':
        return {'value': '8', 'unit': '小時'};
      default:
        return {'value': '', 'unit': ''};
    }
  }

  String _getEmoji(String category) {
    switch (category) {
      case '血壓':
        return '❤️';
      case '血糖':
        return '🩸';
      case '體重':
        return '⚖️';
      case '睡眠':
        return '🛌';
      default:
        return '📋';
    }
  }

  void _showRecordForm({Record? record, int? index}) {
    final category = record?.category ?? selectedCategory;
    final parts = _getDefaultValueParts(category);

    final valueController = TextEditingController(
      text:
          record == null
              ? ''
              : record.value.replaceAll(parts['unit']!, '').trim(),
    );

    final now = DateTime.now();
    String selectedTime = record?.time ?? _formatSmartTime(now);

    // 時間選擇器
    Future<void> selectTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF4A90E2), // 主題藍色
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black87,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        final formattedTime =
            '今天 ${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        selectedTime = formattedTime;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        _getEmoji(category),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    record == null ? '新增紀錄' : '修改紀錄',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 數值欄位
                  TextField(
                    controller: valueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '數值',
                      labelStyle: const TextStyle(color: Color(0xFF4A90E2)),
                      hintText: '${parts['value']} ${parts['unit']}',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF4A90E2),
                          width: 2,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // 時間選擇欄位
                  InkWell(
                    onTap: () async {
                      await selectTime();
                      setDialogState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: Color(0xFF4A90E2),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '時間',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4A90E2),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedTime,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFF4A90E2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF666666),
                  ),
                  child: const Text('取消', style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (valueController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('請輸入數值'),
                          backgroundColor: Color(0xFFFF6B6B),
                        ),
                      );
                      return;
                    }

                    final newRecord = Record(
                      emoji: record?.emoji ?? _getEmoji(category),
                      category: category,
                      title: '$category記錄',
                      value: '${valueController.text.trim()} ${parts['unit']}',
                      time: selectedTime,
                      isWarning: false,
                    );

                    setState(() {
                      if (record == null) {
                        records.add(newRecord);
                      } else {
                        records[index!] = newRecord;
                      }
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(record == null ? '記錄已新增' : '記錄已更新'),
                        backgroundColor: const Color(0xFF10B981),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '儲存',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Record> get filteredRecords {
    if (selectedCategory == '全部') return records;
    return records.where((r) => r.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '健康記錄',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          size: 28,
                          color: Color(0xFF4A90E2),
                        ),
                        onPressed: () {},
                      ),
                      if (selectedCategory != '全部')
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_rounded,
                            size: 28,
                            color: Color(0xFF4A90E2),
                          ),
                          onPressed: () => _showRecordForm(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('全部', selectedCategory == '全部'),
                    const SizedBox(width: 10),
                    _buildCategoryChip('血壓', selectedCategory == '血壓'),
                    const SizedBox(width: 10),
                    _buildCategoryChip('血糖', selectedCategory == '血糖'),
                    const SizedBox(width: 10),
                    _buildCategoryChip('體重', selectedCategory == '體重'),
                    const SizedBox(width: 10),
                    _buildCategoryChip('睡眠', selectedCategory == '睡眠'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredRecords.length,
                itemBuilder: (context, index) {
                  final record = filteredRecords[index];
                  return _buildRecordCard(index, record);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordCard(int index, Record record) {
    return MouseRegion(
      onEnter: (_) => setState(() => hoveredIndex = index),
      onExit: (_) => setState(() => hoveredIndex = -1),
      child: InkWell(
        onTap: () {
          final originalIndex = records.indexOf(record);
          if (originalIndex != -1) {
            _showRecordForm(record: record, index: originalIndex);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  record.isWarning
                      ? const Color(0xFFFF9800)
                      : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
            boxShadow:
                hoveredIndex == index
                    ? [
                      const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      record.isWarning
                          ? const Color(0xFFFFF4E5)
                          : const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    record.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            record.isWarning
                                ? const Color(0xFFFF6B00)
                                : const Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    record.time,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      final originalIndex = records.indexOf(record);
                      if (originalIndex != -1) {
                        _deleteRecord(originalIndex);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool selected) {
    final isHovered = hoveredCategory == label;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredCategory = label),
      onExit: (_) => setState(() => hoveredCategory = null),
      child: GestureDetector(
        onTap: () => _selectCategory(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                selected
                    ? const Color(0xFF4A90E2)
                    : isHovered
                    ? const Color(0xFFE3F2FD)
                    : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF4A90E2), width: 1.5),
            boxShadow:
                isHovered
                    ? [
                      const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ]
                    : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              color:
                  selected
                      ? Colors.white
                      : isHovered
                      ? const Color(0xFF1976D2)
                      : const Color(0xFF4A90E2),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
