class HoatDongNgan {
  final String ten;
  final String? phuDe;
  final String ngay;
  final String trangThai;
  final String mau;
  final String? role;
  final String icon;

  HoatDongNgan({
    required this.ten,
    required this.ngay,
    required this.trangThai,
    required this.mau,
    required this.icon,
    this.role,
    this.phuDe,
  });

  factory HoatDongNgan.fromJson(Map<String, dynamic> j) {
    print("ROLE JSON: ${j['role']}");
    return HoatDongNgan(
      ten: j['title'] ?? "",
      phuDe: j['subtitle'],
      ngay: j['date'] ?? "",
      trangThai: j['status'] ?? "",
      mau: j['color'] ?? "gray",
       role: j["role"], 
      icon: j['icon'] ?? "fa-flag",
    );
  }
}
