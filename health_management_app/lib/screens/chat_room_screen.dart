import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  final String name;
  final Widget avatar;
  final bool isOnline;

  const ChatRoomScreen({
    Key? key,
    required this.name,
    required this.avatar,
    required this.isOnline,
  }) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    if (widget.name == 'AI 健康助理') {
      _messages.addAll([
        ChatMessage(
          text: '您好!我是您的健康助理,有什麼可以幫您的嗎?',
          isUser: false,
          time: '10:30',
        ),
        ChatMessage(text: '我最近血糖有點高,該怎麼辦?', isUser: true, time: '10:32'),
        ChatMessage(
          text:
              '根據您最近的血糖記錄,平均值為142 mg/dL,確實偏高。建議:\n\n1. 減少精緻糖類攝取\n2. 增加運動量,每週至少3次\n3. 按時服用降血糖藥\n4. 建議回診諮詢醫師',
          isUser: false,
          time: '10:33',
        ),
      ]);
    } else if (widget.name == '媽媽') {
      _messages.addAll([
        ChatMessage(text: '今天血壓測了嗎?', isUser: false, time: '昨天 09:30'),
        ChatMessage(text: '測了,128/82', isUser: true, time: '昨天 10:15'),
        ChatMessage(text: '很好!記得按時吃藥哦!', isUser: false, time: '昨天 10:20'),
      ]);
    } else {
      _messages.add(
        ChatMessage(
          text: '開始與 ${widget.name} 的對話...',
          isUser: false,
          time: '剛剛',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            SizedBox(width: 40, height: 40, child: widget.avatar),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  widget.isOnline ? '線上' : '離線',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        widget.isOnline
                            ? const Color(0xFF10B981)
                            : const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_rounded, color: Color(0xFF4A90E2)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call_rounded, color: Color(0xFF4A90E2)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            SizedBox(width: 35, height: 35, child: widget.avatar),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  message.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color:
                        message.isUser ? const Color(0xFF4A90E2) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: message.isUser ? Colors.white : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 10),
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_rounded,
              color: Color(0xFF4A90E2),
              size: 28,
            ),
            onPressed: () {
              _showAttachmentOptions(context);
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: '輸入訊息...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color(0xFF999999)),
                ),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              if (_messageController.text.trim().isNotEmpty) {
                setState(() {
                  _messages.add(
                    ChatMessage(
                      text: _messageController.text,
                      isUser: true,
                      time:
                          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                    ),
                  );
                  _messageController.clear();

                  if (widget.name == 'AI 健康助理') {
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        _messages.add(
                          ChatMessage(
                            text: '我已經收到您的訊息,正在分析您的健康數據...',
                            isUser: false,
                            time:
                                '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                          ),
                        );
                      });
                    });
                  }
                });
              }
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAttachmentOption(
                icon: Icons.camera_alt_rounded,
                label: '拍照上傳病歷',
                color: const Color(0xFF6366F1),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              _buildAttachmentOption(
                icon: Icons.photo_library_rounded,
                label: '從相簿選擇',
                color: const Color(0xFF10B981),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              _buildAttachmentOption(
                icon: Icons.description_rounded,
                label: '分享健康記錄',
                color: const Color(0xFFFF9800),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 15),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}
