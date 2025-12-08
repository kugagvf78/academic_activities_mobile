import 'package:academic_activities_mobile/models/AuthResponse.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<AuthResponse> login(String username, String password) async {
    try {
      final Response res = await _api.post("/auth/login", {
        "TenDangNhap": username,  // ← Sửa lại theo Laravel API
        "MatKhau": password,       // ← Sửa lại theo Laravel API
      });

      print("=== LOGIN RAW ===");
      print(res.data);

      final auth = AuthResponse.fromJson(res.data);

      // Lưu token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", auth.accessToken);

      // Gắn token vào Dio
      ApiService().setToken(auth.accessToken);

      return auth;
    } catch (e) {
      print("Login error: $e");
      rethrow;
    }
  }

  /// Load token khi mở app (main.dart)
  static Future<void> initToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    if (token != null) {
      ApiService().setToken(token);
    }
  }

  /// Logout - xóa token
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access_token");
    ApiService().clearToken();
  }
}