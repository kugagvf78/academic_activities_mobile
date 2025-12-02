class DangKyCaNhan {
  final String id;
  final String tenCuocThi;

  final String? tenDoiThi; // null
  final String? vaiTro;    // null

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

  DangKyCaNhan({
    required this.id,
    required this.tenCuocThi,
    this.tenDoiThi,
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

  factory DangKyCaNhan.fromJson(Map<String, dynamic> j) {
    return DangKyCaNhan(
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
