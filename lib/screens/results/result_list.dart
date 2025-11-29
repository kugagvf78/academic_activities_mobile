import 'package:academic_activities_mobile/models/CuocThi.dart';
import 'package:academic_activities_mobile/models/DatGiai.dart';
import 'package:academic_activities_mobile/models/VongThi.dart';
import 'package:academic_activities_mobile/models/DoiThi.dart';
import 'package:academic_activities_mobile/models/SinhVien.dart';
import 'package:academic_activities_mobile/screens/results/result_detail.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/cores/widgets/app_search_field.dart';
import 'package:academic_activities_mobile/cores/widgets/app_select_field.dart';

class KetQuaScreen extends StatefulWidget {
  const KetQuaScreen({super.key});

  @override
  State<KetQuaScreen> createState() => _KetQuaScreenState();
}

class _KetQuaScreenState extends State<KetQuaScreen>
    with TickerProviderStateMixin {
  List<dynamic> danhSach = [];
  bool loading = true;
  String searchText = '';
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

    await Future.delayed(const Duration(milliseconds: 500));

    // ===========================
    // FAKE DATA THEO ĐÚNG MODEL
    // ===========================
    final fakeData = [
      {
        "date": "15/05/2025",
        "soluongthamgia": 120,
        "soluonggiai": 10,

        "cuocthi": CuocThi(
          maCuocThi: "CT001",
          tenCuocThi: "Cuộc thi Lập Trình Sinh Viên 2025",
          loaiCuocThi: "Lập trình thuật toán",
          thoiGianBatDau: "2025-05-10",
          thoiGianKetThuc: "2025-05-15",
        ),

        // ====== GIẢI ======
        "giai": [
          {
            "data": DatGiai(
              maDatGiai: "DG001",
              tenGiai: "Giải Nhất",
              loaiDangKy: "CaNhan",
              giaiThuong: "Laptop + 5,000,000đ",
              diemRenLuyen: 10,
              ngayTrao: "2025-05-15",
            ),
            "sinhvien": {"ten": "Nguyễn Văn A", "lop": "IT01"},
          },
          {
            "data": DatGiai(
              maDatGiai: "DG002",
              tenGiai: "Giải Nhì",
              loaiDangKy: "CaNhan",
              giaiThuong: "3,000,000đ",
              diemRenLuyen: 7,
              ngayTrao: "2025-05-15",
            ),
            "sinhvien": {"ten": "Trần Thị B", "lop": "IT02"},
          },
        ],

        // ====== VÒNG THI ======
        "vong": [
          VongThi(
            maVongThi: "V01",
            tenVongThi: "Vòng 1: Sơ loại",
            thuTu: 1,
            thoiGianBatDau: "2025-05-01",
            thoiGianKetThuc: "2025-05-05",
            trangThai: "Completed",
          ),
          VongThi(
            maVongThi: "V02",
            tenVongThi: "Bán kết",
            thuTu: 2,
            thoiGianBatDau: "2025-05-06",
            thoiGianKetThuc: "2025-05-10",
            trangThai: "Completed",
          ),
        ],
      },

      // =====================
      // Cuộc thi 2
      // =====================
      {
        "date": "20/11/2024",
        "soluongthamgia": 80,
        "soluonggiai": 8,

        "cuocthi": CuocThi(
          maCuocThi: "CT002",
          tenCuocThi: "Hackathon UIT 2024",
          loaiCuocThi: "Sáng tạo & Ứng dụng",
          thoiGianBatDau: "2024-11-20",
          thoiGianKetThuc: "2024-12-12",
        ),

        "giai": [
          {
            "data": DatGiai(
              maDatGiai: "DG010",
              tenGiai: "Quán quân",
              loaiDangKy: "DoiNhom",
              giaiThuong: "15,000,000đ",
              diemRenLuyen: 12,
              ngayTrao: "2024-12-12",
            ),
            "doithi": {"ten": "UIT Hackers", "sothanhvien": 4},
          },
        ],

        "vong": [
          VongThi(
            maVongThi: "V10",
            tenVongThi: "Build sản phẩm",
            thuTu: 1,
            thoiGianBatDau: "2024-11-20",
            thoiGianKetThuc: "2024-11-22",
            trangThai: "Completed",
          ),
        ],
      },
    ];

    setState(() {
      danhSach = fakeData;
      loading = false;
    });

    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: CustomScrollView(
        slivers: [
          _buildHeroSection(),
          SliverToBoxAdapter(child: _buildFilterBar()),

          if (loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
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
  Widget _buildResultCard(dynamic item) {
    final CuocThi cuocThi = item["cuocthi"];
    final List<dynamic> giai = item["giai"];
    final List<VongThi> vong = item["vong"];

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
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 6),
                    Text(item["date"], style: const TextStyle(fontSize: 13)),
                    const Spacer(),
                    const Icon(Icons.people, size: 14, color: Colors.purple),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KetQuaDetailScreen(
                            cuocThi: cuocThi,
                            giaiThuong: giai, 
                            vongThi: vong,
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
  Widget _buildHeroSection() { return SliverAppBar( expandedHeight: 250, floating: false, pinned: true, elevation: 0, flexibleSpace: FlexibleSpaceBar( background: Stack( fit: StackFit.expand, children: [ Opacity( opacity: 0.7, child: Image.asset( 'assets/images/patterns/pattern1.jpg', fit: BoxFit.cover, ), ), Container( decoration: const BoxDecoration( gradient: LinearGradient( begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [ Color.fromARGB(240, 0, 132, 255), Color.fromARGB(179, 27, 125, 204), ], ), ), ), Container(color: Colors.black.withOpacity(0.15)), SafeArea( child: Padding( padding: const EdgeInsets.all(20), child: Column( mainAxisAlignment: MainAxisAlignment.end, children: [ Container( padding: const EdgeInsets.symmetric( horizontal: 14, vertical: 8, ), decoration: BoxDecoration( color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(30), border: Border.all( color: Colors.white.withOpacity(0.25), ), ), child: const Row( mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [ FaIcon( FontAwesomeIcons.medal, size: 14, color: Color(0xFFFFF176), ), SizedBox(width: 8), Text( "Kết quả Cuộc thi Học thuật", style: TextStyle( color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, ), ), ], ), ), const SizedBox(height: 16), Text.rich( TextSpan( children: [ const TextSpan( text: "Vinh danh ", style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white, ), ), TextSpan( text: "Tài năng & Thành tích", style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold, foreground: Paint() ..shader = const LinearGradient( colors: [ Color(0xFFFFF59D), Color(0xFFFFFFFF), Color(0xFFFFF176), ], ).createShader(Rect.fromLTWH(0, 0, 300, 70)), ), ), ], ), textAlign: TextAlign.center, ), const SizedBox(height: 12), const Text( "Tổng hợp kết quả, giải thưởng và gương mặt xuất sắc nhất trong các cuộc thi học thuật CNTT.", textAlign: TextAlign.center, style: TextStyle( color: Colors.white70, fontSize: 14, height: 1.5, fontWeight: FontWeight.w600, ), ), ], ), ), ), ], ), ), ); }

  // ============= FILTER =============
  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AppSearchField(
        hint: "Tìm kiếm theo tên cuộc thi...",
        onChanged: (v) => setState(() => searchText = v),
      ),
    );
  }
}
