import 'package:intl/intl.dart';
class HoatDongHocThuat {
  final String id; // Thêm id cho mỗi hoạt động
  final String ten;
  final String? phuDe;
  final DateTime ngay;
  final String trangThai;
  final String mau;
  final String? role;
  final String icon;
  final String? attendance;
  final DateTime? attendanceTime;

  HoatDongHocThuat({
    required this.id, // Đảm bảo id là một phần của constructor
    required this.ten,
    required this.ngay,
    required this.trangThai,
    required this.mau,
    required this.icon,
    this.role,
    this.phuDe,
    this.attendance,
    this.attendanceTime,
  });

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime.now();
    try {
      return DateTime.parse(dateStr.replaceAll(' ', 'T'));
    } catch (_) {
      return DateTime.now();
    }
  }

  factory HoatDongHocThuat.fromJson(Map<String, dynamic> j) {
    return HoatDongHocThuat(
      id: j['idcuocthi'] ?? "",  // Đảm bảo lấy id từ JSON
      ten: j['title'] ?? "",
      phuDe: j['subtitle'],
      ngay: _parseDate(j['date']),
      trangThai: j['status'] ?? "",
      mau: j['color'] ?? "gray",
      role: j["role"],
      icon: j['icon'] ?? "fa-flag",
      attendance: j['attendance'],
      attendanceTime:
          j['attendanceTime'] != null ? _parseDate(j['attendanceTime']) : null,
    );
  }

  String get formattedDate => DateFormat('dd/MM/yyyy').format(ngay);
  String? get formattedAttendanceTime => attendanceTime != null
      ? DateFormat('dd/MM/yyyy HH:mm').format(attendanceTime!)
      : null;
}
