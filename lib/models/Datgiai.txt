class DatGiai {
  final String? maDatGiai;
  final String? maCuocThi;
  final String? maDangKyCaNhan;
  final String? maDangKyDoi;
  final String? loaiDangKy;
  final String? tenGiai;
  final String? giaiThuong;
  final double? diemRenLuyen;
  final String? ngayTrao;

  DatGiai({
    this.maDatGiai,
    this.maCuocThi,
    this.maDangKyCaNhan,
    this.maDangKyDoi,
    this.loaiDangKy,
    this.tenGiai,
    this.giaiThuong,
    this.diemRenLuyen,
    this.ngayTrao,
  });

  factory DatGiai.fromJson(Map<String, dynamic> json) {
    return DatGiai(
      maDatGiai: json['madatgiai'],
      maCuocThi: json['macuocthi'],
      maDangKyCaNhan: json['madangkycanhan'],
      maDangKyDoi: json['madangkydoi'],
      loaiDangKy: json['loaidangky'],
      tenGiai: json['tengiai'],
      giaiThuong: json['giaithuong'],
      diemRenLuyen: (json['diemrenluyen'] as num?)?.toDouble(),
      ngayTrao: json['ngaytrao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'madatgiai': maDatGiai,
      'macuocthi': maCuocThi,
      'madangkycanhan': maDangKyCaNhan,
      'madangkydoi': maDangKyDoi,
      'loaidangky': loaiDangKy,
      'tengiai': tenGiai,
      'giaithuong': giaiThuong,
      'diemrenluyen': diemRenLuyen,
      'ngaytrao': ngayTrao,
    };
  }
}
