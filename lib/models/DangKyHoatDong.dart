import 'package:intl/intl.dart';
class DangKyHoatDong {
  final String id;
  final String title;
  final String event;
  final String type;
  final String location;
  final double points;

  final DateTime dateStart;
  final DateTime dateEnd;
  final DateTime registerDate;

  final bool attended;
  final DateTime? attendanceTime;

  final String rawStatus;

  DangKyHoatDong({
    required this.id,
    required this.title,
    required this.event,
    required this.type,
    required this.location,
    required this.points,
    required this.dateStart,
    required this.dateEnd,
    required this.registerDate,
    required this.attended,
    this.attendanceTime,
    required this.rawStatus,
  });

  // Helper parse datetime với timezone
  static DateTime _parseDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime.now();
    try {
      // Chấp nhận cả dạng “2025-11-25 22:46:06+07” hoặc ISO “2025-11-25T22:46:06+07:00”
      return DateTime.parse(dateStr.replaceAll(' ', 'T'));
    } catch (e) {
      print('⚠️ Parse date error: $dateStr - $e');
      return DateTime.now();
    }
  }

  factory DangKyHoatDong.fromJson(Map<String, dynamic> j) {
    return DangKyHoatDong(
      id: j['madangkyhoatdong'] ?? "",
      title: j['tenhoatdong'] ?? "Không có tên",
      event: j['tencuocthi'] ?? "Không có tên cuộc thi",
      type: j['loaihoatdong'] ?? "Không rõ",
      location: j['diadiem'] ?? "Chưa xác định",
      points: double.tryParse(j['diemrenluyen']?.toString() ?? '0') ?? 0.0,
      dateStart: _parseDateTime(j['thoigianbatdau']),
      dateEnd: _parseDateTime(j['thoigianketthuc']),
      registerDate: _parseDateTime(j['ngaydangky']),
      attended: j['diemdanhqr'] ?? false,
      attendanceTime: j['thoigiandiemdanh'] != null
          ? _parseDateTime(j['thoigiandiemdanh'])
          : null,
      rawStatus: j['trangthai'] ?? "Unknown",
    );
  }

  // Logic tự động tính trạng thái
  Map<String, dynamic> get statusInfo {
    final now = DateTime.now();
    if (attended) {
      return {
        'label': 'Hoàn thành',
        'color': 'green',
        'icon': 'check',
      };
    } else if (now.isAfter(dateEnd)) {
      return {
        'label': 'Đã kết thúc',
        'color': 'gray',
        'icon': 'ban',
      };
    } else if (now.isAfter(dateStart) && now.isBefore(dateEnd)) {
      return {
        'label': 'Đang diễn ra',
        'color': 'blue',
        'icon': 'play',
      };
    } else {
      return {
        'label': 'Sắp diễn ra',
        'color': 'orange',
        'icon': 'clock',
      };
    }
  }

  String get statusLabel => statusInfo['label'];
  String get statusColor => statusInfo['color'];
}
