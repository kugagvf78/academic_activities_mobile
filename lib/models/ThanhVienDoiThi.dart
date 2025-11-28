class ThanhVienDoiThi {
  final String? maThanhVien;
  final String? maDoiThi;
  final String? maSinhVien;
  final String? vaiTro;
  final String? ngayThamGia;

  ThanhVienDoiThi({
    this.maThanhVien,
    this.maDoiThi,
    this.maSinhVien,
    this.vaiTro,
    this.ngayThamGia,
  });

  factory ThanhVienDoiThi.fromJson(Map<String, dynamic> json) {
    return ThanhVienDoiThi(
      maThanhVien: json['mathanhvien'],
      maDoiThi: json['madoithi'],
      maSinhVien: json['masinhvien'],
      vaiTro: json['vaitro'],
      ngayThamGia: json['ngaythamgia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mathanhvien': maThanhVien,
      'madoithi': maDoiThi,
      'masinhvien': maSinhVien,
      'vaitro': vaiTro,
      'ngaythamgia': ngayThamGia,
    };
  }
}
