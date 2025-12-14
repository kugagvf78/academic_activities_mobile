import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/cores/widgets/custom_sliver_appbar.dart';
import 'package:academic_activities_mobile/cores/widgets/error_toast.dart';
import 'package:academic_activities_mobile/cores/widgets/success_toast.dart';
import 'package:academic_activities_mobile/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:academic_activities_mobile/cores/widgets/input.dart';
import '../../services/event_service.dart';

class CheerRegisterScreen extends StatefulWidget {
  final String slug;
  final String tenCuocThi;
  final List<Map<String, dynamic>> hoatDongs;

  const CheerRegisterScreen({
    super.key,
    required this.slug,
    required this.tenCuocThi,
    required this.hoatDongs,
  });

  @override
  State<CheerRegisterScreen> createState() => _CheerRegisterScreenState();
}

class _CheerRegisterScreenState extends State<CheerRegisterScreen> {
  String? selectedHoatDong;

  final _nameCtrl = TextEditingController();
  final _mssvCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // ✅ AUTO-FILL THÔNG TIN USER
  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await AuthService().getUserInfo();
      
      if (userInfo != null) {
        setState(() {
          _nameCtrl.text = userInfo['hoten'] ?? '';
          _mssvCtrl.text = userInfo['tendangnhap'] ?? '';
          _emailCtrl.text = userInfo['email'] ?? '';
          _phoneCtrl.text = userInfo['sodienthoai'] ?? '';
        });
        return;
      }
      
      final tokenData = await AuthService().getUserInfoFromToken();
      
      if (tokenData != null) {
        setState(() {
          _nameCtrl.text = tokenData['ho_ten'] ?? '';
          _mssvCtrl.text = tokenData['sub'] ?? '';
          _emailCtrl.text = tokenData['email'] ?? '';
        });
      }
    } catch (e) {
      print('❌ Lỗi load user info: $e');
    }
  }

  void _submitCheer() async {
    if (selectedHoatDong == null) {
      ErrorToast.show(context, "Vui lòng chọn hoạt động cổ vũ");
      return;
    }

    if (_nameCtrl.text.isEmpty || _mssvCtrl.text.isEmpty || 
        _emailCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
      ErrorToast.show(context, "Vui lòng nhập đầy đủ thông tin sinh viên");
      return;
    }

    try {
      final res = await EventService().registerCheer(
        mahoatdong: selectedHoatDong!,
        masinhvien: _mssvCtrl.text,
      );

      if (res["success"] == false) {
        ErrorToast.show(context, res["message"] ?? "Có lỗi xảy ra");
        return;
      }

      SuccessToast.show(
        context,
        res["message"] ?? "Đăng ký cổ vũ thành công!",
      );

      Future.delayed(const Duration(milliseconds: 900), () {
        Navigator.pop(context, true); // ✅ TRẢ VỀ true ĐỂ RELOAD
      });

    } catch (e) {
      ErrorToast.show(
        context,
        e.toString().replaceFirst("Exception: ", ""),
      );
    }
  }

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

            _label("Chọn hoạt động cổ vũ *"),
            const SizedBox(height: 10),

            Column(
              children: widget.hoatDongs.map((hd) {
                return _radioItem(
                  id: hd["mahoatdong"].toString(),
                  title: hd["tenhoatdong"] ?? "Hoạt động",
                  time: hd["thoigianbatdau"] ?? "",
                  location: hd["diadiem"] ?? "",
                  drl: hd["drl"]?.toString() ?? "0",
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            _title("Thông tin sinh viên"),
            const SizedBox(height: 16),

            // ✅ HỌ TÊN - KHÔNG CHO SỬA
            LabeledInput(
              label: "Họ và tên *",
              hint: "Nguyễn Văn A",
              controller: _nameCtrl,
              enabled: false,
            ),
            const SizedBox(height: 16),

            // ✅ MSSV - KHÔNG CHO SỬA
            LabeledInput(
              label: "Mã số sinh viên *",
              hint: "2024001234",
              controller: _mssvCtrl,
              enabled: false,
            ),

            const SizedBox(height: 16),
            
            // ✅ EMAIL - CHO SỬA
            LabeledInput(
              label: "Email sinh viên *",
              hint: "student@example.com",
              controller: _emailCtrl,
            ),
            const SizedBox(height: 16),

            // ✅ SĐT - CHO SỬA
            LabeledInput(
              label: "Số điện thoại *",
              hint: "0912345678",
              controller: _phoneCtrl,
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.calendar,
                        size: 13,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 5),
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
                      const SizedBox(width: 5),
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
                      const SizedBox(width: 5),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            "✓ Vui lòng có mặt đúng giờ để điểm danh.",
            style: TextStyle(fontSize: 14),
          ),
          Text(
            "✓ Không thể đăng ký sau khi hoạt động đã bắt đầu.",
            style: TextStyle(fontSize: 14),
          ),
          Text(
            "✓ Đảm bảo thông tin chính xác để nhận thông báo.",
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
        onPressed: _submitCheer,
        borderRadius: 12,
      ),
    );
  }
}