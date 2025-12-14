class QuyetToan {
  final String? maQuyetToan;
  final String? maCuocThi;
  final double? tongDuTru;
  final double? tongThucTe;
  final double? chenhLech;
  final String? ngayQuyetToan;
  final String? nguoiLap;
  final String? nguoiDuyet;
  final String? trangThai;
  final String? fileQuyetToan;
  final String? ghiChu;

  QuyetToan({
    this.maQuyetToan,
    this.maCuocThi,
    this.tongDuTru,
    this.tongThucTe,
    this.chenhLech,
    this.ngayQuyetToan,
    this.nguoiLap,
    this.nguoiDuyet,
    this.trangThai,
    this.fileQuyetToan,
    this.ghiChu,
  });

  factory QuyetToan.fromJson(Map<String, dynamic> json) {
    return QuyetToan(
      maQuyetToan: json['maquyettoan'],
      maCuocThi: json['macuocthi'],
      tongDuTru: (json['tongdutru'] as num?)?.toDouble(),
      tongThucTe: (json['tongthucte'] as num?)?.toDouble(),
      chenhLech: (json['chenhlech'] as num?)?.toDouble(),
      ngayQuyetToan: json['ngayquyettoan'],
      nguoiLap: json['nguoilap'],
      nguoiDuyet: json['nguoiduyet'],
      trangThai: json['trangthai'],
      fileQuyetToan: json['filequyettoan'],
      ghiChu: json['ghichu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maquyettoan': maQuyetToan,
      'macuocthi': maCuocThi,
      'tongdutru': tongDuTru,
      'tongthucte': tongThucTe,
      'chenhlech': chenhLech,
      'ngayquyettoan': ngayQuyetToan,
      'nguoilap': nguoiLap,
      'nguoiduyet': nguoiDuyet,
      'trangthai': trangThai,
      'filequyettoan': fileQuyetToan,
      'ghichu': ghiChu,
    };
  }
}
