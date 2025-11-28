class HoatDongHoTro {
  final String? maHoatDong;
  final String? tenHoatDong;
  final String? maCuocThi;
  final String? loaiHoatDong;
  final double? diemRenLuyen;
  final String? thoiGianBatDau;
  final String? thoiGianKetThuc;
  final String? diaDiem;
  final String? moTa;
  final int? soLuong;

  HoatDongHoTro({
    this.maHoatDong,
    this.tenHoatDong,
    this.maCuocThi,
    this.loaiHoatDong,
    this.diemRenLuyen,
    this.thoiGianBatDau,
    this.thoiGianKetThuc,
    this.diaDiem,
    this.moTa,
    this.soLuong,
  });

  factory HoatDongHoTro.fromJson(Map<String, dynamic> json) {
    return HoatDongHoTro(
      maHoatDong: json['mahoatdong'],
      tenHoatDong: json['tenhoatdong'],
      maCuocThi: json['macuocthi'],
      loaiHoatDong: json['loaihoatdong'],
      diemRenLuyen: (json['diemrenluyen'] as num?)?.toDouble(),
      thoiGianBatDau: json['thoigianbatdau'],
      thoiGianKetThuc: json['thoigianketthuc'],
      diaDiem: json['diadiem'],
      moTa: json['mota'],
      soLuong: json['soluong'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mahoatdong': maHoatDong,
      'tenhoatdong': tenHoatDong,
      'macuocthi': maCuocThi,
      'loaihoatdong': loaiHoatDong,
      'diemrenluyen': diemRenLuyen,
      'thoigianbatdau': thoiGianBatDau,
      'thoigianketthuc': thoiGianKetThuc,
      'diadiem': diaDiem,
      'mota': moTa,
      'soluong': soLuong,
    };
  }
}
