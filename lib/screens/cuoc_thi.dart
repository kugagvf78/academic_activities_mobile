import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/CuocThi.dart';
import 'dart:ui';
import '../../services/cuoc_thi_service.dart';
import 'package:academic_activities_mobile/cores/widgets/button.dart';

class CuocThiScreen extends StatefulWidget {
  const CuocThiScreen({super.key});

  @override
  State<CuocThiScreen> createState() => _CuocThiScreenState();
}

class _CuocThiScreenState extends State<CuocThiScreen>
    with TickerProviderStateMixin {
  final service = CuocThiService();
  List<CuocThi> danhSach = [];
  bool loading = true;
  String selectedFilter = 'Tất cả';
  DateTimeRange? selectedDateRange;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> filters = [
    'Tất cả',
    'Đang diễn ra',
    'Sắp diễn ra',
    'Đã kết thúc',
  ];

  void _chonKhoangNgay() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 2),
      initialDateRange:
          selectedDateRange ??
          DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: DateTime(now.year, now.month + 1, 0),
          ),
      locale: const Locale('vi', 'VN'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _taiDuLieu();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _taiDuLieu() async {
    setState(() => loading = true);
    try {
      final data = await service.getAll();
      setState(() {
        danhSach = data;
        loading = false;
      });
      _fadeController.forward();
    } catch (e) {
      debugPrint("Lỗi tải cuộc thi: $e");
      setState(() => loading = false);
    }
  }

  List<CuocThi> get filteredList {
    List<CuocThi> list = danhSach;

    if (selectedFilter != 'Tất cả') {
      list = list.where((ct) => ct.trangThaiLabel == selectedFilter).toList();
    }

    if (selectedDateRange != null) {
      final start = selectedDateRange!.start;
      final end = selectedDateRange!.end;

      list = list.where((ct) {
        if (ct.thoiGianBatDau == null) return false;
        final date = DateTime.parse(ct.thoiGianBatDau!);
        return date.isAfter(start.subtract(const Duration(days: 1))) &&
            date.isBefore(end.add(const Duration(days: 1)));
      }).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar với gradient
          SliverAppBar(
            expandedHeight: 340,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // 🌄 Nền pattern
                  Image.asset(
                    'assets/images/patterns/pattern1.jpg',
                    fit: BoxFit.cover,
                  ),

                  // 🟦 Lớp gradient phủ màu xanh dương
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(240, 0, 132, 255),
                          Color.fromARGB(179, 27, 125, 204),
                        ],
                      ),
                    ),
                  ),

                  // 🌫️ Lớp phủ mờ nhẹ để chữ dễ đọc
                  Container(color: Colors.black.withOpacity(0.15)),

                  // 🌟 Nội dung chính
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.25),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.trophy,
                                  size: 14,
                                  color: Color(0xFFB2EBF2),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Cuộc thi Học thuật",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tiêu đề gradient
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Đấu trường ",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: "Tri thức & Sáng tạo",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    foreground: Paint()
                                      ..shader =
                                          const LinearGradient(
                                            colors: [
                                              Color(0xFFB2EBF2),
                                              Color(0xFFBBDEFB),
                                              Color(0xFFB2EBF2),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ).createShader(
                                            Rect.fromLTWH(0, 0, 200, 70),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 12),
                          const Text(
                            "Nơi sinh viên Công nghệ Thông tin thể hiện tài năng, khám phá đam mê và kiến tạo tương lai công nghệ.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 📊 Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStat("12+", "Cuộc thi"),
                              const SizedBox(width: 32),
                              _buildStat("2.5K+", "Sinh viên tham gia"),
                              const SizedBox(width: 32),
                              _buildStat("80+", "Giải thưởng"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.map((filter) {
                    final isSelected = selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => selectedFilter = filter);
                        },
                        backgroundColor: Colors.white,
                        selectedColor: Colors.blue[700],
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        elevation: isSelected ? 4 : 0,
                        shadowColor: Colors.blue[700]!.withOpacity(0.4),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton.icon(
                onPressed: _chonKhoangNgay,
                icon: const FaIcon(FontAwesomeIcons.calendarDays, size: 16),
                label: Text(
                  selectedDateRange == null
                      ? "Lọc theo ngày"
                      : "Từ ${_formatDate(selectedDateRange!.start)} đến ${_formatDate(selectedDateRange!.end)}",
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue[700],
                  side: BorderSide(color: Colors.blue[700]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                ),
              ),
            ),
          ),

          // Content
          if (loading)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF667EEA),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Đang tải cuộc thi...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else if (filteredList.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.inbox,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không có cuộc thi nào',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hãy quay lại sau nhé!',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final ct = filteredList[index];
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + (index * 100)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: _buildCuocThiCard(ct),
                    ),
                  );
                }, childCount: filteredList.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFBBDEFB), fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildCuocThiCard(CuocThi ct) {
    final statusIcon = _getStatusIcon(ct.trangThaiLabel);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to detail
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header với status badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        ct.tenCuocThi ?? 'Không có tên',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ct.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ct.statusColor),
                      ),
                      child: Row(
                        children: [
                          FaIcon(statusIcon, size: 12, color: ct.statusColor),
                          const SizedBox(width: 6),
                          Text(
                            ct.trangThaiLabel ?? 'Không xác định',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ct.statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Info rows
                _buildInfoRow(
                  FontAwesomeIcons.calendar,
                  'Thời gian',
                  ct.thoiGianBatDau != null && ct.thoiGianKetThuc != null
                      ? '${_formatDate(DateTime.parse(ct.thoiGianBatDau!))} - ${_formatDate(DateTime.parse(ct.thoiGianKetThuc!))}'
                      : 'Chưa xác định',
                  Colors.blue,
                ),

                const SizedBox(height: 12),

                _buildInfoRow(
                  FontAwesomeIcons.userGroup,
                  'Số lượng đăng ký',
                  '${ct.soLuongDangKy ?? 0} sinh viên',
                  Colors.purple,
                ),
                const SizedBox(height: 12),

                _buildInfoRow(
                  FontAwesomeIcons.moneyBillWave,
                  'Tổng chi phí giải thưởng',
                  ct.chiPhiThucTe != null
                      ? '${ct.chiPhiThucTe!.toStringAsFixed(0)} VNĐ'
                      : 'Chưa cập nhật',
                  Colors.green,
                ),

                const SizedBox(height: 16),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: DetailButton(
                    label: 'Xem chi tiết',
                    icon: FontAwesomeIcons.arrowRight,
                    onPressed: () {
                      // TODO: chuyển sang trang chi tiết
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: FaIcon(icon, size: 16, color: color)),
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
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'Đang diễn ra':
        return FontAwesomeIcons.circlePlay;
      case 'Sắp diễn ra':
        return FontAwesomeIcons.clock;
      case 'Đã kết thúc':
        return FontAwesomeIcons.circleCheck;
      default:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 15,
    );
    path.quadraticBezierTo(
      3 * size.width / 4,
      size.height - 30,
      size.width,
      size.height - 10,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
