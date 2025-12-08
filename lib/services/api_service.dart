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
        baseUrl: 'http://192.168.1.20:8080/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",  // Thêm Content-Type
        }
      )
    );

    // Thêm interceptor để log request/response
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🔵 REQUEST[${options.method}] => ${options.path}');
          print('Headers: ${options.headers}');
          print('Data: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('🟢 RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
          print('Data: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('🔴 ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}');
          print('Message: ${error.message}');
          print('Response: ${error.response?.data}');
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  void setToken(String token) {
    print("✅ Đã gắn token: $token");
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    print("🗑️ Đã xóa token");
    _dio.options.headers.remove('Authorization');
  }

  Future<Response> get(String endpoint) async {
    return _dio.get(endpoint);
  }

  Future<Response> post(String endpoint, dynamic data) async {
    return _dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, dynamic data) async {
    return _dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint) async {
    return _dio.delete(endpoint);
  }
}