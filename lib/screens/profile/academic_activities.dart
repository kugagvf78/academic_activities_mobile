import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/screens/events/event_detail.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:academic_activities_mobile/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../cores/widgets/colorful_loader.dart';
import 'package:academic_activities_mobile/models/HoatDongHocThuat.dart';

class AcademicActivitiesScreen extends StatefulWidget {
  const AcademicActivitiesScreen({super.key});

  @override
  State<AcademicActivitiesScreen> createState() =>
      _AcademicActivitiesScreenState();
}

class _AcademicActivitiesScreenState extends State<AcademicActivitiesScreen> {
  final ProfileService _profileService = ProfileService();

  List<HoatDongHocThuat> activities = [];
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

        // In dữ liệu hoạt động
        print("Activities data: ${data['activities']}");

        final List<HoatDongHocThuat> rawActivities = data["activities"] ?? [];
        final rawCertificates = data["certificates"] ?? [];

        final diemRL = data["diemRenLuyen"]?.finalScore ?? 0;

        setState(() {
          activities = rawActivities;

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
          ? ColorfulLoader() // Đây là chỗ thay duy nhất!
          : errorMessage != null
          ? _buildErrorView()
          : RefreshIndicator(
              // Thêm luôn pull-to-refresh cho đẹp
              onRefresh: _loadData, // Cho phép kéo xuống reload
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
          style: const TextStyle(fontSize: 12, color: Colors.white70),
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

        // Sử dụng HoatDongHocThuat để hiển thị dữ liệu
        ...activities
            .map(
              (a) => GestureDetector(
                onTap: () {
                  // Khi nhấn vào hoạt động, chuyển sang màn hình chi tiết
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailScreen(
                        id: a.id,
                      ), // Truyền id hoạt động vào chi tiết
                    ),
                  );
                },
                child: _buildActivityCard(a),
              ),
            )
            .toList(),
      ],
    );
  }

  // ========== CARD ITEM (Redesigned to match web version) ==========
  Widget _buildActivityCard(HoatDongHocThuat a) {
    final Color statusColor = _mapColor(a.mau);
    String month = DateFormat('MM').format(a.ngay);
    String day = DateFormat('dd').format(a.ngay);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ====== KHỐI NGÀY (Calendar Style) ======
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Text(
                      "THÁNG $month",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // ====== NỘI DUNG CHÍNH ======
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ====== HÀNG TRÊN CÙNG: TIÊU ĐỀ + TRẠNG THÁI ======
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề
                      Expanded(
                        child: Text(
                          a.ten,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // ====== TRẠNG THÁI ======
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: statusColor.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              a.trangThai,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ====== PHỤ ĐỀ (nếu có) ======
                  if (a.phuDe != null && a.phuDe!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        a.phuDe!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  const SizedBox(height: 10),

                  // ====== TAGS: Vai trò + Điểm danh ======
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Vai trò
                      if (a.role != null && a.role!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFE0E7FF),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.person_rounded,
                                size: 12,
                                color: Color(0xFF4F46E5),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                a.role!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4F46E5),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Điểm danh
                      if (a.attendance == "Đã điểm danh")
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFDCFCE7),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.qr_code_scanner,
                                size: 13,
                                color: Color(0xFF15803D),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Đã điểm danh",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF15803D),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

}
