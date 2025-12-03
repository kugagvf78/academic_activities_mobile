import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/cores/widgets/custom_sliver_appbar.dart';
import 'package:academic_activities_mobile/cores/widgets/error_toast.dart';
import 'package:academic_activities_mobile/cores/widgets/info_tag.dart';
import 'package:academic_activities_mobile/cores/widgets/success_toast.dart';
import 'package:academic_activities_mobile/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:academic_activities_mobile/cores/widgets/input.dart';

class EventRegisterScreen extends StatefulWidget {
  final String id; // slug hoặc mã cuộc thi
  final String tenCuocThi;
  final String hinhThuc; // CaNhan / DoiNhom / CaHai

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
  String type = "individual";
  String teamName = "";

  final _nameCtrl = TextEditingController();
  final _mssvCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  List<Map<String, String>> members = [];

  bool _loading = false;

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

  // ===================================================
  // SUBMIT FORM → GỌI API LARAVEL
  // ===================================================
  void _submit() async {
    if (_nameCtrl.text.isEmpty ||
        _mssvCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _phoneCtrl.text.isEmpty) {
      ErrorToast.show(context, "Vui lòng nhập đủ thông tin bắt buộc");
      return;
    }

    if (type == "team" && teamName.isEmpty) {
      ErrorToast.show(context, "Tên đội không được để trống");
      return;
    }

    setState(() => _loading = true);

    Map<String, dynamic> body = {
      "type": type,
      "team_name": teamName,
      "main_name": _nameCtrl.text,
      "main_student_code": _mssvCtrl.text,
      "main_email": _emailCtrl.text,
      "main_phone": _phoneCtrl.text,
      "note": _noteCtrl.text,
    };

    if (type == "team") {
      body["members"] = members
          .map(
            (m) => {
              "name": m["name"],
              "student_code": m["mssv"],
              "email": m["email"],
            },
          )
          .toList();
    }

    try {
      final res = await EventService().submitRegistration(
        slug: widget.id,
        data: body,
      );

      if (res["success"] == false) {
        ErrorToast.show(context, res["message"] ?? "Có lỗi xảy ra");
        setState(() => _loading = false);
        return;
      }

      // SUCCESS TOAST
      SuccessToast.show(context, res["message"] ?? "Đăng ký thành công!");

      // Close after a delay
      Future.delayed(const Duration(milliseconds: 900), () {
        Navigator.pop(context);
      });
    } catch (e) {
      ErrorToast.show(context, e.toString().replaceFirst("Exception: ", ""));
    }

    setState(() => _loading = false);
  }

  // ===================================================
  // UI BẮT ĐẦU
  // ===================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeader(),
              SliverToBoxAdapter(child: _buildForm()),
            ],
          ),

          if (_loading) ...[
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
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
          children: const [
            Icon(FontAwesomeIcons.user, size: 14, color: Colors.white70),
            SizedBox(width: 6),
            Text("Tham gia thi", style: TextStyle(color: Colors.white70)),
          ],
        ),
        Row(
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

            _buildLabel("Tên cuộc thi"),
            const SizedBox(height: 8),
            InfoTag(color: Colors.grey, text: widget.tenCuocThi),

            const SizedBox(height: 20),
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
            else
              InfoTag(
                color: Colors.green,
                icon: FontAwesomeIcons.users,
                text: "Cuộc thi này chỉ cho phép đăng ký theo đội",
              ),

            if (type == "team") ...[
              const SizedBox(height: 20),
              LabeledInput(
                label: "Tên đội thi *",
                hint: "Nhập tên đội...",
                onChanged: (v) => teamName = v,
              ),
            ],

            const SizedBox(height: 24),

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
              label: "Họ và tên",
              hint: "Nhập họ và tên",
              controller: _nameCtrl,
            ),
            const SizedBox(height: 16),
            LabeledInput(
              label: "Mã số sinh viên",
              hint: "Nhập mã số sinh viên",
              controller: _mssvCtrl,
            ),
            const SizedBox(height: 16),
            LabeledInput(
              label: "Email",
              hint: "Nhập email",
              controller: _emailCtrl,
            ),
            const SizedBox(height: 16),
            LabeledInput(
              label: "Số điện thoại",
              hint: "Nhập số điện thoại",
              controller: _phoneCtrl,
            ),

            const SizedBox(height: 20),

            if (type == "team") _buildTeamMembers(),

            const SizedBox(height: 20),
            _buildLabel("Ghi chú"),
            const SizedBox(height: 6),
            _inputMultiline(controller: _noteCtrl),

            const SizedBox(height: 30),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
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
    );
  }

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
                    const SizedBox(height: 12),

                    LabeledInput(
                      label: "Họ và tên",
                      hint: "Nhập họ và tên",
                      onChanged: (v) => members[i]["name"] = v,
                    ),
                    const SizedBox(height: 14),

                    LabeledInput(
                      label: "Mã sinh viên",
                      hint: "Nhập mã sinh viên",
                      onChanged: (v) => members[i]["mssv"] = v,
                    ),
                    const SizedBox(height: 14),

                    LabeledInput(
                      label: "Email",
                      hint: "Nhập email",
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

// MULTILINE INPUT
Widget _inputMultiline({required TextEditingController controller}) {
  return TextField(
    controller: controller,
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
    ),
  );
}
