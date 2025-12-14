import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/cores/widgets/error_toast.dart';
import 'package:academic_activities_mobile/cores/widgets/success_toast.dart';
import 'package:academic_activities_mobile/models/DangKyHoatDongFull.dart';
import 'package:academic_activities_mobile/screens/events/event_detail.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:academic_activities_mobile/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportRegistrationScreen extends StatefulWidget {
  final List<DangKyHoatDongFull> activities;
  final VoidCallback? onRefresh;

  const SupportRegistrationScreen({
    super.key,
    required this.activities,
    this.onRefresh,
  });

  @override
  State<SupportRegistrationScreen> createState() =>
      _SupportRegistrationScreenState();
}

class _SupportRegistrationScreenState extends State<SupportRegistrationScreen> {
  final ProfileService _profileService = ProfileService();
  late List<DangKyHoatDongFull> _activities;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _activities = widget.activities;
  }

  // ============================================================
  // 🔥 RELOAD DATA SAU KHI HỦY THÀNH CÔNG
  // ============================================================
  Future<void> _reloadData() async {
    setState(() => _loading = true);

    final result = await _profileService.getProfile();

    if (result["success"] == true) {
      setState(() {
        _activities = (result["data"]["activityRegistrations"] as List)
            .map((e) => DangKyHoatDongFull.fromJson(e))
            .toList();
      });

      widget.onRefresh?.call(); // 🔥 Gọi parent reload
    }

    setState(() => _loading = false);
  }

  void _confirmCancel(BuildContext context, String id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(24),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFDC2626),
                  size: 36,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Xác nhận hủy đăng ký",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          content: Text(
            "Bạn có chắc chắn muốn hủy đăng ký này?\nHành động này không thể hoàn tác.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey.shade600,
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Hủy bỏ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context); // Đóng dialog

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );

                      final result = await _profileService.cancelHoatDong(id);

                      if (!context.mounted) return;

                      Navigator.pop(context); // Đóng loading

                      if (result["success"] == true) {
                        SuccessToast.show(
                          context,
                          "Đã hủy đăng ký thành công!",
                        );

                        // Quay lại màn hình Profile mà không cần reload
                        Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        ); // Quay lại màn hình đầu tiên trong stack
                        Navigation.changeTab(4); // Chuyển đến tab Profile
                      } else {
                        ErrorToast.show(
                          context,
                          result["message"] ?? "Hủy thất bại",
                        );
                      }
                    },
                    child: const Text(
                      "Xác nhận",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Color getTypeColor(String type) {
    switch (type) {
      case "CoVu":
        return const Color(0xFF9333EA);
      case "ToChuc":
        return const Color(0xFF2563EB);
      case "HoTroKyThuat":
        return const Color(0xFF16A34A);
      default:
        return Colors.grey.shade600;
    }
  }

  Color getTypeBg(String type) {
    switch (type) {
      case "CoVu":
        return const Color(0xFFF3E8FF);
      case "ToChuc":
        return const Color(0xFFDCEEFE);
      case "HoTroKyThuat":
        return const Color(0xFFDCFCE7);
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

  @override
  Widget build(BuildContext context) {
    // Nếu đang tải thì hiện CircularProgressIndicator
    if (_loading) {
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
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Trả về giao diện khi không còn loading
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
      body: _activities.isEmpty
          ? _buildEmpty()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    ..._activities.map((item) => _buildCard(context, item)),
                    const SizedBox(height: 8),
                    _buildInfoBox(),
                  ],
                ),
              ),
            ),
    );
  }

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
                  "${_activities.length}",
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

  Widget _buildCard(BuildContext context, DangKyHoatDongFull item) {
    final Color accent = getTypeColor(item.loaiHoatDong);
    final String iconUrl = getUrlIcon(item.loaiHoatDong);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(id: item.idCuocThi),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withOpacity(0.15), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Image.asset(iconUrl, width: 25, height: 25),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.tenHoatDong,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.handshake_rounded,
                              size: 16,
                              color: accent,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _typeLabel(item.loaiHoatDong),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.trophy,
                              size: 14,
                              color: Color(0xFF475569),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.tenCuocThi,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBG(item.statusColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          _statusIcon(item.statusColor),
                          size: 11,
                          color: _statusText(item.statusColor),
                        ),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(height: 0.3, color: Colors.grey.shade300),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: item.diemDanhQR
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      border: Border.all(
                        color: item.diemDanhQR
                            ? Colors.green.shade300
                            : Colors.orange.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          item.diemDanhQR
                              ? FontAwesomeIcons.circleCheck
                              : FontAwesomeIcons.circleXmark,
                          size: 18,
                          color: item.diemDanhQR
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
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
                              color: item.diemDanhQR
                                  ? Colors.green.shade800
                                  : Colors.orange.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                          icon: Icons.calendar_month_rounded,
                          label: "Thời gian",
                          value:
                              "${_formatDate(item.thoiGianBatDau)} - ${_formatDate(item.thoiGianKetThuc)}",
                          color: const Color(0xFF3B82F6),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        _infoRow(
                          icon: Icons.access_time_filled_rounded,
                          label: "Ngày đăng ký",
                          value: _formatDate(item.ngayDangKy),
                          color: const Color(0xFF8B5CF6),
                        ),
                      ],
                    ),
                  ),

                  if (item.canCancel)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => _confirmCancel(context, item.id),
                          icon: const Icon(FontAwesomeIcons.xmark, size: 14),
                          label: const Text(
                            "Hủy đăng ký",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
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

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
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

  Future<Map<String, dynamic>> _cancelHoatDong(
    String id,
    BuildContext context,
  ) async {
    final service = ProfileService();
    final res = await service.cancelHoatDong(id);

    if (res['success'] == true) {
      SuccessToast.show(context, "Đã hủy đăng ký thành công!");
    } else {
      ErrorToast.show(context, res['message'] ?? "Lỗi hủy đăng ký");
    }

    return res;
  }
}
