import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home.dart';
import 'cuoc_thi.dart';
import 'ket_qua.dart';
import 'profile.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  final List<Widget> _screens = const [
    HomeScreen(),
    CuocThiScreen(),
    KetQuaScreen(),
    ProfileScreen(),
  ];

  final List<NavItemData> _navItems = const [
    NavItemData(
      icon: FontAwesomeIcons.house,
      label: 'Trang chủ',
      color: Color(0xFF667EEA),
    ),
    NavItemData(
      icon: FontAwesomeIcons.trophy,
      label: 'Cuộc thi',
      color: Color(0xFFF093FB),
    ),
    NavItemData(
      icon: FontAwesomeIcons.medal,
      label: 'Kết quả',
      color: Color(0xFF4FACFE),
    ),
    NavItemData(
      icon: FontAwesomeIcons.user,
      label: 'Hồ sơ',
      color: Color(0xFF43E97B),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _navItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 350),
        vsync: this,
      ),
    );

    _animations = _controllers
        .map((controller) => Tween(begin: 0.9, end: 1.2).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
            ))
        .toList();

    _controllers[0].forward();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTap(int index) {
    if (_currentIndex != index) {
      HapticFeedback.mediumImpact();
      _controllers[_currentIndex].reverse();
      _controllers[index].forward();
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        height: 75,
        decoration: BoxDecoration(
          color: Colors.white, // nền trắng, không blur
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _navItems.asMap().entries.map((entry) {
            int index = entry.key;
            NavItemData item = entry.value;
            bool isSelected = _currentIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => _onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _animations[index],
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    item.color.withOpacity(0.2),
                                    item.color.withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: FaIcon(
                          item.icon,
                          size: 22,
                          color:
                              isSelected ? item.color : Colors.grey.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected ? item.color : Colors.grey.shade400,
                      ),
                      child: Text(item.label),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class NavItemData {
  final IconData icon;
  final String label;
  final Color color;

  const NavItemData({
    required this.icon,
    required this.label,
    required this.color,
  });
}
