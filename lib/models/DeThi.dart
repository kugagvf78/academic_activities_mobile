class DeThi {
  final String? maDeThi;
  final String? tenDeThi;
  final String? maCuocThi;
  final String? loaiDeThi;
  final String? fileDeThi;
  final int? thoiGianLamBai;
  final double? diemToiDa;
  final String? ngayTao;
  final String? nguoiTao;
  final String? trangThai;

  DeThi({
    this.maDeThi,
    this.tenDeThi,
    this.maCuocThi,
    this.loaiDeThi,
    this.fileDeThi,
    this.thoiGianLamBai,
    this.diemToiDa,
    this.ngayTao,
    this.nguoiTao,
    this.trangThai,
  });

  factory DeThi.fromJson(Map<String, dynamic> json) {
    return DeThi(
      maDeThi: json['madethi'],
      tenDeThi: json['tendethi'],
      maCuocThi: json['macuocthi'],
      loaiDeThi: json['loaidethi'],
      fileDeThi: json['filedethi'],
      thoiGianLamBai: json['thoigianlambai'],
      diemToiDa: (json['diemtoida'] as num?)?.toDouble(),
      ngayTao: json['ngaytao'],
      nguoiTao: json['nguoitao'],
      trangThai: json['trangthai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'madethi': maDeThi,
      'tendethi': tenDeThi,
      'macuocthi': maCuocThi,
      'loaidethi': loaiDeThi,
      'filedethi': fileDeThi,
      'thoigianlambai': thoiGianLamBai,
      'diemtoida': diemToiDa,
      'ngaytao': ngayTao,
      'nguoitao': nguoiTao,
      'trangthai': trangThai,
    };
  }
}
