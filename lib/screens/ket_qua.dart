import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/KetQuaThi.dart';
import '../../services/ket_qua_service.dart';
import 'dart:ui';
import 'package:academic_activities_mobile/cores/widgets/button.dart';

class KetQuaScreen extends StatefulWidget {
  const KetQuaScreen({super.key});

  @override
  State<KetQuaScreen> createState() => _KetQuaScreenState();
}

class _KetQuaScreenState extends State<KetQuaScreen>
    with TickerProviderStateMixin {
  final service = KetQuaService();
  List<KetQuaThi> danhSach = [];
  bool loading = true;
  DateTimeRange? selectedDateRange;
  String selectedFilter = 'Tất cả';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> filters = [
    'Tất cả',
    'Có giải thưởng',
    'Không có giải thưởng',
  ];

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
      debugPrint("Lỗi tải kết quả: $e");
      setState(() => loading = false);
    }
  }

  void _chonKhoangNgay() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 2),
      initialDateRange: selectedDateRange ??
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

  List<KetQuaThi> get filteredList {
    List<KetQuaThi> list = danhSach;

    if (selectedFilter != 'Tất cả') {
      if (selectedFilter == 'Có giải thưởng') {
        list = list.where((kq) => (kq.giaiThuong ?? '').isNotEmpty).toList();
      } else {
        list = list.where((kq) => (kq.giaiThuong ?? '').isEmpty).toList();
      }
    }

    if (selectedDateRange != null) {
      final start = selectedDateRange!.start;
      final end = selectedDateRange!.end;
      list = list.where((kq) {
        if (kq.ngayChamDiem == null) return false;
        final date = DateTime.tryParse(kq.ngayChamDiem!);
        if (date == null) return false;
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
          // 🌟 Header
          SliverAppBar(
            expandedHeight: 320,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/patterns/pattern1.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(230, 0, 120, 255),
                          Color.fromARGB(180, 0, 90, 200),
                        ],
                      ),
                    ),
                  ),
                  Container(color: Colors.black.withOpacity(0.1)),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.25)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FaIcon(FontAwesomeIcons.medal,
                                    size: 14, color: Color(0xFFB2EBF2)),
                                SizedBox(width: 8),
                                Text(
                                  "Kết quả Cuộc thi",
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
                          const Text(
                            "Vinh danh thành tích - Tỏa sáng tài năng",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Cùng xem lại những kết quả xuất sắc nhất của các cuộc thi học thuật.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Filter chips
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
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // 🔹 Lọc theo ngày
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
            ),
          ),

          // 🔹 Nội dung
          if (loading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF667EEA))),
              ),
            )
          else if (filteredList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text("Không có kết quả nào",
                    style:
                        TextStyle(fontSize: 16, color: Colors.grey, height: 2)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final kq = filteredList[index];
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildKetQuaCard(kq),
                  );
                }, childCount: filteredList.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKetQuaCard(KetQuaThi kq) {
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.userGraduate,
                    size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  kq.maBaiThi ?? "Bài thi chưa xác định",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            _buildInfoRow(FontAwesomeIcons.star, "Điểm", "${kq.diem ?? 0}",
                Colors.amber),
            const SizedBox(height: 10),
            _buildInfoRow(FontAwesomeIcons.rankingStar, "Xếp hạng",
                "${kq.xepHang ?? '-'}", Colors.blue),
            const SizedBox(height: 10),
            _buildInfoRow(FontAwesomeIcons.medal, "Giải thưởng",
                kq.giaiThuong ?? "Không có", Colors.green),
            const SizedBox(height: 10),
            _buildInfoRow(FontAwesomeIcons.userCheck, "Người chấm điểm",
                kq.nguoiChamDiem ?? "Chưa rõ", Colors.purple),
            const SizedBox(height: 10),
            _buildInfoRow(FontAwesomeIcons.commentDots, "Nhận xét",
                kq.nhanXet ?? "Không có", Colors.teal),
            const SizedBox(height: 10),
            _buildInfoRow(
                FontAwesomeIcons.calendarDay,
                "Ngày chấm điểm",
                kq.ngayChamDiem != null
                    ? _formatDate(DateTime.parse(kq.ngayChamDiem!))
                    : "Chưa xác định",
                Colors.orange),

            const SizedBox(height: 16),
            DetailButton(
              label: "Xem chi tiết",
              icon: FontAwesomeIcons.arrowRight,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, Color color) {
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
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A))),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}
