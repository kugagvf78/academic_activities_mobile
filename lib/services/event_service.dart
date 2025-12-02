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

  Future<Map<String, dynamic>> registerSupport({
    required String macuocthi,
    required String loaiHoTro, 
    required int hoatDongId,  
  }) async {
    try {
      final Response res = await _api.dio.post(
        "/events/support",
        data: {
          "macuocthi": macuocthi,
          "loaihotro": loaiHoTro,
          "mahoatdong": hoatDongId,
        },
      );

      return res.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Lỗi đăng ký hỗ trợ");
    }
  }

  Future<Map<String, dynamic>> registerCheer({
    required String macuocthi,
    required int hoatDongId, 
  }) async {
    try {
      final Response res = await _api.dio.post(
        "/events/cheer",
        data: {
          "macuocthi": macuocthi,
          "mahoatdong": hoatDongId,
        },
      );

      return res.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Lỗi đăng ký cổ vũ");
    }
  }
}
