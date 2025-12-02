import 'package:academic_activities_mobile/models/CuocThi.dart';
import 'package:academic_activities_mobile/models/DatGiai.dart';
import 'package:academic_activities_mobile/models/VongThi.dart';

import 'package:academic_activities_mobile/screens/results/result_detail.dart';
import 'package:academic_activities_mobile/services/result_service.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/cores/widgets/app_search_field.dart';

class KetQuaScreen extends StatefulWidget {
  const KetQuaScreen({super.key});

  @override
  State<KetQuaScreen> createState() => _KetQuaScreenState();
}

class _KetQuaScreenState extends State<KetQuaScreen>
    with TickerProviderStateMixin {
  final ResultService _service = ResultService();

  List<Map<String, dynamic>> danhSach = [];
  bool loading = true;

  String searchText = "";
  String? selectedYear;
  String? selectedType;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _taiDuLieu();
  }

  Future<void> _taiDuLieu() async {
    setState(() => loading = true);

    final response = await _service.getResults(
      page: 1,
      search: searchText,
      year: selectedYear,
      type: selectedType,
    );

    if (!mounted) return;

    if (response["success"]) {
      // API trả về results["data"]
      final rawList = response["results"]["data"] as List;

      final parsed = rawList.map((json) {
        return {
          "date": json["date"],
          "soluongthamgia": json["soluongthamgia"],
          "soluonggiai": json["soluonggiai"],

          // Cuộc thi
          "cuocthi": CuocThi(
            maCuocThi: json["macuocthi"],
            tenCuocThi: json["tencuocthi"],
            loaiCuocThi: json["loaicuocthi"],
            thoiGianBatDau: "",
            thoiGianKetThuc: json["thoigianketthuc"],
          ),

          // Chỉ lấy winner hiển thị tạm
          "winner": json["winner"] ?? "Chưa công bố"
        };
      }).toList();

      setState(() {
        danhSach = parsed;
        loading = false;
      });

      _fadeController.forward();
    } else {
      setState(() => loading = false);
      print("Lỗi API: ${response["message"]}");
    }
  }

  // ================= BUILD UI ================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: CustomScrollView(
        slivers: [
          _buildHeroSection(),
          SliverToBoxAdapter(child: _buildFilterBar()),

          loading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildResultCard(danhSach[i]),
                      ),
                      childCount: danhSach.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // ================= CARD =================
  Widget _buildResultCard(Map<String, dynamic> item) {
    final CuocThi cuocThi = item["cuocthi"];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(
              "assets/images/home/banner1.jpg",
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cuocThi.tenCuocThi ?? "Không có tên",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 6),
                Text(
                  "Chủ đề: ${cuocThi.loaiCuocThi ?? "Không rõ"}",
                  style: const TextStyle(color: Colors.grey),
                ),

                Divider(height: 25, color: Colors.grey[300]),

                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.blue),
                    const SizedBox(width: 6),
                    Text(item["date"], style: const TextStyle(fontSize: 13)),
                    const Spacer(),
                    const Icon(Icons.people,
                        size: 14, color: Colors.purple),
                    const SizedBox(width: 6),
                    Text("${item["soluongthamgia"]} thí sinh"),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: DetailButton(
                    label: "Xem chi tiết",
                    icon: FontAwesomeIcons.arrowRight,
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KetQuaDetailScreen(
                            maCuocThi: cuocThi.maCuocThi!,
                          ),
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

  // ================== HERO ==================
 Widget _buildHeroSection() {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent, // ⭐ Ban đầu trong suốt
      automaticallyImplyLeading: false,

      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          bool collapsed = constraints.biggest.height <= kToolbarHeight + 20;

          return FlexibleSpaceBar(
            centerTitle: true,

            // ⭐ Chỉ hiện khi collapse
            title: collapsed
                ? const Text(
                    "Kết quả Cuộc thi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,

            background: Stack(
              fit: StackFit.expand,
              children: [
                // 🖼 Image nền
                Opacity(
                  opacity: 0.7,
                  child: Image.asset(
                    'assets/images/patterns/award_pattern.jpg',
                    fit: BoxFit.cover,
                  ),
                ),

                // 🎨 Gradient phủ khi expanded
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

                // 🌫️ Overlay nhẹ
                Container(color: Colors.black.withOpacity(0.2)),

                // ⭐ Hero content ẩn dần khi collapse
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: collapsed ? 0 : 1,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
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
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.medal,
                                  size: 14,
                                  color: Color(0xFFFFF176),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Kết quả Cuộc thi Học thuật",
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

                          // Big title
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Vinh danh ",
                                  style: TextStyle(
                                    fontSize: 31,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: "Tài năng & Thành tích",
                                  style: TextStyle(
                                    fontSize: 31,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader =
                                          const LinearGradient(
                                            colors: [
                                              Color(0xFFFFF59D),
                                              Color(0xFFFFFFFF),
                                              Color(0xFFFFF176),
                                            ],
                                          ).createShader(
                                            Rect.fromLTWH(0, 0, 300, 70),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 12),

                          // Subtext
                          const Text(
                            "Tổng hợp kết quả, giải thưởng và gương mặt xuất sắc nhất trong các cuộc thi học thuật CNTT.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ⭐ Thanh AppBar color khi collapsed
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: collapsed
                      ? Colors.blue[700]!.withOpacity(1) // hiện hoàn toàn
                      : Colors.transparent, // ban đầu trong suốt
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============= FILTER =============
  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AppSearchField(
        hint: "Tìm kiếm theo tên cuộc thi...",
        onChanged: (v) {
          searchText = v;
          _taiDuLieu(); // load API theo search
        },
      ),
    );
  }
}
