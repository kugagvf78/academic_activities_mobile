class GiangVien {
  final String? magiangvien;
  final String? manguoidung;
  final String? mabomon;
  final String? chucvu;
  final String? hocvi;
  final String? chuyenmon;

  GiangVien({
    this.magiangvien,
    this.manguoidung,
    this.mabomon,
    this.chucvu,
    this.hocvi,
    this.chuyenmon,
  });

  factory GiangVien.fromJson(Map<String, dynamic> json) {
    return GiangVien(
      magiangvien: json['magiangvien'],
      manguoidung: json['manguoidung'],
      mabomon: json['mabomon'],
      chucvu: json['chucvu'],
      hocvi: json['hocvi'],
      chuyenmon: json['chuyenmon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'magiangvien': magiangvien,
      'manguoidung': manguoidung,
      'mabomon': mabomon,
      'chucvu': chucvu,
      'hocvi': hocvi,
      'chuyenmon': chuyenmon,
    };
  }
}
