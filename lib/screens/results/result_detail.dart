import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/CuocThi.dart';
import '../../../models/DatGiai.dart';
import '../../../models/VongThi.dart';
import 'package:academic_activities_mobile/cores/widgets/custom_sliver_appbar.dart';

class KetQuaDetailScreen extends StatelessWidget {
  final CuocThi cuocThi;

  /// giaiThuong: List<Map> gồm:
  /// { "data": DatGiai, "sinhvien": {...} OR "doithi": {...} }
  final List<dynamic> giaiThuong;

  final List<VongThi> vongThi;

  const KetQuaDetailScreen({
    super.key,
    required this.cuocThi,
    required this.giaiThuong,
    required this.vongThi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildHeroSection(),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              _buildMainContent(context),
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  Widget _buildHeroSection() {
    return CustomHeroSliverAppBar(
      title: cuocThi.tenCuocThi ?? "Kết quả cuộc thi",
      height: 260,
      description:
          "Ngày kết thúc: ${_fmtDate(cuocThi.thoiGianKetThuc)} • Tổng giải: ${giaiThuong.length}",
      imagePath: "assets/images/patterns/pattern3.jpg",
      metaItems: [
        _meta(FontAwesomeIcons.users, "Hình thức: ${cuocThi.hinhThucThamGia}"),
        _meta(
          FontAwesomeIcons.calendarDays,
          "Bắt đầu: ${_fmtDate(cuocThi.thoiGianBatDau)}",
        ),
        _meta(
          FontAwesomeIcons.calendarCheck,
          "Kết thúc: ${_fmtDate(cuocThi.thoiGianKetThuc)}",
        ),
      ],
    );
  }

  // ===========================================================
  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tongQuanSection(),
          const SizedBox(height: 18),

          _vongThiSection(),
          const SizedBox(height: 18),

          _top3Section(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _meta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, size: 13, color: Colors.white),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }

  // ===========================================================
  Widget _sectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: FaIcon(icon, color: iconColor, size: 18)),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          Divider(height: 25, color: Colors.grey[200]),
          child,
        ],
      ),
    );
  }

  // ===========================================================
  Widget _tongQuanSection() {
    return _sectionCard(
      icon: FontAwesomeIcons.infoCircle,
      iconColor: Colors.blue,
      title: "Tổng quan cuộc thi",
      child: Text(
        cuocThi.moTa ?? "Cuộc thi không có mô tả chi tiết.",
        style: const TextStyle(fontSize: 14.5, height: 1.6),
      ),
    );
  }

  // ===========================================================
  Widget _vongThiSection() {
    return _sectionCard(
      icon: FontAwesomeIcons.layerGroup,
      iconColor: Colors.cyan,
      title: "Kết quả từng vòng",
      child: Column(
        children: vongThi.map((v) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.checkCircle,
                  color: Colors.blue,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Text(
                  "Vòng ${v.thuTu}: ${v.tenVongThi}",
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===========================================================
  // 🏆 TOP 3 CHUNG CUỘC — UI GIỐNG WEB TEMPLATE
  // ===========================================================
  Widget _top3Section() {
    final top3 = giaiThuong.take(3).toList();

    return _sectionCard(
      icon: FontAwesomeIcons.trophy,
      iconColor: Colors.amber,
      title: "Top 3 Chung cuộc",
      child: Column(
        children: List.generate(top3.length, (index) {
          final g = top3[index];
          final DatGiai data = g["data"] as DatGiai;

          final String name = (data.loaiDangKy == "CaNhan")
              ? (g["sinhvien"]?["ten"] ?? "Thí sinh")
              : (g["doithi"]?["ten"] ?? "Đội thi");

          // Medal icon & color per rank
          Widget medal;
          Color bgColor;
          if (index == 0) {
            medal = _medalIcon(Colors.amber, FontAwesomeIcons.crown);
            bgColor = Colors.amber.shade50;
          } else if (index == 1) {
            medal = _medalIcon(Colors.grey.shade400, FontAwesomeIcons.medal);
            bgColor = Colors.grey.shade50;
          } else {
            medal = _medalIcon(Colors.orange, FontAwesomeIcons.award);
            bgColor = Colors.orange.shade50;
          }

          return Container(
            margin: EdgeInsets.only(bottom: index < top3.length - 1 ? 12 : 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              gradient: LinearGradient(
                colors: [Colors.white, bgColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Medal icon
                medal,
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.tenGiai ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.giaiThuong ?? "",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Score badge
                if (data.diemRenLuyen != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${data.diemRenLuyen} điểm",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1565C0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _medalIcon(Color color, IconData icon) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(child: FaIcon(icon, color: Colors.white, size: 20)),
    );
  }

  
  // ===========================================================
  String _fmtDate(String? iso) {
    if (iso == null) return "Không rõ";
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return "${dt.day}/${dt.month}/${dt.year}";
  }
}
