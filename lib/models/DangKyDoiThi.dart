class DangKyDoiThi {
  final String id;
  final String tenCuocThi;
  final String thoiGianBatDau;
  final String thoiGianKetThuc;
  final String? trangThaiCuocThi;
  final String ngayDangKy;
  final String? trangthai;
  final String loaiDangKy;
  final String? tenDoiThi;
  final String? vaitro;
  final String? maBaiThi;
  final String? thoiGianNop;
  final String? trangThaiNop;
  final String status;
  final String statusLabel;
  final String statusColor;
  final bool canCancel;
  final bool canSubmit;

  DangKyDoiThi({
    required this.id,
    required this.tenCuocThi,
    required this.thoiGianBatDau,
    required this.thoiGianKetThuc,
    this.trangThaiCuocThi,
    required this.ngayDangKy,
    this.trangthai,
    required this.loaiDangKy,
    this.tenDoiThi,
    this.vaitro,
    this.maBaiThi,
    this.thoiGianNop,
    this.trangThaiNop,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
    required this.canCancel,
    required this.canSubmit,
  });

  factory DangKyDoiThi.fromJson(Map<String, dynamic> json) {
    return DangKyDoiThi(
      id: json['id']?.toString() ?? '',
      tenCuocThi: json['tencuocthi']?.toString() ?? 'Chưa có tên',
      thoiGianBatDau: json['thoigianbatdau']?.toString() ?? '',
      thoiGianKetThuc: json['thoigianketthuc']?.toString() ?? '',
      trangThaiCuocThi: json['trangthaicuocthi']?.toString(),
      ngayDangKy: json['ngaydangky']?.toString() ?? '',
      trangthai: json['trangthai']?.toString(),
      loaiDangKy: json['loaidangky']?.toString() ?? 'DoiNhom',
      tenDoiThi: json['tendoithi']?.toString(),
      vaitro: json['vaitro']?.toString(),
      maBaiThi: json['mabaithi']?.toString(),
      thoiGianNop: json['thoigiannop']?.toString(),
      trangThaiNop: json['trangthainop']?.toString(),
      status: json['status']?.toString() ?? 'ended',
      statusLabel: json['statusLabel']?.toString() ?? 'Đã kết thúc',
      statusColor: json['statusColor']?.toString() ?? 'gray',
      canCancel: json['canCancel'] == true,
      canSubmit: json['canSubmit'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tencuocthi': tenCuocThi,
      'thoigianbatdau': thoiGianBatDau,
      'thoigianketthuc': thoiGianKetThuc,
      'trangthaicuocthi': trangThaiCuocThi,
      'ngaydangky': ngayDangKy,
      'trangthai': trangthai,
      'loaidangky': loaiDangKy,
      'tendoithi': tenDoiThi,
      'vaitro': vaitro,
      'mabaithi': maBaiThi,
      'thoigiannop': thoiGianNop,
      'trangthainop': trangThaiNop,
      'status': status,
      'statusLabel': statusLabel,
      'statusColor': statusColor,
      'canCancel': canCancel,
      'canSubmit': canSubmit,
    };
  }
}