class KeHoachCuocThi {
  final String? maKeHoach;
  final String? maCuocThi;
  final String? namHoc;
  final String? hocKy;
  final String? trangThaiDuyet;
  final String? ngayNopKeHoach;
  final String? ngayDuyet;
  final String? nguoiDuyet;
  final String? ghiChu;

  KeHoachCuocThi({
    this.maKeHoach,
    this.maCuocThi,
    this.namHoc,
    this.hocKy,
    this.trangThaiDuyet,
    this.ngayNopKeHoach,
    this.ngayDuyet,
    this.nguoiDuyet,
    this.ghiChu,
  });

  factory KeHoachCuocThi.fromJson(Map<String, dynamic> json) {
    return KeHoachCuocThi(
      maKeHoach: json['makehoach'],
      maCuocThi: json['macuocthi'],
      namHoc: json['namhoc'],
      hocKy: json['hocky'],
      trangThaiDuyet: json['trangthaiduyet'],
      ngayNopKeHoach: json['ngaynopkehoach'],
      ngayDuyet: json['ngayduyet'],
      nguoiDuyet: json['nguoiduyet'],
      ghiChu: json['ghichu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'makehoach': maKeHoach,
      'macuocthi': maCuocThi,
      'namhoc': namHoc,
      'hocky': hocKy,
      'trangthaiduyet': trangThaiDuyet,
      'ngaynopkehoach': ngayNopKeHoach,
      'ngayduyet': ngayDuyet,
      'nguoiduyet': nguoiDuyet,
      'ghichu': ghiChu,
    };
  }
}
