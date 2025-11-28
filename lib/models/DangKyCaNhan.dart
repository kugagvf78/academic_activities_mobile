class DangKyCaNhan {
  final String? maDangKyCaNhan;
  final String? maCuocThi;
  final String? maSinhVien;
  final String? ngayDangKy;
  final String? trangThai;
  final String? ghiChu;

  DangKyCaNhan({
    this.maDangKyCaNhan,
    this.maCuocThi,
    this.maSinhVien,
    this.ngayDangKy,
    this.trangThai,
    this.ghiChu,
  });

  factory DangKyCaNhan.fromJson(Map<String, dynamic> json) {
    return DangKyCaNhan(
      maDangKyCaNhan: json['madangkycanhan'],
      maCuocThi: json['macuocthi'],
      maSinhVien: json['masinhvien'],
      ngayDangKy: json['ngaydangky'],
      trangThai: json['trangthai'],
      ghiChu: json['ghichu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'madangkycanhan': maDangKyCaNhan,
      'macuocthi': maCuocThi,
      'masinhvien': maSinhVien,
      'ngaydangky': ngayDangKy,
      'trangthai': trangThai,
      'ghichu': ghiChu,
    };
  }
}
