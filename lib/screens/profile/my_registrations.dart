import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyRegistrationsScreen extends StatelessWidget {
  const MyRegistrationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Đăng ký dự thi'),
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                labelColor: const Color(0xFF2563EB),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF2563EB),
                tabs: const [
                  Tab(text: 'Đang chờ'),
                  Tab(text: 'Đã duyệt'),
                  Tab(text: 'Từ chối'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildRegistrationList('pending'),
                  _buildRegistrationList('approved'),
                  _buildRegistrationList('rejected'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationList(String status) {
    final registrations = [
      {
        'title': 'Cuộc thi Lập trình 2024',
        'date': '15/03/2024',
        'type': 'Cá nhân',
        'status': status,
      },
      {
        'title': 'Olympic Tin học',
        'date': '20/04/2024',
        'type': 'Đội',
        'status': status,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: registrations.length,
      itemBuilder: (context, index) {
        return _buildRegistrationCard(registrations[index]);
      },
    );
  }

  Widget _buildRegistrationCard(Map<String, dynamic> reg) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (reg['status']) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = FontAwesomeIcons.circleCheck;
        statusText = 'Đã duyệt';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = FontAwesomeIcons.circleXmark;
        statusText = 'Từ chối';
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = FontAwesomeIcons.clock;
        statusText = 'Chờ duyệt';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  reg['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              FaIcon(statusIcon, color: statusColor, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.calendar,
                size: 13,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 6),
              Text(
                reg['date'],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 16),
              FaIcon(
                FontAwesomeIcons.user,
                size: 13,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 6),
              Text(
                reg['type'],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}