class DangKyDoiThi {
  final String? maDangKyDoi;
  final String? maCuocThi;
  final String? maDoiThi;
  final String? ngayDangKy;
  final String? trangThai;
  final String? ghiChu;

  DangKyDoiThi({
    this.maDangKyDoi,
    this.maCuocThi,
    this.maDoiThi,
    this.ngayDangKy,
    this.trangThai,
    this.ghiChu,
  });

  factory DangKyDoiThi.fromJson(Map<String, dynamic> json) {
    return DangKyDoiThi(
      maDangKyDoi: json['madangkydoi'],
      maCuocThi: json['macuocthi'],
      maDoiThi: json['madoithi'],
      ngayDangKy: json['ngaydangky'],
      trangThai: json['trangthai'],
      ghiChu: json['ghichu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'madangkydoi': maDangKyDoi,
      'macuocthi': maCuocThi,
      'madoithi': maDoiThi,
      'ngaydangky': ngayDangKy,
      'trangthai': trangThai,
      'ghichu': ghiChu,
    };
  }
}
