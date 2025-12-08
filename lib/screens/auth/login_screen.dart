import 'dart:convert';
import 'package:academic_activities_mobile/cores/widgets/error_toast.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:academic_activities_mobile/cores/widgets/input.dart';
import 'package:academic_activities_mobile/cores/widgets/password_input.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:academic_activities_mobile/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool remember = false;
  bool isLoading = false;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

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
                  const SizedBox(height: 28),
                  _buildForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Image.asset("assets/images/logo.jpg"),
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
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        LabeledInput(
          label: "Mã sinh viên",
          hint: "Nhập mã sinh viên (VD: 2024000001)",
          icon: Icons.badge_outlined,
          controller: username,
          enabled: !isLoading, // ← THÊM LẠI
        ),

        const SizedBox(height: 16),

        PasswordInput(
          label: "Mật khẩu",
          hint: "Nhập mật khẩu",
          onChanged: (value) {},
          controller: password,
          enabled: !isLoading, // ← THÊM LẠI
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: remember,
                  onChanged: isLoading ? null : (v) => setState(() => remember = v ?? false),
                  activeColor: Colors.blue,
                ),
                const Text("Ghi nhớ đăng nhập", style: TextStyle(fontSize: 13)),
              ],
            ),
            TextButton(
              onPressed: isLoading ? null : () {},
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

        _loginButton(),

        const SizedBox(height: 14),
      ],
    );
  }

  Widget _loginButton() {
    return GestureDetector(
      onTap: isLoading ? null : _handleLogin,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: isLoading 
              ? [Colors.grey.shade400, Colors.grey.shade500]
              : [const Color(0xFF2563EB), const Color(0xFF06B6D4)],
          ),
          boxShadow: [
            BoxShadow(
              color: (isLoading ? Colors.grey : Colors.blue).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
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

  Future<void> _handleLogin() async {
    // Validate
    if (username.text.trim().isEmpty || password.text.trim().isEmpty) {
      _showError("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    setState(() => isLoading = true);

    try {
      final auth = AuthService();
      final authData = await auth.login(
        username.text.trim(), 
        password.text.trim()
      );

      // Lưu token nếu remember me
      if (remember) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("access_token", authData.accessToken);
        await prefs.setBool("remember_me", true);
      }

      if (mounted) {
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xin chào, ${authData.user.hoten ?? authData.user.tendangnhap}!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Chuyển màn hình
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Navigation()),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);

      String message = "Có lỗi xảy ra, vui lòng thử lại!";

      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          message = "Sai mã sinh viên hoặc mật khẩu";
        } else if (e.response?.statusCode == 403) {
          message = "Tài khoản của bạn đã bị khóa";
        } else {
          dynamic raw = e.response?.data;

          if (raw is Map) {
            if (raw.containsKey("message")) {
              message = raw["message"];
            } else if (raw.containsKey("error")) {
              message = raw["error"];
            }
          } else if (raw is String) {
            try {
              final parsed = jsonDecode(raw);
              if (parsed is Map && parsed.containsKey("error")) {
                message = parsed["error"];
              }
            } catch (_) {}
          }
        }
      } else {
        message = 'Không thể kết nối đến server';
      }

      if (mounted) {
        ErrorToast.show(context, message);
      }
    }
  }

  void _showError(String message) {
    HapticFeedback.mediumImpact();

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) overlayEntry.remove();
    });
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;

  const _ToastWidget({required this.message, required this.onDismiss});

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4)),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}