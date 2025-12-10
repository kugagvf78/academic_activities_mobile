import 'dart:io';
import 'package:academic_activities_mobile/models/DangKyHoatDongFull.dart';
import 'package:academic_activities_mobile/models/DatGiaiApi.dart';
import 'package:academic_activities_mobile/models/HoatDongHocThuat.dart';
import 'package:dio/dio.dart';

import '../models/NguoiDung.dart';
import '../models/SinhVien.dart';
import '../models/Lop.dart';
import '../models/DangKyCaNhan.dart';
import '../models/DangKyDoiThi.dart';
import '../models/DangKyHoatDong.dart';
import '../models/DiemRenLuyen.dart';
import 'api_service.dart';

class ProfileService {
  final ApiService _api = ApiService();

  /// ============================
  /// GET PROFILE - SỬ DỤNG API /profile
  /// ============================
  Future<Map<String, dynamic>> getProfile() async {
    try {
      print("=== CALLING /profile ===");
      final res = await _api.get("/profile");
      print("Token hiện tại: ${_api.dio.options.headers['Authorization']}");

      print("=== RAW RESPONSE ===");
      print("Status Code: ${res.statusCode}");
      print("Full Response: ${res.data}");

      if (res.statusCode != 200) {
        return {
          "success": false,
          "message": res.data?["message"] ?? "Lỗi server",
        };
      }

      final data = res.data["data"];
      if (data == null) {
        return {"success": false, "message": "Data null từ server"};
      }

      final activities = (data["activities"] ?? [])
          .map<HoatDongHocThuat>((e) => HoatDongHocThuat.fromJson(e))
          .toList();

      // Parse từng phần và bắt lỗi riêng
      try {
        final user = NguoiDung.fromJson(data["user"]);

        final profile = data["profile"] != null
            ? SinhVien.fromJson(data["profile"])
            : null;

        final lop = data["profile"]?["lop"] != null
            ? Lop.fromJson(data["profile"]["lop"])
            : null;

        final certificates = <DatGiaiApi>[];
        final rawCerts = data["certificates"] ?? [];

        for (var item in rawCerts) {
          try {
            certificates.add(DatGiaiApi.fromJson(item));
          } catch (e) {
            print("⚠️ Skip certificate: $e");
          }
        }

        final registrations = _parseRegistrations(data["registrations"] ?? []);

        final competitionRegistrations = _parseCompetition(
          data["competitionRegistrations"] ?? [],
        );

        final diemRenLuyen = data["diemRenLuyen"] != null
            ? DiemRenLuyen.fromJson(data["diemRenLuyen"])
            : null;

        return {
          "success": true,
          "data": {
            "user": user,
            "profile": profile,
            "lop": lop,
            "activities": activities,
            "certificates": certificates,
            "registrations": registrations,
            "competitionRegistrations": competitionRegistrations,
            "diemRenLuyen": diemRenLuyen,
          },
        };
      } catch (parseError) {
        return {"success": false, "message": "Lỗi parse data: $parseError"};
      }
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  /// ============================
  /// PARSE HOẠT ĐỘNG
  /// ============================
  List<DangKyHoatDong> _parseActivities(List raw) {
    return raw.map((e) => DangKyHoatDong.fromJson(e)).toList();
  }

  List<DangKyHoatDongFull> _parseRegistrations(List raw) {
    final results = <DangKyHoatDongFull>[];
    for (var item in raw) {
      try {
        results.add(DangKyHoatDongFull.fromJson(item));
      } catch (e) {
        print("⚠️ Skip registration: $e");
      }
    }
    return results;
  }

  /// ============================
  /// PARSE ĐĂNG KÝ CUỘC THI - AN TOÀN
  /// ============================
  List<dynamic> _parseCompetition(List raw) {
    List<dynamic> results = [];

    for (final item in raw) {
      try {
        final loaiDangKy = item["loaidangky"]?.toString();

        if (loaiDangKy == "CaNhan") {
          results.add(DangKyCaNhan.fromJson(item));
        } else if (loaiDangKy == "DoiNhom") {
          results.add(DangKyDoiThi.fromJson(item));
        } else {
          print("⚠️ Unknown loaidangky: $loaiDangKy");
        }
      } catch (e) {
        print("⚠️ Skip competition item: $e");
        print("   Item: $item");
      }
    }

    return results;
  }

  /// ============================
  /// UPDATE AVATAR - SỬ DỤNG API /profile/avatar
  /// ============================
  Future<String?> updateAvatar(File file) async {
    try {
      final formData = FormData.fromMap({
        "avatar": await MultipartFile.fromFile(
          file.path,
        ), // ✅ Đổi từ "anhdaidien" thành "avatar"
      });

      final res = await _api.dio.post(
        "/profile/avatar",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      if (res.data["success"] == true) {
        return res.data["avatar_url"];
      }
      return null;
    } catch (e) {
      print("Lỗi upload avatar: $e");
      return null;
    }
  }

  /// ============================
  /// UPDATE INFO - SỬ DỤNG API /profile/info
  /// ============================
  Future<Map<String, dynamic>> updateInfo(Map<String, dynamic> data) async {
    try {
      final res = await _api.put("/profile/info", data);
      return res.data;
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  /// ============================
  /// CANCEL HOẠT ĐỘNG
  /// ============================
  Future<Map<String, dynamic>> cancelHoatDong(String id) async {
    try {
      final res = await _api.delete("/profile/activities/$id");
      return res.data;
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  /// ============================
  /// CANCEL CUỘC THI
  /// ============================
  Future<Map<String, dynamic>> cancelCompetition(String id) async {
    try {
      final res = await _api.delete("/profile/competitions/$id");
      return res.data;
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getSubmitExamForm({
    required String id,
    required String loaiDangKy,
  }) async {
    try {
      final res = await _api.get("/profile/submit-exam/$id/$loaiDangKy");

      return {
        "success": res.data["success"] == true,
        "data": res.data["data"],
        "message": res.data["message"],
      };
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> submitExam({
    required String id,
    required String loaiDangKy,
    required File file,
  }) async {
    try {
      final formData = FormData.fromMap({
        "filebaithi": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final res = await _api.dio.post(
        "/profile/submit-exam/$id/$loaiDangKy",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      return {
        "success": res.data["success"] == true,
        "message": res.data["message"],
        "file": res.data["file"],
      };
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
