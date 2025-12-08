import 'dart:io';
import 'package:academic_activities_mobile/models/DangKyHoatDongFull.dart';
import 'package:academic_activities_mobile/models/DatGiaiApi.dart';
import 'package:academic_activities_mobile/models/HoatDongNgan.dart';
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

      // Parse từng phần và bắt lỗi riêng
      try {
        print("=== PARSING USER ===");
        final user = NguoiDung.fromJson(data["user"]);
        print("✅ User parsed OK");

        print("=== PARSING PROFILE ===");
        final profile = data["profile"] != null
            ? SinhVien.fromJson(data["profile"])
            : null;
        print("✅ Profile parsed OK");

        print("=== PARSING LOP ===");
        final lop = data["profile"]?["lop"] != null
            ? Lop.fromJson(data["profile"]["lop"])
            : null;
        print("✅ Lop parsed OK");

        print("=== PARSING CERTIFICATES ===");
        final certificates = <DatGiaiApi>[];
        final rawCerts = data["certificates"] ?? [];
        
        for (var item in rawCerts) {
          try {
            certificates.add(DatGiaiApi.fromJson(item));
          } catch (e) {
            print("⚠️ Skip certificate: $e");
          }
        }
        print("✅ Certificates parsed OK: ${certificates.length} items");

        print("=== PARSING REGISTRATIONS ===");
        final registrations = _parseRegistrations(data["registrations"] ?? []);
        print("✅ Registrations parsed OK: ${registrations.length} items");

        print("=== PARSING COMPETITION REGISTRATIONS ===");
        final competitionRegistrations = _parseCompetition(
          data["competitionRegistrations"] ?? [],
        );
        print("✅ Competition registrations parsed OK: ${competitionRegistrations.length} items");

        print("=== PARSING DIEM REN LUYEN ===");
        final diemRenLuyen = data["diemRenLuyen"] != null
            ? DiemRenLuyen.fromJson(data["diemRenLuyen"])
            : null;
        print("✅ Diem ren luyen parsed OK");

        return {
          "success": true,
          "data": {
            "user": user,
            "profile": profile,
            "lop": lop,
            "activities": data["activities"] ?? [],
            "certificates": certificates,
            "registrations": registrations,
            "competitionRegistrations": competitionRegistrations,
            "diemRenLuyen": diemRenLuyen,
          },
        };
        
      } catch (parseError) {
        print("❌ PARSE ERROR: $parseError");
        return {"success": false, "message": "Lỗi parse data: $parseError"};
      }

    } catch (e) {
      print("❌ PROFILE ERROR: $e");
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
}