import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/cores/widgets/custom_sliver_appbar.dart';
import 'package:academic_activities_mobile/cores/widgets/info_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:academic_activities_mobile/cores/widgets/input.dart';

class EventRegisterScreen extends StatefulWidget {
  final String tenCuocThi;
  final String hinhThuc; // CaNhan / DoiNhom / CaHai

  const EventRegisterScreen({
    super.key,
    required this.tenCuocThi,
    required this.hinhThuc,
  });

  @override
  State<EventRegisterScreen> createState() => _EventRegisterScreenState();
}

class _EventRegisterScreenState extends State<EventRegisterScreen> {
  String type = "individual";
  String teamName = "";
  List<Map<String, String>> members = [];

  @override
  void initState() {
    super.initState();
    // auto chọn khi chỉ có 1 hình thức
    if (widget.hinhThuc == "CaNhan") type = "individual";
    if (widget.hinhThuc == "DoiNhom") {
      type = "team";
    }
  }

  void addMember() {
    setState(() {
      members.add({"name": "", "mssv": "", "email": ""});
    });
  }

  void removeMember() {
    setState(() {
      if (members.isNotEmpty) members.removeLast();
    });
  }

  // -------------------------------
  // UI START
  // -------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(child: _buildForm()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return CustomHeroSliverAppBar(
      title: "Đăng Ký Tham Gia",
      description: "Khẳng định bản lĩnh và chinh phục tri thức",

      // Ảnh nền hero
      imagePath: "assets/images/patterns/pattern4.jpg",

      // Trạng thái (option)
      statusText: widget.hinhThuc == "CaNhan"
          ? "Cá nhân"
          : widget.hinhThuc == "DoiNhom"
          ? "Đội nhóm"
          : "Cả hai",
      statusColor: Colors.white,

      // Meta info
      metaItems: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(FontAwesomeIcons.user, size: 14, color: Colors.white70),
            SizedBox(width: 6),
            Text("Tham gia thi", style: TextStyle(color: Colors.white70)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              FontAwesomeIcons.circleInfo,
              size: 14,
              color: Colors.white70,
            ),
            const SizedBox(width: 6),
            Text(
              widget.tenCuocThi,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  // -------------------------------
  // FORM
  // -------------------------------
  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE
            Center(
              child: Column(
                children: [
                  const Text(
                    "Thông Tin Đăng Ký",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Vui lòng điền đủ thông tin",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tên Cuộc Thi
            _buildLabel("Tên cuộc thi"),
            const SizedBox(height: 10),
            InfoTag(color: Colors.grey, text: widget.tenCuocThi),

            const SizedBox(height: 18),

            // Hình thức
            _buildLabel("Hình thức thi"),
            const SizedBox(height: 10),

            if (widget.hinhThuc == "CaHai") ...[
              _radio("individual", "Cá nhân"),
              _radio("team", "Theo nhóm"),
            ] else if (widget.hinhThuc == "CaNhan")
              InfoTag(
                color: Colors.blue,
                icon: FontAwesomeIcons.user,
                text: "Cuộc thi này chỉ cho phép đăng ký cá nhân",
              )
            else if (widget.hinhThuc == "DoiNhom")
              InfoTag(
                color: Colors.green,
                icon: FontAwesomeIcons.users,
                text: "Cuộc thi này chỉ cho phép đăng ký theo đội",
              ),

            const SizedBox(height: 20),

            LabeledInput(
              label: "Tên đội thi *",
              hint: "Nhập tên đội...",
              onChanged: (v) => setState(() => teamName = v),
            ),

            const SizedBox(height: 24),

            // Info leader/student
            Text(
              type == "individual"
                  ? "Thông tin thí sinh"
                  : "Thông tin trưởng nhóm",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            LabeledInput(label: "Họ và tên *", hint: "Nhập họ và tên"),
            const SizedBox(height: 16),
            LabeledInput(label: "Mã số sinh viên *", hint: "2024001234"),
            const SizedBox(height: 16),
            LabeledInput(
              label: "Email sinh viên *",
              hint: "student@example.com",
            ),
            const SizedBox(height: 16),
            LabeledInput(label: "Số điện thoại *", hint: "0912345678"),

            const SizedBox(height: 30),

            // Thành viên nhóm
            if (type == "team") _buildTeamMembers(),

            const SizedBox(height: 20),

            // Ghi chú
            _buildLabel("Ghi chú"),
            SizedBox(height: 6),
            _inputMultiline(),

            const SizedBox(height: 30),

            // SUBMIT BUTTON
            Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF0EA5E9)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: PrimaryButton(
                  label: "Gửi Đăng Ký",
                  icon: Icons.send_rounded,
                  onPressed: () {},
                  borderRadius: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------
  // TEAM MEMBERS LIST
  // -------------------------------
  Widget _buildTeamMembers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Thành viên nhóm (Ngoài trưởng nhóm)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (members.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text(
                "Chưa có thành viên",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),
          )
        else
          Column(
            children: List.generate(members.length, (i) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thành viên ${i + 1}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: LabeledInput(
                            label: "Họ và tên *",
                            hint: "0912345678",
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: LabeledInput(
                            label: "Mã sinh viên *",
                            hint: "0912345678",
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: LabeledInput(
                            label: "Email *",
                            hint: "0912345678",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              icon: const Icon(FontAwesomeIcons.userPlus, size: 14),
              label: const Text("Thêm thành viên"),
              onPressed: addMember,
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
            if (members.isNotEmpty)
              TextButton.icon(
                icon: const Icon(FontAwesomeIcons.userMinus, size: 14),
                label: const Text("Xóa thành viên"),
                onPressed: removeMember,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
          ],
        ),
      ],
    );
  }

  // -------------------------------
  // SMALL UI HELPERS
  // -------------------------------
  Widget _radio(String value, String label) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: type,
          onChanged: (v) => setState(() => type = v.toString()),
          activeColor: Colors.blue,
        ),
        Text(label),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2937),
        fontSize: 16,
      ),
    );
  }
}

Widget _inputMultiline() {
  return TextField(
    maxLines: 3,
    decoration: InputDecoration(
      hintText: "Nhập ghi chú ...",
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
      ),

      isDense: true,
    ),
  );
}

// ======================================
// WAVES - SVG giống bản web
// ======================================
const String _waveSvg = '''
<svg viewBox="0 0 1440 120" xmlns="http://www.w3.org/2000/svg">
<path fill="#ffffff" d="M0,64L80,74.7C160,85,320,107,480,117.3C640,128,800,128,960,117.3C1120,107,1280,85,1360,74.7L1440,64V120H0Z"/>
</svg>
''';
