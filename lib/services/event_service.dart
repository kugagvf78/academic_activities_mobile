import 'package:dio/dio.dart';
import '../models/CuocThi.dart';
import 'api_service.dart';

class EventService {
  final ApiService _api = ApiService();

  /// ==============================
  /// 🔥 LẤY DANH SÁCH CUỘC THI
  /// ==============================
  Future<List<CuocThi>> getEvents() async {
    try {
      final Response res = await _api.dio.get("/events");

      if (res.data["success"] == true) {
        final List list = res.data["data"];

        // Convert JSON → CuocThi model
        return list.map((e) => CuocThi.fromJson(e)).toList();
      }

      throw Exception(res.data["message"] ?? "Không thể lấy dữ liệu");
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Lỗi server");
    }
  }

  /// ==============================
  /// 🔥 LẤY CHI TIẾT CUỘC THI
  /// ==============================
  Future<Map<String, dynamic>> getEventDetail(String id) async {
    try {
      final Response res = await _api.dio.get("/events/$id");
      if (res.data["success"] == true) {
        return res.data["data"] as Map<String, dynamic>;
      }

      throw Exception(res.data["message"] ?? "Không thể lấy chi tiết");
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Lỗi server");
    }
  }

  Future<Map<String, dynamic>> registerCompetition({
    required String macuocthi,
    required String loaiDangKy,
    String? madoithi,
  }) async {
    try {
      final Response res = await _api.dio.post(
        "/events/register",
        data: {
          "macuocthi": macuocthi,
          "loaidangky": loaiDangKy,
          "madoithi": madoithi,
        },
      );

      return res.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Lỗi đăng ký dự thi");
    }
  }

  /// ==============================
  /// 🔥 ĐĂNG KÝ HỖ TRỢ
  /// ==============================
  Future<Map<String, dynamic>> registerSupport({
    required String macuocthi,
    required String mahoatdong,
    required String masinhvien,
  }) async {
    try {
      final Response res = await _api.dio.post(
        "/events/support",
        data: {
          "macuocthi": macuocthi,
          "mahoatdong": mahoatdong,
          "masinhvien": masinhvien,
        },
      );

      return res.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Lỗi đăng ký hỗ trợ");
    }
  }

  /// ==============================
  /// 🔥 ĐĂNG KÝ CỔ VŨ (API thật)
  /// ==============================
  Future registerCheer({
    required String mahoatdong,
    required String masinhvien,
  }) async {
    try {
      final Response res = await _api.dio.post(
        "/events/cheer",
        data: {
          "mahoatdong": mahoatdong, // gửi string
          "masinhvien": masinhvien,
        },
      );
      return res.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Lỗi đăng ký cổ vũ");
    }
  }

  Future<Map<String, dynamic>> submitRegistration({
    required String slug,
    required Map<String, dynamic> data,
  }) async {
    try {
      final Response res = await _api.dio.post(
        "/events/$slug/register",
        data: data,
      );

      return res.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Lỗi đăng ký dự thi");
    }
  }
}
