import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/models/DatGiaiApi.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CertificatesScreen extends StatelessWidget {
  final List<DatGiaiApi> certificates;

  const CertificatesScreen({super.key, required this.certificates});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBarWidget(
        title: "Chứng Nhận & Đạt Giải",
        action: IconButton(
          icon: const Icon(Icons.home_rounded, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigation.changeTab(0);
          },
        ),
      ),
      body: certificates.isEmpty
          ? _buildEmpty()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    ...certificates.map((c) => _buildCertificateCard(c)).toList(),
                  ],
                ),
              ),
            ),
    );
  }

  // ========================= HEADER =========================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Danh sách chứng nhận",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              border: Border.all(color: Colors.amber.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.award,
                    size: 14, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                Text(
                  "${certificates.length}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========================= EMPTY STATE =========================
  Widget _buildEmpty() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                FontAwesomeIcons.trophy,
                size: 48,
                color: Colors.amber.shade400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Chưa có chứng nhận",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tham gia và đạt giải trong các cuộc thi\nđể nhận chứng nhận!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================= CERTIFICATE CARD =========================
  Widget _buildCertificateCard(DatGiaiApi cert) {
    // ✅ Sửa: Dùng đúng properties từ DatGiaiApi
    final award = cert.tenGiai ?? "Chưa có tên giải";
    final prize = cert.giaiThuong ?? "Chưa có giải thưởng";
    final event = cert.tenCuocThi ?? "Chưa có tên cuộc thi";
    final date = cert.ngayTrao;
    final points = cert.diemRenLuyen ?? 0.0;
    final type = cert.loaiDangKy == "DoiNhom" ? "Đội nhóm" : "Cá nhân";

    final awardLevel = _getAwardLevel(award);
    final awardColor = _getAwardColor(awardLevel);
    final awardIcon = _getAwardIcon(awardLevel);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: awardColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: awardColor.withOpacity(0.3)),
                ),
                child: Center(
                  child: FaIcon(
                    awardIcon,
                    color: awardColor,
                    size: 22,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      award,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: awardColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    // ✅ Hiển thị tên đội nếu có
                    if (cert.tenDoiThi != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          "Đội: ${cert.tenDoiThi}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "${points.toStringAsFixed(1)} điểm",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),
          Divider(thickness: 1, color: Colors.grey.shade200),
          const SizedBox(height: 5),

          _miniInfo("assets/icons/event2.png", event),
          const SizedBox(height: 7),

          _miniInfo("assets/icons/gift.png", prize),
          const SizedBox(height: 7),

          _miniInfo("assets/icons/calendar.png", _formatDate(date)),
        ],
      ),
    );
  }

  // ========================= Info Row =========================
  Widget _miniInfo(String iconUrl, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(iconUrl, width: 18, height: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }

  // ========================= AWARD HELPERS =========================
  int _getAwardLevel(String award) {
    final a = award.toLowerCase();
    if (a.contains("nhất") || a.contains("first") || a.contains("vàng")) return 1;
    if (a.contains("nhì") || a.contains("second") || a.contains("bạc")) return 2;
    if (a.contains("ba") || a.contains("third") || a.contains("đồng")) return 3;
    return 0;
  }

  Color _getAwardColor(int level) {
    switch (level) {
      case 1:
        return const Color(0xFFEAB308);
      case 2:
        return const Color(0xFFD97706);
      case 3:
        return const Color(0xFF94A3B8);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  IconData _getAwardIcon(int level) {
    switch (level) {
      case 1:
        return FontAwesomeIcons.crown;
      case 2:
        return FontAwesomeIcons.medal;
      case 3:
        return FontAwesomeIcons.award;
      default:
        return FontAwesomeIcons.certificate;
    }
  }

  // ========================= DATE FORMAT =========================
  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return "—";
    try {
      final dt = DateTime.parse(raw);
      return "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year}";
    } catch (_) {
      return raw;
    }
  }
}