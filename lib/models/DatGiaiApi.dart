class DatGiaiApi {
  final String? maDatGiai;
  final String? maCuocThi;
  final String? tenCuocThi;
  final String? maDangKyCaNhan;
  final String? maDangKyDoi;
  final String? loaiDangKy;
  final String? tenGiai;
  final String? giaiThuong;
  final double? diemRenLuyen;
  final String? ngayTrao;
  final String? tenDoiThi; // Tên đội nếu là đăng ký đội

  DatGiaiApi({
    this.maDatGiai,
    this.maCuocThi,
    this.tenCuocThi,
    this.maDangKyCaNhan,
    this.maDangKyDoi,
    this.loaiDangKy,
    this.tenGiai,
    this.giaiThuong,
    this.diemRenLuyen,
    this.ngayTrao,
    this.tenDoiThi,
  });

  factory DatGiaiApi.fromJson(Map<String, dynamic> json) {
    return DatGiaiApi(
      maDatGiai: json['madatgiai'],
      maCuocThi: json['macuocthi'],
      tenCuocThi: json['tencuocthi'],
      maDangKyCaNhan: json['madangkycanhan'],
      maDangKyDoi: json['madangkydoi'],
      loaiDangKy: json['loaidangky'],
      tenGiai: json['tengiai'],
      giaiThuong: json['giaithuong'],
      diemRenLuyen: _parseDouble(json['diemrenluyen']),
      ngayTrao: json['ngaytrao'],
      tenDoiThi: json['tendoithi'],
    );
  }

  // Helper để parse double an toàn
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'madatgiai': maDatGiai,
      'macuocthi': maCuocThi,
      'tencuocthi': tenCuocThi,
      'madangkycanhan': maDangKyCaNhan,
      'madangkydoi': maDangKyDoi,
      'loaidangky': loaiDangKy,
      'tengiai': tenGiai,
      'giaithuong': giaiThuong,
      'diemrenluyen': diemRenLuyen,
      'ngaytrao': ngayTrao,
      'tendoithi': tenDoiThi,
    };
  }

  // Helper để hiển thị
  String get tenHienThi {
    if (loaiDangKy == 'DoiNhom' && tenDoiThi != null) {
      return '$tenGiai (Đội: $tenDoiThi)';
    }
    return tenGiai ?? 'Chưa có tên giải';
  }

  String get ngayTraoFormatted {
    if (ngayTrao == null || ngayTrao!.isEmpty) return '';
    try {
      final dt = DateTime.parse(ngayTrao!);
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (_) {
      return ngayTrao!;
    }
  }
}