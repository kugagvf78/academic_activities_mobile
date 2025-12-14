class VongThi {
  final String? maVongThi;
  final String? tenVongThi;
  final String? maCuocThi;
  final int? thuTu;
  final String? thoiGianBatDau;
  final String? thoiGianKetThuc;
  final String? diaDiem;
  final String? moTa;
  final String? trangThai;

  VongThi({
    this.maVongThi,
    this.tenVongThi,
    this.maCuocThi,
    this.thuTu,
    this.thoiGianBatDau,
    this.thoiGianKetThuc,
    this.diaDiem,
    this.moTa,
    this.trangThai,
  });

  factory VongThi.fromJson(Map<String, dynamic> json) {
    return VongThi(
      maVongThi: json['mavongthi'],
      tenVongThi: json['tenvongthi'],
      maCuocThi: json['macuocthi'],
      thuTu: json['thutu'],
      thoiGianBatDau: json['thoigianbatdau'],
      thoiGianKetThuc: json['thoigianketthuc'],
      diaDiem: json['diadiem'],
      moTa: json['mota'],
      trangThai: json['trangthai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mavongthi': maVongThi,
      'tenvongthi': tenVongThi,
      'macuocthi': maCuocThi,
      'thutu': thuTu,
      'thoigianbatdau': thoiGianBatDau,
      'thoigianketthuc': thoiGianKetThuc,
      'diadiem': diaDiem,
      'mota': moTa,
      'trangthai': trangThai,
    };
  }
}
