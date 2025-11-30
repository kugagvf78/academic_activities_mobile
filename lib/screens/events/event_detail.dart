import 'package:academic_activities_mobile/cores/widgets/custom_sliver_appbar.dart';
import 'package:academic_activities_mobile/cores/widgets/info_tag.dart';
import 'package:academic_activities_mobile/cores/widgets/section_tag.dart';
import 'package:academic_activities_mobile/screens/events/cheer_register.dart';
import 'package:academic_activities_mobile/screens/events/event_register.dart';
import 'package:academic_activities_mobile/screens/events/support_register.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../models/CuocThi.dart';
import 'package:intl/intl.dart';
import 'package:academic_activities_mobile/cores/widgets/button.dart';

class EventDetailScreen extends StatelessWidget {
  final CuocThi event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
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

  Widget _buildHeroSection(BuildContext context) {
    return CustomHeroSliverAppBar(
      title: event.tenCuocThi ?? "",
      description: event.moTa ?? event.mucDich,
      imagePath: "assets/images/patterns/pattern3.jpg",

      statusText: event.trangThaiLabel,
      statusColor: event.statusColor,

      // ⚡ Các icon meta map vào đây
      metaItems: [
        _metaIcon(FontAwesomeIcons.calendar, _fmtDate(event.thoiGianBatDau)),
        if (event.thoiGianBatDau != null && event.thoiGianKetThuc != null)
          _metaIcon(
            FontAwesomeIcons.clock,
            "${_fmtTime(event.thoiGianBatDau)} - ${_fmtTime(event.thoiGianKetThuc)}",
          ),
        if (event.diaDiem != null)
          _metaIcon(FontAwesomeIcons.locationDot, event.diaDiem!),
        _metaIcon(
          FontAwesomeIcons.userGroup,
          "${event.soLuongDangKy ?? 0}+ sinh viên đăng ký",
        ),
      ],

      // ⚡ Icon bên phải (có thể null nếu không muốn)
      action: IconButton(
        icon: const Icon(Icons.share_rounded, color: Colors.white),
        onPressed: () {
          // TODO: share
        },
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

  // ✳️ Nút hành động - FIXED
  Widget _buildActionButtons(BuildContext context) {
    if (event.trangThaiLabel == "Sắp diễn ra") {
      return Column(
        children: [
          // Nút Đăng ký dự thi — PrimaryButton
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: "Đăng ký dự thi",
              icon: FontAwesomeIcons.userPlus,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventRegisterScreen(
                      tenCuocThi: event.tenCuocThi ?? "",
                      hinhThuc: event.hinhThucThamGia ?? "CaNhan",
                    ),
                  ),
                );
              },
              borderRadius: 12,
            ),
          ),
          const SizedBox(height: 10),

          // Hai nút đăng ký khác — Outline
          Row(
            children: [
              Expanded(
                child: OutlineButtonCustom(
                  label: "Đăng ký hỗ trợ",
                  icon: FontAwesomeIcons.peopleCarryBox,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SupportRegisterScreen(
                          tenCuocThi: event.tenCuocThi ?? "",
                          hoatDongs: [
                            {
                              "id": 1,
                              "ten": "Hỗ trợ kỹ thuật",
                              "thoigian": "08:00 - 12:00, 12/12/2025",
                              "diadiem": "Hội trường A",
                              "drl": 10,
                            },
                            {
                              "id": 2,
                              "ten": "Hỗ trợ truyền thông",
                              "thoigian": "13:00 - 17:00, 12/12/2025",
                              "diadiem": "Sảnh khu A",
                              "drl": 8,
                            },
                          ],
                        ),
                      ),
                    );
                  },
                  color: const Color.fromARGB(255, 94, 47, 204),
                  bgColor: true,
                  borderRadius: 12,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlineButtonCustom(
                  label: "Đăng ký cổ vũ",
                  icon: FontAwesomeIcons.handsClapping,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheerRegisterScreen(
                          tenCuocThi: event.tenCuocThi ?? "",
                          hoatDongs: [
                            {
                              "id": 1,
                              "ten": "Cổ vũ vòng chung kết",
                              "thoigian": "14:00 - 17:00, 22/12/2025",
                              "diadiem": "Hội trường lớn",
                              "drl": 5,
                            },
                          ],
                        ),
                      ),
                    );
                  },
                  color: const Color.fromARGB(255, 4, 165, 111),
                  bgColor: true,
                  borderRadius: 12,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // Khi không thể đăng ký
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FaIcon(FontAwesomeIcons.lock, color: Colors.grey, size: 14),
            SizedBox(width: 8),
            Text(
              "Cuộc thi không nhận đăng ký",
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
  }

  // 📋 MAIN CONTENT
  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionCard(
          icon: FontAwesomeIcons.circleInfo,
          iconColor: Colors.blue,
          title: "Giới thiệu chung",
          child: Text(
            event.moTa ??
                event.mucDich ??
                "Chưa có thông tin giới thiệu cho cuộc thi này.",
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 14.5,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Đối tượng & yêu cầu
        if (event.doiTuongThamGia != null ||
            event.hinhThucThamGia != null ||
            event.soLuongThanhVien != null)
          _sectionCard(
            icon: FontAwesomeIcons.bullseye,
            iconColor: Colors.green,
            title: "Đối tượng & Yêu cầu",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.doiTuongThamGia != null)
                  _infoRow("Đối tượng tham gia:", event.doiTuongThamGia!),
                if (event.hinhThucThamGia != null)
                  _infoRow("Hình thức tham gia:", event.hinhThucThamGia!),
                if (event.soLuongThanhVien != null)
                  _infoRow(
                    "Số lượng thành viên:",
                    "${event.soLuongThanhVien} người/đội",
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
                title: "Thời gian tổ chức",
                subtitle:
                    "${_fmtDateTime(event.thoiGianBatDau)} → ${_fmtDateTime(event.thoiGianKetThuc)}",
                color: Colors.blue,
              ),
              const SizedBox(height: 8),
              if (event.diaDiem != null)
                _infoTile(
                  icon: FontAwesomeIcons.locationDot,
                  title: "Địa điểm",
                  subtitle: event.diaDiem!,
                  color: Colors.purple,
                ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        _sectionCard(
          icon: FontAwesomeIcons.layerGroup,
          iconColor: Colors.indigo,
          title: "Cấu trúc cuộc thi",
          child: _buildCompetitionStructure(),
        ),
        const SizedBox(height: 18),

        // Kế hoạch tổ chức
        _sectionCard(
          icon: FontAwesomeIcons.clipboardList,
          iconColor: Colors.cyan,
          title: "Kế hoạch tổ chức",
          child: const Text(
            "Kế hoạch tổ chức chi tiết sẽ được cập nhật trong thời gian tới. "
            "Hiện tại, cuộc thi đang trong giai đoạn chuẩn bị nội dung và thể lệ.",
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.6),
          ),
        ),
        const SizedBox(height: 18),

        // Ban tổ chức
        _sectionCard(
          icon: FontAwesomeIcons.userTie,
          iconColor: Colors.teal,
          title: "Ban tổ chức",
          child: Column(
            children: [
              _organizerTile(
                "Ban Điều Hành",
                "Phụ trách điều phối, phê duyệt kế hoạch",
                5,
              ),
              const SizedBox(height: 10),
              _organizerTile(
                "Ban Truyền Thông",
                "Thiết kế, đăng bài, quảng bá cuộc thi",
                4,
              ),
              const SizedBox(height: 10),
              _organizerTile(
                "Ban Kỹ Thuật",
                "Hỗ trợ hệ thống thi online, kỹ thuật chấm điểm",
                3,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Giải thưởng
        if (event.duTruKinhPhi != null)
          _sectionCard(
            icon: FontAwesomeIcons.trophy,
            iconColor: Colors.amber[700]!,
            title: "Giải thưởng",
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 234, 41),
                      width: 1,
                    ),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(188, 255, 252, 227),
                        Color(0xFFFFF3E0),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFC107), Color(0xFFFFA000)],
                          ),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.trophy,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tổng giá trị giải thưởng",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Dự kiến phân bổ cho các giải",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "${NumberFormat("#,###", "vi_VN").format(event.duTruKinhPhi)}đ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFA000),
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                InfoTag(
                  text:
                      'Tất cả thí sinh vào vòng chung kết đều nhận Giấy chứng nhận tham gia.',
                  color: Colors.blue.shade500,
                  icon: FontAwesomeIcons.circleExclamation,
                ),
              ],
            ),
          ),
      ],
    );
  }

  // 🔹 Helpers
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'RobotoCondensed', // ⚠️ Thêm dòng này
            fontSize: 14,
            height: 1.45,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
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
          Divider(thickness: 1, color: Colors.grey[200], height: 15),
          const SizedBox(height: 5),
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
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    height: 1.4,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
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
            child: const Icon(
              FontAwesomeIcons.users,
              color: Colors.white,
              size: 14,
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
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
                Text(
                  "$members thành viên",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitionStructure() {
    // 🔹 Giả sử sau này m lấy từ API -> dùng event.vongThiList
    final List<Map<String, dynamic>> vongThiList = [
      {
        "ten": "Vòng sơ loại",
        "moTa": "Thí sinh làm bài thi trắc nghiệm trực tuyến.",
        "thoiGianBatDau": "2025-03-10T08:00:00",
        "thoiGianKetThuc": "2025-03-12T17:00:00",
        "diaDiem": "Online qua hệ thống học tập",
        "hinhThuc": "Trắc nghiệm 40 câu",
      },
      {
        "ten": "Vòng bán kết",
        "moTa": "Các đội thi trình bày ý tưởng và phản biện.",
        "thoiGianBatDau": "2025-03-20T08:00:00",
        "thoiGianKetThuc": "2025-03-21T17:00:00",
        "diaDiem": "Phòng A201 - Khoa CNTT",
        "hinhThuc": "Thuyết trình nhóm",
      },
      {
        "ten": "Vòng chung kết",
        "moTa": "Các đội thi xuất sắc tranh tài trực tiếp.",
        "thoiGianBatDau": "2025-03-30T08:00:00",
        "thoiGianKetThuc": "2025-03-30T17:00:00",
        "diaDiem": "Hội trường lớn, cơ sở chính",
        "hinhThuc": "Thi trực tiếp",
      },
    ];

    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.pink,
    ];

    return Column(
      children: List.generate(vongThiList.length, (index) {
        final vong = vongThiList[index];
        final color = colors[index % colors.length];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: color, width: 1.2),
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString().padLeft(2, '0'),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vong["ten"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (vong["moTa"] != null)
                          Text(
                            vong["moTa"],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              height: 1.5,
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
                  if (vong["thoiGianBatDau"] != null)
                    _buildTag(
                      FontAwesomeIcons.calendar,
                      _fmtDateTime(vong["thoiGianBatDau"]),
                      Colors.blue,
                    ),
                  if (vong["thoiGianKetThuc"] != null)
                    _buildTag(
                      FontAwesomeIcons.calendarCheck,
                      _fmtDateTime(vong["thoiGianKetThuc"]),
                      Colors.green,
                    ),
                  if (vong["diaDiem"] != null)
                    _buildTag(
                      FontAwesomeIcons.locationDot,
                      vong["diaDiem"],
                      Colors.purple,
                    ),
                  if (vong["hinhThuc"] != null)
                    _buildTag(
                      FontAwesomeIcons.fileLines,
                      vong["hinhThuc"],
                      Colors.cyan,
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
          FaIcon(icon, size: 11, color: color),
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

  // ⏰ Format date
  String _fmtDate(String? iso) => iso == null
      ? "Chưa xác định"
      : DateFormat('dd/MM/yyyy').format(DateTime.parse(iso));
  String _fmtTime(String? iso) =>
      iso == null ? "--:--" : DateFormat('HH:mm').format(DateTime.parse(iso));
  String _fmtDateTime(String? iso) => iso == null
      ? "Chưa xác định"
      : DateFormat('HH:mm, dd/MM/yyyy').format(DateTime.parse(iso));
}
