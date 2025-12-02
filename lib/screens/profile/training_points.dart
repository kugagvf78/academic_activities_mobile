import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/models/DiemRenLuyen.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrainingPointsScreen extends StatelessWidget {
  final DiemRenLuyen? diemRenLuyen;

  const TrainingPointsScreen({super.key, required this.diemRenLuyen});

  @override
  Widget build(BuildContext context) {
    final base = diemRenLuyen?.base ?? 0;
    final bonus = diemRenLuyen?.bonus ?? 0;
    final total = diemRenLuyen?.finalScore ?? 0;
    final details = diemRenLuyen?.details ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBarWidget(
        title: "Điểm Rèn Luyện",
        action: IconButton(
          icon: const Icon(Icons.home_rounded, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigation.changeTab(0);
          },
        ),
      ),

      body: details.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  const SizedBox(height: 16),
                  _buildOverview(base, bonus, total),
                  const SizedBox(height: 24),
                  const Text(
                    "Chi tiết điểm cộng",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...details.map((d) => _buildDetailCard(d)).toList(),
                ],
              ),
            ),
    );
  }

  /// ==========================
  /// EMPTY STATE
  /// ==========================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.chartLine,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            "Chưa có điểm rèn luyện",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tham gia hoạt động để tích lũy điểm!",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  /// ==========================
  /// HEADER + EXPORT BUTTON
  /// ==========================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Điểm rèn luyện",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.download,
                  size: 13,
                  color: Colors.white,
                ),
                SizedBox(width: 7),
                Text(
                  "Xuất PDF",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ==========================
  /// 3 CARD: BASE – BONUS – FINAL
  /// ==========================
  Widget _buildOverview(int base, int bonus, int total) {
    return Row(
      children: [
        Expanded(
          child: _box(
            "Điểm cơ bản",
            base.toString(),
            const Color(0xFF3B82F6),
            const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _box(
            "Điểm cộng thêm",
            "+$bonus",
            const Color(0xFF10B981),
            const Color(0xFF059669),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _box(
            "Tổng điểm",
            total.toString(),
            const Color(0xFFA855F7),
            const Color(0xFF9333EA),
          ),
        ),
      ],
    );
  }

  Widget _box(String label, String value, Color c1, Color c2) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c1, c2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: c1.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// ==========================
  /// DETAIL CARD - ENHANCED
  /// ==========================
  Widget _buildDetailCard(DiemRLDetail d) {
    final color = getColorByType(d.loai);
    final icon = getIconByType(d.loai);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(1.4), // bo viền màu
      decoration: BoxDecoration(
        color: color, // viền ngoài
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            // ---------------- HEADER ----------------
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ICON
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: FaIcon(icon, color: color, size: 20)),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.calendar,
                              size: 12,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              d.dateFormatted,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                d.loai,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "+${d.diem.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- DETAIL SECTION ----------------
            _buildDetailSection(d, color),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(DiemRLDetail d, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hoạt động
          _detailLine(
            icon: FontAwesomeIcons.tag,
            label: "Hoạt động",
            value: d.title,
          ),

          // Loại
          _detailLine(
            icon: FontAwesomeIcons.list,
            label: "Loại",
            value: d.loai,
          ),

          // Thời gian
          _detailLine(
            icon: FontAwesomeIcons.clock,
            label: "Thời gian",
            value: d.dateFormatted,
          ),

          // Địa điểm (nếu có)
          if (d.chiTiet?["dia_diem"] != null)
            _detailLine(
              icon: FontAwesomeIcons.mapMarkerAlt,
              label: "Địa điểm",
              value: d.chiTiet?["dia_diem"] ?? "",
            ),

          // Mô tả
          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 6),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FaIcon(
                FontAwesomeIcons.infoCircle,
                size: 12,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  d.mota,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailLine({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          FaIcon(icon, size: 13, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  IconData getIconByType(String loai) {
    switch (loai.toLowerCase()) {
      case "đạt giải":
      case "dat giai":
        return FontAwesomeIcons.award;

      case "hỗ trợ":
      case "ho tro":
        return FontAwesomeIcons.handsHelping;

      case "dự thi":
      case "du thi":
        return FontAwesomeIcons.userGraduate;

      case "tham dự":
      case "tham du":
        return FontAwesomeIcons.calendarCheck;

      default:
        return FontAwesomeIcons.circleInfo;
    }
  }

  Color getColorByType(String loai) {
    switch (loai.toLowerCase()) {
      case "đạt giải":
      case "dat giai":
        return const Color(0xFFF59E0B); // purple

      case "hỗ trợ":
      case "ho tro":
        return const Color(0xFF7C3AED); // violet

      case "dự thi":
      case "du thi":
        return const Color(0xFF16A34A); // green

      case "tham dự":
      case "tham du":
        return const Color(0xFF2563EB); // blue

      default:
        return Colors.grey.shade600;
    }
  }

  /// ==========================
  /// SUPPORTING FUNCTIONS
  /// ==========================
  IconData _mapIcon(String? icon) {
    switch (icon) {
      case "fa-user-graduate":
        return FontAwesomeIcons.userGraduate;
      case "fa-hands-helping":
        return FontAwesomeIcons.handsHelping;
      case "fa-users":
        return FontAwesomeIcons.users;
      default:
        return FontAwesomeIcons.circleInfo;
    }
  }

  Color _mapColor(String? c) {
    switch (c) {
      case "blue":
        return const Color(0xFF2563EB);
      case "green":
        return const Color(0xFF16A34A);
      case "purple":
        return const Color(0xFFA855F7);
      case "yellow":
        return const Color(0xFFEAB308);
      case "orange":
        return const Color(0xFFF97316);
      case "red":
        return const Color(0xFFDC2626);
      default:
        return Colors.grey.shade600;
    }
  }
}
