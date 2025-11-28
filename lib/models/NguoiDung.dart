class NguoiDung {
  final String? manguoidung;
  final String? tendangnhap;
  final String? matkhau;
  final String? hoten;
  final String? email;
  final String? sodienthoai;
  final String? vaitro;
  final String? trangthai;
  final String? ngaytao;
  final String? ngaycapnhat;

  NguoiDung({
    this.manguoidung,
    this.tendangnhap,
    this.matkhau,
    this.hoten,
    this.email,
    this.sodienthoai,
    this.vaitro,
    this.trangthai,
    this.ngaytao,
    this.ngaycapnhat,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      manguoidung: json['manguoidung'],
      tendangnhap: json['tendangnhap'],
      matkhau: json['matkhau'],
      hoten: json['hoten'],
      email: json['email'],
      sodienthoai: json['sodienthoai'],
      vaitro: json['vaitro'],
      trangthai: json['trangthai'],
      ngaytao: json['ngaytao'],
      ngaycapnhat: json['ngaycapnhat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manguoidung': manguoidung,
      'tendangnhap': tendangnhap,
      'matkhau': matkhau,
      'hoten': hoten,
      'email': email,
      'sodienthoai': sodienthoai,
      'vaitro': vaitro,
      'trangthai': trangthai,
      'ngaytao': ngaytao,
      'ngaycapnhat': ngaycapnhat,
    };
  }
}
