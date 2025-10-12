import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'profile_screen.dart'; // 引入 UserProfile 模型

// =================================================================
// EditProfileScreen 類別
// =================================================================

class EditProfileScreen extends StatefulWidget {
  // 接收 ProfileScreen 傳入的初始資料
  final UserProfile initialUser;

  const EditProfileScreen({Key? key, required this.initialUser}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

// =================================================================
// _EditProfileScreenState 狀態管理
// =================================================================

class _EditProfileScreenState extends State<EditProfileScreen> {
  // 用於表單驗證的 GlobalKey
  final _formKey = GlobalKey<FormState>();

  // 用於儲存欄位值 (初始化為傳入的初始資料)
  late String _name;
  late String _gender;
  late DateTime? _dateOfBirth;
  late String _phoneNumber;
  late String _chronicDisease;
  late String _height;
  late String _weight;
  late String _bloodType;

  @override
  void initState() {
    super.initState();
    // 使用傳入的初始資料來初始化 State 變數
    _name = widget.initialUser.name;
    _gender = widget.initialUser.gender;
    _dateOfBirth = widget.initialUser.dateOfBirth;
    _phoneNumber = widget.initialUser.phoneNumber;
    _chronicDisease = widget.initialUser.chronicDisease;
    _height = widget.initialUser.height;
    _weight = widget.initialUser.weight;
    _bloodType = widget.initialUser.bloodType;
  }

  // 處理日期選擇器
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A90E2),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  // 儲存表單資料的函式
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // 建立一個新的 UserProfile 物件，包含更新後的資料
      final updatedUser = UserProfile(
        name: _name,
        gender: _gender,
        dateOfBirth: _dateOfBirth,
        phoneNumber: _phoneNumber,
        chronicDisease: _chronicDisease,
        height: _height,
        weight: _weight,
        bloodType: _bloodType,
        profileImagePath: widget.initialUser.profileImagePath, // 保持大頭貼路徑不變
      );

      // 返回更新後的資料給 ProfileScreen (實現跨畫面資料同步和持久化)
      Navigator.of(context).pop(updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編輯個人資料',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // 預留底部空間給按鈕
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // --- 基本資訊 ---
                _buildTitle('基本資訊'),
                _buildTextFormField(
                  label: '姓名',
                  initialValue: _name,
                  validator: (value) => value == null || value.isEmpty ? '請輸入姓名' : null,
                  onSaved: (value) => _name = value!,
                ),
                const SizedBox(height: 15),
                _buildDropdownFormField(
                  label: '性別',
                  value: _gender,
                  items: ['男', '女', '其他', '未設定'],
                  onChanged: (newValue) => setState(() => _gender = newValue!),
                  onSaved: (value) => _gender = value!,
                ),
                const SizedBox(height: 15),
                // 修正後的生日欄位
                _buildDateFormField(
                  label: '出生日期',
                  value: _dateOfBirth,
                  onTap: () => _selectDate(context),
                  onSaved: () {}, 
                ),
                const SizedBox(height: 30),

                // --- 身體測量資訊 ---
                _buildTitle('身體測量'),
                _buildTextFormField(
                  label: '身高 (公分)',
                  initialValue: _height.replaceAll(' 公分', ''),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? '請輸入身高' : null,
                  onSaved: (value) => _height = '$value 公分',
                ),
                const SizedBox(height: 15),
                _buildTextFormField(
                  label: '體重 (公斤)',
                  initialValue: _weight.replaceAll(' 公斤', ''),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? '請輸入體重' : null,
                  onSaved: (value) => _weight = '$value 公斤',
                ),
                const SizedBox(height: 15),
                _buildDropdownFormField(
                  label: '血型',
                  value: _bloodType,
                  items: ['A 型', 'B 型', 'O 型', 'AB 型', '未設定'],
                  onChanged: (newValue) => setState(() => _bloodType = newValue!),
                  onSaved: (value) => _bloodType = value!,
                ),
                const SizedBox(height: 30),

                // --- 健康與聯繫資訊 ---
                _buildTitle('健康與聯繫'),
                _buildTextFormField(
                  label: '主要慢性病',
                  initialValue: _chronicDisease,
                  validator: (value) => value == null || value.isEmpty ? '請輸入主要慢性病' : null,
                  onSaved: (value) => _chronicDisease = value!,
                ),
                const SizedBox(height: 15),
                _buildTextFormField(
                  label: '手機號碼',
                  initialValue: _phoneNumber,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) return '請輸入手機號碼';
                    if (value.length < 10 && value.length > 0) return '號碼格式不正確';
                    return null;
                  },
                  onSaved: (value) => _phoneNumber = value!,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      
      // 固定底部的儲存按鈕
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _saveForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90E2),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('儲存變更', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // =================================================================
  // Helper Widgets
  // =================================================================

  // Helper Widget: 區塊標題
  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  // Helper Widget: 文本輸入欄位
  Widget _buildTextFormField({
    required String label,
    required String initialValue,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF9E9E9E)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  // Helper Widget: 下拉選單欄位
  Widget _buildDropdownFormField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
    required void Function(String?)? onSaved,
  }) {
    String? selectedValue = items.contains(value) ? value : '未設定';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF9E9E9E)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4A90E2)),
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(color: Colors.black87)),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value == '未設定') {
            return '請選擇 $label';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }

  // 修正後的 Helper Widget: 日期選擇欄位 (實現靠左對齊和日曆圖示在左側)
  Widget _buildDateFormField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    required VoidCallback onSaved,
  }) {
    // 創建一個 TextEditingController 來顯示格式化後的日期
    final TextEditingController _dateController = TextEditingController(
      text: value == null ? '' : DateFormat('yyyy/MM/dd').format(value),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Builder(
        builder: (context) {
          // 確保每次日期更新時，controller 的 text 都能刷新
          _dateController.text = value == null ? '' : DateFormat('yyyy/MM/dd').format(value);

          return TextFormField(
            controller: _dateController,
            readOnly: true, // 設定為只讀，只能透過點擊日曆圖示選擇
            onTap: onTap, // 點擊輸入框時觸發日期選擇
            
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Color(0xFF9E9E9E)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              
              // 將日曆圖示放在左側 (Prefix Icon)
              prefixIcon: IconButton(
                icon: const Icon(Icons.calendar_today, size: 20, color: Color(0xFF4A90E2)),
                onPressed: onTap, // 點擊圖示也觸發日期選擇
                padding: const EdgeInsets.only(left: 10, right: 10),
              ),
            ),
            
            textAlign: TextAlign.left, // 確保文字內容靠左對齊
            
            validator: (text) {
              if (value == null) {
                return '請選擇 $label';
              }
              return null;
            },
            onSaved: (text) => onSaved(),
          );
        }
      ),
    );
  }
}