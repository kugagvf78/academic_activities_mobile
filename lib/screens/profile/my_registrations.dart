import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/cores/widgets/error_toast.dart';
import 'package:academic_activities_mobile/cores/widgets/status_badge.dart';
import 'package:academic_activities_mobile/cores/widgets/success_toast.dart';
import 'package:academic_activities_mobile/models/DangKyCaNhan.dart';
import 'package:academic_activities_mobile/models/DangKyDoiThi.dart';
import 'package:academic_activities_mobile/screens/events/event_detail.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:academic_activities_mobile/screens/profile/submit_exam_screen.dart';
import 'package:academic_activities_mobile/services/profile_service.dart'; // ✅ IMPORT
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyRegistrationsScreen extends StatefulWidget {
  final List competition;
  final VoidCallback onRefresh;

  const MyRegistrationsScreen({
    super.key,
    required this.competition,
    required this.onRefresh,
  });

  @override
  State<MyRegistrationsScreen> createState() => _MyRegistrationsScreenState();
}

class _MyRegistrationsScreenState extends State<MyRegistrationsScreen> {
  final ProfileService _profileService = ProfileService();
  List _competitions = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _competitions = widget.competition; // ✅ KHỞI TẠO TỪ PROP
  }

  Future<void> _reloadData() async {
    setState(() => _isLoading = true);

    final result = await _profileService.getProfile();

    if (result['success'] == true) {
      setState(() {
        _competitions = result['data']['competitionRegistrations'] ?? [];
        _isLoading = false;
      });

      widget.onRefresh(); // ✅ GỌI CALLBACK ĐỂ PARENT CŨNG RELOAD
    } else {
      setState(() => _isLoading = false);
    }
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
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
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

          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "Bạn có chắc chắn muốn hủy đăng ký này?\nHành động này không thể hoàn tác.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
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
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Navigator.pop(context); // Đóng dialog

                        // ✅ SHOW LOADING
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        );

                        // ✅ GỌI API HỦY
                        final result = await _profileService.cancelCompetition(
                          id,
                        );

                        if (!context.mounted) return;

                        Navigator.pop(context); // Đóng loading

                        if (result['success'] == true) {
                          SuccessToast.show(
                            context,
                            'Đã hủy đăng ký thành công!',
                          );

                          // ✅ RELOAD DATA NGAY TRONG MÀN HÌNH NÀY
                          await _reloadData();
                        } else {
                          ErrorToast.show(
                            context,
                            result['message'] ?? 'Lỗi hủy đăng ký',
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
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBarWidget(
          title: "Đăng Ký Dự Thi",
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

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBarWidget(
        title: "Đăng Ký Dự Thi",
        action: IconButton(
          icon: const Icon(Icons.home_rounded, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigation.changeTab(0);
          },
        ),
      ),
      body:
          _competitions
              .isEmpty // ✅ DÙNG _competitions
          ? _buildEmpty()
          : DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.white,
                    child: TabBar(
                      isScrollable: false,
                      labelColor: const Color(0xFF2563EB),
                      unselectedLabelColor: Colors.grey.shade600,
                      indicatorColor: const Color(0xFF2563EB),
                      indicatorWeight: 3,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(text: 'Sắp diễn ra'),
                        Tab(text: 'Đang diễn ra'),
                        Tab(text: 'Đã kết thúc'),
                        Tab(text: 'Tất cả'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildRegistrationList('upcoming'),
                        _buildRegistrationList('ongoing'),
                        _buildRegistrationList('ended'),
                        _buildRegistrationList('all'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ========================= EMPTY STATE =========================
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
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.clipboardList,
              size: 50,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              "Chưa có đăng ký nào",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "Hãy đăng ký tham gia cuộc thi để nhận điểm rèn luyện!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onPressed: () => Navigation.changeTab(1),
              icon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 14),
              label: const Text("Tìm cuộc thi"),
            ),
          ],
        ),
      ),
    );
  }

  // ========================= LIST =========================
  Widget _buildRegistrationList(String filterStatus) {
    List filtered = _competitions.where((item) {
      // ✅ DÙNG _competitions
      final status = _getStatus(item).toLowerCase();

      if (filterStatus == 'upcoming') return status == 'upcoming';
      if (filterStatus == 'ongoing') return status == 'ongoing';
      if (filterStatus == 'ended') return status == 'ended';

      return true;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.inbox,
              size: 48,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              "Không có đăng ký nào",
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _buildRegistrationCard(filtered[index], context);
      },
    );
  }

  // ========================= CARD =========================
  Widget _buildRegistrationCard(dynamic item, BuildContext context) {
    String title, dateStart, dateEnd, registerDate, statusLabel;
    String? subtitle;
    bool isCaNhan;
    String idcuocthi;

    if (item is DangKyCaNhan) {
      title = item.tenCuocThi;
      subtitle = null;
      dateStart = item.thoiGianBatDau;
      dateEnd = item.thoiGianKetThuc;
      registerDate = item.ngayDangKy;
      statusLabel = item.statusLabel;
      isCaNhan = true;
      idcuocthi = item.idcuocthi;
    } else if (item is DangKyDoiThi) {
      title = item.tenCuocThi;
      subtitle = "Đội: ${item.tenDoiThi}";
      dateStart = item.thoiGianBatDau;
      dateEnd = item.thoiGianKetThuc;
      registerDate = item.ngayDangKy;
      statusLabel = item.statusLabel;
      isCaNhan = false;
      idcuocthi = item.idcuocthi;
    } else {
      return const SizedBox.shrink();
    }

    final Color accent = isCaNhan
        ? const Color(0xFF2563EB)
        : const Color(0xFF7C3AED);

    bool submitted = item.trangThaiNop?.toLowerCase() == "submitted";
    bool isOngoing = item.status.toLowerCase() == "ongoing";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EventDetailScreen(id: idcuocthi)),
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
              spreadRadius: 0,
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
            // ================= HEADER =================
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [accent, accent.withOpacity(0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: FaIcon(
                            isCaNhan
                                ? FontAwesomeIcons.userGraduate
                                : FontAwesomeIcons.users,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // TITLE + TYPE
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
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
                                  isCaNhan
                                      ? Icons.person_rounded
                                      : Icons.groups_rounded,
                                  size: 16,
                                  color: accent,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isCaNhan ? "Cá nhân" : "Đội nhóm",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: accent,
                                  ),
                                ),
                              ],
                            ),

                            if (subtitle != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.group,
                                      size: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        subtitle!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      StatusBadge(
                        label: statusLabel,
                        color: _mapStatusColor(statusLabel),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(height: 0.3, color: Colors.grey.shade300),
            ),

            // ================= BODY =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== SUBMISSION STATUS =====
                  if (item.status.toLowerCase() != "upcoming")
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: submitted
                            ? Colors.green.shade50
                            : Colors.orange.shade50,
                        border: Border.all(
                          color: submitted
                              ? Colors.green.shade300
                              : Colors.orange.shade300,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          FaIcon(
                            submitted
                                ? FontAwesomeIcons.circleCheck
                                : FontAwesomeIcons.circleXmark,
                            size: 18,
                            color: submitted
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              submitted
                                  ? "Đã nộp bài (${_formatDate(item.thoiGianNop!)})"
                                  : "Chưa nộp bài",
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: submitted
                                    ? Colors.green.shade800
                                    : Colors.orange.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // ===== INFO GRID =====
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
                          label: "Thời gian thi",
                          value:
                              "${_formatOnlyDate(dateStart)} - ${_formatOnlyDate(dateEnd)}",
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
                          icon: Icons.flag_rounded,
                          label: "Hạn nộp bài",
                          value: _formatOnlyDate(dateEnd),
                          color: const Color(0xFFEF4444),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        _infoRow(
                          icon: Icons.edit_calendar_rounded,
                          label: "Ngày đăng ký",
                          value: _formatOnlyDate(registerDate),
                          color: const Color(0xFF8B5CF6),
                        ),
                      ],
                    ),
                  ),

                  // ================== ACTION BUTTON ==================
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: _buildActionButton(
                      context: context,
                      item: item,
                      idcuocthi: idcuocthi,
                      submitted: submitted,
                      isOngoing: isOngoing,
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

  Widget _buildActionButton({
    required BuildContext context,
    required dynamic item,
    required String idcuocthi,
    required bool submitted,
    required bool isOngoing,
  }) {
    final bool isUpcoming = item.status.toLowerCase() == "upcoming";

    // ==========================
    // CASE 1: Sắp diễn ra → cho phép Hủy đăng ký
    // ==========================
    if (isUpcoming) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          _confirmCancel(context, item.id);
        },
        icon: const Icon(FontAwesomeIcons.xmark, size: 14),
        label: const Text(
          "Hủy đăng ký",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      );
    }

    // ==========================
    // CASE 2: Không phải sắp diễn ra → nút HỦY nhưng disabled
    // ==========================
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade400,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: null, // 🔥 disabled
      icon: const Icon(FontAwesomeIcons.xmark, size: 14),
      label: const Text(
        "Hủy đăng ký",
        style: TextStyle(fontWeight: FontWeight.w700),
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

  Color _mapStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "đang diễn ra":
      case "ongoing":
      case "inprogress":
        return const Color(0xFF16A34A); // xanh lá
      case "sắp diễn ra":
      case "approved":
        return const Color(0xFFEA580C); // cam
      case "đã kết thúc":
      case "completed":
      default:
        return const Color(0xFF6B7280); // xám
    }
  }

  String _getStatus(dynamic item) {
    if (item is DangKyCaNhan) return item.status;
    if (item is DangKyDoiThi) return item.status;
    return 'ended';
  }

  DateTime _parseLocal(dynamic iso) {
    try {
      String cleaned = iso.toString();

      // Loại bỏ timezone Z hoặc +07:00
      cleaned = cleaned.replaceAll(RegExp(r'Z$'), '');
      cleaned = cleaned.replaceAll(RegExp(r'\+\d{2}:\d{2}$'), '');

      return DateTime.parse(cleaned);
    } catch (_) {
      return DateTime.now();
    }
  }

  String _formatOnlyDate(dynamic iso) {
    try {
      final dt = _parseLocal(iso);
      return "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year}";
    } catch (_) {
      return iso.toString();
    }
  }

  String _formatDate(dynamic iso) {
    try {
      final dt = _parseLocal(iso);
      return "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year} "
          "${dt.hour.toString().padLeft(2, '0')}:"
          "${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return iso.toString();
    }
  }
}
