import 'package:academic_activities_mobile/cores/widgets/colorful_loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/CuocThi.dart';
import '../../../models/DatGiai.dart';
import '../../../models/VongThi.dart';

import '../../../cores/widgets/custom_sliver_appbar.dart';
import '../../../services/result_service.dart';

class KetQuaDetailScreen extends StatefulWidget {
  final String maCuocThi;

  const KetQuaDetailScreen({
    super.key,
    required this.maCuocThi,
  });

  @override
  State<KetQuaDetailScreen> createState() => _KetQuaDetailScreenState();
}

class _KetQuaDetailScreenState extends State<KetQuaDetailScreen> {
  final ResultService _service = ResultService();

  bool loading = true;
  CuocThi? cuocThi;

  List<VongThi> vongThi = [];
  List<Map<String, dynamic>> giaiThuong = [];

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final res = await _service.getResultDetail(widget.maCuocThi);

    if (!mounted) return;

    if (res["success"]) {
      // ======== Parse CuocThi ========
      final r = res["result"];
      cuocThi = CuocThi(
        maCuocThi: r["macuocthi"],
        tenCuocThi: r["tencuocthi"],
        loaiCuocThi: r["loaicuocthi"],
        hinhThucThamGia: r["hinhthucthamgia"],
        thoiGianBatDau: r["thoigianbatdau"],
        thoiGianKetThuc: r["thoigianketthuc"],
        moTa: r["mota"] ?? "Không có mô tả",
      );

      // ======== Parse Vòng thi ========
      vongThi = (res["rounds"] as List).map((j) {
        return VongThi(
          maVongThi: j["mavongthi"] ?? "",
          tenVongThi: j["name"],
          thuTu: j["thutu"] ?? 0,
          thoiGianBatDau: j["start"],
          thoiGianKetThuc: j["end"],
          trangThai: j["winner"] != null ? "Completed" : "Pending",
        );
      }).toList();

      // ======== Parse Top 3 & Awards ========
      giaiThuong = (res["top3"] as List).map((j) {
        return {
          "data": DatGiai(
            maDatGiai: "",
            tenGiai: j["rank"],
            giaiThuong: j["prize"],
            diemRenLuyen: j["score"],
            ngayTrao: j["date"],
            loaiDangKy: "CaNhan",
          ),
          "sinhvien": {"ten": j["name"]},
        };
      }).toList();

      setState(() => loading = false);
    } else {
      setState(() => loading = false);
      print("Lỗi load detail: ${res["message"]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading || cuocThi == null) {
      return Scaffold(
        body: ColorfulLoader(),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildHeroSection(),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              _buildMainContent(context),
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  Widget _buildHeroSection() {
    return CustomHeroSliverAppBar(
      title: cuocThi!.tenCuocThi ?? "Kết quả cuộc thi",
      description:
          "Ngày kết thúc: ${_fmtDate(cuocThi!.thoiGianKetThuc)} • Tổng giải: ${giaiThuong.length}",
      imagePath: "assets/images/patterns/pattern3.jpg",
      metaItems: [
        _meta(FontAwesomeIcons.users,
            "Hình thức: ${cuocThi!.hinhThucThamGia ?? "Không rõ"}"),
        _meta(FontAwesomeIcons.calendarDays,
            "Bắt đầu: ${_fmtDate(cuocThi!.thoiGianBatDau)}"),
        _meta(FontAwesomeIcons.calendarCheck,
            "Kết thúc: ${_fmtDate(cuocThi!.thoiGianKetThuc)}"),
      ],
    );
  }

  // ===========================================================
  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tongQuanSection(),
          const SizedBox(height: 18),

          _vongThiSection(),
          const SizedBox(height: 18),

          _top3Section(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _meta(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, size: 13, color: Colors.white),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }

  // ===========================================================
  Widget _sectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: FaIcon(icon, color: iconColor, size: 18)),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          Divider(height: 25, color: Colors.grey[200]),
          child,
        ],
      ),
    );
  }

  // ===========================================================
  Widget _tongQuanSection() {
    return _sectionCard(
      icon: FontAwesomeIcons.infoCircle,
      iconColor: Colors.blue,
      title: "Tổng quan cuộc thi",
      child: Text(
        cuocThi!.moTa ?? "Không có mô tả.",
        style: const TextStyle(fontSize: 14.5, height: 1.6),
      ),
    );
  }

  // ===========================================================
  Widget _vongThiSection() {
    return _sectionCard(
      icon: FontAwesomeIcons.layerGroup,
      iconColor: Colors.cyan,
      title: "Kết quả từng vòng",
      child: Column(
        children: vongThi.map((v) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.checkCircle,
                    color: Colors.blue, size: 16),
                const SizedBox(width: 10),
                Text(
                  "Vòng ${v.thuTu}: ${v.tenVongThi}",
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===========================================================
  Widget _top3Section() {
    final top3 = giaiThuong;

    return _sectionCard(
      icon: FontAwesomeIcons.trophy,
      iconColor: Colors.amber,
      title: "Top 3 Chung cuộc",
      child: Column(
        children: List.generate(top3.length, (index) {
          final g = top3[index];
          final DatGiai data = g["data"];

          final name = g["sinhvien"]?["ten"] ?? "Thí sinh";

          return _buildTop3Item(index, data, name);
        }),
      ),
    );
  }

  Widget _buildTop3Item(int index, DatGiai data, String name) {
    Color color;
    IconData icon;

    if (index == 0) {
      color = Colors.amber;
      icon = FontAwesomeIcons.crown;
    } else if (index == 1) {
      color = Colors.grey;
      icon = FontAwesomeIcons.medal;
    } else {
      color = Colors.orange;
      icon = FontAwesomeIcons.award;
    }

    return Container(
      margin: EdgeInsets.only(bottom: index < 2 ? 12 : 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _medalIcon(color, icon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(data.tenGiai ?? "",
                    style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 6),
                Text(data.giaiThuong ?? ""),
              ],
            ),
          ),
          if (data.diemRenLuyen != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${data.diemRenLuyen} điểm",
                style: const TextStyle(
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _medalIcon(Color color, IconData icon) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.9),
      ),
      child: Center(
          child: FaIcon(icon, color: Colors.white, size: 20)),
    );
  }

  // ===========================================================
  String _fmtDate(String? iso) {
    if (iso == null) return "Không rõ";
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return "${dt.day}/${dt.month}/${dt.year}";
  }
}
