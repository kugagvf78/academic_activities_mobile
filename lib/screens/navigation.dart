import 'package:academic_activities_mobile/screens/news/news_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home.dart';
import 'events/event_list.dart';
import 'results/result_list.dart';
import 'profile/profile.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  static void changeTab(int index) => _NavigationState._instance?._onTap(index);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  static _NavigationState? _instance;
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    NewsScreen(), 
    CuocThiScreen(),
    KetQuaScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _instance = this;
  }

  @override
  void dispose() {
    _instance = null;
    super.dispose();
  }

  void _onTap(int index) {
    if (_currentIndex != index) {
      HapticFeedback.selectionClick();
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Nền có lỗ lõm
          Positioned.fill(child: CustomPaint(painter: NavBarPainter())),

          // Menu items
          Positioned.fill(
            child: Row(
              children: [
                _buildNavItem(
                  index: 0,
                  icon: "assets/icons/home.png",
                  iconActive: "assets/icons/home_active.png",
                  label: "Trang chủ",
                ),
                _buildNavItem(
                  index: 1,
                  icon: "assets/icons/notification.png",
                  iconActive: "assets/icons/notification_active.png",
                  label: "Tin tức",
                ),

                Expanded(child: SizedBox()), // khoảng trống ở giữa

                _buildNavItem(
                  index: 3,
                  icon: "assets/icons/award.png",
                  iconActive: "assets/icons/award_active.png",
                  label: "Kết quả",
                ),
                _buildNavItem(
                  index: 4,
                  icon: "assets/icons/user.png",
                  iconActive: "assets/icons/user_active.png",
                  label: "Hồ sơ",
                ),
              ],
            ),
          ),

          // Nút giữa
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => _onTap(2),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0088FF), Color(0xFF0066CC)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/icons/event.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String iconActive,
    required String label,
  }) {
    bool isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(isSelected ? iconActive : icon, width: 28, height: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF0088FF)
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color.fromARGB(255, 210, 213, 218) // viền xám nhẹ
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();

    const notchRadius = 38.0;
    final center = size.width / 2;

    path.moveTo(0, 0);
    path.lineTo(center - notchRadius - 20, 0);

    // Vòng lõm lên
    path.quadraticBezierTo(
      center - notchRadius, 0,
      center - notchRadius + 10, 20,
    );

    path.arcToPoint(
      Offset(center + notchRadius - 10, 20),
      radius: const Radius.circular(50),
      clockwise: false,
    );

    path.quadraticBezierTo(
      center + notchRadius, 0,
      center + notchRadius + 20, 0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Đổ nền
    canvas.drawPath(path, bgPaint);

    // Viền xám nhẹ
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
