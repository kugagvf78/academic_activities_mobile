import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/models/DangKyHoatDong.dart';
import 'package:academic_activities_mobile/models/HoatDongNgan.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:academic_activities_mobile/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cores/widgets/colorful_loader.dart';

class AcademicActivitiesScreen extends StatefulWidget {
  const AcademicActivitiesScreen({super.key});

  @override
  State<AcademicActivitiesScreen> createState() =>
      _AcademicActivitiesScreenState();
}

class _AcademicActivitiesScreenState extends State<AcademicActivitiesScreen> {
  final ProfileService _profileService = ProfileService();

  List<HoatDongNgan> activities = [];
  int soThamGia = 0;
  int soDatGiai = 0;
  int tongDiem = 0;

  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final res = await _profileService.getProfile();

      if (res["success"] == true) {
        final data = res["data"];

        final List<dynamic> rawActivities = data["activities"] ?? [];
        final rawCertificates = data["certificates"] ?? [];

        final diemRL = data["diemRenLuyen"]?.finalScore ?? 0;

        setState(() {
          activities = rawActivities
    .map<HoatDongNgan>((e) => HoatDongNgan.fromJson(e))
    .toList();

          soThamGia = activities.length;
          soDatGiai = rawCertificates.length;
          tongDiem = diemRL;

          loading = false;
          errorMessage = null;
        });
      } else {
        setState(() {
          loading = false;
          errorMessage = res["message"] ?? "Unknown error";
        });
      }
    } catch (e, stack) {
      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
      print("❌ Exception: $e");
      print("Stack: $stack");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBarWidget(
        title: "Hoạt Động Học Thuật",
        action: IconButton(
          icon: const Icon(Icons.home_rounded, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigation.changeTab(0);
          },
        ),
      ),
      body: loading
    ? ColorfulLoader()   // Đây là chỗ thay duy nhất!
    : errorMessage != null
        ? _buildErrorView()
        : RefreshIndicator(      // Thêm luôn pull-to-refresh cho đẹp
            onRefresh: _loadData,  // Cho phép kéo xuống reload
            color: Colors.orange,
            backgroundColor: Colors.blue,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildStatCard(),
                  const SizedBox(height: 16),
                  _buildActivitiesList(),
                ],
              ),
            ),
          ),
    );
  }

  // ========== ERROR VIEW ==========
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Lỗi: $errorMessage',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  loading = true;
                  errorMessage = null;
                });
                _loadData();
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  // ========== STAT CARD ==========
  Widget _buildStatCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Tham gia', '$soThamGia', FontAwesomeIcons.calendar),
          Container(width: 1, height: 40, color: Colors.white30),
          _buildStatItem('Đạt giải', '$soDatGiai', FontAwesomeIcons.trophy),
          Container(width: 1, height: 40, color: Colors.white30),
          _buildStatItem('Điểm RL', '$tongDiem', FontAwesomeIcons.star),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        FaIcon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  // ========== LIST ==========
  Widget _buildActivitiesList() {
    if (activities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'Chưa có hoạt động nào',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lịch sử tham gia',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),

        ...activities.map((a) => _buildActivityCard(a)).toList(),
      ],
    );
  }

  // ========== CARD ITEM ==========
  Widget _buildActivityCard(HoatDongNgan a) {
  final Color color = _mapColor(a.mau);

  return Container(
    margin: const EdgeInsets.only(bottom: 18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      children: [
        // -----------------
        // 🔵 TOP SECTION
        // -----------------
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FaIcon(_mapIcon(a.icon), color: color, size: 22),
                ),
              ),

              const SizedBox(width: 14),

              // TEXT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
                    Text(
                      a.ten,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),

                    // SUBTITLE
                    if (a.phuDe != null && a.phuDe!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          a.phuDe!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),

                    // ROLE (Thêm ở đây)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_pin_circle_rounded,
                            color: Colors.grey.shade500,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            a.role ?? "Không rõ",
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // BADGE TRẠNG THÁI
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  a.trangThai,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),

        // -----------------
        // 🔻 DIVIDER
        // -----------------
        Container(
          height: 1,
          color: Colors.grey.shade100,
          margin: const EdgeInsets.symmetric(horizontal: 16),
        ),

        // -----------------
        // 📅 BOTTOM SECTION
        // -----------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.calendar_month_rounded,
                  size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 8),
              Text(
                a.ngay,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  // ========== HELPERS ==========
  Color _mapColor(String c) {
    switch (c) {
      case "green":
        return Colors.green.shade600;
      case "blue":
        return Colors.blue.shade600;
      case "purple":
        return Colors.purple.shade600;
      case "orange":
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _mapIcon(String icon) {
    switch (icon) {
      case "fa-user-graduate":
        return FontAwesomeIcons.userGraduate;
      case "fa-hands-helping":
        return FontAwesomeIcons.handsHelping;
      case "fa-users":
        return FontAwesomeIcons.users;
      default:
        return FontAwesomeIcons.flag;
    }
  }
}
