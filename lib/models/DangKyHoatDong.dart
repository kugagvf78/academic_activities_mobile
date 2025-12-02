class DangKyHoatDong {
  final String id;
  final String title;        
  final String event;        
  final String type;         

  final String dateStart;
  final String dateEnd;
  final String registerDate;

  final bool attended;
  final String? attendanceTime;

  final bool canCancel;

  final String status;
  final String statusColor;
  final String statusLabel;

  DangKyHoatDong({
    required this.id,
    required this.title,
    required this.event,
    required this.type,
    required this.dateStart,
    required this.dateEnd,
    required this.registerDate,
    required this.attended,
    this.attendanceTime,
    required this.canCancel,
    required this.status,
    required this.statusColor,
    required this.statusLabel,
  });

  factory DangKyHoatDong.fromJson(Map<String, dynamic> j) {
    return DangKyHoatDong(
      id: j['madangkyhoatdong'] ?? "",
      title: j['tenhoatdong'] ?? "",
      event: j['tencuocthi'] ?? "",
      type: j['loaihoatdong'] ?? "",

      dateStart: j['thoigianbatdau'] ?? "",
      dateEnd: j['thoigianketthuc'] ?? "",
      registerDate: j['ngaydangky'] ?? "",

      attended: j['diemdanhqr'] ?? false,
      attendanceTime: j['thoigiandiemdanh'],

      canCancel: j['canCancel'] ?? false,

      status: j['status'] ?? "",
      statusColor: j['statusColor'] ?? "",
      statusLabel: j['statusLabel'] ?? "",
    );
  }
}
