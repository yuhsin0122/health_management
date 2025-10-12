// medication_model.dart
class Medication {
  String name;
  DateTime startDate;
  int duration;
  String usage;
  String frequencyType;
  int frequencyValue;
  String timesPerDay;
  String time;
  String dose;
  String unit;
  String instruction;
  String notes;
  bool taken;
  int remaining;

  // 向後兼容的 getter
  String get dosage => '$dose$unit';
  String get frequency => timesPerDay;
  String get dosePerIntake => '$dose$unit';

  Medication({
    required this.name,
    required this.startDate,
    required this.duration,
    required this.usage,
    required this.frequencyType,
    required this.frequencyValue,
    required this.timesPerDay,
    required this.time,
    required this.dose,
    required this.unit,
    required this.instruction,
    required this.notes,
    this.taken = false,
    this.remaining = 0,
  });

  // 向後兼容的構造函數
  factory Medication.fromLegacy({
    required String name,
    required String dosage,
    required String time,
    bool taken = false,
    int remaining = 0,
    String frequency = '每天1次',
    String instruction = '',
    String dosePerIntake = '',
  }) {
    // 簡單解析劑量和單位
    String dose = '';
    String unit = '顆';
    
    if (dosage.contains('mg')) {
      dose = dosage.replaceAll('mg', '').trim();
      unit = 'mg';
    } else if (dosage.contains('ml')) {
      dose = dosage.replaceAll('ml', '').trim();
      unit = 'ml';
    } else if (dosage.contains('IU')) {
      dose = dosage.replaceAll('IU', '').trim();
      unit = 'IU';
    } else {
      // 嘗試提取數字和單位
      final regex = RegExp(r'(\d+)\s*(\D+)');
      final match = regex.firstMatch(dosage);
      if (match != null) {
        dose = match.group(1)!;
        unit = match.group(2)!.trim();
      } else {
        dose = dosage;
        unit = '顆';
      }
    }

    // 解析頻率 - 更新為新的選項格式
    String frequencyType = '每天幾次';
    int frequencyValue = 1;
    String timesPerDay = frequency;

    if (frequency.contains('每天')) {
      frequencyType = '每天幾次';
      final match = RegExp(r'每天(\d+)次').firstMatch(frequency);
      if (match != null) {
        frequencyValue = int.tryParse(match.group(1)!) ?? 1;
        timesPerDay = '每天${frequencyValue}次';
      }
    } else if (frequency.contains('天一次')) {
      frequencyType = '幾天一次';
      final match = RegExp(r'(\d+)天一次').firstMatch(frequency);
      if (match != null) {
        frequencyValue = int.tryParse(match.group(1)!) ?? 1;
        timesPerDay = '${frequencyValue}天一次';
      }
    } else if (frequency.contains('小時一次')) {
      frequencyType = '幾小時一次';
      final match = RegExp(r'(\d+)小時一次').firstMatch(frequency);
      if (match != null) {
        frequencyValue = int.tryParse(match.group(1)!) ?? 1;
        timesPerDay = '${frequencyValue}小時一次';
      }
    }

    return Medication(
      name: name,
      startDate: DateTime.now(),
      duration: remaining,
      usage: '口服',
      frequencyType: frequencyType,
      frequencyValue: frequencyValue,
      timesPerDay: timesPerDay,
      time: time,
      dose: dose,
      unit: unit,
      instruction: instruction,
      notes: '',
      taken: taken,
      remaining: remaining,
    );
  }

  // 可選：添加 toMap 和 fromMap 方法以便資料持久化
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startDate': startDate.millisecondsSinceEpoch,
      'duration': duration,
      'usage': usage,
      'frequencyType': frequencyType,
      'frequencyValue': frequencyValue,
      'timesPerDay': timesPerDay,
      'time': time,
      'dose': dose,
      'unit': unit,
      'instruction': instruction,
      'notes': notes,
      'taken': taken,
      'remaining': remaining,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      name: map['name'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] ?? 0),
      duration: map['duration'] ?? 30,
      usage: map['usage'] ?? '口服',
      frequencyType: map['frequencyType'] ?? '每天幾次',
      frequencyValue: map['frequencyValue'] ?? 1,
      timesPerDay: map['timesPerDay'] ?? '每天1次',
      time: map['time'] ?? '',
      dose: map['dose'] ?? '',
      unit: map['unit'] ?? '顆',
      instruction: map['instruction'] ?? '飯後',
      notes: map['notes'] ?? '',
      taken: map['taken'] ?? false,
      remaining: map['remaining'] ?? 0,
    );
  }
}