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
}
