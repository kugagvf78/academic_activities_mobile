import 'package:academic_activities_mobile/models/CuocThi.dart';
import 'api_service.dart';

class CuocThiService {
  final ApiService _api = ApiService();

  Future<List<CuocThi>> getAll() async {
    final response = await _api.get('/cuocthi');

    if (response is Map<String, dynamic> && response['data'] != null) {
      final rawData = response['data'] as List;
      return rawData.map((json) => CuocThi.fromJson(json)).toList();
    } else if (response is List) {
      return response.map((json) => CuocThi.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
