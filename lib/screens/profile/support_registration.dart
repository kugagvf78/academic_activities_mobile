import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/models/DangKyHoatDongFull.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportRegistrationScreen extends StatelessWidget {
  final List<DangKyHoatDongFull> activities;

  const SupportRegistrationScreen({super.key, required this.activities});

  // ========================= STYLE MAPPING =========================

  Color _borderColor(String type) {
    switch (type) {
      case "CoVu":
        return Colors.purple.shade200;
      case "ToChuc":
        return Colors.blue.shade200;
      case "HoTroKyThuat":
        return Colors.green.shade200;
    }
    return Colors.grey.shade300;
  }

  Color _tagBG(String type) {
    switch (type) {
      case "CoVu":
        return Colors.purple.shade100;
      case "ToChuc":
        return Colors.blue.shade100;
      case "HoTroKyThuat":
        return Colors.green.shade100;
    }
    return Colors.grey.shade100;
  }

  Color _tagText(String type) {
    switch (type) {
      case "CoVu":
        return Colors.purple.shade700;
      case "ToChuc":
        return Colors.blue.shade700;
      case "HoTroKyThuat":
        return Colors.green.shade700;
    }
    return Colors.grey.shade700;
  }

  String _typeLabel(String type) {
    switch (type) {
      case "CoVu":
        return "Cổ vũ";
      case "ToChuc":
        return "Tổ chức";
      case "HoTroKyThuat":
        return "Hỗ trợ kỹ thuật";
    }
    return type;
  }

  Color _statusBG(String color) {
    switch (color) {
      case "green":
        return Colors.green.shade100;
      case "blue":
        return Colors.blue.shade100;
      case "gray":
      default:
        return Colors.grey.shade200;
    }
  }

  Color _statusText(String color) {
    switch (color) {
      case "green":
        return Colors.green.shade700;
      case "blue":
        return Colors.blue.shade700;
      case "gray":
      default:
        return Colors.grey.shade700;
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

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: activities.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, i) =>
                          _buildCard(context, activities[i]),
                    ),
            ),

            const SizedBox(height: 12),
            if (activities.isNotEmpty) _buildInfoBox(),
          ],
        ),
      ),
    );
  }

  // =========================== HEADER ===========================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Đăng ký cổ vũ - hỗ trợ của tôi",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            Navigation.changeTab(1);
          },
          icon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 14),
          label: const Text("Khám phá sự kiện"),
        )
      ],
    );
  }

  // =========================== EMPTY ===========================

  Widget _buildEmpty() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        width: 280,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            const FaIcon(FontAwesomeIcons.handsClapping, size: 50, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("Chưa có đăng ký nào",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text("Hãy tham gia cổ vũ hoặc hỗ trợ để nhận điểm rèn luyện!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey)),

            const SizedBox(height: 18),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () => Navigation.changeTab(1),
              icon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 14),
              label: const Text("Tìm sự kiện"),
            )
          ],
        ),
      ),
    );
  }

  // =========================== CARD ===========================

  Widget _buildCard(BuildContext context, DangKyHoatDongFull item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _borderColor(item.loaiHoatDong)),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Header ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.tenHoatDong,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _tagText(item.loaiHoatDong),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              _tagType(item.loaiHoatDong),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: _statusBG(item.statusColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _statusText(item.statusColor),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ---------- DETAILS ----------
          _detailRow(FontAwesomeIcons.trophy, item.tenCuocThi),
          const SizedBox(height: 6),
          _detailRow(FontAwesomeIcons.calendarDays,
              "Bắt đầu: ${_formatDate(item.thoiGianBatDau)}"),
          const SizedBox(height: 6),
          _detailRow(FontAwesomeIcons.calendarCheck,
              "Kết thúc:${_formatDate(item.thoiGianKetThuc)}"),
          const SizedBox(height: 6),
          _detailRow(FontAwesomeIcons.clock,
              "Đăng ký:${_formatDate(item.ngayDangKy)}"),
          const SizedBox(height: 10),

          // ---------- Attendance ----------
          if (item.diemDanhQR)
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 6),
                Text(
                  "Đã điểm danh (${item.thoiGianDiemDanh})",
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    SizedBox(width: 6),
                    Text("Chưa điểm danh",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),

                if (item.canCancel)
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.close, size: 14, color: Colors.red),
                    label: const Text("Hủy đăng ký",
                        style: TextStyle(color: Colors.red, fontSize: 13)),
                  ),
              ],
            ),

          // ---------- Warning: cannot cancel ----------
          if (item.status == 'upcoming' &&
              !item.canCancel &&
              !item.diemDanhQR)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.warning, color: Colors.amber, size: 16),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Không thể hủy trong vòng 24 giờ trước sự kiện.",
                      style: TextStyle(
                          fontSize: 12, color: Colors.amber, height: 1.3),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  // Tag type
  Widget _tagType(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _tagBG(type),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _typeLabel(type),
        style: TextStyle(
          color: _tagText(type),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Row detail
  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        FaIcon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        )
      ],
    );
  }

  // =========================== INFO BOX ===========================

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(FontAwesomeIcons.circleInfo,
                  size: 16, color: Colors.blue),
              SizedBox(width: 8),
              Text("Lưu ý",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 10),
          Text("• Hủy đăng ký được thực hiện trước 24 giờ bắt đầu sự kiện.",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          Text("• Không thể hủy nếu đã điểm danh.",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          Text("• Điểm rèn luyện được cộng sau khi điểm danh thành công.",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
        ],
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return "";
    try {
      final dt = DateTime.parse(raw);
      return "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year}";
    } catch (e) {
      return raw; // fallback nếu lỗi
    }
  }
}
