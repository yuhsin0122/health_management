import 'package:flutter/material.dart';
import 'registration_screen.dart'; // 導入註冊頁面
import '../main.dart'; // 導入 MainScreen（包含底部導航列的主畫面）

// 應用程式主要顏色
const Color _primaryColor = Color(0xFF4A90E2);

// =================================================================
// AuthScreen Widget (登入/身份驗證入口)
// =================================================================
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '帳號登入',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              // Logo/應用程式名稱 (模擬)
              const Icon(
                Icons.medical_services_rounded,
                size: 80,
                color: _primaryColor,
              ),
              const SizedBox(height: 20),
              const Text(
                '歡迎回來',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              
              // 登入表單
              _LoginForm(),

              const SizedBox(height: 20),

              // --- 註冊連結 ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '還沒有帳號嗎？',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      // 導航到註冊頁面
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      '立即註冊',
                      style: TextStyle(
                        color: _primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================================================================
// 登入表單 Stateful Widget
// =================================================================
class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  // 登入成功處理
  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // 模擬登入成功並導航到 MainScreen
      // 使用 pushAndRemoveUntil 確保主頁面替換掉所有的登入歷史記錄
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()), 
        (Route<dynamic> route) => false,
      );
    }
  }

  // 顯示忘記密碼對話框
  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 確保使用者必須完成流程或點擊取消
      builder: (BuildContext dialogContext) {
        return const _ForgotPasswordDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // 電子郵件輸入
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              decoration: _inputDecoration('電子郵件', Icons.email_rounded),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value == null || !value.contains('@') ? '請輸入有效的電子郵件' : null,
              onSaved: (value) => _email = value!,
            ),
          ),
          
          // 密碼輸入
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0), // 留空間給忘記密碼連結
            child: TextFormField(
              decoration: _inputDecoration('密碼', Icons.lock_rounded),
              obscureText: true,
              validator: (value) => value == null || value.length < 6 ? '密碼長度至少為 6 個字元' : null,
              onSaved: (value) => _password = value!,
            ),
          ),

          // 忘記密碼連結
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showForgotPasswordDialog,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                '忘記密碼?',
                style: TextStyle(color: _primaryColor, fontSize: 13),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 登入按鈕
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text(
                '登入',
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

  // 統一的 InputDecoration 樣式
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
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
    );
  }
}

// =================================================================
// 忘記密碼流程對話框 (兩步驟流程)
// =================================================================
class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog();

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  int _step = 1; // 1: 輸入Email, 2: 輸入驗證碼和新密碼

  String _email = '';
  // 模擬正確的驗證碼
  final String _simulatedCode = '123456'; 
  final TextEditingController _newPasswordController = TextEditingController();

  // Step 1: 處理發送驗證碼
  void _sendCode() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _step = 2; // 切換到第二步
      });
      // 顯示發送成功的 SnackBar 提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('模擬：驗證碼已發送到您的電子郵件！'),
          backgroundColor: Color(0xFF50C878),
        ),
      );
    }
  }

  // Step 2: 處理重設密碼
  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // 模擬重設密碼成功
      Navigator.of(context).pop(); 

      // 顯示最終成功提示
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('密碼已重設'),
            content: const Text('您的密碼已成功更新，請使用新密碼登入。'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('確定'),
              ),
            ],
          );
        },
      );
    }
  }

  // Step 1 UI: 輸入 Email
  Widget _buildStep1() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '輸入您的電子郵件地址以接收驗證碼：',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: _dialogInputDecoration('電子郵件', Icons.email_rounded),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => (value == null || !value.contains('@')) ? '請輸入有效的電子郵件' : null,
          onSaved: (value) => _email = value!,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _sendCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('傳送驗證信'),
        ),
      ],
    );
  }

  // Step 2 UI: 輸入驗證碼和新密碼
  Widget _buildStep2() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '驗證碼已寄至 $_email，請輸入並設定新密碼：',
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: _dialogInputDecoration('驗證碼', Icons.code_rounded),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return '請輸入驗證碼';
            // 模擬驗證碼檢查
            if (value != _simulatedCode) return '驗證碼不正確 (模擬: $_simulatedCode)';
            return null;
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _newPasswordController,
          decoration: _dialogInputDecoration('新密碼', Icons.lock_open_rounded),
          obscureText: true,
          validator: (value) => (value == null || value.length < 6) ? '密碼長度需至少為 6 個字元' : null,
        ),
        const SizedBox(height: 15),
        TextFormField(
          decoration: _dialogInputDecoration('確定新密碼', Icons.lock_outline_rounded),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) return '請再次輸入密碼';
            if (value != _newPasswordController.text) return '兩次輸入的密碼不一致';
            return null;
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _resetPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF50C878), // 綠色確認按鈕
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('重設密碼'),
        ),
        TextButton(
          onPressed: () {
            setState(() => _step = 1); // 返回第一步
          },
          child: const Text('重新發送驗證信'),
        ),
      ],
    );
  }
  
  // 統一的 InputDecoration 樣式 (給對話框內部使用)
  InputDecoration _dialogInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _primaryColor.withOpacity(0.7), size: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
      isDense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(_step == 1 ? '忘記密碼 (步驟 1/2)' : '重設密碼 (步驟 2/2)'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: _step == 1 ? _buildStep1() : _buildStep2(),
        ),
      ),
      actions: _step == 1 ? [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ] : [
        // 第二步不需要額外的 actions，因為它有自己的返回按鈕
      ], 
    );
  }
}
