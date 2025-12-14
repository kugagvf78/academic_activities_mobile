import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/models/NguoiDung.dart';
import 'package:academic_activities_mobile/models/SinhVien.dart';
import 'package:academic_activities_mobile/models/Lop.dart';
import 'package:intl/intl.dart';

class PersonalInfoScreen extends StatefulWidget {
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
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Tạo staggered animations cho 3 cards
    _fadeAnimations = List.generate(3, (index) {
      final start = index * 0.2;
      final end = start + 0.4;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _slideAnimations = List.generate(3, (index) {
      final start = index * 0.2;
      final end = start + 0.4;
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

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
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildAnimatedCard(
              index: 0,
              child: _buildInfoCard(),
            ),
            const SizedBox(height: 16),
            _buildAnimatedCard(
              index: 1,
              child: _buildContactCard(),
            ),
            const SizedBox(height: 16),
            _buildAnimatedCard(
              index: 2,
              child: _buildEducationCard(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({required int index, required Widget child}) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: child,
      ),
    );
  }

  Widget _buildInfoCard() {
    return _card(
      icon: FontAwesomeIcons.user,
      iconGradient: const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      title: "Thông tin cơ bản",
      children: [
        _buildInfoRow('Họ và tên', widget.user.hoten ?? 'N/A', Icons.person),
        _buildInfoRow('MSSV', widget.profile.masinhvien ?? 'N/A', Icons.badge),
        _buildInfoRow('Lớp', widget.lop?.tenlop ?? 'N/A', Icons.class_),
        _buildInfoRow(
          'Khoa',
          'Công nghệ Thông tin',
          Icons.school,
        ),
      ],
    );
  }

  Widget _buildContactCard() {
    return _card(
      icon: FontAwesomeIcons.addressBook,
      iconGradient: const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      title: "Thông tin liên hệ",
      children: [
        _buildInfoRow('Email', widget.user.email ?? 'N/A', Icons.email),
        _buildInfoRow(
          'Số điện thoại',
          widget.user.sodienthoai ?? 'N/A',
          Icons.phone,
        ),
      ],
    );
  }

  Widget _buildEducationCard() {
    return _card(
      icon: FontAwesomeIcons.graduationCap,
      iconGradient: const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      title: "Thông tin học tập",
      children: [
        _buildInfoRow(
          'Hệ đào tạo',
          'Đại học chính quy',
          Icons.apartment,
        ),
        _buildInfoRow(
          'Khóa học',
          widget.profile.namnhaphoc != null
              ? '${widget.profile.namnhaphoc} - ${widget.profile.namnhaphoc! + 4}'
              : 'N/A',
          Icons.calendar_today,
        ),
        _buildInfoRow('Trạng thái', 'Đang học', Icons.check_circle),
        _buildInfoRow('GPA', 'N/A', Icons.star),
      ],
    );
  }

  Widget _card({
    required IconData icon,
    required Gradient iconGradient,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: iconGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: iconGradient.colors.first.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: FaIcon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade200,
                  Colors.grey.shade100,
                  Colors.grey.shade200,
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Icon(
              iconData,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}