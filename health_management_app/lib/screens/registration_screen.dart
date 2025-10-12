import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 假設登入畫面為 login_screen.dart，註冊成功後將導航回此處
import 'login_screen.dart'; 

// 應用程式主要顏色
const Color _primaryColor = Color(0xFF4A90E2);
const Color _accentColor = Color(0xFF50C878); // 註冊成功的綠色

// =================================================================
// 1. RegistrationScreen Widget
// =================================================================
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '建立新帳號',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F7FA), // 淺灰色背景
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: _RegistrationForm(),
        ),
      ),
    );
  }
}

// =================================================================
// 2. Registration Form Stateful Widget
// =================================================================
class _RegistrationForm extends StatefulWidget {
  const _RegistrationForm();

  @override
  State<_RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<_RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');
  // 用於比較密碼是否一致
  final TextEditingController _passwordController = TextEditingController(); 

  // Form Data States
  String _email = '';
  String _password = ''; 
  String _confirmPassword = ''; 
  String _fullName = '';
  String _idNumber = '';
  String _gender = '未選擇';
  DateTime? _dateOfBirth;
  String _phoneNumber = '';
  String _address = '';
  String _bloodType = '未選擇';
  
  // 慢性病史維持下拉式選單
  String _chronicDiseases = '無'; 
  // 變更為文字輸入框，預設為空字串
  String _allergies = '';
  // 正在服用的藥物狀態，移除可選標註
  String _medications = ''; 
  
  String _emergencyName = '';
  String _emergencyRelationship = '';
  String _emergencyPhone = '';

  final List<String> _genders = ['未選擇', '男', '女', '其他'];
  final List<String> _bloodTypes = ['未選擇', 'A 型', 'B 型', 'O 型', 'AB 型', '不確定'];
  
  // 慢性病選項 (過敏選項已移除，因為改為文字輸入)
  final List<String> _chronicDiseaseOptions = ['無', '高血壓', '糖尿病', '心臟病', '氣喘', '腎臟病', '其他'];

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  // =================================================================
  // Helper Functions
  // =================================================================

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('zh', 'TW'), // 設定為繁體中文
      builder: (context, child) {
        // 優化 DatePicker 的主題配置，確保中文顏色正確
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryColor, 
              onPrimary: Colors.white, 
              surface: Colors.white, 
              onSurface: Colors.black87, 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: _primaryColor,
              ),
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

  // 顯示成功對話框並導航的函數
  void _showSuccessDialogAndNavigate() {
    showDialog(
      context: context,
      barrierDismissible: false, // 註冊成功的關鍵提示，不允許被隨意點掉
      builder: (BuildContext dialogContext) {
        // 設定延遲 2 秒後關閉對話框並跳轉
        Future.delayed(const Duration(seconds: 2), () {
          // 確保對話框在跳轉前被關閉
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop(); 
          }
          // 跳轉至登入頁面並移除所有歷史路由
          Navigator.of(context).pushAndRemoveUntil( 
            MaterialPageRoute(builder: (context) => const AuthScreen()), 
            (Route<dynamic> route) => false,
          );
        });
        
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.all(24.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, color: _accentColor, size: 48),
              const SizedBox(height: 15),
              const Text(
                '註冊成功',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor),
              ),
              const SizedBox(height: 5),
              const Text(
                '病歷資料已建立完成，即將自動導向登入頁面...',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // 模擬執行後端操作...
      
      _showSuccessDialogAndNavigate();
    }
  }

  // =================================================================
  // UI Builder Components
  // =================================================================

  // 建立表單輸入欄位
  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    String? Function(String?)? validator,
    required void Function(String?) onSaved,
    TextEditingController? controller, 
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled, 
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller, 
        autovalidateMode: autovalidateMode, 
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: _primaryColor.withOpacity(0.7)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
          fillColor: Colors.white,
          filled: true,
        ),
        keyboardType: keyboardType,
        obscureText: isPassword,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  // 建立表單區塊標題
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
      ),
    );
  }
  
  // 建立日期選擇欄位
  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: '出生日期 *',
            prefixIcon: const Icon(Icons.calendar_today, color: _primaryColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
            fillColor: Colors.white,
            filled: true,
          ),
          // 確保 Text 小工具能顯示正確的日期或提示
          child: Text(
            _dateOfBirth == null
                ? '請選擇日期'
                : _dateFormat.format(_dateOfBirth!),
            style: TextStyle(
              fontSize: 16,
              color: _dateOfBirth == null ? Colors.grey[600] : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  // 建立下拉式選單欄位
  Widget _buildDropdownSelector({
    required String label,
    required IconData icon,
    required String selectedValue,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: _primaryColor.withOpacity(0.7)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
          fillColor: Colors.white,
          filled: true,
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) => value == '未選擇' || value == null ? '請選擇一個選項' : null,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ===============================================
          // 區塊 1: 帳號設定 
          // ===============================================
          _buildSectionHeader('1. 帳號設定'),
          _buildTextField(
            label: '電子郵件 *',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || !value.contains('@')) {
                return '請輸入有效的電子郵件地址';
              }
              return null;
            },
            onSaved: (value) => _email = value!,
          ),
          _buildTextField(
            label: '密碼 *',
            icon: Icons.lock_rounded,
            isPassword: true,
            controller: _passwordController, // 綁定 Controller
            validator: (value) {
              if (value == null || value.length < 6) {
                return '密碼長度必須至少為 6 個字元';
              }
              return null;
            },
            onSaved: (value) => _password = value!,
          ),
          // 確定密碼 (新增即時驗證)
          _buildTextField(
            label: '確定密碼 *',
            icon: Icons.lock_rounded,
            isPassword: true,
            // 啟用即時驗證
            autovalidateMode: AutovalidateMode.onUserInteraction, 
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '請再次輸入密碼';
              }
              // 檢查與上方密碼欄位是否一致
              if (value != _passwordController.text) {
                return '兩次輸入的密碼不一致';
              }
              return null;
            },
            onSaved: (value) => _confirmPassword = value!, 
          ),

          // ===============================================
          // 區塊 2: 基本身份資訊
          // ===============================================
          _buildSectionHeader('2. 基本身份資訊'),
          _buildTextField(
            label: '姓名 *',
            icon: Icons.person_rounded,
            validator: (value) => (value == null || value.isEmpty) ? '姓名為必填欄位' : null,
            onSaved: (value) => _fullName = value!,
          ),
          _buildTextField(
            label: '身份證字號/護照號碼',
            icon: Icons.credit_card_rounded,
            onSaved: (value) => _idNumber = value ?? '',
          ),
          // 日期選擇器
          _buildDateSelector(),
          _buildDropdownSelector(
            label: '性別 *',
            icon: Icons.wc_rounded,
            selectedValue: _gender,
            items: _genders,
            onChanged: (newValue) {
              setState(() {
                _gender = newValue!;
              });
            },
          ),

          // ===============================================
          // 區塊 3: 聯絡資訊
          // ===============================================
          _buildSectionHeader('3. 聯絡資訊'),
          _buildTextField(
            label: '電話號碼 *',
            icon: Icons.phone_android_rounded,
            keyboardType: TextInputType.phone,
            validator: (value) => (value == null || value.isEmpty) ? '電話號碼為必填欄位' : null,
            onSaved: (value) => _phoneNumber = value!,
          ),
          _buildTextField(
            label: '居住地址',
            icon: Icons.home_rounded,
            onSaved: (value) => _address = value ?? '',
          ),

          // ===============================================
          // 區塊 4: 醫療健康資訊
          // ===============================================
          _buildSectionHeader('4. 醫療健康資訊'),
          _buildDropdownSelector(
            label: '血型 *',
            icon: Icons.bloodtype_rounded,
            selectedValue: _bloodType,
            items: _bloodTypes,
            onChanged: (newValue) {
              setState(() {
                _bloodType = newValue!;
              });
            },
          ),
          
          // 慢性病史 (維持下拉式選單)
          _buildDropdownSelector(
            label: '慢性病史 *',
            icon: Icons.sick_rounded,
            selectedValue: _chronicDiseases,
            items: _chronicDiseaseOptions,
            onChanged: (newValue) {
              setState(() {
                _chronicDiseases = newValue!;
              });
            },
          ),

          // 過敏史 (簡答文字輸入框)
          _buildTextField(
            label: '過敏史', 
            icon: Icons.warning_rounded,
            keyboardType: TextInputType.multiline,
            onSaved: (value) => _allergies = value ?? '',
          ),

          // 正在服用的藥物
          _buildTextField(
            label: '正在服用的藥物', 
            icon: Icons.medication_rounded,
            keyboardType: TextInputType.multiline,
            onSaved: (value) => _medications = value ?? '',
          ),

          // ===============================================
          // 區塊 5: 緊急聯絡人
          // ===============================================
          _buildSectionHeader('5. 緊急聯絡人'),
          _buildTextField(
            label: '姓名 *',
            icon: Icons.person_add_alt_rounded,
            validator: (value) => (value == null || value.isEmpty) ? '緊急聯絡人姓名為必填欄位' : null,
            onSaved: (value) => _emergencyName = value!,
          ),
          _buildTextField(
            label: '關係',
            icon: Icons.supervisor_account_rounded,
            onSaved: (value) => _emergencyRelationship = value ?? '',
          ),
          _buildTextField(
            label: '電話號碼 *',
            icon: Icons.phone_in_talk_rounded,
            keyboardType: TextInputType.phone,
            validator: (value) => (value == null || value.isEmpty) ? '緊急聯絡人電話為必填欄位' : null,
            onSaved: (value) => _emergencyPhone = value!,
          ),

          const SizedBox(height: 25),
          // 註冊按鈕
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text(
                '註冊並建立病歷',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
