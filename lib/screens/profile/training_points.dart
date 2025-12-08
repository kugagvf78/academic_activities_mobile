import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
import 'package:academic_activities_mobile/models/DiemRenLuyen.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrainingPointsScreen extends StatefulWidget {
  final DiemRenLuyen? diemRenLuyen;

  const TrainingPointsScreen({super.key, required this.diemRenLuyen});

  @override
  State<TrainingPointsScreen> createState() => _TrainingPointsScreenState();
}

class _TrainingPointsScreenState extends State<TrainingPointsScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardsController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late List<Animation<double>> _cardFades;
  late List<Animation<Offset>> _cardSlides;

  @override
  void initState() {
    super.initState();

    // Header animation
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // Cards animation
    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final details = widget.diemRenLuyen?.details ?? [];
    final cardCount = details.length + 1; // +1 for overview cards

    _cardFades = List.generate(cardCount, (index) {
      final start = index * 0.1;
      final end = start + 0.4;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _cardsController,
          curve: Interval(start.clamp(0.0, 0.6), end.clamp(0.1, 1.0),
              curve: Curves.easeOut),
        ),
      );
    });

    _cardSlides = List.generate(cardCount, (index) {
      final start = index * 0.1;
      final end = start + 0.4;
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _cardsController,
          curve: Interval(start.clamp(0.0, 0.6), end.clamp(0.1, 1.0),
              curve: Curves.easeOutCubic),
        ),
      );
    });

    _headerController.forward();
    _cardsController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.diemRenLuyen?.base ?? 0;
    final bonus = widget.diemRenLuyen?.bonus ?? 0;
    final total = widget.diemRenLuyen?.finalScore ?? 0;
    final details = widget.diemRenLuyen?.details ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBarWidget(
        title: "Điểm Rèn Luyện",
        action: IconButton(
          icon: const Icon(Icons.home_rounded, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigation.changeTab(0);
          },
        ),
      ),
      body: details.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _headerFade,
                    child: SlideTransition(
                      position: _headerSlide,
                      child: _header(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAnimatedCard(
                    index: 0,
                    child: _buildOverview(base, bonus, total),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _headerFade,
                    child: const Text(
                      "Chi tiết điểm cộng",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...details.asMap().entries.map((entry) {
                    return _buildAnimatedCard(
                      index: entry.key + 1,
                      child: _buildDetailCard(entry.value),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildAnimatedCard({required int index, required Widget child}) {
    if (index >= _cardFades.length) return child;

    return FadeTransition(
      opacity: _cardFades[index],
      child: SlideTransition(
        position: _cardSlides[index],
        child: child,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.chartLine,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Chưa có điểm rèn luyện",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tham gia hoạt động để tích lũy điểm!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Điểm rèn luyện",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
              letterSpacing: -0.5,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Export PDF logic
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.download,
                      size: 13,
                      color: Colors.white,
                    ),
                    SizedBox(width: 7),
                    Text(
                      "Xuất PDF",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(int base, int bonus, int total) {
    return Row(
      children: [
        Expanded(
          child: _box(
            "Điểm cơ bản",
            base.toString(),
            const Color(0xFF3B82F6),
            const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _box(
            "Điểm cộng thêm",
            "+$bonus",
            const Color(0xFF10B981),
            const Color(0xFF059669),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _box(
            "Tổng điểm",
            total.toString(),
            const Color(0xFFA855F7),
            const Color(0xFF9333EA),
          ),
        ),
      ],
    );
  }

  Widget _box(String label, String value, Color c1, Color c2) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: 0.9 + (scale * 0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c1, c2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: c1.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(DiemRLDetail d) {
    final color = getColorByType(d.loai);
    final icon = getIconByType(d.loai);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: FaIcon(icon, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.calendar,
                            size: 11,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            d.dateFormatted,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: color.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              d.loai,
                              style: TextStyle(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "+${d.diem.toStringAsFixed(1)}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Detail Section
          _buildDetailSection(d, color),
        ],
      ),
    );
  }

  Widget _buildDetailSection(DiemRLDetail d, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.03),
        border: Border(
          top: BorderSide(color: color.withOpacity(0.1), width: 1),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailLine(
            icon: FontAwesomeIcons.tag,
            label: "Hoạt động",
            value: d.title,
            color: color,
          ),
          _detailLine(
            icon: FontAwesomeIcons.list,
            label: "Loại",
            value: d.loai,
            color: color,
          ),
          _detailLine(
            icon: FontAwesomeIcons.clock,
            label: "Thời gian",
            value: d.dateFormatted,
            color: color,
          ),
          if (d.chiTiet?["dia_diem"] != null)
            _detailLine(
              icon: FontAwesomeIcons.mapMarkerAlt,
              label: "Địa điểm",
              value: d.chiTiet?["dia_diem"] ?? "",
              color: color,
            ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FaIcon(
                  FontAwesomeIcons.infoCircle,
                  size: 13,
                  color: color.withOpacity(0.7),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    d.mota,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailLine({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: FaIcon(icon, size: 11, color: color),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData getIconByType(String loai) {
    switch (loai.toLowerCase()) {
      case "đạt giải":
      case "dat giai":
        return FontAwesomeIcons.award;
      case "hỗ trợ":
      case "ho tro":
        return FontAwesomeIcons.handsHelping;
      case "dự thi":
      case "du thi":
        return FontAwesomeIcons.userGraduate;
      case "tham dự":
      case "tham du":
        return FontAwesomeIcons.calendarCheck;
      default:
        return FontAwesomeIcons.circleInfo;
    }
  }

  Color getColorByType(String loai) {
    switch (loai.toLowerCase()) {
      case "đạt giải":
      case "dat giai":
        return const Color(0xFFF59E0B);
      case "hỗ trợ":
      case "ho tro":
        return const Color(0xFF7C3AED);
      case "dự thi":
      case "du thi":
        return const Color(0xFF16A34A);
      case "tham dự":
      case "tham du":
        return const Color(0xFF2563EB);
      default:
        return Colors.grey.shade600;
    }
  }
}