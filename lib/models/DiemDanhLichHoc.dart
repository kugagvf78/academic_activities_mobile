class DiemDanhLichHoc {
  final String? maDiemDanh;
  final String? maLichHoc;
  final String? maSinhVien;
  final String? ngayHoc;
  final String? trangThai;
  final String? ghiChu;
  final String? thoiGianDiemDanh;

  DiemDanhLichHoc({
    this.maDiemDanh,
    this.maLichHoc,
    this.maSinhVien,
    this.ngayHoc,
    this.trangThai,
    this.ghiChu,
    this.thoiGianDiemDanh,
  });

  factory DiemDanhLichHoc.fromJson(Map<String, dynamic> json) {
    return DiemDanhLichHoc(
      maDiemDanh: json['madiemdanh'],
      maLichHoc: json['malichhoc'],
      maSinhVien: json['masinhvien'],
      ngayHoc: json['ngayhoc'],
      trangThai: json['trangthai'],
      ghiChu: json['ghichu'],
      thoiGianDiemDanh: json['thoigiandiemdanh'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'madiemdanh': maDiemDanh,
      'malichhoc': maLichHoc,
      'masinhvien': maSinhVien,
      'ngayhoc': ngayHoc,
      'trangthai': trangThai,
      'ghichu': ghiChu,
      'thoigiandiemdanh': thoiGianDiemDanh,
    };
  }
}
