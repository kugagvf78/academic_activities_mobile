import 'nguoidung.dart';

class AuthResponse {
  final String accessToken;
  final NguoiDung user;

  AuthResponse({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json["access_token"]?.toString() ?? "",
      user: NguoiDung.fromJson(json["user"]),
    );
  }
}
