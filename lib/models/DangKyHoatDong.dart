class DangKyHoatDong {
  final String? maDangKyHoatDong;
  final String? maHoatDong;
  final String? maSinhVien;
  final String? ngayDangKy;
  final String? trangThai;
  final bool? diemDanhQR;
  final String? thoiGianDiemDanh;

  DangKyHoatDong({
    this.maDangKyHoatDong,
    this.maHoatDong,
    this.maSinhVien,
    this.ngayDangKy,
    this.trangThai,
    this.diemDanhQR,
    this.thoiGianDiemDanh,
  });

  factory DangKyHoatDong.fromJson(Map<String, dynamic> json) {
    return DangKyHoatDong(
      maDangKyHoatDong: json['madangkyhoatdong'],
      maHoatDong: json['mahoatdong'],
      maSinhVien: json['masinhvien'],
      ngayDangKy: json['ngaydangky'],
      trangThai: json['trangthai'],
      diemDanhQR: json['diemdanhqr'] == true,
      thoiGianDiemDanh: json['thoigiandiemdanh'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'madangkyhoatdong': maDangKyHoatDong,
      'mahoatdong': maHoatDong,
      'masinhvien': maSinhVien,
      'ngaydangky': ngayDangKy,
      'trangthai': trangThai,
      'diemdanhqr': diemDanhQR,
      'thoigiandiemdanh': thoiGianDiemDanh,
    };
  }
}
