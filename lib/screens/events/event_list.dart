import 'package:academic_activities_mobile/cores/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../models/CuocThi.dart';
import '../../services/event_service.dart';
import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/cores/widgets/app_select_field.dart';
import 'package:academic_activities_mobile/screens/events/event_detail.dart';

class CuocThiScreen extends StatefulWidget {
  const CuocThiScreen({super.key});

  @override
  State<CuocThiScreen> createState() => _CuocThiScreenState();
}

class _CuocThiScreenState extends State<CuocThiScreen>
    with TickerProviderStateMixin {
  final service = EventService();
  List<CuocThi> danhSach = [];
  bool loading = true;
  String? selectedFilter;
  DateTimeRange? selectedDateRange;
  String search = "";

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
    selectedFilter = null;
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
      final list = await service.getEvents();
      setState(() {
        danhSach = list; // list là List<CuocThi>
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

    // 🔍 Lọc theo từ khóa
    if (search.isNotEmpty) {
      final lower = search.toLowerCase();
      list = list.where((ct) {
        return (ct.tenCuocThi ?? "").toLowerCase().contains(lower) ||
            (ct.moTa ?? "").toLowerCase().contains(lower);
      }).toList();
    }

    // 📌 Lọc theo trạng thái
    if (selectedFilter != null && selectedFilter != "Tất cả") {
      list = list.where((ct) => ct.statusLabel == selectedFilter).toList();
    }

    // 📅 Lọc theo ngày
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
          _buildHeroSection(),
          _buildFilterSection(),
          if (loading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                ),
              ),
            )
          else if (filteredList.isEmpty)
            _buildEmptyState()
          else
            _buildCuocThiList(),
        ],
      ),
    );
  }

  // 🌟 HERO SECTION
  Widget _buildHeroSection() {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,

      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          bool isCollapsed =
              constraints.biggest.height <= (kToolbarHeight + 20);

          return FlexibleSpaceBar(
            centerTitle: true,
            title: isCollapsed
                ? const Text(
                    "Đấu trường Tri thức & Sáng tạo",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )
                : null,

            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/patterns/event_pattern.jpg',
                  fit: BoxFit.cover,
                ),

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

                Container(color: Colors.black.withOpacity(0.20)),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isCollapsed ? 0 : 1,
                  child: _buildExpandedContent(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpandedContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.25)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
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
                        ..shader = const LinearGradient(
                          colors: [
                            Color(0xFFB2EBF2),
                            Color(0xFFBBDEFB),
                            Color(0xFFB2EBF2),
                          ],
                        ).createShader(Rect.fromLTWH(0, 0, 300, 70)),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            const Text(
              "Nơi sinh viên CNTT thể hiện tài năng, khám phá đam mê và kiến tạo tương lai.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStat("12+", "Cuộc thi"),
                const SizedBox(width: 32),
                _buildStat("2.5K+", "Sinh viên"),
                const SizedBox(width: 32),
                _buildStat("80+", "Giải thưởng"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Column(
          children: [
            // 🔎 SEARCH FIELD
            AppSearchField(
              hint: "Tìm kiếm cuộc thi...",
              onChanged: (value) {
                setState(() => search = value);
              },
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                // 📌 Lọc trạng thái cuộc thi
                Expanded(
                  child: AppSelectField(
                    value: selectedFilter,
                    hint: "Trạng thái",
                    items: const [
                      'Tất cả',
                      'Đang diễn ra',
                      'Sắp diễn ra',
                      'Đã kết thúc',
                    ],
                    onChanged: (v) => setState(() => selectedFilter = v),
                  ),
                ),
                const SizedBox(width: 12),

                // 📅 Lọc theo khoảng ngày
                Expanded(
                  child: GestureDetector(
                    onTap: _chonKhoangNgay,
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedDateRange == null
                              ? const Color(0xFFE5E7EB)
                              : const Color(0xFF2563EB),
                          width: 1.4,
                        ),
                      ),
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.calendarDays,
                            size: 14,
                            color: Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              selectedDateRange == null
                                  ? "Khoảng ngày"
                                  : "${_formatDate(selectedDateRange!.start)} - ${_formatDate(selectedDateRange!.end)}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Widget _buildCuocThiList() {
    return SliverPadding(
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

  // 🎯 THẺ CUỘC THI
  Widget _buildCuocThiCard(CuocThi ct) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🌄 Header
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  'assets/images/patterns/event_pattern2.jpg',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.25),
                  colorBlendMode: BlendMode.darken,
                ),
              ),

              // trạng thái
              Positioned(
                top: 10,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        ct.statusLabel ?? 'Không xác định',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Nội dung
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ct.tenCuocThi ?? "Không có tên",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),

                if (ct.moTa != null && ct.moTa!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      ct.moTa!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),

                Divider(color: Colors.grey[300], thickness: 1, height: 30),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      ct.thoiGianBatDau != null && ct.thoiGianKetThuc != null
                          ? "${_formatDate(DateTime.parse(ct.thoiGianBatDau!))} - ${_formatDate(DateTime.parse(ct.thoiGianKetThuc!))}"
                          : "Chưa xác định",
                      style: const TextStyle(fontSize: 13),
                    ),

                    const Spacer(),
                    const Icon(Icons.people, size: 14, color: Colors.purple),
                    const SizedBox(width: 4),
                    Text(
                      "${ct.soLuongDangKy ?? 0}+ thí sinh",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: DetailButton(
                    label: 'Xem chi tiết',
                    icon: FontAwesomeIcons.arrowRight,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventDetailScreen(id: ct.maCuocThi!),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverFillRemaining _buildEmptyState() {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.trophy, size: 70, color: Color(0xFFB0BEC5)),
            SizedBox(height: 12),
            Text(
              "Không có cuộc thi nào",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Hãy thử thay đổi tiêu chí lọc.",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
