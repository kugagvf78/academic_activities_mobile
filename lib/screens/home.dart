import 'package:academic_activities_mobile/models/CuocThi.dart';
import 'package:academic_activities_mobile/screens/events/event_detail.dart';
import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:academic_activities_mobile/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:academic_activities_mobile/cores/widgets/button.dart';
import 'package:academic_activities_mobile/cores/widgets/section_tag.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentBanner = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final EventService _eventService = EventService();
  List<CuocThi> upcomingEvents = [];
  bool _loadingEvents = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> banners = [
    'assets/images/home/banner1.jpg',
    'assets/images/home/banner2.jpg',
    'assets/images/home/banner3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadUpcomingEvents();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadUpcomingEvents() async {
    try {
      final events = await _eventService.getEvents();
      final now = DateTime.now();

      final filtered = events.where((e) {
        if (e.thoiGianBatDau == null) return false;
        final start = DateTime.tryParse(e.thoiGianBatDau!);
        if (start == null) return false;
        return start.isAfter(now);
      }).toList();

      filtered.sort(
        (a, b) => DateTime.parse(
          a.thoiGianBatDau!,
        ).compareTo(DateTime.parse(b.thoiGianBatDau!)),
      );

      setState(() {
        upcomingEvents = filtered.take(2).toList();
        _loadingEvents = false;
      });
    } catch (e) {
      setState(() {
        _loadingEvents = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // 🎨 Banner với overlay gradient đẹp hơn
          _buildModernBanner(size),

          // 🎓 Hero Section với animation
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, const Color(0xFFF0F9FF), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  _buildHeroSection(),
                  _buildStatsSection(),
                  _buildFeaturedEvents(),
                  _buildFeatureShowcase(),
                  _buildAchievementsSection(),
                  _buildContactSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBanner(Size size) {
    return SafeArea(
      bottom: false, // không cần chừa khoảng dưới
      child: Container(
        height: size.height * 0.30, // giảm từ 0.38 xuống 0.30 cho đẹp hơn
        margin: const EdgeInsets.only(top: 8), // tạo khoảng thở
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                0,
              ), // để flat nếu muốn bo viền sau
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: size.height * 0.30,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 900),
                  autoPlayCurve: Curves.easeInOutCubic,
                  onPageChanged: (index, _) =>
                      setState(() => _currentBanner = index),
                ),
                items: banners.map((path) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(path, fit: BoxFit.cover, width: size.width),

                      // Gradient overlay mềm mại hơn
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.15),
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.35),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            // Indicator
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: banners.asMap().entries.map((e) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    width: _currentBanner == e.key ? 26 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _currentBanner == e.key
                          ? Colors.white
                          : Colors.white.withOpacity(0.35),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      child: Column(
        children: [
          // Tag nổi bật
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.bolt,
                    color: Color(0xFFFBBF24),
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Khám phá • Học hỏi • Tỏa sáng",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Tiêu đề chính
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF06B6D4)],
            ).createShader(bounds),
            child: const Text(
              "Cuộc thi Học thuật",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Phụ đề
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Dành cho sinh viên CNTT",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                letterSpacing: 0.2,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Mô tả
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Tham gia các cuộc thi học thuật, hội thảo và hoạt động chuyên môn để nâng cao kỹ năng, kết nối cộng đồng và khẳng định bản lĩnh sinh viên Công nghệ Thông tin.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.6,
                letterSpacing: 0.1,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Buttons
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        try {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigation.changeTab(2);
                        } catch (e) {
                          // Fallback nếu Navigation chưa được setup
                          debugPrint('Navigation error: $e');
                        }
                      },
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.trophy,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Xem cuộc thi",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF3B82F6),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        try {
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigation.changeTab(2);
                        } catch (e) {
                          debugPrint('Navigation error: $e');
                        }
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.circleInfo,
                              color: Color(0xFF3B82F6),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Tìm hiểu",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3B82F6),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E40AF).withOpacity(0.05),
            const Color(0xFF3B82F6).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            "15+",
            "Cuộc thi",
            FontAwesomeIcons.trophy,
            const Color(0xFF3B82F6),
          ),
          _buildStatItem(
            "500+",
            "Sinh viên",
            FontAwesomeIcons.userGraduate,
            const Color(0xFF06B6D4),
          ),
          _buildStatItem(
            "50+",
            "Giải thưởng",
            FontAwesomeIcons.award,
            const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedEvents() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Sự kiện nổi bật",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Sắp diễn ra",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Events
          _loadingEvents
              ? const Center(child: CircularProgressIndicator())
              : upcomingEvents.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: upcomingEvents
                      .map((e) => _buildEventCard(e))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEventCard(CuocThi e) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background image
            Image.asset(
              "assets/images/patterns/event_pattern2.jpg",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      e.tenCuocThi ?? "Cuộc thi",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.3,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Date
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _formatDate(e.thoiGianBatDau),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const Spacer(),
                        DetailButton(
                          label: "Xem chi tiết",
                          icon: FontAwesomeIcons.arrowRight,
                          isSmall: true,
                          color: const Color(0xFF3B82F6),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailScreen(id: e.maCuocThi!),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.calendarDays,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "Chưa có sự kiện sắp diễn ra",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureShowcase() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      child: Column(
        children: [
          // Header
          const Text(
            "Tính năng dành cho bạn",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Trải nghiệm đầy đủ các tính năng\nđể tham gia cuộc thi hiệu quả nhất",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),

          const SizedBox(height: 40),

          // Main features
          _buildMainFeature(
            icon: FontAwesomeIcons.trophy,
            title: "Đăng ký cuộc thi dễ dàng",
            description:
                "Tìm kiếm và đăng ký tham gia các cuộc thi chỉ với vài thao tác đơn giản",
            gradient: [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
          ),

          const SizedBox(height: 16),

          _buildMainFeature(
            icon: FontAwesomeIcons.clockRotateLeft,
            title: "Theo dõi tiến trình & lịch thi",
            description:
                "Cập nhật lịch trình, nhận thông báo và quản lý thời gian thi cử hiệu quả",
            gradient: [const Color(0xFF06B6D4), const Color(0xFF0891B2)],
          ),

          const SizedBox(height: 16),

          _buildMainFeature(
            icon: FontAwesomeIcons.award,
            title: "Nhận chứng nhận & thành tích",
            description:
                "Lưu trữ chứng chỉ điện tử và xây dựng hồ sơ thành tích học thuật",
            gradient: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
          ),

          const SizedBox(height: 40),

          // Secondary features grid
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.15,
            children: [
              _buildSecondaryFeature(
                icon: FontAwesomeIcons.bell,
                title: "Thông báo\ntức thì",
                colors: [const Color(0xFFEF4444), const Color(0xFFDC2626)],
              ),
              _buildSecondaryFeature(
                icon: FontAwesomeIcons.chartLine,
                title: "Thống kê\nkết quả",
                colors: [const Color(0xFF10B981), const Color(0xFF059669)],
              ),
              _buildSecondaryFeature(
                icon: FontAwesomeIcons.star,
                title: "Bảng xếp\nhạng",
                colors: [const Color(0xFFF59E0B), const Color(0xFFD97706)],
              ),
              _buildSecondaryFeature(
                icon: FontAwesomeIcons.users,
                title: "Cộng đồng\nCNTT",
                colors: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainFeature({
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.2,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryFeature({
    required IconData icon,
    required String title,
    required List<Color> colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: colors[0].withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E40AF).withOpacity(0.08),
            const Color(0xFF06B6D4).withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Thành tích nổi bật",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAchievementItem(
                'assets/images/home/seminar.png',
                "150+",
                "Hội thảo",
                const Color(0xFF3B82F6),
              ),
              _buildAchievementItem(
                'assets/images/home/student.png',
                "2.5K+",
                "Sinh viên",
                const Color(0xFF06B6D4),
              ),
              _buildAchievementItem(
                'assets/images/home/teacher.png',
                "80+",
                "Giảng viên",
                const Color(0xFF8B5CF6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
    String image,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset(image, width: 40, height: 40, fit: BoxFit.contain),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            FontAwesomeIcons.envelopeOpenText,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 20),
          const Text(
            "Liên hệ với chúng tôi",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Khoa Công nghệ Thông tin\nTrường Đại học Công Thương TP.HCM",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.95),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),

          // Contact items
          _buildContactItem(
            icon: FontAwesomeIcons.locationDot,
            text: "140 Lê Trọng Tấn, Tân Phú, TP. HCM",
          ),
          const SizedBox(height: 14),
          _buildContactItem(
            icon: FontAwesomeIcons.phone,
            text: "+84 (28) 3816 5673",
          ),
          const SizedBox(height: 14),
          _buildContactItem(
            icon: FontAwesomeIcons.envelope,
            text: "cntt@huit.edu.vn",
          ),

          const SizedBox(height: 28),

          // Social icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(FontAwesomeIcons.facebookF),
              const SizedBox(width: 12),
              _buildSocialButton(FontAwesomeIcons.youtube),
              const SizedBox(width: 12),
              _buildSocialButton(FontAwesomeIcons.instagram),
              const SizedBox(width: 12),
              _buildSocialButton(FontAwesomeIcons.linkedinIn),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Center(child: Icon(icon, color: Colors.white, size: 20)),
        ),
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null) return "--/--/----";
    try {
      final dt = DateTime.parse(raw);
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (_) {
      return raw;
    }
  }
}
