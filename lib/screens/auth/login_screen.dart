import 'package:academic_activities_mobile/cores/widgets/input.dart';
import 'package:academic_activities_mobile/cores/widgets/password_input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String role = "SinhVien";
  bool remember = false;
  bool showPassword = false;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEFF6FF), Colors.white, Color(0xFFE0F7FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildRoleTabs(),
                  const SizedBox(height: 18),
                  _buildForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔷 Header Icon + Title
  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Image.asset("assets/images/logo.jpg", width: 30, height: 30),
        ),
        const SizedBox(height: 12),
        const Text(
          "Đăng Nhập Hệ Thống",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Quản lý cuộc thi học thuật khoa Công nghệ Thông tin trường Đại Học Công Thương TP.HCM",
          style: TextStyle(color: Colors.grey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // 🔷 Tabs Vai trò
  Widget _buildRoleTabs() {
    return Row(
      children: [
        Expanded(child: _roleTab("SinhVien", FontAwesomeIcons.userGraduate)),
        const SizedBox(width: 12),
        Expanded(child: _roleTab("GiangVien", FontAwesomeIcons.chalkboardUser)),
      ],
    );
  }

  Widget _roleTab(String value, IconData icon) {
    final bool active = role == value;

    return GestureDetector(
      onTap: () => setState(() => role = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
          color: active ? Colors.blue.shade50 : Colors.white,
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 16, color: active ? Colors.blue : Colors.grey),
            const SizedBox(width: 8),
            Text(
              value == "SinhVien" ? "Sinh viên" : "Giảng viên",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: active ? Colors.blue.shade700 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔷 Form inputs
  Widget _buildForm() {
    return Column(
      children: [
        // Username
        LabeledInput(
          label: "Tên đăng nhập",
          hint: "Nhập MSSV",
          icon: Icons.person,
        ),

        const SizedBox(height: 16),

        PasswordInput(
          label: "Mật khẩu",
          hint: "Nhập mật khẩu",
          onChanged: (value) {
            print(value);
          },
        ),

        const SizedBox(height: 12),

        // Remember + Forgot
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: remember,
                  onChanged: (v) => setState(() => remember = v ?? false),
                  activeColor: Colors.blue,
                ),
                const Text("Ghi nhớ đăng nhập", style: TextStyle(fontSize: 13)),
              ],
            ),

            TextButton(
              onPressed: () {},
              child: const Text(
                "Quên mật khẩu?",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 🔵 Login Button
        _loginButton(),

        const SizedBox(height: 14),
      ],
    );
  }

  Widget _loginButton() {
    return GestureDetector(
      onTap: () {
        debugPrint("Login with: ${username.text} / ${password.text}");
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Đăng nhập",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
