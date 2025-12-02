import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/models/NguoiDung.dart';
import 'package:academic_activities_mobile/models/SinhVien.dart';
import 'package:academic_activities_mobile/models/Lop.dart';
import 'package:intl/intl.dart';

class PersonalInfoScreen extends StatelessWidget {
  final NguoiDung user;
  final SinhVien profile;
  final Lop? lop;

  const PersonalInfoScreen({
    super.key,
    required this.user,
    required this.profile,
    this.lop,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBarWidget(
        title: "Thông Tin Cá Nhân",
        action: IconButton(
          icon: const Icon(Icons.home_rounded, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigation.changeTab(0);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildContactCard(),
            const SizedBox(height: 16),
            _buildEducationCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return _card(
      icon: FontAwesomeIcons.user,
      iconColor: const Color(0xFF2563EB),
      title: "Thông tin cơ bản",
      children: [
        _buildInfoRow('Họ và tên', user.hoten ?? 'N/A'),
        _buildInfoRow('MSSV', profile.masinhvien ?? 'N/A'),
        _buildInfoRow('Lớp', lop?.tenlop ?? 'N/A'),
        _buildInfoRow('Khoa', 'Công nghệ Thông tin'), // Có thể thêm từ API
        // _buildInfoRow(
        //   'Ngày sinh',
        //   profile.ngaysinh != null
        //       ? DateFormat('dd/MM/yyyy').format(profile.ngaysinh!)
        //       : 'N/A',
        // ),
        // _buildInfoRow('Giới tính', profile.gioitinh ?? 'N/A'),
      ],
    );
  }

  Widget _buildContactCard() {
    return _card(
      icon: FontAwesomeIcons.addressBook,
      iconColor: Colors.green,
      title: "Thông tin liên hệ",
      children: [
        _buildInfoRow('Email', user.email ?? 'N/A'),
        _buildInfoRow('Số điện thoại', user.sodienthoai ?? 'N/A'),
        // _buildInfoRow('Địa chỉ', profile.diachi ?? 'TP. Hồ Chí Minh'),
      ],
    );
  }

  Widget _buildEducationCard() {
    return _card(
      icon: FontAwesomeIcons.graduationCap,
      iconColor: Colors.purple,
      title: "Thông tin học tập",
      children: [
        _buildInfoRow('Hệ đào tạo', 'Đại học chính quy'),
        _buildInfoRow(
          'Khóa học',
          profile.namnhaphoc != null
              ? '${profile.namnhaphoc} - ${profile.namnhaphoc! + 4}'
              : 'N/A',
        ),
        _buildInfoRow('Trạng thái', 'Đang học'),
        _buildInfoRow('GPA', 'N/A'), // Có thể thêm từ API
      ],
    );
  }

  Widget _card({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FaIcon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF111827),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}