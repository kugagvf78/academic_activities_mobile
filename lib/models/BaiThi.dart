class BaiThi {
  final String? maBaiThi;
  final String? maDeThi;
  final String? maDangKyCaNhan;
  final String? maDangKyDoi;
  final String? loaiDangKy;
  final String? fileBaiThi;
  final String? thoiGianNop;
  final String? trangThai;

  BaiThi({
    this.maBaiThi,
    this.maDeThi,
    this.maDangKyCaNhan,
    this.maDangKyDoi,
    this.loaiDangKy,
    this.fileBaiThi,
    this.thoiGianNop,
    this.trangThai,
  });

  factory BaiThi.fromJson(Map<String, dynamic> json) {
    return BaiThi(
      maBaiThi: json['mabaithi'],
      maDeThi: json['madethi'],
      maDangKyCaNhan: json['madangkycanhan'],
      maDangKyDoi: json['madangkydoi'],
      loaiDangKy: json['loaidangky'],
      fileBaiThi: json['filebaithi'],
      thoiGianNop: json['thoigiannop'],
      trangThai: json['trangthai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mabaithi': maBaiThi,
      'madethi': maDeThi,
      'madangkycanhan': maDangKyCaNhan,
      'madangkydoi': maDangKyDoi,
      'loaidangky': loaiDangKy,
      'filebaithi': fileBaiThi,
      'thoigiannop': thoiGianNop,
      'trangthai': trangThai,
    };
  }
}
