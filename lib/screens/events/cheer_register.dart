import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/cores/widgets/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:academic_activities_mobile/cores/widgets/input.dart';

class CheerRegisterScreen extends StatefulWidget {
  final String tenCuocThi;
  final List<Map<String, dynamic>> hoatDongs;

  const CheerRegisterScreen({
    super.key,
    required this.tenCuocThi,
    required this.hoatDongs,
  });

  @override
  State<CheerRegisterScreen> createState() => _CheerRegisterScreenState();
}

class _CheerRegisterScreenState extends State<CheerRegisterScreen> {
  String? selectedHoatDong;

  // Student info
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
            title: "ĐĂNG KÝ CỔ VŨ",
            description: "Lan tỏa tinh thần học thuật và nhiệt huyết 💙",
            imagePath: "assets/images/patterns/pattern2.jpg",

            metaItems: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(FontAwesomeIcons.user, size: 14, color: Colors.white70),
                  SizedBox(width: 6),
                  Text(
                    "Tham gia cổ vũ",
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

          SliverToBoxAdapter(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title("Thông tin đăng ký cổ vũ"),

            const SizedBox(height: 20),

            //------------------------------------------------
            // LIST HOẠT ĐỘNG RADIO
            //------------------------------------------------
            _label("Chọn hoạt động cổ vũ *"),

            const SizedBox(height: 10),

            Column(
              children: widget.hoatDongs.map((hd) {
                return _radioItem(
                  id: hd["id"].toString(),
                  title: hd["ten"],
                  time: hd["thoigian"],
                  location: hd["diadiem"],
                  drl: hd["drl"].toString(),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            //------------------------------------------------
            // THÔNG TIN SINH VIÊN
            //------------------------------------------------
            _title("Thông tin sinh viên"),

            const SizedBox(height: 16),
            LabeledInput(
              label: "Họ và tên *",
              hint: "Nguyễn Văn A",
              onChanged: (v) => name = v,
            ),
            const SizedBox(height: 16),
            LabeledInput(
              label: "Mã số sinh viên *",
              hint: "2024001234",
              onChanged: (v) => mssv = v,
            ),

            const SizedBox(height: 16),
            LabeledInput(
              label: "Email sinh viên *",
              hint: "student@example.com",
              onChanged: (v) => email = v,
            ),
            const SizedBox(height: 16),
            LabeledInput(
              label: "Số điện thoại *",
              hint: "0912345678",
              onChanged: (v) => phone = v,
            ),

            const SizedBox(height: 30),

            //------------------------------------------------
            // NOTE / WARNING
            //------------------------------------------------
            _noteBox(),

            const SizedBox(height: 30),

            //------------------------------------------------
            // SUBMIT BUTTON
            //------------------------------------------------
            _submitButton(),
          ],
        ),
      ),
    );
  }

  // ------------------------------
  // UI PIECES
  // ------------------------------

  Widget _title(String text) {
    return Center(
      child: Column(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Vui lòng điền đầy đủ thông tin",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2937),
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
              ? const Color(0xFF2563EB)
              : Colors.grey.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
        color: selectedHoatDong == id ? Colors.blue.shade50 : Colors.white,
      ),
      child: InkWell(
        onTap: () => setState(() => selectedHoatDong = id),
        child: Row(
          children: [
            Radio(
              value: id,
              groupValue: selectedHoatDong,
              onChanged: (v) => setState(() => selectedHoatDong = v as String),
              activeColor: Colors.blue,
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
                        color: Colors.blue,
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
          colors: [Color(0xFFFFF7E6), Color(0xFFFFF3D6)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(FontAwesomeIcons.lightbulb, color: Colors.orange),
              SizedBox(width: 10),
              Text(
                "Lưu ý khi đăng ký",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
            "✔ Đảm bảo thông tin chính xác để nhận thông báo.",
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
          colors: [Color(0xFF2563EB), Color(0xFF0EA5E9)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: PrimaryButton(
        label: "Đăng Ký Cổ Vũ",
        icon: Icons.volunteer_activism,
        onPressed: () {},
        borderRadius: 12,
      ),
    );
  }
}
