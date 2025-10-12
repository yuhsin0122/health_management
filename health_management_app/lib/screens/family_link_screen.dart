// lib/screens/family_link_screen.dart

import 'package:flutter/material.dart';
// 引入新增成員頁面和聊天室
// 確保您在同一個資料夾中或路徑正確，否則可能會報錯
import 'add_member_screen.dart'; 
import 'chat_room_screen.dart'; 

// FamilyMember class 定義 (為了確保此檔案的獨立編譯性)
class FamilyMember {
  String name;
  String relation;
  String emailOrPhone;
  bool isOnline;
  // ⭐ 修正 1: 新增 avatarUrl 屬性 (可為空)
  String? avatarUrl; 
  
  // 記錄該成員可以查看的資料清單 (血糖, 血壓, 體重, 體溫)
  Map<String, bool> sharedData; 

  FamilyMember({
    required this.name,
    required this.relation,
    required this.emailOrPhone,
    this.isOnline = false,
    // ⭐ 修正 1: 新增 avatarUrl 參數
    this.avatarUrl, 
    Map<String, bool>? sharedData,
  }) : sharedData = sharedData ?? {
   '用藥數據': false,
    '分析數據': false,
    '血糖數據': false,
    '血壓數據': false,
  };
}


class FamilyLinkScreen extends StatefulWidget {
  const FamilyLinkScreen({Key? key}) : super(key: key);

  @override
  State<FamilyLinkScreen> createState() => _FamilyLinkScreenState();
}

class _FamilyLinkScreenState extends State<FamilyLinkScreen> {
  // 模擬已綁定的家庭成員列表 (狀態)
  List<FamilyMember> _members = [
    FamilyMember(
      name: '李小美', 
      relation: '女兒', 
      emailOrPhone: 'mei@g.com', 
      isOnline: true, 
      // ⭐ 修正 2: 模擬頭像 URL
      avatarUrl: 'https://cdn.pixabay.com/photo/2017/08/30/17/57/girl-2696956_1280.jpg',
      sharedData: {
        '用藥': true,
      '分析': false,
      '血糖': true,
      '血壓': true,
      }
    ),
    FamilyMember(
      name: '李大衛', 
      relation: '配偶', 
      emailOrPhone: 'david@g.com', 
      isOnline: false, 
      // ⭐ 修正 2: 模擬頭像 URL
      avatarUrl: 'https://cdn.pixabay.com/photo/2017/09/25/13/12/man-2785535_1280.jpg',
      sharedData: {
    '用藥': true,
      '分析': true,
      '血糖': true,
      '血壓': true,
      }
    ),
    // 新增 AI 助理作為範例，因為 ChatRoomScreen 中有用到
    FamilyMember(
      name: 'AI 健康助理', 
      relation: '系統', 
      emailOrPhone: '', 
      isOnline: true, 
      avatarUrl: null, // AI 助理可能沒有圖片
      sharedData: {},
    ),
  ];

  // 導航到新增成員頁面
  void _navigateToAddMember() async {
    // 假設 AddMemberScreen 返回 FamilyMember 對象
    // 這裡我們假設 AddMemberScreen 是一個有效的 Widget
    final newMember = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddMemberScreen()),
    );

    if (newMember != null && newMember is FamilyMember) {
      setState(() {
        _members.add(newMember);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已向 ${newMember.name} 發出綁定邀請！')),
      );
    }
  }
  
  // 顯示資料分享設定的 Modal
  void _showShareSettings(FamilyMember member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 這會讓 Modal 可以佔據更多空間，如果內容多的話
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)), // 設定圓角
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              // *** START: 修正這裡的 Container 設定 ***
              padding: const EdgeInsets.all(20),
              // 移除手動設定的 margin，讓 Modal 內容自然適應
              // 裝飾器也移到 showModalBottomSheet 的 shape 參數，使圓角生效
              // 如果需要底部安全區域，可以使用 Padding(bottom: MediaQuery.of(context).viewInsets.bottom)
              
              child: Column(
                mainAxisSize: MainAxisSize.min, // 讓 Column 內容高度自適應
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '設定 ${member.name} 的資料分享權限',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Divider(height: 30, thickness: 1, color: Color(0xFFE0E0E0)), // 增加分隔線的間距
                  ...member.sharedData.keys.map((dataName) {
                    return CheckboxListTile(
                      title: Text(
                        '分享 $dataName 數據',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      value: member.sharedData[dataName],
                      onChanged: (bool? newValue) {
                        modalSetState(() {
                          setState(() { // 這個 setState 是更新 FamilyLinkScreen 的狀態
                            member.sharedData[dataName] = newValue!;
                          });
                        });
                      },
                      activeColor: const Color(0xFF4A90E2),
                      checkColor: Colors.white,
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 3, // 增加按鈕陰影
                      ),
                      child: const Text(
                        '完成設定',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // 如果有鍵盤彈出，確保內容不被遮擋
                  Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('家人關係綁定',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 1,
        actions: [
          // 右上角 + 號按鈕，點擊可以輸入家庭成員、成員關係、成員姓名
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
            onPressed: _navigateToAddMember, // 點擊新增成員
            tooltip: '新增家庭成員',
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: _members.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];
                return _buildMemberCard(member);
              },
            ),
    );
  }

  // Helper: 空狀態介面
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.family_restroom_rounded, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          const Text('尚未綁定任何家庭成員', style: TextStyle(fontSize: 18, color: Color(0xFF666666))),
          const SizedBox(height: 10),
          const Text('點擊右上角 "+" 邀請家人加入。', style: TextStyle(fontSize: 14, color: Color(0xFF999999))),
        ],
      ),
    );
  }

  // Helper: 構建頭像 Widget
  Widget _buildAvatarWidget(FamilyMember member) {
    // 檢查是否為 AI 助理，提供特殊圖標
    if (member.name == 'AI 健康助理') {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF4A90E2),
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 25),
      );
    }

    // 構建 CircleAvatar
    return CircleAvatar(
      radius: 20, 
      backgroundColor: const Color(0xFF4A90E2).withOpacity(0.8),
      
      // 如果有圖片 URL，使用 NetworkImage
      backgroundImage: (member.avatarUrl != null && member.avatarUrl!.isNotEmpty)
          ? NetworkImage(member.avatarUrl!) as ImageProvider<Object>?
          : null,
      
      // 如果沒有圖片 URL，顯示名字的第一個字
      child: (member.avatarUrl == null || member.avatarUrl!.isEmpty) 
          ? Text(
              member.name[0],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            )
          : null,
    );
  }

  // Helper: 成員卡片
  Widget _buildMemberCard(FamilyMember member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 頭像/狀態 (成員是否上線中)
            Stack(
              children: [
                // ⭐ 修正 3: 使用 _buildAvatarWidget 構建頭像
                SizedBox(width: 50, height: 50, child: _buildAvatarWidget(member)),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: member.isOnline ? Colors.greenAccent[400] : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            
            // 資訊
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    member.relation,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  ),
                  const SizedBox(height: 5),
                  // 資料分享狀態提示
                  Text(
                    '共享數據: ${member.sharedData.values.where((v) => v).length} 項',
                    style: TextStyle(fontSize: 13, color: Colors.blueGrey[400]),
                  ),
                ],
              ),
            ),

            // 操作按鈕區塊
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. 資料分享按鈕
                IconButton(
                  icon: const Icon(Icons.settings_suggest_rounded, color: Color(0xFF4A90E2)),
                  tooltip: '設定資料分享',
                  onPressed: () => _showShareSettings(member),
                ),
                // 2. 聊天按鈕 (已修正參數名稱)
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF7ED321)),
                  tooltip: '開啟聊天室',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatRoomScreen(
                          name: member.name, 
                          isOnline: member.isOnline, 
                          // ⭐ 修正 3: 將構建的 Widget 傳入 avatar 參數
                          avatar: _buildAvatarWidget(member), 
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}