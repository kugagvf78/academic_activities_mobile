class TinTuc {
  final String? maTinTuc;
  final String? tieuDe;
  final String? noiDung;
  final String? maCuocThi;
  final String? loaiTin;
  final String? hinhAnh;
  final String? tacGia;
  final int? luotXem;
  final String? trangThai;
  final String? ngayDang;
  final String? ngayCapNhat;

  TinTuc({
    this.maTinTuc,
    this.tieuDe,
    this.noiDung,
    this.maCuocThi,
    this.loaiTin,
    this.hinhAnh,
    this.tacGia,
    this.luotXem,
    this.trangThai,
    this.ngayDang,
    this.ngayCapNhat,
  });

  factory TinTuc.fromJson(Map<String, dynamic> json) {
    return TinTuc(
      maTinTuc: json['matintuc'],
      tieuDe: json['tieude'],
      noiDung: json['noidung'],
      maCuocThi: json['macuocthi'],
      loaiTin: json['loaitin'],
      hinhAnh: json['hinhanh'],
      tacGia: json['tacgia'],
      luotXem: json['luotxem'],
      trangThai: json['trangthai'],
      ngayDang: json['ngaydang'],
      ngayCapNhat: json['ngaycapnhat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matintuc': maTinTuc,
      'tieude': tieuDe,
      'noidung': noiDung,
      'macuocthi': maCuocThi,
      'loaitin': loaiTin,
      'hinhanh': hinhAnh,
      'tacgia': tacGia,
      'luotxem': luotXem,
      'trangthai': trangThai,
      'ngaydang': ngayDang,
      'ngaycapnhat': ngayCapNhat,
    };
  }
}
