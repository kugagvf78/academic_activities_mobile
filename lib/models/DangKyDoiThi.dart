class DangKyDoiThi {
  final String id;
  final String tenCuocThi;

  final String tenDoiThi;
  final String? vaiTro;

  final String thoiGianBatDau;
  final String thoiGianKetThuc;
  final String submitDeadline;

  final String ngayDangKy;

  final String trangThai;
  final String status;
  final String statusLabel;
  final String statusColor;

  final bool canCancel;
  final bool canSubmit;

  final String? maBaiThi;
  final String? thoiGianNop;
  final String? trangThaiNop;

  DangKyDoiThi({
    required this.id,
    required this.tenCuocThi,
    required this.tenDoiThi,
    this.vaiTro,
    required this.thoiGianBatDau,
    required this.thoiGianKetThuc,
    required this.submitDeadline,
    required this.ngayDangKy,
    required this.trangThai,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
    required this.canCancel,
    required this.canSubmit,
    this.maBaiThi,
    this.thoiGianNop,
    this.trangThaiNop,
  });

  factory DangKyDoiThi.fromJson(Map<String, dynamic> j) {
    return DangKyDoiThi(
      id: j["id"],
      tenCuocThi: j["tencuocthi"],
      tenDoiThi: j["tendoithi"],
      vaiTro: j["vaitro"],

      thoiGianBatDau: j["thoigianbatdau"],
      thoiGianKetThuc: j["thoigianketthuc"],
      submitDeadline: j["submitDeadline"],

      ngayDangKy: j["ngaydangky"],

      trangThai: j["trangthai"],
      status: j["status"],
      statusLabel: j["statusLabel"],
      statusColor: j["statusColor"],

      canCancel: j["canCancel"],
      canSubmit: j["canSubmit"],

      maBaiThi: j["mabaithi"],
      thoiGianNop: j["thoigiannop"],
      trangThaiNop: j["trangthainop"],
    );
  }
}
