import 'dart:io';
import 'package:academic_activities_mobile/models/DangKyHoatDongFull.dart';
import 'package:dio/dio.dart';

import '../models/NguoiDung.dart';
import '../models/SinhVien.dart';
import '../models/Lop.dart';
import '../models/DangKyCaNhan.dart';
import '../models/DangKyDoiThi.dart';
import '../models/DangKyHoatDong.dart';
import '../models/DatGiai.dart';
import '../models/DiemRenLuyen.dart';
import 'api_service.dart';

class ProfileService {
  final ApiService _api = ApiService();

  /// ============================
  /// GET PROFILE
  /// ============================
  Future<Map<String, dynamic>> getProfile() async {
    try {
      print("=== CALLING /profile ===");
      final res = await _api.get("/profile");
      print("Token hiện tại: ${_api.dio.options.headers['Authorization']}");

      print("=== RAW RESPONSE ===");
      print(res.data);

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

      return {
        "success": true,
        "data": {
          "user": NguoiDung.fromJson(data["user"]),
          "profile": data["profile"] != null
              ? SinhVien.fromJson(data["profile"])
              : null,

          "lop": data["profile"]?["lop"] != null
              ? Lop.fromJson(data["profile"]["lop"])
              : null,

          "activities": (data["activities"] ?? [])
              .map((e) => DangKyHoatDong.fromJson(e))
              .toList(),

          "certificates": (data["certificates"] ?? [])
              .map((e) => DatGiai.fromJson(e))
              .toList(),

          "registrations": _parseRegistrations(data["registrations"] ?? []),

          "competitionRegistrations": _parseCompetition(
            data["competitionRegistrations"] ?? [],
          ),

          "diemRenLuyen": data["diemRenLuyen"] != null
              ? DiemRenLuyen.fromJson(data["diemRenLuyen"])
              : null,
        },
      };
    } catch (e) {
      print("PROFILE ERROR: $e");
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
    return raw.map((e) => DangKyHoatDongFull.fromJson(e)).toList();
  }

  /// ============================
  /// PARSE ĐĂNG KÝ CUỘC THI
  /// ============================
  List<dynamic> _parseCompetition(List raw) {
    List<dynamic> results = [];

    for (final item in raw) {
      if (item["loaidangky"] == "CaNhan") {
        results.add(DangKyCaNhan.fromJson(item));
      } else {
        results.add(DangKyDoiThi.fromJson(item));
      }
    }

    return results;
  }

  /// ============================
  /// UPDATE AVATAR
  /// ============================
  Future<Map<String, dynamic>> updateAvatar(File file) async {
    try {
      final form = FormData.fromMap({
        "avatar": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final res = await _api.post("/profile/avatar", form);
      return res.data;
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  /// ============================
  /// UPDATE INFO
  /// ============================
  Future<Map<String, dynamic>> updateInfo(Map<String, dynamic> data) async {
    try {
      final res = await _api.dio.put("/profile/info", data: data);
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
      final res = await _api.dio.delete("/profile/activities/$id");
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
      final res = await _api.dio.delete("/profile/competitions/$id");
      return res.data;
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
