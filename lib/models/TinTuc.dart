class TinTuc {
  String? maTinTuc;
  String? tieuDe;
  String? noiDung;
  String? maCuocThi;
  String? loaiTin;
  String? tacGia;
  int? luotXem;
  String? trangThai;
  String? ngayDang;
  String? hinhAnh;
  String? tenCuocThi;
  String? slug;
  String? excerpt;
  String? thoiGianBatDau;
  String? thoiGianKetThuc;

  TinTuc({
    this.maTinTuc,
    this.tieuDe,
    this.noiDung,
    this.maCuocThi,
    this.loaiTin,
    this.tacGia,
    this.luotXem,
    this.trangThai,
    this.ngayDang,
    this.hinhAnh,
    this.tenCuocThi,
    this.slug,
    this.excerpt,
    this.thoiGianBatDau,
    this.thoiGianKetThuc,
  });

  /// Parse từ JSON (API response)
  factory TinTuc.fromJson(Map<String, dynamic> json) {
    return TinTuc(
      maTinTuc: json['matintuc']?.toString(),
      tieuDe: json['tieude']?.toString(),
      noiDung: json['noidung']?.toString(),
      maCuocThi: json['macuocthi']?.toString(),
      loaiTin: json['loaitin']?.toString(),
      tacGia: json['tacgia']?.toString(),
      luotXem: json['luotxem'] != null ? int.tryParse(json['luotxem'].toString()) : 0,
      trangThai: json['trangthai']?.toString(),
      ngayDang: json['ngaydang']?.toString(),
      hinhAnh: json['hinhanh']?.toString(),
      tenCuocThi: json['tencuocthi']?.toString(),
      slug: json['slug']?.toString(),
      excerpt: json['excerpt']?.toString(),
      thoiGianBatDau: json['thoigianbatdau']?.toString(),
      thoiGianKetThuc: json['thoigianketthuc']?.toString(),
    );
  }

  /// Convert sang JSON
  Map<String, dynamic> toJson() {
    return {
      'matintuc': maTinTuc,
      'tieude': tieuDe,
      'noidung': noiDung,
      'macuocthi': maCuocThi,
      'loaitin': loaiTin,
      'tacgia': tacGia,
      'luotxem': luotXem,
      'trangthai': trangThai,
      'ngaydang': ngayDang,
      'hinhanh': hinhAnh,
      'tencuocthi': tenCuocThi,
      'slug': slug,
      'excerpt': excerpt,
      'thoigianbatdau': thoiGianBatDau,
      'thoigianketthuc': thoiGianKetThuc,
    };
  }

  /// Lấy màu theo loại tin
  String getCategoryColor() {
    switch (loaiTin) {
      case 'TinTuc':
        return '#3B82F6'; // blue
      case 'ThongBao':
        return '#EF4444'; // red
      case 'SuKien':
        return '#10B981'; // green
      default:
        return '#6B7280'; // gray
    }
  }

  /// Lấy label theo loại tin
  String getCategoryLabel() {
    switch (loaiTin) {
      case 'TinTuc':
        return 'Tin tức';
      case 'ThongBao':
        return 'Thông báo';
      case 'SuKien':
        return 'Sự kiện';
      default:
        return loaiTin ?? 'Khác';
    }
  }
}