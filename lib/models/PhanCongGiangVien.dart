class PhanCongGiangVien {
  final String? maPhanCong;
  final String? maGiangVien;
  final String? maCongViec;
  final String? maBan;
  final String? vaiTro;
  final String? ngayPhanCong;

  PhanCongGiangVien({
    this.maPhanCong,
    this.maGiangVien,
    this.maCongViec,
    this.maBan,
    this.vaiTro,
    this.ngayPhanCong,
  });

  factory PhanCongGiangVien.fromJson(Map<String, dynamic> json) {
    return PhanCongGiangVien(
      maPhanCong: json['maphancong'],
      maGiangVien: json['magiangvien'],
      maCongViec: json['macongviec'],
      maBan: json['maban'],
      vaiTro: json['vaitro'],
      ngayPhanCong: json['ngayphancong'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maphancong': maPhanCong,
      'magiangvien': maGiangVien,
      'macongviec': maCongViec,
      'maban': maBan,
      'vaitro': vaiTro,
      'ngayphancong': ngayPhanCong,
    };
  }
}
