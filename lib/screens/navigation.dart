import 'package:academic_activities_mobile/screens/news/news_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      HapticFeedback.lightImpact();
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Nền có lỗ lõm với hiệu ứng đẹp hơn
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
                const Expanded(child: SizedBox()),
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

          // Nút giữa với animation đẹp mắt
          Positioned(
            top: -25,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => _onTap(2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: 68,
                  height: 68,
                  transform: Matrix4.identity()
                    ..scale(_currentIndex == 2 ? 1.08 : 1.0),
                  transformAlignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _currentIndex == 2
                          ? [const Color(0xFF0099FF), const Color(0xFF0055CC)]
                          : [const Color(0xFF0088FF), const Color(0xFF0066CC)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0088FF).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 8,
                        spreadRadius: -2,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedScale(
                      scale: _currentIndex == 2 ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      child: Image.asset(
                        "assets/icons/event.png",
                        width: 32,
                        height: 32,
                        color: Colors.white,
                      ),
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: isSelected
                      ? const EdgeInsets.all(8)
                      : EdgeInsets.zero,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFF0088FF).withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Image.asset(
                    isSelected ? iconActive : icon,
                    width: 26,
                    height: 26,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontSize: isSelected ? 13.5 : 12.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF0088FF)
                      : Colors.grey.shade600,
                  letterSpacing: 0.2,
                ),
                child: Text(label),
              ),
            ],
          ),
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

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.03)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final borderPaint = Paint()
      ..color = const Color(0xFFE8EAED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    const notchRadius = 40.0;
    final center = size.width / 2;

    path.moveTo(0, 0);
    path.lineTo(center - notchRadius - 22, 0);

    // Đường cong mượt mà hơn
    path.cubicTo(
      center - notchRadius - 10, 0,
      center - notchRadius - 5, 8,
      center - notchRadius + 8, 22,
    );

    // Vòng cung cho nút giữa
    path.arcToPoint(
      Offset(center + notchRadius - 8, 22),
      radius: const Radius.circular(52),
      clockwise: false,
    );

    path.cubicTo(
      center + notchRadius + 5, 8,
      center + notchRadius + 10, 0,
      center + notchRadius + 22, 0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Vẽ bóng mờ
    canvas.drawPath(path, shadowPaint);

    // Đổ nền
    canvas.drawPath(path, bgPaint);

    // Viền thanh lịch
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}