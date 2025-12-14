import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiemRenLuyen {
  final List<DiemRLDetail> details;
  final int total;
  final int base;
  final int bonus;
  final int finalScore;

  DiemRenLuyen({
    required this.details,
    required this.total,
    required this.base,
    required this.bonus,
    required this.finalScore,
  });

  factory DiemRenLuyen.fromJson(Map<String, dynamic> json) {
    return DiemRenLuyen(
      details: (json['details'] as List? ?? [])
          .map((e) => DiemRLDetail.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
      base: json['base'] ?? 0,
      bonus: json['bonus'] ?? 0,
      finalScore: json['final'] ?? 0,
    );
  }
}

// ================================
//   CHI TIẾT ĐIỂM RÈN LUYỆN
// ================================
class DiemRLDetail {
  final String loai;
  final String title;
  final double diem;
  final String ngay;
  final String mota;

  final Map<String, dynamic>? chiTiet;

  // format ngày dd/mm/yyyy
  String get dateFormatted {
    if (ngay.isEmpty) return "";
    try {
      final dt = DateTime.parse(ngay);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (_) {
      return ngay;
    }
  }

  DiemRLDetail({
    required this.loai,
    required this.title,
    required this.diem,
    required this.ngay,
    required this.mota,
    this.chiTiet,
  });

  factory DiemRLDetail.fromJson(Map<String, dynamic> json) {
    return DiemRLDetail(
      loai: json['loai'] ?? "",
      title: json['title'] ?? "",
      diem: double.tryParse(json['diem'].toString()) ?? 0,
      ngay: json['ngay'] ?? "",
      mota: json['mota'] ?? "",

      chiTiet: json['chi_tiet'],
    );
  }


}
