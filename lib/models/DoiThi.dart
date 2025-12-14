class DoiThi {
  final String? maDoiThi;
  final String? tenDoiThi;
  final String? maCuocThi;
  final String? maTruongDoi;
  final int? soThanhVien;
  final String? ngayDangKy;
  final String? trangThai;

  DoiThi({
    this.maDoiThi,
    this.tenDoiThi,
    this.maCuocThi,
    this.maTruongDoi,
    this.soThanhVien,
    this.ngayDangKy,
    this.trangThai,
  });

  factory DoiThi.fromJson(Map<String, dynamic> json) {
    return DoiThi(
      maDoiThi: json['madoithi'],
      tenDoiThi: json['tendoithi'],
      maCuocThi: json['macuocthi'],
      maTruongDoi: json['matruongdoi'],
      soThanhVien: json['sothanhvien'],
      ngayDangKy: json['ngaydangky'],
      trangThai: json['trangthai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'madoithi': maDoiThi,
      'tendoithi': tenDoiThi,
      'macuocthi': maCuocThi,
      'matruongdoi': maTruongDoi,
      'sothanhvien': soThanhVien,
      'ngaydangky': ngayDangKy,
      'trangthai': trangThai,
    };
  }
}
