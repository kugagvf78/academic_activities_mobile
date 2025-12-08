import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/cores/widgets/custom_sliver_appbar.dart';
import 'package:academic_activities_mobile/cores/widgets/info_tag.dart';
import 'package:academic_activities_mobile/cores/widgets/section_tag.dart';
import 'package:academic_activities_mobile/screens/events/cheer_register.dart';
import 'package:academic_activities_mobile/screens/events/event_register.dart';
import 'package:academic_activities_mobile/screens/events/support_register.dart';
import 'package:academic_activities_mobile/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../cores/widgets/colorful_loader.dart';

class EventDetailScreen extends StatefulWidget {
  final String id; // nhận id cuộc thi

  const EventDetailScreen({super.key, required this.id});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final _service = EventService();
  Map<String, dynamic>? event;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final data = await _service.getEventDetail(widget.id);

      debugPrint("===== DỮ LIỆU NHẬN TỪ API =====");
      debugPrint(data.toString()); // IN RA TOÀN BỘ JSON
      debugPrint("===== HẾT JSON =====");

      setState(() {
        event = data;
        loading = false;
      });
    } catch (e, stack) {
      debugPrint("===== LỖI TẢI CHI TIẾT =====");
      debugPrint(e.toString());
      debugPrint(stack.toString()); // In stacktrace để biết dòng bị crash
      debugPrint("============================");

      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: ColorfulLoader(),
      );
    }

    if (event == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(child: Text("Không tải được dữ liệu")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeroSection(context),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildActionButtons(context),
                    const SizedBox(height: 22),
                    _buildMainContent(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  // =====================================================================================
  // HERO SECTION
  // =====================================================================================

  Widget _buildHeroSection(BuildContext context) {
    return CustomHeroSliverAppBar(
      title: event!["tencuocthi"] ?? "",
      description: event!["mota"] ?? event!["mucdich"],
      imagePath: "assets/images/patterns/pattern3.jpg",

      statusText: event!["status_label"],
      statusColor: _statusColor(event!["status_label"]),

      metaItems: [
        _metaIcon(
          FontAwesomeIcons.calendar,
          _fmtDate(event!["thoigianbatdau"]),
        ),
        _metaIcon(
          FontAwesomeIcons.clock,
          "${_fmtTime(event!["thoigianbatdau"])} - ${_fmtTime(event!["thoigianketthuc"])}",
        ),
        _metaIcon(FontAwesomeIcons.locationDot, event!["diadiem"] ?? "Chưa rõ"),
        _metaIcon(
          FontAwesomeIcons.userGroup,
          "${event!["soluongdangky"] ?? 0}+ sinh viên tham gia",
        ),
      ],

      action: IconButton(
        icon: const Icon(Icons.share_rounded, color: Colors.white),
        onPressed: () {},
      ),
    );
  }

  Widget _metaIcon(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, color: Colors.white, size: 13),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case "Đang diễn ra":
        return Colors.blue;
      case "Sắp diễn ra":
        return Colors.green;
      case "Đã kết thúc":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // =====================================================================================
  // ACTION BUTTONS
  // =====================================================================================

  Widget _buildActionButtons(BuildContext context) {
    final String id = event!["macuocthi"];

    if (event!["status_label"] == "Sắp diễn ra") {
      return Column(
        children: [
          // ---------------------
          // 🔵 ĐĂNG KÝ DỰ THI
          // ---------------------
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: "Đăng ký dự thi",
              icon: FontAwesomeIcons.userPlus,
              borderRadius: 15,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventRegisterScreen(
                      id: event!["macuocthi"],
                      tenCuocThi: event!["tencuocthi"],
                      hinhThuc: event!["hinhthucthamgia"] ?? "CaNhan",
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              // ---------------------
              // 🟣 ĐĂNG KÝ HỖ TRỢ
              Flexible(
                fit: FlexFit.loose,
                child: _outlineButton(
                  "Đăng ký hỗ trợ",
                  FontAwesomeIcons.peopleCarryBox,
                  Colors.deepPurple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SupportRegisterScreen(
                          macuocthi: event!["macuocthi"], 
                          tenCuocThi: event!["tencuocthi"],
                          hoatDongs: List<Map<String, dynamic>>.from(
                            event!["hotro"] ?? [],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(width: 10),
              // 🟢 ĐĂNG KÝ CỔ VŨ
              Flexible(
                fit: FlexFit.loose,
                child: _outlineButton(
                  "Đăng ký cổ vũ",
                  FontAwesomeIcons.handsClapping,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheerRegisterScreen(
                          slug: event!["slug"],
                          tenCuocThi: event!["tencuocthi"],
                          hoatDongs: List<Map<String, dynamic>>.from(
                            event!["colvu"] ?? [],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          FaIcon(FontAwesomeIcons.lock, size: 14, color: Colors.grey),
          SizedBox(width: 10),
          Text("Cuộc thi không nhận đăng ký"),
        ],
      ),
    );
  }

  Widget _outlineButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
        color: color.withOpacity(0.1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================================================
  // MAIN CONTENT
  // =====================================================================================

  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionCard(
          icon: FontAwesomeIcons.circleInfo,
          iconColor: Colors.blue,
          title: "Giới thiệu chung",
          child: Text(
            event!["mota"] ?? event!["mucdich"] ?? "Chưa cập nhật mô tả.",
            style: const TextStyle(height: 1.6, fontSize: 14.5),
          ),
        ),

        const SizedBox(height: 18),

        if (event!["doituongthamgia"] != null)
          _sectionCard(
            icon: FontAwesomeIcons.bullseye,
            iconColor: Colors.green,
            title: "Đối tượng & Yêu cầu",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow("Đối tượng", event!["doituongthamgia"]),
                _infoRow(
                  "Hình thức tham gia",
                  event!["hinhthucthamgia"] ?? "Không xác định",
                ),
                _infoRow(
                  "Số lượng thành viên",
                  "${event!["soluongthanhvien"] ?? 1} người/đội",
                ),
              ],
            ),
          ),

        const SizedBox(height: 18),

        _sectionCard(
          icon: FontAwesomeIcons.calendarCheck,
          iconColor: Colors.amber,
          title: "Thời gian & Địa điểm",
          child: Column(
            children: [
              _infoTile(
                icon: FontAwesomeIcons.clock,
                title: "Thời gian",
                subtitle:
                    "${_fmtDateTime(event!["thoigianbatdau"])} → ${_fmtDateTime(event!["thoigianketthuc"])}",
                color: Colors.blue,
              ),
              if (event!["diadiem"] != null)
                _infoTile(
                  icon: FontAwesomeIcons.locationDot,
                  title: "Địa điểm",
                  subtitle: event!["diadiem"],
                  color: Colors.purple,
                ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        if (event!["vongthi"] != null)
          _sectionCard(
            icon: FontAwesomeIcons.layerGroup,
            iconColor: Colors.indigo,
            title: "Cấu trúc cuộc thi",
            child: _buildCompetitionStructure(),
          ),

        const SizedBox(height: 18),

        if (event!["bantochuc"] != null)
          _sectionCard(
            icon: FontAwesomeIcons.userTie,
            iconColor: Colors.teal,
            title: "Ban tổ chức",
            child: Column(
              children: List.generate(
                event!["bantochuc"].length,
                (i) => _organizerTile(
                  event!["bantochuc"][i]["tenban"],
                  event!["bantochuc"][i]["motaban"],
                  event!["bantochuc"][i]["sothanhvien"],
                ),
              ),
            ),
          ),

        const SizedBox(height: 18),

        if (event!["dutrukinhphi"] != null)
          _sectionCard(
            icon: FontAwesomeIcons.award,
            iconColor: Colors.amber,
            title: "Giải thưởng",
            child: Column(
              children: [
                // ====== CARD VÀNG ======
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6), // vàng nhạt
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber.shade100),
                  ),
                  child: Row(
                    children: [
                      // ICON
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.trophy,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),

                      // TEXT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tổng giá trị giải thưởng",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Dự kiến phân bổ cho các giải",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              NumberFormat("#,###", "vi_VN").format(
                                    double.tryParse(
                                          event!["dutrukinhphi"].toString(),
                                        ) ??
                                        0,
                                  ) +
                                  "đ",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF8A00), // cam đậm giống hình
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                InfoTag(
                  color: Colors.blue,
                  text:
                      "Tất cả thí sinh vào vòng chung kết đều được nhận giấy chứng nhận tham gia.",
                  icon: FontAwesomeIcons.infoCircle,
                ),
              ],
            ),
          ),
      ],
    );
  }

  // =====================================================================================
  // HELPERS
  // =====================================================================================

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            height: 1.45,
          ),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

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
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
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
          Divider(height: 20, color: Colors.grey.shade300),
          child,
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 3)),
        color: color.withOpacity(0.05),
      ),
      child: Row(
        children: [
          FaIcon(icon, color: color, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _organizerTile(String name, String desc, int members) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF0EA5E9)],
              ),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.users,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
                Text(
                  "$members thành viên",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitionStructure() {
    if (event?["vongthi"] == null) return SizedBox();

    final vongThiList = event!["vongthi"];

    final colors = [Colors.blue, Colors.purple, Colors.teal];

    return Column(
      children: List.generate(vongThiList.length, (i) {
        final vong = vongThiList[i];
        final c = colors[i % colors.length];

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: c, width: 1.2),
                    ),
                    child: Center(
                      child: Text(
                        (i + 1).toString().padLeft(2, '0'),
                        style: TextStyle(
                          color: c,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vong["tenvongthi"] ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          vong["mota"] ?? "",
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildTag(
                    FontAwesomeIcons.calendar,
                    vong["thoigianbatdau"] ?? "",
                    Colors.blue,
                  ),
                  _buildTag(
                    FontAwesomeIcons.calendarCheck,
                    vong["thoigianketthuc"] ?? "",
                    Colors.green,
                  ),
                  _buildTag(
                    FontAwesomeIcons.locationDot,
                    vong["diadiem"] ?? "",
                    Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTag(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, color: color, size: 11),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // DATE FORMATTERS
  String _fmtDate(String? iso) => iso == null
      ? "Chưa rõ"
      : DateFormat('dd/MM/yyyy').format(DateTime.parse(iso));

  String _fmtTime(String? iso) =>
      iso == null ? "--:--" : DateFormat('HH:mm').format(DateTime.parse(iso));

  String _fmtDateTime(String? iso) => iso == null
      ? "Chưa xác định"
      : DateFormat('HH:mm, dd/MM/yyyy').format(DateTime.parse(iso));
}
