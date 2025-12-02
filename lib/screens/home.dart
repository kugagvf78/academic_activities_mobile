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

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final EventService _eventService = EventService();
  List<CuocThi> upcomingEvents = [];
  bool _loadingEvents = true;

  final List<String> banners = [
    'assets/images/home/banner1.jpg',
    'assets/images/home/banner2.jpg',
    'assets/images/home/banner3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadUpcomingEvents();
  }

  Future<void> _loadUpcomingEvents() async {
    try {
      final events = await _eventService.getEvents();

      // Lọc sự kiện sắp diễn ra (chưa bắt đầu)
      final now = DateTime.now();

      final filtered = events.where((e) {
        if (e.thoiGianBatDau == null) return false;
        final start = DateTime.tryParse(e.thoiGianBatDau!);
        if (start == null) return false;
        return start.isAfter(now);
      }).toList();

      // Lấy 2 cái sớm nhất
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
      _loadingEvents = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // 🖼️ Banner
          SizedBox(
            height: size.height * 0.35,
            child: Stack(
              children: [
                CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: size.height * 0.35,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    onPageChanged: (index, _) =>
                        setState(() => _currentBanner = index),
                  ),
                  items: banners.map((path) {
                    return Image.asset(
                      path,
                      fit: BoxFit.cover,
                      width: size.width,
                    );
                  }).toList(),
                ),

                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: banners.asMap().entries.map((e) {
                      return GestureDetector(
                        onTap: () => _carouselController.jumpToPage(e.key),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentBanner == e.key ? 20 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _currentBanner == e.key
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // 🎓 Hero Section
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE3F2FD),
                  Colors.white,
                  Color.fromARGB(255, 247, 254, 255),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTag(),
                const SizedBox(height: 16),
                Text(
                  "Cuộc thi Học thuật",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1976D2),
                  ),
                ),
                Text(
                  "Dành cho sinh viên CNTT",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Tham gia các cuộc thi học thuật, hội thảo và hoạt động chuyên môn để nâng cao kỹ năng, kết nối cộng đồng và khẳng định bản lĩnh sinh viên Công nghệ Thông tin.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                _buildActionButtons(),
                const SizedBox(height: 30),
                _buildSmallStats(),
                const SizedBox(height: 40),
                _buildFeaturedTitle(),
                const SizedBox(height: 16),
                _loadingEvents
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: upcomingEvents
                            .map((e) => _buildUpcomingEventCard(e))
                            .toList(),
                      ),
                _buildAboutSection(),
                _buildBigStatsSection(),
                _buildContactSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.bolt, color: Colors.amber, size: 14),
            const SizedBox(width: 8),
            Text(
              "Khám phá – Học hỏi – Tỏa sáng cùng CNTT",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            label: "Xem cuộc thi",
            icon: FontAwesomeIcons.trophy,
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigation.changeTab(2);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlineButtonCustom(
            label: "Tìm hiểu thêm",
            icon: FontAwesomeIcons.circleInfo,
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigation.changeTab(2);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStat("15+", "Cuộc thi mỗi năm", Colors.blue[600]!),
        _buildStat("500+", "Sinh viên tham gia", Colors.cyan[600]!),
        _buildStat("50+", "Giải thưởng", Colors.indigo[600]!),
      ],
    );
  }

  Widget _buildStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildFeaturedTitle() {
    return Center(child: const SectionTag(label: "Sự kiện nổi bật"));
  }

  Widget _buildUpcomingEventCard(CuocThi e) {
    final img = "assets/images/patterns/event_pattern2.jpg"; 

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Ảnh đại diện cuộc thi
            Image.asset(
              img,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // Mờ nền
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Nội dung
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.tenCuocThi ?? "Cuộc thi",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white70,
                        size: 13,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(e.thoiGianBatDau),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    label: "Xem chi tiết",
                    icon: FontAwesomeIcons.arrowRight,
                    isSmall: true,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Center(
            child: const SectionTag(label: "Tính năng dành cho sinh viên"),
          ),
          const SizedBox(height: 16),
          Text(
            "Tham gia Cuộc thi Học thuật\nDễ dàng - Nhanh chóng - Hiệu quả",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1976D2),
            ),
          ),
          const SizedBox(height: 20),

          _buildFeatureCards(),
        ],
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Column(
      children: [
        // 3 thẻ chính
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _featureCardMain(
              icon: Icons.emoji_events_rounded,
              title: "Đăng ký cuộc thi dễ dàng",
              gradient: [Colors.blue[500]!, Colors.blue[700]!],
            ),
            _featureCardMain(
              icon: Icons.access_time_filled_rounded,
              title: "Theo dõi tiến trình & lịch thi",
              gradient: [Colors.cyan[500]!, Colors.cyan[700]!],
            ),
            _featureCardMain(
              icon: Icons.workspace_premium_rounded,
              title: "Nhận chứng nhận & thành tích",
              gradient: [Colors.indigo[500]!, Colors.indigo[700]!],
            ),
          ],
        ),
        const SizedBox(height: 40),

        // 4 thẻ phụ
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            _featureCardSecondary(
              icon: Icons.notifications_active_rounded,
              colors: [Colors.blue[500]!, Colors.cyan[500]!],
              title: "Thông báo tức thì",
            ),
            _featureCardSecondary(
              icon: Icons.menu_book_rounded,
              colors: [Colors.cyan[500]!, Colors.blue[500]!],
              title: "Xem lại kết quả & đề thi",
            ),
            _featureCardSecondary(
              icon: Icons.star_rounded,
              colors: [Colors.indigo[500]!, Colors.purple[500]!],
              title: "Vinh danh sinh viên xuất sắc",
            ),
            _featureCardSecondary(
              icon: Icons.school_rounded,
              colors: [Colors.purple[500]!, Colors.pink[400]!],
              title: "Phát triển kỹ năng học thuật",
            ),
          ],
        ),
      ],
    );
  }

  Widget _featureCardMain({
    required IconData icon,
    required String title,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _featureCardSecondary({
    required IconData icon,
    required List<Color> colors,
    required String title,
  }) {
    return Center(
      child: Container(
        width: 160,
        height: 150, // 👈 thêm chiều cao để cân đối & tránh overflow
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        // Căn giữa toàn bộ nội dung trong Container
        child: Column(
          mainAxisSize: MainAxisSize.min, // 👈 tránh bị kéo full chiều cao
          mainAxisAlignment:
              MainAxisAlignment.center, // 👈 căn giữa theo chiều dọc
          crossAxisAlignment: CrossAxisAlignment.center, // 👈 căn giữa ngang
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center, // 👈 căn giữa text luôn
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigStatsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBigStat("150+", "Hội thảo", 'assets/images/home/seminar.png'),
          _buildBigStat("2.5K+", "Sinh viên", 'assets/images/home/student.png'),
          _buildBigStat("80+", "Giảng viên", 'assets/images/home/teacher.png'),
        ],
      ),
    );
  }

  Widget _buildBigStat(String value, String label, String image) {
    return Expanded(
      // 👈 giúp 3 phần giãn đều
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(image, width: 35, height: 35, fit: BoxFit.contain),
          const SizedBox(height: 10),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Tiêu đề chính
          const Text(
            "Liên hệ với Khoa Công nghệ Thông tin",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Hãy liên hệ với chúng tôi để được hỗ trợ nhanh chóng về các cuộc thi, hội thảo và hoạt động học thuật.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),

          // 🔹 Thông tin liên hệ
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _contactItem(
                icon: Icons.location_on,
                title: "Địa chỉ",
                content:
                    "Khoa Công nghệ Thông tin\nTrường Đại học Công Thương TP.HCM\n140 Lê Trọng Tấn, Tân Phú, TP. HCM",
              ),
              const SizedBox(height: 20),
              _contactItem(
                icon: Icons.phone,
                title: "Điện thoại",
                content: "+84 (28) 3816 5673\n+84 (28) 3816 5674",
              ),
              const SizedBox(height: 20),
              _contactItem(
                icon: Icons.email_outlined,
                title: "Email",
                content: "cntt@huit.edu.vn\nhoithao.cntt@huit.edu.vn",
              ),
            ],
          ),

          const SizedBox(height: 30),

          // 🔹 Mạng xã hội
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Icons.facebook, Colors.blue[800]!),
              _socialIcon(Icons.linked_camera, Colors.cyan[700]!),
              _socialIcon(Icons.video_library_rounded, Colors.red[600]!),
              _socialIcon(Icons.camera_alt_rounded, Colors.purple[400]!),
            ],
          ),
        ],
      ),
    );
  }

  // --- item thông tin liên hệ ---
  Widget _contactItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        // Căn giữa toàn bộ nội dung trong Container
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.blue[700], size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- icon mạng xã hội ---
  Widget _socialIcon(IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null) return "--/--/----";
    try {
      final dt = DateTime.parse(raw);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (_) {
      return raw;
    }
  }
}
