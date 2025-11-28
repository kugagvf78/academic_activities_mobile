class SinhVien {
  final String? masinhvien;
  final String? manguoidung;
  final String? malop;
  final int? namnhaphoc;
  final double? diemrenluyen;
  final String? trangthai;

  SinhVien({
    this.masinhvien,
    this.manguoidung,
    this.malop,
    this.namnhaphoc,
    this.diemrenluyen,
    this.trangthai,
  });

  factory SinhVien.fromJson(Map<String, dynamic> json) {
    return SinhVien(
      masinhvien: json['masinhvien'],
      manguoidung: json['manguoidung'],
      malop: json['malop'],
      namnhaphoc: json['namnhaphoc'],
      diemrenluyen: (json['diemrenluyen'] as num?)?.toDouble(),
      trangthai: json['trangthai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'masinhvien': masinhvien,
      'manguoidung': manguoidung,
      'malop': malop,
      'namnhaphoc': namnhaphoc,
      'diemrenluyen': diemrenluyen,
      'trangthai': trangthai,
    };
  }
}
