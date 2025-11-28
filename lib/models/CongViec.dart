class CongViec {
  final String? maCongViec;
  final String? tenCongViec;
  final String? maBan;
  final String? maCuocThi;
  final String? moTa;
  final String? thoiGianBatDau;
  final String? thoiGianKetThuc;
  final String? trangThai;

  CongViec({
    this.maCongViec,
    this.tenCongViec,
    this.maBan,
    this.maCuocThi,
    this.moTa,
    this.thoiGianBatDau,
    this.thoiGianKetThuc,
    this.trangThai,
  });

  factory CongViec.fromJson(Map<String, dynamic> json) {
    return CongViec(
      maCongViec: json['macongviec'],
      tenCongViec: json['tencongviec'],
      maBan: json['maban'],
      maCuocThi: json['macuocthi'],
      moTa: json['mota'],
      thoiGianBatDau: json['thoigianbatdau'],
      thoiGianKetThuc: json['thoigianketthuc'],
      trangThai: json['trangthai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'macongviec': maCongViec,
      'tencongviec': tenCongViec,
      'maban': maBan,
      'macuocthi': maCuocThi,
      'mota': moTa,
      'thoigianbatdau': thoiGianBatDau,
      'thoigianketthuc': thoiGianKetThuc,
      'trangthai': trangThai,
    };
  }
}
