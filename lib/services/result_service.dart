import 'package:academic_activities_mobile/services/api_service.dart';
import 'package:dio/dio.dart';

class ResultService {
  final ApiService api = ApiService();

  /// Lấy danh sách kết quả cuộc thi (có phân trang)
  Future<Map<String, dynamic>> getResults({
    int page = 1,
    String? search,
    String? year,
    String? type,
  }) async {
    try {
      String endpoint = "/results?page=$page";

      if (search != null && search.isNotEmpty) {
        endpoint += "&search=$search";
      }
      if (year != null && year.isNotEmpty) {
        endpoint += "&year=$year";
      }
      if (type != null && type.isNotEmpty) {
        endpoint += "&type=$type";
      }

      Response response = await api.get(endpoint);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "results": response.data["results"],
          "years": response.data["years"]
        };
      }

      return {"success": false, "message": "Lỗi không xác định."};
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  /// Lấy chi tiết kết quả cuộc thi
  Future<Map<String, dynamic>> getResultDetail(String id) async {
    try {
      Response response = await api.get("/results/$id");

      if (response.statusCode == 200) {
        return {
          "success": true,
          "result": response.data["result"],
          "rounds": response.data["rounds"],
          "top3": response.data["top3"],
          "allAwards": response.data["all_awards"]
        };
      }

      return {"success": false, "message": "Không lấy được dữ liệu"};
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
