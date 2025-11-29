import 'package:flutter/material.dart';

class CuocThi {
  final String? maCuocThi;
  final String? tenCuocThi;
  final String? loaiCuocThi;
  final String? moTa;
  final String? mucDich;
  final String? doiTuongThamGia;
  final String? thoiGianBatDau;
  final String? thoiGianKetThuc;
  final String? diaDiem;
  final int? soLuongThanhVien;
  final int? soLuongDangKy;
  final String? hinhThucThamGia;
  final String? trangThaiLabel;
  final double? duTruKinhPhi;
  final double? chiPhiThucTe;
  final String? maBoMon;
  final String? ngayTao;
  final String? ngayCapNhat;

  CuocThi({
    this.maCuocThi,
    this.tenCuocThi,
    this.loaiCuocThi,
    this.moTa,
    this.mucDich,
    this.doiTuongThamGia,
    this.thoiGianBatDau,
    this.thoiGianKetThuc,
    this.diaDiem,
    this.soLuongThanhVien,
    this.soLuongDangKy,
    this.hinhThucThamGia,
    this.trangThaiLabel,
    this.duTruKinhPhi,
    this.chiPhiThucTe,
    this.maBoMon,
    this.ngayTao,
    this.ngayCapNhat,
  });

  factory CuocThi.fromJson(Map<String, dynamic> json) {
    return CuocThi(
      maCuocThi: json['macuocthi']?.toString(),
      tenCuocThi: json['tencuocthi']?.toString(),
      loaiCuocThi: json['loaicuocthi']?.toString(),
      moTa: json['mota']?.toString(),
      mucDich: json['mucdich']?.toString(),
      doiTuongThamGia: json['doituongthamgia']?.toString(),
      thoiGianBatDau: json['thoigianbatdau']?.toString(),
      thoiGianKetThuc: json['thoigianketthuc']?.toString(),
      diaDiem: json['diadiem']?.toString(),
      soLuongThanhVien: int.tryParse(
        json['soluongthanhvien']?.toString() ?? '0',
      ),
      soLuongDangKy: int.tryParse(json['soluongdangky']?.toString() ?? '0'),
      hinhThucThamGia: json['hinhthucthamgia']?.toString(),

      // ✅ Đúng key của API
      trangThaiLabel: json['status_label']?.toString(),

      duTruKinhPhi: double.tryParse(json['dutrukinhphi']?.toString() ?? '0.0'),
      chiPhiThucTe: double.tryParse(json['chiphithucte']?.toString() ?? '0.0'),
      maBoMon: json['mabomon']?.toString(),
      ngayTao: json['ngaytao']?.toString(),
      ngayCapNhat: json['ngaycapnhat']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'macuocthi': maCuocThi,
      'tencuocthi': tenCuocThi,
      'loaicuocthi': loaiCuocThi,
      'mota': moTa,
      'mucdich': mucDich,
      'doituongthamgia': doiTuongThamGia,
      'thoigianbatdau': thoiGianBatDau,
      'thoigianketthuc': thoiGianKetThuc,
      'diadiem': diaDiem,
      'soluongthanhvien': soLuongThanhVien,
      'soluongdangky': soLuongDangKy,
      'hinhthucthamgia': hinhThucThamGia,
      'trangthai_label': trangThaiLabel,
      'dutrukinhphi': duTruKinhPhi,
      'chiphithucte': chiPhiThucTe,
      'mabomon': maBoMon,
      'ngaytao': ngayTao,
      'ngaycapnhat': ngayCapNhat,
    };
  }

  String get translatedStatus {
    switch (trangThaiLabel?.trim()) {
      case 'Đang diễn ra':
        return 'Ongoing';
      case 'Sắp diễn ra':
        return 'Upcoming';
      case 'Đã kết thúc':
        return 'Ended';
      default:
        return 'Unknown';
    }
  }

  Color get statusColor {
    switch (trangThaiLabel?.trim()) {
      case 'Đang diễn ra':
        return const Color(0xFF1E88E5); // Blue
      case 'Sắp diễn ra':
        return const Color(0xFF43A047); // Green
      case 'Đã kết thúc':
        return const Color(0xFF9E9E9E); // Grey
      default:
        return Colors.grey;
    }
  }
}
