import 'package:academic_activities_mobile/services/api_service.dart';
import 'package:dio/dio.dart';
import '../models/TinTuc.dart';

class NewsService {
  final ApiService api = ApiService();

  /// ============================
  /// GET - Danh sách tin tức
  /// ============================
  Future<Map<String, dynamic>> getNews({
    int page = 1,
    String? search,
    String? category,
    String? sort,
  }) async {
    try {
      String endpoint = "/news?page=$page";

      if (search != null && search.isNotEmpty) {
        endpoint += "&search=$search";
      }
      if (category != null && category.isNotEmpty) {
        endpoint += "&category=$category"; // contest, seminar, announcement
      }
      if (sort != null && sort.isNotEmpty) {
        endpoint += "&sort=$sort"; // newest, oldest, popular
      }

      Response res = await api.get(endpoint);

      if (res.statusCode == 200 && res.data["success"]) {
        final rawList = res.data["news"]["data"] as List;

        // Parse list thành TinTuc model
        final List<TinTuc> list = rawList.map((item) {
          return TinTuc.fromJson(item);
        }).toList();

        return {
          "success": true,
          "news": list,
          "pagination": res.data["news"],
          "featured": res.data["featured"],
          "stats": res.data["stats"],
        };
      }

      return {"success": false, "message": "Lỗi không xác định"};
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  /// ============================
  /// GET - Chi tiết tin tức
  /// ============================
  Future<Map<String, dynamic>> getNewsDetail(String slug) async {
    try {
      Response res = await api.get("/news/$slug");

      if (res.statusCode == 200 && res.data["success"]) {
        final TinTuc tin = TinTuc.fromJson(res.data["news"]);
        final List related = res.data["related"];

        return {
          "success": true,
          "news": tin,
          "related": related,
        };
      }

      return {
        "success": false,
        "message": "Không lấy được chi tiết tin tức"
      };
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
