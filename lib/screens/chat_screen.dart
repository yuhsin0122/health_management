import 'package:flutter/material.dart';

import 'chat_room_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

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
                    '訊息',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit_note_rounded,
                      size: 28,
                      color: Color(0xFF4A90E2),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // 搜尋框
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: '搜尋聊天記錄',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Color(0xFF999999)),
                    hintStyle: TextStyle(color: Color(0xFF999999)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 聊天列表
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildChatItem(
                    context,
                    name: 'AI 健康助理',
                    message: '根據您最近的血糖記錄,平均值為142 mg/dL...',
                    time: '10:33',
                    unread: 0,
                    avatar: _buildAIAvatar(),
                    isOnline: true,
                  ),
                  _buildChatItem(
                    context,
                    name: '媽媽',
                    message: '記得按時吃藥哦!',
                    time: '昨天',
                    unread: 2,
                    avatar: _buildPersonAvatar(Colors.pink, Icons.person),
                    isOnline: false,
                  ),
                  _buildChatItem(
                    context,
                    name: '爸爸',
                    message: '今天血壓量了嗎?',
                    time: '昨天',
                    unread: 0,
                    avatar: _buildPersonAvatar(Colors.blue, Icons.person),
                    isOnline: false,
                  ),
                  _buildChatItem(
                    context,
                    name: '女兒',
                    message: '爸,晚餐要吃什麼?',
                    time: '星期三',
                    unread: 0,
                    avatar: _buildPersonAvatar(Colors.purple, Icons.person),
                    isOnline: true,
                  ),
                  _buildChatItem(
                    context,
                    name: '家庭群組',
                    message: '張醫師: 下週二回診記得帶健保卡',
                    time: '星期二',
                    unread: 5,
                    avatar: _buildGroupAvatar(),
                    isOnline: false,
                  ),
                  _buildChatItem(
                    context,
                    name: '張醫師',
                    message: '您的檢查報告已經出來了',
                    time: '星期一',
                    unread: 1,
                    avatar: _buildPersonAvatar(
                      Colors.teal,
                      Icons.medical_services,
                    ),
                    isOnline: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(
    BuildContext context, {
    required String name,
    required String message,
    required String time,
    required int unread,
    required Widget avatar,
    required bool isOnline,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ChatRoomScreen(
                  name: name,
                  avatar: avatar,
                  isOnline: isOnline,
                ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                avatar,
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 13,
                          color:
                              unread > 0
                                  ? const Color(0xFF4A90E2)
                                  : const Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                unread > 0
                                    ? Colors.black87
                                    : const Color(0xFF666666),
                            fontWeight:
                                unread > 0
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (unread > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A90E2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            unread.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIAvatar() {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.psychology_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildPersonAvatar(Color color, IconData icon) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }

  Widget _buildGroupAvatar() {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFF10B981),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.groups_rounded, color: Colors.white, size: 28),
    );
  }
}
