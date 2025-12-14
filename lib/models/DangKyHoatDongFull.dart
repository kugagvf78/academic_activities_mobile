class DangKyHoatDongFull {
  final String id;
  final String idCuocThi;      
  final String tenCuocThi;
  final String tenHoatDong;
  final String loaiHoatDong;

  final String thoiGianBatDau;
  final String thoiGianKetThuc;
  final String ngayDangKy;

  final String status;
  final String statusLabel;
  final String statusColor;

  final bool diemDanhQR;
  final String? thoiGianDiemDanh;

  final bool canCancel;

  DangKyHoatDongFull({
    required this.id,
    required this.idCuocThi,   
    required this.tenCuocThi,
    required this.tenHoatDong,
    required this.loaiHoatDong,
    required this.thoiGianBatDau,
    required this.thoiGianKetThuc,
    required this.ngayDangKy,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
    required this.diemDanhQR,
    this.thoiGianDiemDanh,
    required this.canCancel,
  });

  factory DangKyHoatDongFull.fromJson(Map<String, dynamic> json) {
    return DangKyHoatDongFull(
      id: json['madangkyhoatdong'] ?? "",
      idCuocThi: json['macuocthi'] ?? "",  
      tenCuocThi: json['tencuocthi'] ?? "",
      tenHoatDong: json['tenhoatdong'] ?? "",
      loaiHoatDong: json['loaihoatdong'] ?? "",

      thoiGianBatDau: json['thoigianbatdau'] ?? "",
      thoiGianKetThuc: json['thoigianketthuc'] ?? "",
      ngayDangKy: json['ngaydangky'] ?? "",

      status: json['status'] ?? "",
      statusLabel: json['statusLabel'] ?? "",
      statusColor: json['statusColor'] ?? "",

      diemDanhQR: json['diemdanhqr'] ?? false,
      thoiGianDiemDanh: json['thoigiandiemdanh'],

      canCancel: json['canCancel'] ?? false,
    );
  }
}
