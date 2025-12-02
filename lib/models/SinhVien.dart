import 'package:academic_activities_mobile/models/Lop.dart';

class SinhVien {
  final String masinhvien;
  final String manguoidung;
  final String? malop;
  final int? namnhaphoc;
  final double? diemrenluyen;
  final String trangthai;
  final Lop? lop;

  SinhVien({
    required this.masinhvien,
    required this.manguoidung,
    this.malop,
    this.namnhaphoc,
    this.diemrenluyen,
    required this.trangthai,
    this.lop,
  });

  factory SinhVien.fromJson(Map<String, dynamic> json) {
    return SinhVien(
      masinhvien: json["masinhvien"] ?? "",
      manguoidung: json["manguoidung"] ?? "",
      malop: json["malop"],
      namnhaphoc: json["namnhaphoc"] == null
          ? null
          : int.tryParse(json["namnhaphoc"].toString()),
      diemrenluyen: json["diemrenluyen"] == null
          ? null
          : double.tryParse(json["diemrenluyen"].toString()),
      trangthai: json["trangthai"] ?? "",
      lop: json["lop"] != null ? Lop.fromJson(json["lop"]) : null,
    );
  }
}
