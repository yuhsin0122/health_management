import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'clinic_add_screen.dart';

class ClinicsScreen extends StatefulWidget {
  const ClinicsScreen({Key? key}) : super(key: key);

  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  List<Clinic> clinicList = [
    Clinic(
      name: '台大醫院',
      department: '新陳代謝科',
      doctor: '王醫師',
      address: '台北市中正區中山南路7號',
      phone: '02-2312-3456',
      nextVisit: '2024/10/15 14:00',
      note: '記得帶健保卡和上次的檢查報告',
    ),
    Clinic(
      name: '仁愛醫院',
      department: '心臟內科',
      doctor: '李醫師',
      address: '台北市大安區仁愛路四段10號',
      phone: '02-2709-3600',
    ),
    Clinic(
      name: '康寧診所',
      department: '家醫科',
      doctor: '陳醫師',
      address: '台北市內湖區成功路四段168號',
      phone: '02-2634-5678',
    ),
  ];

  void _addClinic(Clinic clinic) {
    setState(() {
      clinicList.add(clinic);
    });
  }

  void _deleteClinic(int index) {
    setState(() {
      clinicList.removeAt(index);
    });
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
        title: const Text(
          '我的診所',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_rounded,
              color: Color(0xFF4A90E2),
              size: 28,
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClinicAddScreen(),
                ),
              );
              if (result is Clinic) {
                _addClinic(result);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('診所已新增成功'),
                    backgroundColor: Color(0xFF10B981),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: clinicList.length,
        itemBuilder: (context, index) {
          final clinic = clinicList[index];
          return _buildClinicCard(
            context,
            index: index,
            name: clinic.name,
            department: clinic.department,
            doctor: clinic.doctor,
            address: clinic.address,
            phone: clinic.phone,
            nextVisit: clinic.nextVisit,
            note: clinic.note,
          );
        },
      ),
    );
  }

  Widget _buildClinicCard(
    BuildContext context, {
    required int index,
    required String name,
    required String department,
    required String doctor,
    required String address,
    required String phone,
    String? nextVisit,
    String note = '',
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: Color(0xFF4A90E2),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$department · $doctor',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Color(0xFF666666)),
                onSelected: (value) {
                  if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('確認刪除'),
                            content: const Text('確定要刪除此診所嗎?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _deleteClinic(index);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('診所已刪除'),
                                      backgroundColor: Color(0xFFFF6B6B),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Text(
                                  '刪除',
                                  style: TextStyle(color: Color(0xFFFF6B6B)),
                                ),
                              ),
                            ],
                          ),
                    );
                  }
                },
                itemBuilder:
                    (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Color(0xFFFF6B6B)),
                            SizedBox(width: 8),
                            Text('刪除診所'),
                          ],
                        ),
                      ),
                    ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildInfoRow(Icons.location_on_outlined, address),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.phone_outlined, phone),
          if (nextVisit != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4E5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event, size: 16, color: Color(0xFFFF9800)),
                  const SizedBox(width: 8),
                  Text(
                    '下次回診: $nextVisit',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (note.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.note_outlined,
                    size: 16,
                    color: Color(0xFF666666),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      note,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _openMap(address);
                  },
                  icon: const Icon(Icons.navigation_rounded, size: 18),
                  label: const Text('導航'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4A90E2),
                    side: const BorderSide(color: Color(0xFF4A90E2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _makePhoneCall(phone);
                  },
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text('電話'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF666666)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
        ),
      ],
    );
  }

  void _openMap(String address) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _makePhoneCall(String phone) async {
    final url = Uri.parse('tel:${phone.replaceAll('-', '')}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
