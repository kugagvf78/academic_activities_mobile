import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:academic_activities_mobile/services/profile_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class SubmitExamScreen extends StatefulWidget {
  final String id;
  final String loaiDangKy;
  final Map<String, dynamic> examData;

  const SubmitExamScreen({
    super.key,
    required this.id,
    required this.loaiDangKy,
    required this.examData,
  });

  @override
  State<SubmitExamScreen> createState() => _SubmitExamScreenState();
}

class _SubmitExamScreenState extends State<SubmitExamScreen> {
  File? selectedFile;
  bool submitting = false;

  late DateTime start;
  late DateTime end;
  late DateTime deadline;

  Timer? countdownTimer;
  Duration remaining = Duration.zero;

  @override
  void initState() {
    super.initState();

    DateTime parseLocal(String dt) {
      return DateTime.parse(dt.replaceAll("+07", ""));
    }

    start = parseLocal(widget.examData["thoigianbatdau"]);
    end = parseLocal(widget.examData["thoigianketthuc"]);
    deadline = end;

    _startCountdown();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  // =====================================================
  //                 COUNTDOWN (REALTIME)
  // =====================================================
  void _startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        remaining = deadline.difference(DateTime.now());
      });
    });
  }

  String formatRemaining() {
    if (remaining.isNegative) return "ĐÃ HẾT HẠN";

    int days = remaining.inDays;
    int hours = remaining.inHours % 24;
    int minutes = remaining.inMinutes % 60;
    int seconds = remaining.inSeconds % 60;

    if (days > 0) {
      return "$days ngày ${hours.toString().padLeft(2, '0')}:"
          "${minutes.toString().padLeft(2, '0')}:"
          "${seconds.toString().padLeft(2, '0')}";
    }

    return "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  // =====================================================
  //                   PICK FILE
  // =====================================================
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'doc', 'docx', 'zip', 'rar'],
      type: FileType.custom,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  // =====================================================
  //                   SUBMIT EXAM
  // =====================================================
  Future<void> submitExam() async {
    if (selectedFile == null) return;

    setState(() => submitting = true);

    final result = await ProfileService().submitExam(
      id: widget.id,
      loaiDangKy: widget.loaiDangKy,
      file: selectedFile!,
    );

    setState(() => submitting = false);

    if (!mounted) return;

    if (result["success"] == true) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Thành công"),
          content: const Text("Nộp bài thi thành công!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"] ?? "Lỗi nộp bài")),
      );
    }
  }

  // =====================================================
  //                        UI
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final exam = widget.examData;
    final isTeam = widget.loaiDangKy == "DoiNhom";

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBarWidget(
        title: "Đăng Ký Dự Thi",
        action: IconButton(
          icon: const Icon(Icons.home_rounded, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigation.changeTab(0);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ==================== HEADER CARD (ĐẸP NHƯ WEB) ====================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1D4ED8),
                    Color(0xFF172554),
                  ], // blue-700 → blue-900
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên cuộc thi
                  Text(
                    exam["tencuocthi"] ?? "Cuộc thi",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Loại thi
                  Row(
                    children: [
                      Icon(
                        isTeam ? Icons.groups : Icons.person,
                        color: Colors.blue.shade200,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isTeam
                            ? "Đội thi: ${exam["tendoithi"] ?? ''}"
                            : "Thi cá nhân",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue.shade100,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Hạn nộp bài
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: double.infinity, // 👉 FULL WIDTH
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Hạn nộp bài",
                                  style: TextStyle(
                                    color: Colors.blue.shade200,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  DateFormat("dd/MM/yyyy").format(deadline),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  DateFormat("HH:mm").format(deadline),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Timeline - 3 cột đều nhau, KHÔNG BỊ TRÀN
                  Row(
                    children: [
                      Expanded(
                        child: _timelineItem(
                          "Bắt đầu",
                          FontAwesomeIcons.calendarCheck,
                          start,
                          Colors.blue.shade600,
                        ),
                      ),

                      Expanded(
                        child: _timelineItem(
                          "Kết thúc",
                          FontAwesomeIcons.flagCheckered,
                          end,
                          Colors.blue.shade600,
                        ),
                      ),

                      Expanded(child: _countdownItem()),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================== ĐỀ THI (nếu có) ====================
            if (exam["tendethi"] != null) _examFileCard(exam),

            const SizedBox(height: 20),

            // ==================== FORM NỘP BÀI + HƯỚNG DẪN ====================
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _guideCard(),

                const SizedBox(height: 20),

                _submitFormCard(),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _timelineItem(
    String label,
    IconData icon,
    DateTime dt,
    Color bgColor,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue.shade200,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          DateFormat("dd/MM/yyyy").format(dt),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          DateFormat("HH:mm").format(dt),
          style: TextStyle(fontSize: 13, color: Colors.blue.shade200),
        ),
      ],
    );
  }

  Widget _countdownItem() {
    final expired = remaining.isNegative;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: expired ? Colors.red.shade600 : Colors.yellow.shade600,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.access_time, color: Colors.white, size: 24),
        ),

        const SizedBox(height: 8),

        Text(
          "Còn lại",
          style: TextStyle(fontSize: 12, color: Colors.blue.shade200),
        ),

        const SizedBox(height: 6),

        Text(
          formatRemaining(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: expired ? Colors.red.shade300 : Colors.yellow.shade300,
          ),
        ),
      ],
    );
  }

  Widget _examFileCard(dynamic exam) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: const Icon(
              Icons.picture_as_pdf,
              size: 36,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam["tendethi"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (exam["thoigianlambai"] != null)
                  Text(
                    "Thời gian: ${exam["thoigianlambai"]} phút",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                if (exam["diemtoida"] != null)
                  Text(
                    "Điểm tối đa: ${exam["diemtoida"]}",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download),
            label: const Text("Tải đề"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.upload, size: 32, color: Colors.green),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Khu vực nộp bài",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Chỉ được nộp một lần duy nhất",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Upload zone
          GestureDetector(
            onTap: pickFile,
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedFile == null
                      ? Colors.grey.shade300
                      : Colors.green,
                  width: 3,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(20),
                color: selectedFile == null
                    ? Colors.grey.shade50
                    : Colors.green.shade50,
              ),
              child: Center(
                child: selectedFile == null
                    ? Column(
                        children: [
                          Icon(
                            Icons.cloud_upload,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Kéo thả hoặc chọn file",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "PDF, DOC, DOCX, ZIP, RAR \n Tối đa 10MB",
                            style: TextStyle(color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 80,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            selectedFile!.path.split('/').last,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${(selectedFile!.lengthSync() / 1024 / 1024).toStringAsFixed(2)} MB",
                          ),
                          TextButton(
                            onPressed: () =>
                                setState(() => selectedFile = null),
                            child: const Text(
                              "Xóa file",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Cảnh báo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB), // vàng nhạt premium
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFACC15), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFD97706),
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Cảnh báo & Quy định nộp bài",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFD97706),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "• Bạn chỉ được nộp bài **1 lần duy nhất**.",
                  style: TextStyle(fontSize: 15),
                ),
                const Text(
                  "• Sau khi nộp sẽ **không thể sửa đổi**.",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "• Hạn chót: ${DateFormat("dd/MM/yyyy HH:mm").format(deadline)}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: submitting || selectedFile == null ? null : submitExam,
              icon: const Icon(Icons.send),
              label: Text(
                submitting ? "Đang nộp..." : "Nộp bài thi",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _guideCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              children: const [
                Icon(Icons.menu_book_rounded, color: Colors.white, size: 30),
                SizedBox(width: 12),
                Text(
                  "Hướng dẫn nộp bài thi",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _guideItem("Tải đề thi và hoàn thành bài làm theo yêu cầu."),
                _guideItem("Lưu bài làm dưới dạng PDF hoặc ZIP/RAR."),
                _guideItem("Đặt tên file rõ ràng theo cú pháp hệ thống."),
                _guideItem("Kéo thả hoặc chọn file để tải lên."),
                _guideItem("Kiểm tra kỹ nội dung trước khi nộp."),
                _guideItem("Nhấn nút Nộp bài thi và xác nhận."),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(22),
              ),
            ),
            child: const Text(
              "⚠️ Lưu ý: Hệ thống chỉ cho phép nộp bài 1 lần duy nhất.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _guideItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
