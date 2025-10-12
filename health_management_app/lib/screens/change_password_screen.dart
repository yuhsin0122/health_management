// lib/screens/change_password_screen.dart

import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('更改密碼',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              '請輸入您的舊密碼及新密碼以完成更改。',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            
            // 舊密碼欄位
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '舊密碼',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),

            // 新密碼欄位
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '新密碼',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),

            // 確認新密碼欄位
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '確認新密碼',
                prefixIcon: const Icon(Icons.lock_reset),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),

            // 確認按鈕
            ElevatedButton(
              onPressed: () {
                // 模擬更改密碼成功
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('密碼已成功更改！')),
                );
                Navigator.of(context).pop(); // 返回上一頁
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                '確認更改',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}