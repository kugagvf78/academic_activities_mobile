class AuthResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final User user;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? 'bearer',
      expiresIn: json['expires_in'] ?? 3600,
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'user': user.toJson(),
    };
  }
}

class User {
  final String manguoidung;
  final String tendangnhap;
  final String? email;
  final String? hoten;
  final String? sodienthoai;
  final String vaitro;
  final String trangthai;

  User({
    required this.manguoidung,
    required this.tendangnhap,
    this.email,
    this.hoten,
    this.sodienthoai,
    required this.vaitro,
    required this.trangthai,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      manguoidung: json['manguoidung'] ?? '',
      tendangnhap: json['tendangnhap'] ?? '',
      email: json['email'],
      hoten: json['hoten'],
      sodienthoai: json['sodienthoai'],
      vaitro: json['vaitro'] ?? 'SinhVien',
      trangthai: json['trangthai'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manguoidung': manguoidung,
      'tendangnhap': tendangnhap,
      'email': email,
      'hoten': hoten,
      'sodienthoai': sodienthoai,
      'vaitro': vaitro,
      'trangthai': trangthai,
    };
  }

  bool get isActive => trangthai == 'Active';
  
  // App chỉ dành cho sinh viên
  String get displayName => hoten ?? tendangnhap;
  String get maSinhVien => tendangnhap; // tendangnhap chính là mã sinh viên
}