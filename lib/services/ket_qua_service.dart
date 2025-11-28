import 'api_service.dart';
import '../../models/KetQuaThi.dart';

class KetQuaService {
  final ApiService _api = ApiService();

  Future<List<KetQuaThi>> getAll() async {
    final response = await _api.get('/ketqua');
    dynamic rawData;
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      rawData = response['data'];
    } else if (response is List) {
      rawData = response;
    } else {
      return [];
    }

    return List<KetQuaThi>.from(
      (rawData as List).map((json) => KetQuaThi.fromJson(json)),
    );
  }
}
