import 'package:academic_activities_mobile/models/AuthResponse.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<AuthResponse> login(String username, String password) async {
    try {
      final Response res = await _api.post("/auth/login", {
        "TenDangNhap": username, 
        "MatKhau": password,     
      });


      final auth = AuthResponse.fromJson(res.data);

      // Lưu token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", auth.accessToken);

      // Gắn token vào Dio
      ApiService().setToken(auth.accessToken);

      return auth;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final Response res = await _api.get("/auth/me");
      
      if (res.statusCode == 200 && res.data != null) {
        // Backend trả về: {user: {...}, detail: {...}}
        final userData = res.data['user'];
        
        return {
          'manguoidung': userData['manguoidung'],
          'tendangnhap': userData['tendangnhap'],
          'hoten': userData['hoten'],
          'email': userData['email'],
          'sodienthoai': userData['sodienthoai'],
          'vaitro': userData['vaitro'],
        };
      }
      
      return null;
    } catch (e) {
      print('❌ Error getting user info: $e');
      return null;
    }
  }

  // ✅ DECODE JWT TOKEN (FALLBACK NẾU API FAIL)
  Future<Map<String, dynamic>?> getUserInfoFromToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");
      
      if (token == null) return null;
      
      // JWT format: header.payload.signature
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      // Decode payload (part[1])
      final payload = parts[1];
      
      // Base64 decode
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      
      return json.decode(decoded);
    } catch (e) {
      print('❌ Error decoding token: $e');
      return null;
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