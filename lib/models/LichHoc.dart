class LichHoc {
  final String? maLichHoc;
  final String? maMonHoc;
  final String? maLop;
  final String? maGiangVien;
  final String? thu;
  final int? tietBatDau;
  final int? tietKetThuc;
  final String? phongHoc;
  final String? ngayBatDau;
  final String? ngayKetThuc;
  final String? ghiChu;

  LichHoc({
    this.maLichHoc,
    this.maMonHoc,
    this.maLop,
    this.maGiangVien,
    this.thu,
    this.tietBatDau,
    this.tietKetThuc,
    this.phongHoc,
    this.ngayBatDau,
    this.ngayKetThuc,
    this.ghiChu,
  });

  factory LichHoc.fromJson(Map<String, dynamic> json) {
    return LichHoc(
      maLichHoc: json['malichhoc'],
      maMonHoc: json['mamonhoc'],
      maLop: json['malop'],
      maGiangVien: json['magiangvien'],
      thu: json['thu'],
      tietBatDau: json['tietbatdau'],
      tietKetThuc: json['tietketthuc'],
      phongHoc: json['phonghoc'],
      ngayBatDau: json['ngaybatdau'],
      ngayKetThuc: json['ngayketthuc'],
      ghiChu: json['ghichu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'malichhoc': maLichHoc,
      'mamonhoc': maMonHoc,
      'malop': maLop,
      'magiangvien': maGiangVien,
      'thu': thu,
      'tietbatdau': tietBatDau,
      'tietketthuc': tietKetThuc,
      'phonghoc': phongHoc,
      'ngaybatdau': ngayBatDau,
      'ngayketthuc': ngayKetThuc,
      'ghichu': ghiChu,
    };
  }
}
