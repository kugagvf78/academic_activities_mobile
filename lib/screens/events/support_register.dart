import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/cores/widgets/custom_sliver_appbar.dart';
import 'package:academic_activities_mobile/cores/widgets/error_toast.dart';
import 'package:academic_activities_mobile/cores/widgets/success_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:academic_activities_mobile/cores/widgets/input.dart';

import '../../services/event_service.dart';

class SupportRegisterScreen extends StatefulWidget {
  final String macuocthi;
  final String tenCuocThi;
  final List<Map<String, dynamic>> hoatDongs;

  const SupportRegisterScreen({
    super.key,
    required this.macuocthi,
    required this.tenCuocThi,
    required this.hoatDongs,
  });

  @override
  State<SupportRegisterScreen> createState() => _SupportRegisterScreenState();
}

class _SupportRegisterScreenState extends State<SupportRegisterScreen> {
  String? selectedHoatDong;

  // student info
  String name = "";
  String mssv = "";
  String email = "";
  String phone = "";

  // ================================
  // 🔥 SUBMIT API
  // ================================
  void _submitSupport() async {
    if (selectedHoatDong == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn hoạt động hỗ trợ")),
      );
      return;
    }

    if (name.isEmpty || mssv.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đủ thông tin sinh viên")),
      );
      return;
    }

    try {
      final res = await EventService().registerSupport(
        macuocthi: widget.macuocthi,
        mahoatdong: selectedHoatDong!,
        masinhvien: mssv,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res["message"])));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          CustomHeroSliverAppBar(
            title: "ĐĂNG KÝ HỖ TRỢ",
            description: "Hãy trở thành một phần của đội ngũ tổ chức!!",
            imagePath: "assets/images/patterns/pattern3.jpg",
            metaItems: [
              Row(
                children: const [
                  Icon(FontAwesomeIcons.user, size: 14, color: Colors.white70),
                  SizedBox(width: 6),
                  Text(
                    "Tham gia hỗ trợ",
                    style: TextStyle(color: Colors.white70),
                  ),
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
          ),

          SliverToBoxAdapter(child: _buildForm()),
        ],
      ),
    );
  }

  // ========================= FORM =========================

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),

            const SizedBox(height: 20),

            const Text(
              "Chọn hoạt động hỗ trợ *",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),

            Column(
              children: widget.hoatDongs.map((hd) {
                return _radioItem(
                  id: hd["mahoatdong"].toString(),
                  title: hd["tenhoatdong"] ?? "Hoạt động",
                  time: hd["thoigianbatdau"] ?? "",
                  location: hd["diadiem"] ?? "",
                  drl: (hd["diemrenluyen"] ?? "0").toString(),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            const Text(
              "Thông tin sinh viên",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 14),

            LabeledInput(
              label: "Họ và tên *",
              hint: "Nguyễn Văn A",
              onChanged: (v) => name = v,
            ),
            const SizedBox(height: 14),

            LabeledInput(
              label: "Mã số sinh viên *",
              hint: "2024001234",
              onChanged: (v) => mssv = v,
            ),
            const SizedBox(height: 14),

            LabeledInput(
              label: "Email *",
              hint: "student@example.com",
              onChanged: (v) => email = v,
            ),
            const SizedBox(height: 14),

            LabeledInput(
              label: "Số điện thoại *",
              hint: "0912345678",
              onChanged: (v) => phone = v,
            ),

            const SizedBox(height: 30),

            _noteBox(),

            const SizedBox(height: 30),

            _submitButton(),
          ],
        ),
      ),
    );
  }

  // ========================= UI PIECES =========================

  Widget _title() {
    return Center(
      child: Column(
        children: [
          const Text(
            "Đăng ký hỗ trợ Ban tổ chức",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Hãy lựa chọn vai trò phù hợp để đồng hành cùng sự kiện",
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _radioItem({
    required String id,
    required String title,
    required String time,
    required String location,
    required String drl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedHoatDong == id
              ? const Color(0xFF4F46E5)
              : Colors.grey.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
        color: selectedHoatDong == id
            ? const Color.fromARGB(75, 99, 102, 241)
            : Colors.white,
      ),
      child: InkWell(
        onTap: () => setState(() => selectedHoatDong = id),
        child: Row(
          children: [
            Radio(
              value: id,
              groupValue: selectedHoatDong,
              onChanged: (v) => setState(() => selectedHoatDong = v as String),
              activeColor: Colors.indigo,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.calendar,
                        size: 13,
                        color: Colors.indigo,
                      ),
                      const SizedBox(width: 6),
                      Text(time),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.locationDot,
                        size: 13,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(location),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.star,
                        size: 13,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "+$drl điểm rèn luyện",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noteBox() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF6FF), Color(0xFFE0E7FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(FontAwesomeIcons.lightbulb, color: Colors.indigo),
              SizedBox(width: 10),
              Text(
                "Lưu ý khi đăng ký",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "✔ Vui lòng có mặt đúng giờ để điểm danh.",
            style: TextStyle(fontSize: 14),
          ),
          Text(
            "✔ Không thể đăng ký sau khi hoạt động đã bắt đầu.",
            style: TextStyle(fontSize: 14),
          ),
          Text(
            "✔ Ban tổ chức sẽ gửi email hướng dẫn nhiệm vụ.",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() async {
    if (selectedHoatDong == null) {
      ErrorToast.show(context, "Vui lòng chọn hoạt động hỗ trợ");
      return;
    }

    if (name.isEmpty || mssv.isEmpty || email.isEmpty || phone.isEmpty) {
      ErrorToast.show(context, "Vui lòng điền đủ thông tin sinh viên");
      return;
    }

    try {
      final res = await EventService().registerSupport(
        macuocthi: widget.macuocthi,
        mahoatdong: selectedHoatDong!,
        masinhvien: mssv,
      );

      if (res["success"] == false) {
        ErrorToast.show(context, res["message"] ?? "Có lỗi xảy ra");
        return;
      }

      // 🔥 SUCCESS TOAST HERE
      SuccessToast.show(context, res["message"] ?? "Đăng ký thành công!");

      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pop(context);
      });
    } catch (e) {
      ErrorToast.show(context, e.toString().replaceFirst("Exception: ", ""));
    }
  }

  Widget _submitButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: PrimaryButton(
        label: "Đăng Ký Hỗ Trợ",
        icon: Icons.send_rounded,
        onPressed: _handleSubmit,
        borderRadius: 12,
      ),
    );
  }
}
