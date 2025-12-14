import 'nguoidung.dart';
import 'sinhvien.dart';
import 'giangvien.dart';

class AuthMeResponse {
  final NguoiDung user;
  final dynamic detail;

  AuthMeResponse({
    required this.user,
    this.detail,
  });

  factory AuthMeResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    final userData = data["user"];
    final detailData = data["detail"];

    return AuthMeResponse(
      user: NguoiDung.fromJson(userData),
      detail: userData["vaitro"] == "SinhVien"
          ? SinhVien.fromJson(detailData)
          : GiangVien.fromJson(detailData),
    );
  }
}
