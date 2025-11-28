import 'package:academic_activities_mobile/models/CuocThi.dart';
import 'api_service.dart';

class CuocThiService {
  final ApiService _api = ApiService();

  Future<List<CuocThi>> getAll() async {
    final response = await _api.get('/cuocthi');

    dynamic rawData;

    // Nếu Laravel trả về dạng Map có key "data"
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      rawData = response['data'];
    }
    // Nếu Laravel trả về trực tiếp mảng JSON
    else if (response is List) {
      rawData = response;
    }
    // Nếu không phải List hoặc Map => không hợp lệ
    else {
      return [];
    }

    // Chuyển sang danh sách CuocThi
    return List<CuocThi>.from(
      (rawData as List).map((json) => CuocThi.fromJson(json)),
    );
  }
}
