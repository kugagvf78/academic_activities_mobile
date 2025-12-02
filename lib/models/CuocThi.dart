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
  final String? trangThai;

  final String? statusLabel;
  final String? statusColor;
  final String? tenBoMon;
  final String? motaBoMon;
  final String? truongBoMon;
  final String? slug;

  // 🔥 Các trường bổ sung từ API
  final List<dynamic>? vongThi;
  final List<dynamic>? banToChuc;
  final Map<String, dynamic>? keHoach;

  final double? duTruKinhPhi;
  final int? soLuongDoi;

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
    this.trangThai,

    this.statusLabel,
    this.statusColor,
    this.tenBoMon,
    this.motaBoMon,
    this.truongBoMon,
    this.slug,

    this.vongThi,
    this.banToChuc,
    this.keHoach,

    this.duTruKinhPhi,
    this.soLuongDoi,
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
      soLuongThanhVien: int.tryParse(json['soluongthanhvien']?.toString() ?? "0"),
      soLuongDangKy: int.tryParse(json['soluongdangky']?.toString() ?? "0"),
      hinhThucThamGia: json['hinhthucthamgia']?.toString(),
      trangThai: json['trangthai']?.toString(),

      // Thông tin bổ sung
      statusLabel: json['status_label']?.toString(),
      statusColor: json['status_color']?.toString(),
      tenBoMon: json['tenbomon']?.toString(),
      motaBoMon: json['motabomon']?.toString(),
      truongBoMon: json['truongbomon']?.toString(),
      slug: json['slug']?.toString(),

      // 🔥 Field List
      vongThi: json['vongthi'] != null ? List.from(json['vongthi']) : [],
      banToChuc: json['bantochuc'] != null ? List.from(json['bantochuc']) : [],
      keHoach: json['kehoach'],

      // 🔥 Field số
      duTruKinhPhi: double.tryParse(json['dutrukinhphi']?.toString() ?? "0"),

      soLuongDoi: json['soluongdoi'] != null
          ? int.tryParse(json['soluongdoi'].toString())
          : null,
    );
  }
}
