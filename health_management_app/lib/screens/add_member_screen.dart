// lib/screens/add_member_screen.dart

import 'package:flutter/material.dart';

// 定義一個新的家庭成員模型
class FamilyMember {
  String name;
  String relation; // 家庭關係 (如: 父親、女兒)
  String emailOrPhone; // 用於綁定的資訊
  bool isOnline;
  
  // 記錄該成員可以查看的資料清單 (血糖, 血壓, 體重, 體溫)
  Map<String, bool> sharedData; 

  FamilyMember({
    required this.name,
    required this.relation,
    required this.emailOrPhone,
    this.isOnline = false,
    Map<String, bool>? sharedData,
  }) : sharedData = sharedData ?? {
    '血糖': false,
    '血壓': false,
    '體重': false,
    '體溫': false,
  };
}


class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  String _memberName = '';
  String _memberRelation = '父親'; 
  String _emailOrPhone = '';

  // 關係選單
  final List<String> _relations = ['父親', '母親', '兒子', '女兒', '配偶', '其他'];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // 模擬創建新成員對象
      final newMember = FamilyMember(
        name: _memberName,
        relation: _memberRelation,
        emailOrPhone: _emailOrPhone,
        isOnline: false, // 假設發出邀請後是離線/待驗證狀態
      );
      
      // 返回新成員對象給 FamilyLinkScreen
      Navigator.of(context).pop(newMember);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增家庭成員', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- 成員姓名 ---
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '成員姓名 (顯示名稱)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入成員姓名';
                  }
                  return null;
                },
                onSaved: (value) {
                  _memberName = value!;
                },
              ),
              const SizedBox(height: 20),
              
              // --- 成員關係 (下拉選單) ---
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '成員關係',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.family_restroom),
                ),
                value: _memberRelation,
                items: _relations.map((String relation) {
                  return DropdownMenuItem<String>(
                    value: relation,
                    child: Text(relation),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _memberRelation = newValue!;
                  });
                },
                onSaved: (value) {
                  _memberRelation = value!;
                },
              ),
              const SizedBox(height: 20),

              // --- 綁定資訊 (Email 或 電話) ---
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '電子郵件或電話 (用於綁定)',
                  hintText: '輸入家人帳號的 Email 或電話',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.contact_mail),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '請輸入綁定資訊';
                  }
                  return null;
                },
                onSaved: (value) {
                  _emailOrPhone = value!;
                },
              ),
              const SizedBox(height: 40),

              // --- 提交按鈕 ---
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('發送綁定邀請', style: TextStyle(fontSize: 18)),
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}