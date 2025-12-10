class NguoiDung {
  String? manguoidung;
  String? tendangnhap;
  String? matkhau;
  String? hoten;
  String? email;
  String? sodienthoai;
  String? vaitro;
  String? trangthai;
  String? ngaytao;
  String? ngaycapnhat;
  String? anhdaidien; // Removed final

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
    this.anhdaidien,
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
      anhdaidien: json['anhdaidien'],
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
      'anhdaidien': anhdaidien,
    };
  }
}
