import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Ảnh đại diện & thông tin sinh viên
              _buildProfileHeader(),

              const SizedBox(height: 24),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
              const SizedBox(height: 8),

              // Danh sách menu
              // Menu items không có khoảng cách
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: FontAwesomeIcons.user,
                      title: 'Thông tin cá nhân',
                      selected: true,
                      onTap: () {},
                      isFirst: true,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.trophy,
                      title: 'Hoạt động học thuật',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.chartLine,
                      title: 'Điểm rèn luyện',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.clipboardList,
                      title: 'Đăng ký dự thi',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.handsHelping,
                      title: 'Đăng ký cổ vũ - hỗ trợ',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.certificate,
                      title: 'Chứng nhận',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.gear,
                      title: 'Cài đặt',
                      onTap: () {},
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildMenuItem(
                  icon: FontAwesomeIcons.rightFromBracket,
                  title: 'Đăng xuất',
                  color: Colors.red,
                  onTap: () {
                    // TODO: Xử lý đăng xuất
                  },
                  isFirst: true,
                  isLast: true,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Header
  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            // Avatar với viền xanh dương
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF4A6FA5), width: 4),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4A6FA5),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/avatars/default_avt.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Icon camera
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.camera,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Lê Trung Kiên',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'MSSV: 2001221872',
          style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
        ),
        const SizedBox(height: 2),
        const Text(
          'Lớp 13DHTH02',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }

  // 🔹 Divider giữa các menu items
  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 56),
      child: Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),
    );
  }

  // 🔹 Menu item widget
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color? color,
    bool selected = false,
    bool isFirst = false,
    bool isLast = false,
    required VoidCallback onTap,
  }) {
    final Color textColor =
        color ?? (selected ? const Color(0xFF1976D2) : const Color(0xFF424242));
    final Color iconColor =
        color ?? (selected ? const Color(0xFF1976D2) : const Color(0xFF616161));

    return Material(
      color: selected ? const Color(0xFFE3F2FD) : Colors.transparent,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(12) : Radius.zero,
        bottom: isLast ? const Radius.circular(12) : Radius.zero,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(12) : Radius.zero,
          bottom: isLast ? const Radius.circular(12) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Center(child: FaIcon(icon, color: iconColor, size: 18)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                    fontSize: 15,
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
