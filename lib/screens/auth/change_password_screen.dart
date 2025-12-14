import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:academic_activities_mobile/cores/widgets/error_toast.dart';
import 'package:academic_activities_mobile/cores/widgets/success_toast.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _useOtpMethod = false;

  final String baseUrl = 'http://10.0.2.2:8000'; // Đổi thành URL API của bạn

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _sendOtp() async {
    setState(() => _isLoading = true);

    try {
      final token = await _getToken();
      if (token == null) {
        if (mounted) ErrorToast.show(context, 'Vui lòng đăng nhập lại');
        return;
      }

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        '$baseUrl/api/auth/send-otp-change-password',
      );

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VerifyOtpChangePasswordScreen(),
            ),
          );
        }
      }
    } on DioException catch (e) {
      String message = 'Không thể gửi OTP';
      if (e.response?.data != null) {
        if (e.response!.data is Map && e.response!.data.containsKey('error')) {
          message = e.response!.data['error'];
        }
      }
      if (mounted) ErrorToast.show(context, message);
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Lỗi kết nối: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final token = await _getToken();
      if (token == null) {
        if (mounted) ErrorToast.show(context, 'Vui lòng đăng nhập lại');
        return;
      }

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        '$baseUrl/api/auth/change-password',
        data: {
          'MatKhauCu': _currentPasswordController.text,
          'MatKhauMoi': _newPasswordController.text,
          'MatKhauMoi_confirmation': _confirmPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          SuccessToast.show(context, 'Đổi mật khẩu thành công!');
          Navigator.pop(context);
        }
      }
    } on DioException catch (e) {
      String message = 'Đổi mật khẩu thất bại';
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          if (data.containsKey('errors') && data['errors'] is Map) {
            final errors = data['errors'] as Map;
            message = errors.values.first[0];
          } else if (data.containsKey('error')) {
            message = data['error'];
          }
        }
      }
      if (mounted) ErrorToast.show(context, message);
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Lỗi kết nối: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Method Selection Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chọn phương thức đổi mật khẩu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMethodOption(
                      title: 'Sử dụng mật khẩu hiện tại',
                      subtitle: 'Nhập mật khẩu cũ để đổi sang mật khẩu mới',
                      icon: FontAwesomeIcons.key,
                      isSelected: !_useOtpMethod,
                      onTap: () => setState(() => _useOtpMethod = false),
                    ),
                    const SizedBox(height: 12),
                    _buildMethodOption(
                      title: 'Sử dụng mã OTP',
                      subtitle: 'Gửi mã xác thực qua email',
                      icon: FontAwesomeIcons.shield,
                      isSelected: _useOtpMethod,
                      onTap: () => setState(() => _useOtpMethod = true),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Password Form
              if (!_useOtpMethod) ...[
                _buildPasswordField(
                  controller: _currentPasswordController,
                  label: 'Mật khẩu hiện tại',
                  icon: FontAwesomeIcons.lock,
                  obscureText: _obscureCurrentPassword,
                  onToggleVisibility: () {
                    setState(() => _obscureCurrentPassword = !_obscureCurrentPassword);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu hiện tại';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              if (!_useOtpMethod) ...[
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: 'Mật khẩu mới',
                  icon: FontAwesomeIcons.lockOpen,
                  obscureText: _obscureNewPassword,
                  onToggleVisibility: () {
                    setState(() => _obscureNewPassword = !_obscureNewPassword);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu mới';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Xác nhận mật khẩu mới',
                  icon: FontAwesomeIcons.circleCheck,
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng xác nhận mật khẩu mới';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Mật khẩu xác nhận không khớp';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : (_useOtpMethod ? _sendOtp : _changePassword),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _useOtpMethod ? 'Gửi mã OTP' : 'Đổi mật khẩu',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FaIcon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.blue : const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                color: Colors.blue,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: FaIcon(icon, size: 18, color: Colors.grey.shade600),
          ),
          suffixIcon: IconButton(
            icon: FaIcon(
              obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
              size: 18,
              color: Colors.grey.shade600,
            ),
            onPressed: onToggleVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

// OTP Verification Screen
class VerifyOtpChangePasswordScreen extends StatefulWidget {
  const VerifyOtpChangePasswordScreen({super.key});

  @override
  State<VerifyOtpChangePasswordScreen> createState() => _VerifyOtpChangePasswordScreenState();
}

class _VerifyOtpChangePasswordScreenState extends State<VerifyOtpChangePasswordScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  
  final String baseUrl = 'http://10.0.2.2:8000'; // Đổi thành URL API của bạn

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();
    
    if (otp.length != 6) {
      if (mounted) ErrorToast.show(context, 'Vui lòng nhập đầy đủ mã OTP');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await _getToken();
      if (token == null) {
        if (mounted) ErrorToast.show(context, 'Vui lòng đăng nhập lại');
        return;
      }

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        '$baseUrl/api/auth/verify-otp',
        data: {'otp': otp},
      );

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ResetPasswordScreen(),
            ),
          );
        }
      }
    } on DioException catch (e) {
      String message = 'Mã OTP không hợp lệ';
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('error')) {
          message = data['error'];
        } else if (data is Map && data.containsKey('errors')) {
          final errors = data['errors'];
          if (errors is Map && errors.containsKey('otp')) {
            message = errors['otp'][0];
          }
        }
      }
      if (mounted) ErrorToast.show(context, message);
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Lỗi kết nối: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    try {
      final token = await _getToken();
      if (token == null) return;

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.post('$baseUrl/api/auth/resend-otp');

      if (response.statusCode == 200 && mounted) {
        SuccessToast.show(context, 'Đã gửi lại mã OTP');
      }
    } on DioException catch (e) {
      if (mounted) ErrorToast.show(context, 'Không thể gửi lại OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Xác thực OTP'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const FaIcon(
                FontAwesomeIcons.envelope,
                size: 50,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Nhập mã OTP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vui lòng kiểm tra email của bạn',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: _resendOtp,
              child: const Text('Gửi lại mã OTP'),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Xác nhận', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reset Password Screen
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final String baseUrl = 'http://10.0.2.2:8000'; // Đổi thành URL API của bạn

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final token = await _getToken();
      if (token == null) {
        if (mounted) ErrorToast.show(context, 'Vui lòng đăng nhập lại');
        return;
      }

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(
        '$baseUrl/api/auth/reset-password-otp',
        data: {
          'MatKhau': _newPasswordController.text,
          'MatKhau_confirmation': _confirmPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          SuccessToast.show(context, 'Đổi mật khẩu thành công!');
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } on DioException catch (e) {
      String message = 'Đổi mật khẩu thất bại';
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('error')) {
          message = data['error'];
        }
      }
      if (mounted) ErrorToast.show(context, message);
    } catch (e) {
      if (mounted) ErrorToast.show(context, 'Lỗi kết nối: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Đặt lại mật khẩu'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 32),
              _buildPasswordField(
                controller: _newPasswordController,
                label: 'Mật khẩu mới',
                obscureText: _obscureNewPassword,
                onToggleVisibility: () {
                  setState(() => _obscureNewPassword = !_obscureNewPassword);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Xác nhận mật khẩu mới',
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () {
                  setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu mới';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Mật khẩu xác nhận không khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Đặt lại mật khẩu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Padding(
            padding: EdgeInsets.all(12),
            child: FaIcon(FontAwesomeIcons.lock, size: 18),
          ),
          suffixIcon: IconButton(
            icon: FaIcon(
              obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
              size: 18,
            ),
            onPressed: onToggleVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}