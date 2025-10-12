import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/medication_model.dart';

class MedicationAddScreen extends StatefulWidget {
  @override
  State<MedicationAddScreen> createState() => _MedicationAddScreenState();
}

class _MedicationAddScreenState extends State<MedicationAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  
  // 表單狀態變數
  String name = '';
  DateTime startDate = DateTime.now();
  int duration = 30;
  String usage = '口服';
  String frequencyType = '每天幾次'; 
  int frequencyValue = 1;
  String timesPerDay = '每天1次'; 
  String time = '';
  String dose = '';
  String unit = '顆';
  String instruction = '飯後';
  String notes = '';
  List<String> instructions = [];

  File? _selectedImage;
  bool _isAnalyzing = false;
  bool _useCameraInput = false;
  bool _isSubmitButtonHovered = false;

  // 下拉選項數據
  final List<String> usageOptions = ['口服', '外用', '注射', '吸入', '栓劑', '點滴'];
  final List<String> frequencyTypeOptions = ['每天幾次', '幾天一次', '幾小時一次'];
  final List<String> unitOptions = ['顆', '粒', '錠', '包', 'ml', 'mg', 'μg', '單位', 'cc'];
  final List<String> instructionOptions = ['飯前', '飯後', '隨餐', '空腹', '睡前', '睡醒'];

  // 模擬AI識別藥單功能 - 修正資料格式
  Future<void> _analyzePrescription() async {
    if (_selectedImage == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    await Future.delayed(Duration(seconds: 2));

    final mockMedications = [
      {
        'name': '阿斯匹靈', 
        'dose': '100', 
        'unit': 'mg',
        'time': '08:00, 20:00', 
        'duration': 7,
        'frequencyType': '每天幾次', // 修正為新的格式
        'frequencyValue': 1,
        'timesPerDay': '每天2次', // 修正為新的格式
        'usage': '口服',
        'instruction': '飯後',
        'notes': '請勿與其他抗凝血藥併用'
      },
      {
        'name': '降血壓藥', 
        'dose': '5', 
        'unit': 'mg',
        'time': '08:00', 
        'duration': 30,
        'frequencyType': '每天幾次', // 修正為新的格式
        'frequencyValue': 1,
        'timesPerDay': '每天1次', // 修正為新的格式
        'usage': '口服',
        'instruction': '早上',
        'notes': '定期監測血壓'
      },
    ];
    
    final randomMed = mockMedications[_selectedImage!.path.hashCode % mockMedications.length];
    
    setState(() {
      name = randomMed['name'] as String;
      dose = randomMed['dose'] as String;
      unit = randomMed['unit'] as String;
      time = randomMed['time'] as String;
      duration = randomMed['duration'] as int;
      frequencyType = randomMed['frequencyType'] as String;
      frequencyValue = randomMed['frequencyValue'] as int;
      timesPerDay = randomMed['timesPerDay'] as String;
      usage = randomMed['usage'] as String;
      instruction = randomMed['instruction'] as String;
      // 初始化用藥指導列表
      instructions = [randomMed['instruction'] as String];
      notes = randomMed['notes'] as String;
      
      _isAnalyzing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('藥單識別完成！已自動填入 "${randomMed['name']}" 的資訊'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // 修正示範資料
  void _showManualInputDemo() {
    setState(() {
      name = '示範藥物';
      dose = '250';
      unit = 'mg';
      time = '09:00, 21:00';
      duration = 30;
      frequencyType = '每天幾次'; // 修正為新的格式
      frequencyValue = 1;
      timesPerDay = '每天2次'; // 修正為新的格式
      usage = '口服';
      instruction = '飯後';
      instructions = ['飯後']; // 初始化用藥指導列表
      notes = '請按時服用，如有不適請立即就醫';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已填入示範資料，請修改為您的用藥資訊'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // 確保至少選擇一個用藥指導
      if (instructions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('請至少選擇一個用藥指導'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final newMed = Medication(
        name: name,
        startDate: startDate,
        duration: duration,
        usage: usage,
        frequencyType: frequencyType,
        frequencyValue: frequencyValue,
        timesPerDay: timesPerDay,
        time: time,
        dose: dose,
        unit: unit,
        instruction: instructions.join(', '), // 合併多個指導
        notes: notes,
        taken: false,
        remaining: duration,
      );
      Navigator.pop(context, newMed);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('成功新增用藥: $name'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // 其他方法保持不變...
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: _useCameraInput ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        await _analyzePrescription();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('圖片選擇失敗: 請檢查權限設定'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
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
        startDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (time.isNotEmpty && time != '需要時') {
          time = '$time, ${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        } else {
          time = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        }
      });
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '新增用藥',
          style: TextStyle(
            color: Colors.black87, 
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF4A90E2)),
        actions: [
          Tooltip(
            message: '查看示範資料',
            child: IconButton(
              icon: Icon(Icons.help_outline, size: 24),
              onPressed: _showManualInputDemo,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 上傳藥單卡片
              _buildUploadCard(),
              const SizedBox(height: 20),
              
              // 詳細輸入表單卡片
              _buildInputFormCard(),
            ],
          ),
        ),
      ),
    );
  }

  // 其他 Widget 方法保持不變...
  Widget _buildUploadCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.photo_camera, color: Color(0xFF4A90E2), size: 24),
                SizedBox(width: 8),
                Text(
                  '上傳藥單識別',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '拍攝或上傳您的藥單照片，系統將自動識別用藥資訊',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            
            if (_selectedImage != null) ...[
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF4A90E2), width: 2),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.close, size: 16, color: Colors.white),
                          onPressed: _clearImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _useCameraInput ? Color(0xFF4A90E2) : Colors.grey,
                      side: BorderSide(
                        color: _useCameraInput ? Color(0xFF4A90E2) : Colors.grey,
                      ),
                    ),
                    icon: Icon(Icons.camera_alt),
                    label: Text('拍照'),
                    onPressed: () {
                      setState(() {
                        _useCameraInput = true;
                      });
                      _pickImage();
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: !_useCameraInput ? Color(0xFF4A90E2) : Colors.grey,
                      side: BorderSide(
                        color: !_useCameraInput ? Color(0xFF4A90E2) : Colors.grey,
                      ),
                    ),
                    icon: Icon(Icons.photo_library),
                    label: Text('相簿'),
                    onPressed: () {
                      setState(() {
                        _useCameraInput = false;
                      });
                      _pickImage();
                    },
                  ),
                ),
              ],
            ),

            if (_isAnalyzing) ...[
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI正在分析藥單...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A90E2),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '正在識別藥物資訊',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputFormCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.medication, color: Color(0xFF4A90E2), size: 24),
                  SizedBox(width: 8),
                  Text(
                    '用藥資訊',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // 藥品名稱
              _buildInputField(
                label: '藥品名稱',
                hintText: '例如：阿斯匹靈',
                icon: Icons.medication_outlined,
                onChanged: (val) => name = val,
                validator: (val) => val!.isEmpty ? '請輸入藥品名稱' : null,
              ),
              SizedBox(height: 16),

              // 開始日期
              _buildDatePickerField(),
              SizedBox(height: 16),

              // 持續時間
              _buildDurationField(),
              SizedBox(height: 16),

              // 用法
              _buildDropdownField(
                label: '用法',
                value: usage,
                icon: Icons.medical_services,
                items: usageOptions,
                onChanged: (val) => setState(() => usage = val!),
              ),
              SizedBox(height: 16),

              // 用藥方案
              _buildMedicationPlanSection(),
              SizedBox(height: 16),

              // 用藥時間
              _buildTimePickerField(),
              SizedBox(height: 16),

              // 藥品劑量與單位
              _buildDoseSection(),
              SizedBox(height: 16),

              // 用藥指導（複選）
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '用藥指導（可複選）',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: instructionOptions.map((option) {
                      return FilterChip(
                        label: Text(option),
                        selected: instructions.contains(option),
                        selectedColor: Color(0xFF4A90E2),
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: instructions.contains(option) ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              instructions.add(option);
                            } else {
                              instructions.remove(option);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // 備註
              _buildNotesField(),
              SizedBox(height: 24),

              // 提交按鈕
              MouseRegion(
                onEnter: (_) => setState(() => _isSubmitButtonHovered = true),
                onExit: (_) => setState(() => _isSubmitButtonHovered = false),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  transform: Matrix4.identity()..scale(_isSubmitButtonHovered ? 1.02 : 1.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4A90E2),
                        foregroundColor: Colors.white,
                        elevation: _isSubmitButtonHovered ? 6 : 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.check_circle_outline, size: 24),
                      label: Text(
                        '確定新增',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _submitForm,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required IconData icon,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Color(0xFF4A90E2)),
        filled: true,
        fillColor: Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return GestureDetector(
      onTap: () => _selectStartDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: '開始日期',
            hintText: '${startDate.year}/${startDate.month}/${startDate.day}',
            prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF4A90E2)),
            suffixIcon: Icon(Icons.arrow_drop_down, color: Color(0xFF4A90E2)),
            filled: true,
            fillColor: Color(0xFFF5F7FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
            ),
          ),
          validator: (val) => startDate == null ? '請選擇開始日期' : null,
        ),
      ),
    );
  }

  Widget _buildDurationField() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            initialValue: duration.toString(),
            keyboardType: TextInputType.number,
            onChanged: (val) => duration = int.tryParse(val) ?? 30,
            decoration: InputDecoration(
              labelText: '持續時間',
              prefixIcon: Icon(Icons.schedule, color: Color(0xFF4A90E2)),
              filled: true,
              fillColor: Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
              ),
            ),
            validator: (val) {
              if (val!.isEmpty) return '請輸入持續天數';
              if (int.tryParse(val) == null) return '請輸入有效的數字';
              if (int.parse(val) <= 0) return '天數必須大於0';
              return null;
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text('天', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationPlanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '用藥方案',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: frequencyTypeOptions.map((type) {
            return ChoiceChip(
              label: Text(type),
              selected: frequencyType == type,
              selectedColor: Color(0xFF4A90E2),
              labelStyle: TextStyle(
                color: frequencyType == type ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              onSelected: (selected) {
                setState(() {
                  frequencyType = type;
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 10),
        if (frequencyType == '每天幾次')
          DropdownButtonFormField<String>(
            value: timesPerDay,
            isExpanded: true,
            onChanged: (val) => setState(() => timesPerDay = val!),
            decoration: InputDecoration(
              labelText: '用藥次數',
              filled: true,
              fillColor: Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: [
              DropdownMenuItem(value: '每天1次', child: Text('每天1次')),
              DropdownMenuItem(value: '每天2次', child: Text('每天2次')),
              DropdownMenuItem(value: '每天3次', child: Text('每天3次')),
              DropdownMenuItem(value: '每天4次', child: Text('每天4次')),
            ],
          )
        else if (frequencyType == '幾天一次')
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: frequencyValue.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => frequencyValue = int.tryParse(val) ?? 1,
                  decoration: InputDecoration(
                    labelText: '間隔天數',
                    filled: true,
                    fillColor: Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text('天一次', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            ],
          )
        else if (frequencyType == '幾小時一次')
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: frequencyValue.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => frequencyValue = int.tryParse(val) ?? 1,
                  decoration: InputDecoration(
                    labelText: '間隔小時',
                    filled: true,
                    fillColor: Color(0xFFF5F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text('小時一次', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            ],
          ),
      ],
    );
  }

  Widget _buildTimePickerField() {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: '用藥時間',
            hintText: time.isEmpty ? '點擊選擇時間（可選多個）' : time,
            prefixIcon: Icon(Icons.access_time, color: Color(0xFF4A90E2)),
            suffixIcon: Icon(Icons.arrow_drop_down, color: Color(0xFF4A90E2)),
            filled: true,
            fillColor: Color(0xFFF5F7FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
            ),
          ),
          validator: (val) => time.isEmpty ? '請選擇用藥時間' : null,
        ),
      ),
    );
  }

  Widget _buildDoseSection() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            onChanged: (val) => dose = val,
            decoration: InputDecoration(
              labelText: '藥品劑量',
              hintText: '例如：100',
              prefixIcon: Icon(Icons.scale, color: Color(0xFF4A90E2)),
              filled: true,
              fillColor: Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
              ),
            ),
            validator: (val) => val!.isEmpty ? '請輸入劑量' : null,
          ),
        ),
        SizedBox(width: 6),
        Expanded(
          flex: 1,
          child: DropdownButtonFormField<String>(
            value: unit,
            isExpanded: true,
            onChanged: (val) => setState(() => unit = val!),
            decoration: InputDecoration(
              labelText: '單位',
              filled: true,
              fillColor: Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: unitOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF4A90E2)),
        filled: true,
        fillColor: Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      maxLines: 3,
      onChanged: (val) => notes = val,
      decoration: InputDecoration(
        labelText: '備註',
        hintText: '輸入任何額外的用藥注意事項...',
        alignLabelWithHint: true,
        prefixIcon: Icon(Icons.note, color: Color(0xFF4A90E2)),
        filled: true,
        fillColor: Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
        ),
      ),
    );
  }
}