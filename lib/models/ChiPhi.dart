class ChiPhi {
  final String? maChiPhi;
  final String? maCuocThi;
  final String? tenKhoanChi;
  final double? duTruChiPhi;
  final double? thucTeChi;
  final String? ngayChi;
  final String? nguoiDuyet;
  final String? trangThai;
  final String? chungTu;
  final String? ghiChu;

  ChiPhi({
    this.maChiPhi,
    this.maCuocThi,
    this.tenKhoanChi,
    this.duTruChiPhi,
    this.thucTeChi,
    this.ngayChi,
    this.nguoiDuyet,
    this.trangThai,
    this.chungTu,
    this.ghiChu,
  });

  factory ChiPhi.fromJson(Map<String, dynamic> json) {
    return ChiPhi(
      maChiPhi: json['machiphi'],
      maCuocThi: json['macuocthi'],
      tenKhoanChi: json['tenkhoanchi'],
      duTruChiPhi: (json['dutruchiphi'] as num?)?.toDouble(),
      thucTeChi: (json['thuctechi'] as num?)?.toDouble(),
      ngayChi: json['ngaychi'],
      nguoiDuyet: json['nguoiduyet'],
      trangThai: json['trangthai'],
      chungTu: json['chungtu'],
      ghiChu: json['ghichu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'machiphi': maChiPhi,
      'macuocthi': maCuocThi,
      'tenkhoanchi': tenKhoanChi,
      'dutruchiphi': duTruChiPhi,
      'thuctechi': thucTeChi,
      'ngaychi': ngayChi,
      'nguoiduyet': nguoiDuyet,
      'trangthai': trangThai,
      'chungtu': chungTu,
      'ghichu': ghiChu,
    };
  }
}
