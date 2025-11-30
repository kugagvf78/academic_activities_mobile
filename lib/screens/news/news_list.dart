import 'package:academic_activities_mobile/cores/widgets/app_search_field.dart';
import 'package:academic_activities_mobile/cores/widgets/app_select_field.dart';
import 'package:academic_activities_mobile/models/TinTuc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'news_detail.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  // Fake data demo
  List<Map<String, dynamic>> news = [
    {
      "title": "Thông báo tuyển sinh lập trình mùa hè 2025",
      "excerpt":
          "Khóa học lập trình mùa hè dành cho sinh viên CNTT với nhiều ưu đãi...",
      "category": "Thông báo",
      "categoryColor": Colors.blue,
      "views": 123,
      "image": "assets/images/home/banner1.jpg",
      "date": "20/11/2025",
      "author": "Phòng Đào tạo",
      "event": "Cuộc thi Lập trình UIT 2025",
    },
    {
      "title": "Kết quả cuộc thi AI Hackathon 2025",
      "excerpt":
          "Cuộc thi AI Hackathon đã chính thức khép lại với những thành tích ấn tượng...",
      "category": "Cuộc thi",
      "categoryColor": Colors.red,
      "views": 982,
      "image": "assets/images/home/banner2.jpg",
      "date": "17/11/2025",
      "author": "CLB AI UIT",
      "event": null,
    },
  ];

  String search = "";
  String selectedCategory = "Tất cả";
  String sort = "Mới nhất";

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeroSection(),
          _buildFilterSection(),
          news.isEmpty ? _buildEmptyState() : _buildNewsList(),
        ],
      ),
    );
  }

  // 🌟 HERO SECTION
  Widget _buildHeroSection() {
    return SliverAppBar(
      expandedHeight: 335,
      elevation: 0,
      pinned: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          bool isCollapsed =
              constraints.biggest.height <= (kToolbarHeight + 20);

          return FlexibleSpaceBar(
            centerTitle: true,
            title: isCollapsed
                ? const Text(
                    "Tin tức & Thông báo",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/patterns/news_pattern.jpg',
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(240, 0, 132, 255),
                        Color.fromARGB(179, 27, 125, 204),
                      ],
                    ),
                  ),
                ),

                Container(color: Colors.black.withOpacity(0.20)),

                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: isCollapsed ? 0 : 1,
                  child: _buildHeroContent(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 90, 24, 40),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white.withOpacity(.2),
              border: Border.all(color: Colors.white.withOpacity(.3)),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.newspaper,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Tin tức & Thông báo",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Cập nhật các hoạt động, sự kiện, thông báo mới nhất của khoa CNTT.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat("25+", "Tin tức"),
              const SizedBox(width: 28),
              _buildStat("12", "Tháng này"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Column(
          children: [
            AppSearchField(
              hint: "Tìm kiếm tin tức...",
              onChanged: (value) {
                setState(() => search = value);
              },
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: AppSelectField(
                    value: selectedCategory,
                    hint: "Danh mục",
                    items: const [
                      "Tất cả",
                      "Cuộc thi học thuật",
                      "Thông báo chung",
                      "Hội thảo & Sự kiện",
                    ],
                    onChanged: (v) {
                      setState(() => selectedCategory = v ?? "Tất cả");
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppSelectField(
                    value: sort,
                    hint: "Sắp xếp",
                    items: const ["Mới nhất", "Cũ nhất", "Xem nhiều nhất"],
                    onChanged: (v) {
                      setState(() => sort = v ?? "Mới nhất");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 📰 NEWS LIST
  Widget _buildNewsList() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, i) {
          final item = news[i];

          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildNewsCard(item),
          );
        }, childCount: news.length),
      ),
    );
  }

  Widget _buildNewsCard(item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // IMAGE + CATEGORY
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  item["image"],
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Category badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: item["categoryColor"],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    item["category"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),

              // Views
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.85),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.remove_red_eye,
                        size: 13,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item["views"].toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // CONTENT
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  item["title"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),

                // Excerpt
                Text(
                  item["excerpt"],
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),

                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 13,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      item["date"],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.person, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      item["author"] ?? "Không rõ tác giả",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                if (item["event"] != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link, size: 14, color: Colors.blue),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item["event"],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "3 giờ trước",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    InkWell(
                      onTap: () {
                        final tin = TinTuc(
                          tieuDe: item["title"],
                          noiDung: item["excerpt"], // hoặc nội dung thật nếu có
                          hinhAnh: item["image"],
                          tacGia: item["author"],
                          luotXem: item["views"],
                          ngayDang: item["date"],
                          loaiTin: item["category"],
                        );

                        final relatedList = news.map((n) {
                          return TinTuc(
                            tieuDe: n["title"],
                            noiDung: n["excerpt"],
                            hinhAnh: n["image"],
                            tacGia: n["author"],
                            luotXem: n["views"],
                            ngayDang: n["date"],
                            loaiTin: n["category"],
                          );
                        }).toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewsDetailScreen(
                              news: tin,
                              related: relatedList,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: const [
                          Text(
                            "Xem thêm",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_right_alt,
                            color: Colors.blue,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FaIcon(
              FontAwesomeIcons.newspaper,
              size: 70,
              color: Color(0xFFB0BEC5),
            ),
            SizedBox(height: 12),
            Text(
              "Không có tin tức nào",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Hãy thử thay đổi bộ lọc.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
