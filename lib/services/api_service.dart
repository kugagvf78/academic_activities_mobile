import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          'http://10.0.2.2:8000/api', // dùng 10.0.2.2 nếu chạy Android emulator
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<dynamic> get(String endpoint) async {
    final response = await _dio.get(endpoint);
    return response.data;
  }

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    return _dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, Map<String, dynamic> data) async {
    return _dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint) async {
    return _dio.delete(endpoint);
  }
}
