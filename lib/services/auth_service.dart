import 'package:academic_activities_mobile/models/AuthResponse.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<AuthResponse> login(String username, String password) async {
    final Response res = await _api.post("/auth/login", {
      "TenDangNhap": username,
      "MatKhau": password,
    });

    print("=== LOGIN RAW ===");
    print(res.data);

    final data = res.data;

    final auth = AuthResponse.fromJson(data);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("access_token", auth.accessToken);

    // phải dùng SINGLETON
    ApiService().setToken(auth.accessToken);

    return auth;
  }

  /// Load token khi khởi động app
  static Future<void> initToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    if (token != null) {
      ApiService().setToken(token);
    }
  }
}
