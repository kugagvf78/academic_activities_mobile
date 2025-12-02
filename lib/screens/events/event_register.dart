import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/cores/widgets/custom_sliver_appbar.dart';
import 'package:academic_activities_mobile/cores/widgets/info_tag.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:academic_activities_mobile/cores/widgets/input.dart';

class EventRegisterScreen extends StatefulWidget {
  final String id;          // 🔥 MÃ CUỘC THI
  final String tenCuocThi;
  final String hinhThuc;    // CaNhan / DoiNhom / CaHai

  const EventRegisterScreen({
    super.key,
    required this.id,
    required this.tenCuocThi,
    required this.hinhThuc,
  });

  @override
  State<EventRegisterScreen> createState() => _EventRegisterScreenState();
}

class _EventRegisterScreenState extends State<EventRegisterScreen> {
  String type = "individual"; // individual / team
  String teamName = "";

  // Controllers cho leader/student
  final _nameCtrl = TextEditingController();
  final _mssvCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  // Thành viên nhóm
  List<Map<String, String>> members = [];

  @override
  void initState() {
    super.initState();

    if (widget.hinhThuc == "CaNhan") type = "individual";
    if (widget.hinhThuc == "DoiNhom") type = "team";
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

  // -----------------------------------------
  // SUBMIT
  // -----------------------------------------
  void _submit() async {
    if (_nameCtrl.text.isEmpty ||
        _mssvCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin bắt buộc")),
      );
      return;
    }

    Map<String, dynamic> body = {
      "macuocthi": widget.id,
      "type": type,
      "team_name": teamName,
      "leader": {
        "name": _nameCtrl.text,
        "mssv": _mssvCtrl.text,
        "email": _emailCtrl.text,
        "phone": _phoneCtrl.text,
      },
      "members": members,
      "note": _noteCtrl.text,
    };

    print("📤 JSON GỬI API:");
    print(body);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gửi đăng ký thành công")),
    );

    // TODO:
    // await EventService().registerCompetition(body);
  }

  // -----------------------------------------
  // UI START
  // -----------------------------------------
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
      imagePath: "assets/images/patterns/pattern4.jpg",
      statusText: widget.hinhThuc == "CaNhan"
          ? "Cá nhân"
          : widget.hinhThuc == "DoiNhom"
              ? "Đội nhóm"
              : "Cả hai",
      statusColor: Colors.white,
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
            const Icon(FontAwesomeIcons.circleInfo,
                size: 14, color: Colors.white70),
            const SizedBox(width: 6),
            Text(widget.tenCuocThi,
                style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ],
    );
  }

  // -----------------------------------------
  // FORM
  // -----------------------------------------
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
            // Title
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
                  Text("Vui lòng điền đủ thông tin",
                      style: TextStyle(color: Colors.grey.shade600)),
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

            // Team Name
            if (type == "team")
              LabeledInput(
                label: "Tên đội thi *",
                hint: "Nhập tên đội...",
                onChanged: (v) => teamName = v,
              ),

            const SizedBox(height: 24),

            // Leader/Student Info
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

            LabeledInput(
              label: "Họ và tên *",
              hint: "Nhập họ và tên",
              controller: _nameCtrl,
            ),
            const SizedBox(height: 16),

            LabeledInput(
              label: "Mã số sinh viên *",
              hint: "2024001234",
              controller: _mssvCtrl,
            ),
            const SizedBox(height: 16),

            LabeledInput(
              label: "Email sinh viên *",
              hint: "student@example.com",
              controller: _emailCtrl,
            ),
            const SizedBox(height: 16),

            LabeledInput(
              label: "Số điện thoại *",
              hint: "0912345678",
              controller: _phoneCtrl,
            ),
            const SizedBox(height: 30),

            //
            if (type == "team") _buildTeamMembers(),

            const SizedBox(height: 20),

            _buildLabel("Ghi chú"),
            const SizedBox(height: 6),
            _inputMultiline(controller: _noteCtrl),

            const SizedBox(height: 30),

            //
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
                  onPressed: _submit,
                  borderRadius: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------
  // TEAM MEMBERS LIST
  // -----------------------------------------
  Widget _buildTeamMembers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thành viên nhóm (Ngoài trưởng nhóm)",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 14),

        if (members.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text("Chưa có thành viên",
                  style: TextStyle(color: Colors.grey.shade500)),
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
                    Text("Thành viên ${i + 1}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        )),
                    const SizedBox(height: 12),

                    LabeledInput(
                      label: "Họ và tên",
                      hint: "Nhập họ tên",
                      onChanged: (v) => members[i]["name"] = v,
                    ),
                    const SizedBox(height: 14),

                    LabeledInput(
                      label: "Mã sinh viên",
                      hint: "Nhập MSSV",
                      onChanged: (v) => members[i]["mssv"] = v,
                    ),
                    const SizedBox(height: 14),

                    LabeledInput(
                      label: "Email",
                      hint: "Nhập Email",
                      onChanged: (v) => members[i]["email"] = v,
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
            OutlineButtonCustom(
              label: "Thêm thành viên",
              icon: FontAwesomeIcons.userPlus,
              onPressed: addMember,
              isSmall: true,
              bgColor: true,
            ),
            OutlineButtonCustom(
              label: "Xóa thành viên",
              icon: FontAwesomeIcons.userMinus,
              onPressed: removeMember,
              isSmall: true,
              bgColor: true,
              color: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  // -----------------------------------------
  // UI HELPERS
  // -----------------------------------------
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

// MULTILINE
Widget _inputMultiline({required TextEditingController controller}) {
  return TextField(
    controller: controller,
    maxLines: 3,
    decoration: InputDecoration(
      hintText: "Nhập ghi chú ...",
      hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
