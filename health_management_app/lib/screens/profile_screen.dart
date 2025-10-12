// 文件名: profile_screen.dart

import 'dart:io' show File; // 只保留 File
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // 新增: 導入 kIsWeb 來判斷是否為 Web 環境
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; 
import 'edit_profile_screen.dart'; 
import 'health_record_screen.dart'; 
import 'family_link_screen.dart';
import 'notification_setting_screen.dart';
import 'privacy_security_screen.dart';
import 'about_app_screen.dart';
import 'login_screen.dart'; 
import 'dart:typed_data'; // 導入 Uint8List 所需

// =================================================================
// 1. UserProfile Data Model (必須放在此處或單獨的 model.dart 中)
// =================================================================
class UserProfile {
  String name;
  String gender;
  DateTime? dateOfBirth;
  String phoneNumber;
  String chronicDisease;
  String height;
  String weight;
  String bloodType;
  String? profileImagePath; 

  UserProfile({
    required this.name,
    this.gender = '未設定',
    this.dateOfBirth,
    this.phoneNumber = '',
    this.chronicDisease = '未設定',
    this.height = '未設定',
    this.weight = '75 公斤',
    this.bloodType = '未設定',
    this.profileImagePath,
  });
  
  // 複製構造函數，用於在 EditProfileScreen 中建立副本
  UserProfile copyWith({
    String? name,
    String? gender,
    DateTime? dateOfBirth,
    String? phoneNumber,
    String? chronicDisease,
    String? height,
    String? weight,
    String? bloodType,
    String? profileImagePath,
  }) {
    return UserProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      chronicDisease: chronicDisease ?? this.chronicDisease,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bloodType: bloodType ?? this.bloodType,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}

// =================================================================
// 2. ProfileScreen Widget
// =================================================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 模擬初始或上次儲存的資料
  UserProfile _user = UserProfile(
    name: '王小明',
    gender: '男',
    dateOfBirth: DateTime(1960, 5, 15),
    chronicDisease: '糖尿病患者',
    phoneNumber: '0987654321',
    height: '170 公分',
    weight: '75 公斤',
    bloodType: 'A 型',
    profileImagePath: null, 
  );

  // 用於儲存 Web 環境下的圖片位元組資料
  Uint8List? _profileImageBytes; 

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    
    // 選取完畢後，關閉底部的 action sheet
    if (mounted) Navigator.of(context).pop(); 
    
    if (image != null) {
      if (kIsWeb) {
        // Web 環境: 讀取圖片位元組並使用 Image.memory 顯示
        final bytes = await image.readAsBytes();
        setState(() {
          _profileImageBytes = bytes;
          // 在 Web 上 profileImagePath 留空，避免與 File 混淆
          _user.profileImagePath = null; 
        });
      } else {
        // 行動裝置/桌面環境: 使用圖片路徑和 Image.file 顯示
        setState(() {
          _user.profileImagePath = image.path;
          _profileImageBytes = null;
        });
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('圖庫中選擇照片'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('拍攝照片'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  // 導航到編輯頁面
  void _navigateToEditProfile() async {
    // 傳遞一個副本，接收更新後的 UserProfile 物件
    final updatedUser = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(initialUser: _user),
      ),
    );

    if (updatedUser != null && updatedUser is UserProfile) {
      setState(() {
        _user = updatedUser;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('個人資料已同步更新！')),
        );
      });
    }
  }
  
  void _navigateToHealthRecord() {
     Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HealthRecordScreen()),
    );
  }
  
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('確認登出'),
          content: const Text('您確定要登出帳號嗎？'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('登出', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
                // 使用從 login_screen.dart 導入的 AuthScreen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (Route<dynamic> route) => false, 
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _getProfileImageWidget() {
    // 1. 優先檢查是否有 Web 環境下的位元組資料 (kIsWeb 條件成立時)
    if (_profileImageBytes != null) {
      return ClipOval(
        child: Image.memory(
          _profileImageBytes!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    }
    
    // 2. 檢查是否有 Native 環境下的檔案路徑 (非 Web 條件成立時)
    if (_user.profileImagePath != null && !kIsWeb) {
      try {
        // 這裡只有在非 Web 環境下，File 類別才真正有效
        return ClipOval(
          child: Image.file(
            File(_user.profileImagePath!),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading image file: $error');
              // 文件路徑無效時的 fallback
              return const Icon(Icons.person, size: 60, color: Colors.white);
            },
          ),
        );
      } catch (e) {
        debugPrint('Error creating File object: $e');
      }
    }

    // 3. 預設圖標 (沒有圖片或 Web 且沒有位元組)
    return const Icon(Icons.person, size: 60, color: Colors.white);
  }
  
  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () => _showImageSourceActionSheet(context),
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _getProfileImageWidget(), 
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: 30,
              height: 30,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(color: Color(0xFF4A90E2), width: 1.5),
                  ),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Color(0xFF4A90E2),
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateAge(DateTime? dob) {
    if (dob == null) return 0;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  // =================================================================
  // 3. build 函式
  // =================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildProfileImage(), 
              const SizedBox(height: 15),
              Text(
                _user.name, 
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                // 這裡假設 dateOfBirth 不會為空
                '${_calculateAge(_user.dateOfBirth)}歲 · ${_user.chronicDisease}', 
                style: const TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
              
              const SizedBox(height: 20),
              _buildUserInfoCard(),
              
              const SizedBox(height: 30),

              // --- 區塊 1: 個人資料 ---
              _buildSettingSection('個人資料', [
                _buildSettingItem(Icons.edit_rounded, '編輯個人資料', _navigateToEditProfile), 
                _buildSettingItem(
                  Icons.health_and_safety_rounded,
                  '健康檔案',
                  _navigateToHealthRecord,
                  isLast: true,
                ),
              ]),

              // --- 區塊 2: 帳號與設定 ---
              _buildSettingSection('帳號與設定', [
                _buildSettingItem(
                  Icons.family_restroom_rounded, 
                  '家人關係綁定', 
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const FamilyLinkScreen()),
                    );
                  }
                ),
                _buildSettingItem(
                  Icons.notifications_active_rounded, 
                  '通知設定', 
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const NotificationSettingScreen()),
                    );
                  }
                ), 
                _buildSettingItem(
                  Icons.privacy_tip_rounded, 
                  '隱私與安全性', 
                  () { 
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const PrivacySecurityScreen()),
                    );
                  }
                ),
                _buildSettingItem(
                  Icons.info_rounded, 
                  '關於本應用程式', 
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AboutAppScreen()),
                    );
                  }
                ),
                _buildSettingItem(
                  Icons.logout_rounded,
                  '登出',
                  _handleLogout,
                  isDestructive: true,
                  isLast: true,
                ),
              ]),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildUserInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoItem('身高', _user.height),
            _buildDivider(),
            _buildInfoItem('體重', _user.weight),
            _buildDivider(),
            _buildInfoItem('血型', _user.bloodType),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    final parts = value.split(' ');
    final displayValue = parts[0];
    final displayUnit = parts.length > 1 ? parts[1] : '';
    
    return Column(
      children: [
        Row(
           crossAxisAlignment: CrossAxisAlignment.end,
           children: [
             Text(
               displayValue,
               style: const TextStyle(
                 fontSize: 18,
                 fontWeight: FontWeight.bold,
                 color: Color(0xFF4A90E2),
               ),
             ),
             if (displayUnit.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 2.0, bottom: 1.0),
                  child: Text(
                    displayUnit,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                ),
           ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
  
  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 35,
      color: const Color(0xFFE0E0E0),
    );
  }

  Widget _buildSettingSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: items),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
    bool isLast = false,
  }) {
    BorderRadius? borderRadius;
    // 只有最後一項才設置底部的圓角
    if (isLast) {
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      );
    } 
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          border: Border(
            bottom: BorderSide(
              color: isLast ? Colors.transparent : const Color(0xFFF0F0F0),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive
                  ? const Color(0xFFFF6B6B)
                  : const Color(0xFF4A90E2),
              size: 24,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: isDestructive ? const Color(0xFFFF6B6B) : Colors.black87,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
