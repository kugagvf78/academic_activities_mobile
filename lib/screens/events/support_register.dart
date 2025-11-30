import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/cores/widgets/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:academic_activities_mobile/cores/widgets/input.dart';

class SupportRegisterScreen extends StatefulWidget {
  final String tenCuocThi;
  final List<Map<String, dynamic>> hoatDongs;

  const SupportRegisterScreen({
    super.key,
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
                mainAxisSize: MainAxisSize.min,
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
          ),

          SliverToBoxAdapter(child: _buildForm()),
        ],
      ),
    );
  }

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

            //-------------------------------
            // RADIO LIST HOẠT ĐỘNG
            //-------------------------------
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
                  id: hd["id"].toString(),
                  title: hd["ten"],
                  time: hd["thoigian"],
                  location: hd["diadiem"],
                  drl: hd["drl"],
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            //-------------------------------
            // THÔNG TIN SINH VIÊN
            //-------------------------------
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
              label: "Email sinh viên *",
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

            //-------------------------------
            // NOTE BOX
            //-------------------------------
            _noteBox(),

            const SizedBox(height: 30),

            //-------------------------------
            // SUBMIT BUTTON
            //-------------------------------
            _submitButton(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // UI PIECES
  // ---------------------------------------------------------

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
    required int drl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedHoatDong == id
              ? const Color.fromARGB(255, 108, 162, 255)
              : Colors.grey.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
        color: selectedHoatDong == id
            ? const Color.fromARGB(162, 222, 235, 255)
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
              activeColor: Colors.blueAccent,
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
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.calendar,
                        size: 14,
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
                        size: 14,
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
                        size: 14,
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
        onPressed: () {},
        borderRadius: 12,
      ),
    );
  }
}
