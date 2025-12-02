import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/models/DangKyCaNhan.dart';
import 'package:academic_activities_mobile/models/DangKyDoiThi.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyRegistrationsScreen extends StatelessWidget {
  final List competition;

  const MyRegistrationsScreen({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
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
      body: competition.isEmpty
          ? _buildEmpty()
          : DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const TabBar(
                      labelColor: Color(0xFF2563EB),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFF2563EB),
                      indicatorWeight: 3,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      tabs: [
                        Tab(text: 'Đang diễn ra'),
                        Tab(text: 'Đã kết thúc'),
                        Tab(text: 'Tất cả'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildRegistrationList('active'),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
    List filtered;

    if (filterStatus == 'all') {
      filtered = competition;
    } else {
      filtered = competition.where((item) {
        final status = _getStatus(item);
        return status == filterStatus;
      }).toList();
    }

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
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _buildRegistrationCard(filtered[index]);
      },
    );
  }

  // ========================= CARD =========================
  Widget _buildRegistrationCard(dynamic item) {
  // ======== LẤY DỮ LIỆU ========
  String title;
  String? subtitle;
  String dateStart;
  String dateEnd;
  String registerDate;
  String status;
  String statusLabel;
  String statusColor;
  bool isCaNhan;

  if (item is DangKyCaNhan) {
    title = item.tenCuocThi;
    subtitle = null;
    dateStart = item.thoiGianBatDau;
    dateEnd = item.thoiGianKetThuc;
    registerDate = item.ngayDangKy;
    status = item.status;
    statusLabel = item.statusLabel;
    statusColor = item.statusColor;
    isCaNhan = true;
  } else if (item is DangKyDoiThi) {
    title = item.tenCuocThi;
    subtitle = "Đội: ${item.tenDoiThi}";
    dateStart = item.thoiGianBatDau;
    dateEnd = item.thoiGianKetThuc;
    registerDate = item.ngayDangKy;
    status = item.status;
    statusLabel = item.statusLabel;
    statusColor = item.statusColor;
    isCaNhan = false;
  } else {
    return const SizedBox.shrink();
  }

  final Color color = _statusTextColor(statusColor);

  // ======== UI ========
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
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        // ========================= TOP SECTION =========================
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON TRÒN (giống activity)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.12),
                ),
                child: Center(
                  child: FaIcon(
                    isCaNhan ? FontAwesomeIcons.userGraduate : FontAwesomeIcons.users,
                    size: 20,
                    color: color,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // TEXT ZONE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),

                    // SUBTITLE
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),

                    // ROLE (dùng cá nhân/đội nhóm)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Icon(Icons.person_pin_circle_rounded,
                              color: Colors.grey.shade500, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            isCaNhan ? "Cá nhân" : "Đội nhóm",
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

              // STATUS BADGE
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
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

        // ========================= DIVIDER =========================
        Container(
          height: 1,
          color: Colors.grey.shade100,
          margin: const EdgeInsets.symmetric(horizontal: 16),
        ),

        // ========================= BOTTOM SECTION =========================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DATE RANGE
              Row(
                children: [
                  Icon(Icons.calendar_month_rounded,
                      size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${_formatDate(dateStart)} → ${_formatDate(dateEnd)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // REGISTER DATE
              Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Text(
                    "Đăng ký: ${_formatDate(registerDate)}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    ),
  );
}

  // ========================= HELPERS =========================
  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        FaIcon(icon, size: 13, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  String _getStatus(dynamic item) {
    if (item is DangKyCaNhan) return item.status;
    if (item is DangKyDoiThi) return item.status;
    return 'ended';
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return isoDate;
    }
  }

  Color _statusBG(String color) {
    switch (color) {
      case 'green':
        return Colors.green.shade100;
      case 'blue':
        return Colors.blue.shade100;
      case 'orange':
        return Colors.orange.shade100;
      case 'gray':
      default:
        return Colors.grey.shade200;
    }
  }

  Color _statusTextColor(String color) {
    switch (color) {
      case 'green':
        return Colors.green.shade700;
      case 'blue':
        return Colors.blue.shade700;
      case 'orange':
        return Colors.orange.shade700;
      case 'gray':
      default:
        return Colors.grey.shade700;
    }
  }

  IconData _statusIcon(String color) {
    switch (color) {
      case 'green':
        return FontAwesomeIcons.circleCheck;
      case 'blue':
        return FontAwesomeIcons.play;
      case 'orange':
        return FontAwesomeIcons.clock;
      case 'gray':
      default:
        return FontAwesomeIcons.circleXmark;
    }
  }
}