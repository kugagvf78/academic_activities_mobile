import 'package:dio/dio.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  late Dio _dio;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8000/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Accept": "application/json"
        }
      ),
    );
  }

  Dio get dio => _dio;

  void setToken(String token) {
    print("Đã gắn token: $token");
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<Response> get(String endpoint) async {
    return _dio.get(endpoint);
  }

  Future<Response> post(String endpoint, dynamic data) async {
    return _dio.post(endpoint, data: data);
  }
}
