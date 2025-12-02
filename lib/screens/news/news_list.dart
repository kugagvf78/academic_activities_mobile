import 'package:academic_activities_mobile/cores/widgets/app_search_field.dart';
import 'package:academic_activities_mobile/cores/widgets/app_select_field.dart';
import 'package:academic_activities_mobile/models/TinTuc.dart';
import 'package:academic_activities_mobile/services/news_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'news_detail.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  final NewsService _newsService = NewsService();

  /// DATA
  List<TinTuc> news = [];
  List featured = [];
  Map stats = {};

  /// FILTERS
  String search = "";
  String selectedCategory = "Tất cả";
  String sort = "Mới nhất";

  bool loading = true;

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

    fetchNews();
  }

  Future<void> fetchNews() async {
    setState(() => loading = true);

    /// Map filter → api parameters
    String? apiCategory = {
      "Tất cả": "all",
      "Cuộc thi học thuật": "contest",
      "Thông báo chung": "announcement",
      "Hội thảo & Sự kiện": "seminar",
    }[selectedCategory];

    String? apiSort = {
      "Mới nhất": "newest",
      "Cũ nhất": "oldest",
      "Xem nhiều nhất": "popular",
    }[sort];

    final res = await _newsService.getNews(
      page: 1,
      search: search,
      category: apiCategory,
      sort: apiSort,
    );

    if (!mounted) return;

    if (res["success"]) {
      news = res["news"];
      featured = res["featured"];
      stats = res["stats"];

      loading = false;
      _fadeController.forward();
    } else {
      loading = false;
      print("Lỗi API: ${res["message"]}");
    }

    setState(() {});
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
          loading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : news.isEmpty
              ? _buildEmptyState()
              : _buildNewsList(),
        ],
      ),
    );
  }

  // 🌟 HERO SECTION
  Widget _buildHeroSection() {
    return SliverAppBar(
      expandedHeight: 345,
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
            style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat("${stats['total'] ?? 0}", "Tin tức"),
              const SizedBox(width: 28),
              _buildStat("${stats['this_month'] ?? 0}", "Tháng này"),
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
                search = value;
                fetchNews();
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
                      selectedCategory = v ?? "Tất cả";
                      fetchNews();
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
                      sort = v ?? "Mới nhất";
                      fetchNews();
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
        delegate: SliverChildBuilderDelegate(
          (context, i) => FadeTransition(
            opacity: _fadeAnimation,
            child: _buildNewsCard(news[i]),
          ),
          childCount: news.length,
        ),
      ),
    );
  }

  Widget _buildNewsCard(TinTuc item) {
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
          // IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: (item.hinhAnh == null || item.hinhAnh!.isEmpty)
                    ? Image.asset(
                        "assets/images/news_no_image.jpg",
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        item.hinhAnh!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          "assets/images/news_no_image.jpg",
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),

              // category
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    item.loaiTin ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
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
                Text(
                  item.tieuDe ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  (item.noiDung?.length ?? 0) > 120
                      ? item.noiDung!.substring(0, 120) + "..."
                      : (item.noiDung ?? ""),
                  maxLines: 3,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
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
                      _formatDate(item.ngayDang),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.person, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      item.tacGia ?? "Không rõ tác giả",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsDetailScreen(slug: item.maTinTuc!),
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
                      Icon(Icons.arrow_right_alt, color: Colors.blue, size: 18),
                    ],
                  ),
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

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return "";
    try {
      final dt = DateTime.parse(raw);
      return "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year}";
    } catch (e) {
      return raw; // fallback nếu lỗi
    }
  }
}
