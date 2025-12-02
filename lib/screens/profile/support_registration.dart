import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/cores/widgets/info_tag.dart';
import 'package:academic_activities_mobile/cores/widgets/section_tag.dart';
import 'package:academic_activities_mobile/models/DangKyHoatDongFull.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportRegistrationScreen extends StatelessWidget {
  final List<DangKyHoatDongFull> activities;

  const SupportRegistrationScreen({super.key, required this.activities});

  // ========================= STYLE MAPPING =========================

  Color getTypeColor(String type) {
    switch (type) {
      case "CoVu":
        return const Color(0xFF9333EA); // Purple 600
      case "ToChuc":
        return const Color(0xFF2563EB); // Blue 600
      case "HoTroKyThuat":
        return const Color(0xFF16A34A); // Green 600
      default:
        return Colors.grey.shade600;
    }
  }

  Color getTypeBg(String type) {
    switch (type) {
      case "CoVu":
        return const Color(0xFFF3E8FF); // Purple 100
      case "ToChuc":
        return const Color(0xFFDCEEFE); // Blue 100
      case "HoTroKyThuat":
        return const Color(0xFFDCFCE7); // Green 100
      default:
        return Colors.grey.shade100;
    }
  }

  String getUrlIcon(String type) {
    switch (type) {
      case "CoVu":
        return "assets/icons/cheer.png";
      case "ToChuc":
        return "assets/icons/to_do_list.png";
      case "HoTroKyThuat":
        return "assets/icons/support.png";
      default:
        return "assets/icons/handshake.png";
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case "CoVu":
        return "Cổ vũ";
      case "ToChuc":
        return "Tổ chức";
      case "HoTroKyThuat":
        return "Hỗ trợ kỹ thuật";
      default:
        return type;
    }
  }

  Color _statusBG(String c) {
    switch (c) {
      case "green":
        return const Color(0xFFD1FAE5);
      case "blue":
        return const Color(0xFFDCEEFE);
      case "orange":
        return const Color(0xFFFED7AA);
      case "gray":
      default:
        return Colors.grey.shade200;
    }
  }

  Color _statusText(String c) {
    switch (c) {
      case "green":
        return const Color(0xFF059669);
      case "blue":
        return const Color(0xFF2563EB);
      case "orange":
        return const Color(0xFFEA580C);
      case "gray":
      default:
        return Colors.grey.shade700;
    }
  }

  IconData _statusIcon(String c) {
    switch (c) {
      case "green":
        return FontAwesomeIcons.circleCheck;
      case "blue":
        return FontAwesomeIcons.play;
      case "orange":
        return FontAwesomeIcons.clock;
      case "gray":
      default:
        return FontAwesomeIcons.ban;
    }
  }

  // ========================= BUILD =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBarWidget(
        title: "Đăng ký hỗ trợ - cổ vũ",
        action: IconButton(
          icon: const Icon(Icons.home_rounded, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigation.changeTab(0);
          },
        ),
      ),

      body: activities.isEmpty
          ? _buildEmpty()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    ...activities
                        .map((item) => _buildCard(context, item))
                        .toList(),
                    const SizedBox(height: 8),
                    _buildInfoBox(),
                  ],
                ),
              ),
            ),
    );
  }

  // =========================== HEADER ===========================

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
            "Đăng ký của tôi",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blueAccent.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.listCheck,
                  size: 14,
                  color: Colors.blueAccent.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  "${activities.length}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================== EMPTY ===========================

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
                color: Colors.purple.shade50,
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                FontAwesomeIcons.handsClapping,
                size: 48,
                color: Colors.purple.shade400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Chưa có đăng ký nào",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Hãy tham gia cổ vũ hoặc hỗ trợ\nđể nhận điểm rèn luyện!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9333EA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              onPressed: () => Navigation.changeTab(1),
              icon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 16),
              label: const Text(
                "Khám phá sự kiện",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================== CARD (ENHANCED) ===========================

  Widget _buildCard(BuildContext context, DangKyHoatDongFull item) {
  final color = getTypeColor(item.loaiHoatDong);
  final iconUrl = getUrlIcon(item.loaiHoatDong);

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(1), 
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.5),
        boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          // ================= HEADER (sạch sẽ, tinh tế) =================
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                // Icon nhỏ trong vòng tròn nhẹ
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset('${iconUrl}', width: 25, height: 25),
                  ),
                ),
                const SizedBox(width: 14),

                // Tên hoạt động + loại
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.tenHoatDong,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(FontAwesomeIcons.tag, size: 11, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        _typeLabel(item.loaiHoatDong),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

                // Status badge (gọn, đẹp)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusBG(item.statusColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(_statusIcon(item.statusColor), size: 11, color: _statusText(item.statusColor)),
                      const SizedBox(width: 5),
                      Text(
                        item.statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _statusText(item.statusColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ================= BODY (phần chi tiết - nền xám nhẹ) =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16.5),
                bottomRight: Radius.circular(16.5),
              ),
            ),
            child: Column(
              children: [
                _detailRow(FontAwesomeIcons.trophy, "Sự kiện", item.tenCuocThi),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _detailRow(FontAwesomeIcons.calendar, "Bắt đầu", _formatDate(item.thoiGianBatDau))),
                    const SizedBox(width: 20),
                    Expanded(child: _detailRow(FontAwesomeIcons.calendarCheck, "Kết thúc", _formatDate(item.thoiGianKetThuc))),
                  ],
                ),
                const SizedBox(height: 10),
                _detailRow(FontAwesomeIcons.clock, "Đăng ký", _formatDate(item.ngayDangKy)),
                const SizedBox(height: 16),

                // Điểm danh - nổi bật nhẹ
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: BoxDecoration(
                    color: item.diemDanhQR 
                        ? Colors.green.shade50 
                        : Colors.orange.shade50,
                    border: Border.all(
                      color: item.diemDanhQR ? Colors.green.shade300 : Colors.orange.shade300,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      FaIcon(
                        item.diemDanhQR ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circleXmark,
                        size: 18,
                        color: item.diemDanhQR ? Colors.green.shade700 : Colors.orange.shade700,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.diemDanhQR 
                              ? "Đã điểm danh (${_formatDateTime(item.thoiGianDiemDanh)})"
                              : "Chưa điểm danh",
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: item.diemDanhQR ? Colors.green.shade800 : Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Helper cho dòng thông tin (giống hệt màn điểm rèn luyện)
Widget _detailRow(IconData icon, String label, String value) {
  return Row(
    children: [
      FaIcon(icon, size: 13, color: Colors.grey.shade600),
      const SizedBox(width: 10),
      Text(
        "$label: ",
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ),
    ],
  );
}
  
  // =========================== INFO BOX ===========================

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.lightbulb,
                  size: 16,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Lưu ý quan trọng",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _noteItem("Hủy đăng ký được thực hiện trước 24 giờ bắt đầu sự kiện"),
          const SizedBox(height: 8),
          _noteItem("Không thể hủy nếu đã điểm danh"),
          const SizedBox(height: 8),
          _noteItem("Điểm rèn luyện được cộng sau khi điểm danh thành công"),
        ],
      ),
    );
  }

  Widget _noteItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF2563EB),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // =========================== HELPERS ===========================

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

  String _formatDateTime(String? raw) {
    if (raw == null || raw.isEmpty) return "—";
    try {
      final dt = DateTime.parse(raw);
      return "${dt.day}/${dt.month}/${dt.year} "
          "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return raw;
    }
  }
}
