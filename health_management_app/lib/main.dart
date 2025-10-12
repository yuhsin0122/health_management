import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // <--- 1. 關鍵導入

import 'screens/chat_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/medication_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/records_screen.dart';
import 'screens/login_screen.dart'; // 導入 AuthScreen

void main() {
  runApp(const HealthManagementApp());
}

class HealthManagementApp extends StatelessWidget {
  const HealthManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '慢性病健康管理',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF4A90E2),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'SF Pro Display',
      ),
      // ==========================================================
      // 2. 國際化配置：解決日期選擇器錯誤的關鍵
      // ==========================================================
      supportedLocales: const [
        Locale('en', ''),       // 英文
        Locale('zh', 'TW'),     // 繁體中文 (台灣)
      ],
      // 移除 const 關鍵字來解決 "Not a constant expression" 錯誤
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ==========================================================
      
      // 應用程式應從登入畫面開始，而不是直接進入 MainScreen
      home: const AuthScreen(), 
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const RecordsScreen(),
    const MedicationScreen(),
    const InsightsScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
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
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF4A90E2),
          unselectedItemColor: const Color(0xFF9E9E9E),
          selectedFontSize: 13,
          unselectedFontSize: 13,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 28),
              label: '首頁',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_note_rounded, size: 28),
              label: '記錄',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medication_rounded, size: 28),
              label: '用藥',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_rounded, size: 28),
              label: '分析',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded, size: 28),
              label: '訊息',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded, size: 28),
              label: '我的',
            ),
          ],
        ),
      ),
    );
  }
}
