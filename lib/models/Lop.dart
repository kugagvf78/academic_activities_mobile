class Lop {
  final String? malop;
  final String? tenlop;
  final String? nienkhoa;
  final int? soluongsinhvien;
  final String? magiangvienchunhiem;

  Lop({
    this.malop,
    this.tenlop,
    this.nienkhoa,
    this.soluongsinhvien,
    this.magiangvienchunhiem,
  });

  factory Lop.fromJson(Map<String, dynamic> json) {
    return Lop(
      malop: json['malop'],
      tenlop: json['tenlop'],
      nienkhoa: json['nienkhoa'],
      soluongsinhvien: json['soluongsinhvien'],
      magiangvienchunhiem: json['magiangvienchunhiem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'malop': malop,
      'tenlop': tenlop,
      'nienkhoa': nienkhoa,
      'soluongsinhvien': soluongsinhvien,
      'magiangvienchunhiem': magiangvienchunhiem,
    };
  }
}
