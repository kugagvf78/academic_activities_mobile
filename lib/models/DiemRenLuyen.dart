class DiemRenLuyen {
  final String? maDiemRL;
  final String? maSinhVien;
  final String? maCuocThi;
  final String? maHoatDong;
  final String? loaiHoatDong;
  final double? diem;
  final String? moTa;
  final String? ngayCong;

  DiemRenLuyen({
    this.maDiemRL,
    this.maSinhVien,
    this.maCuocThi,
    this.maHoatDong,
    this.loaiHoatDong,
    this.diem,
    this.moTa,
    this.ngayCong,
  });

  factory DiemRenLuyen.fromJson(Map<String, dynamic> json) {
    return DiemRenLuyen(
      maDiemRL: json['madiemrl'],
      maSinhVien: json['masinhvien'],
      maCuocThi: json['macuocthi'],
      maHoatDong: json['mahoatdong'],
      loaiHoatDong: json['loaihoatdong'],
      diem: (json['diem'] as num?)?.toDouble(),
      moTa: json['mota'],
      ngayCong: json['ngaycong'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'madiemrl': maDiemRL,
      'masinhvien': maSinhVien,
      'macuocthi': maCuocThi,
      'mahoatdong': maHoatDong,
      'loaihoatdong': loaiHoatDong,
      'diem': diem,
      'mota': moTa,
      'ngaycong': ngayCong,
    };
  }
}
