class DiemDanhQR {
  final String? maDiemDanh;
  final String? maHoatDong;
  final String? maCuocThi;
  final String? maSinhVien;
  final String? maQR;
  final String? thoiGianDiemDanh;
  final String? viTri;

  DiemDanhQR({
    this.maDiemDanh,
    this.maHoatDong,
    this.maCuocThi,
    this.maSinhVien,
    this.maQR,
    this.thoiGianDiemDanh,
    this.viTri,
  });

  factory DiemDanhQR.fromJson(Map<String, dynamic> json) {
    return DiemDanhQR(
      maDiemDanh: json['madiemdanh'],
      maHoatDong: json['mahoatdong'],
      maCuocThi: json['macuocthi'],
      maSinhVien: json['masinhvien'],
      maQR: json['maqr'],
      thoiGianDiemDanh: json['thoigiandiemdanh'],
      viTri: json['vitri'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'madiemdanh': maDiemDanh,
      'mahoatdong': maHoatDong,
      'macuocthi': maCuocThi,
      'masinhvien': maSinhVien,
      'maqr': maQR,
      'thoigiandiemdanh': thoiGianDiemDanh,
      'vitri': viTri,
    };
  }
}
