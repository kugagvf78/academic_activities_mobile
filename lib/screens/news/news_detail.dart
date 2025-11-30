import 'package:academic_activities_mobile/cores/widgets/custom_sliver_appbar.dart';
import 'package:academic_activities_mobile/models/TinTuc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewsDetailScreen extends StatelessWidget {
  final TinTuc news;
  final List<TinTuc> related;

  const NewsDetailScreen({
    super.key,
    required this.news,
    this.related = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeroSection(context),

          // 🔥 Nội dung
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildMainContent(context),
            ),
          ),
        ],
      ),
    );
  }

  // 🌟 SLIVER HERO
  Widget _buildHeroSection(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,

      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final bool collapsed =
              constraints.biggest.height <=
              kToolbarHeight + MediaQuery.of(context).padding.top;

          return Stack(
            fit: StackFit.expand,
            children: [
              // 🟦 Lớp trắng đảm bảo màu không bị ảnh hưởng
              Container(color: Colors.white),

              // 🖼 Ảnh nền CHỈ hiển thị khi chưa collapsed
              AnimatedOpacity(
                opacity: collapsed ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: Image.network(
                  news.hinhAnh ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    "assets/images/home/banner1.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              AnimatedOpacity(
                opacity: collapsed ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: Container(color: Colors.black.withOpacity(0.25)),
              ),

              AnimatedOpacity(
                opacity: collapsed ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Container(color: const Color.fromARGB(255, 44, 98, 212)),
              ),

              // 📌 FlexibleSpaceBar – hiện title lúc collapsed
              FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(bottom: 16),
                title: collapsed
                    ? Text(
                        news.tieuDe ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                centerTitle: true,
              ),
            ],
          );
        },
      ),

      // Back button
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Share button
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  // 📰 MAIN CONTENT
  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoHeader(),
        const SizedBox(height: 18),
        _buildArticleImage(),
        const SizedBox(height: 18),
        _buildContent(),
        const SizedBox(height: 20),
        _buildShareSection(),
        const SizedBox(height: 20),
        _buildBackButton(context),
        const SizedBox(height: 30),
        if (related.isNotEmpty) _buildRelatedNews(),
      ],
    );
  }


  // 🏷 INFO HEADER (category – views – date – author)
  Widget _buildInfoHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category + view
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                news.loaiTin ?? "Tin tức",
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                const Icon(Icons.remove_red_eye, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "${news.luotXem ?? 0} lượt xem",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 14),

        Text(
          news.tieuDe ?? "",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            const Icon(Icons.calendar_today, size: 14, color: Colors.blue),
            const SizedBox(width: 6),
            Text(news.ngayDang ?? ""),
            const SizedBox(width: 20),
            const Icon(Icons.person, size: 14, color: Colors.grey),
            const SizedBox(width: 6),
            Text(news.tacGia ?? "Không rõ"),
          ],
        ),
      ],
    );
  }

  // 🌄 ARTICLE IMAGE (ảnh chính bài viết)
  Widget _buildArticleImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        news.hinhAnh ?? "",
        errorBuilder: (_, __, ___) =>
            Image.asset("assets/images/home/banner1.jpg", fit: BoxFit.cover),
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  // ✍️ CONTENT
  Widget _buildContent() {
    return Text(
      news.noiDung ?? "",
      style: const TextStyle(
        fontSize: 15,
        height: 1.55,
        color: Color(0xFF374151),
      ),
    );
  }

  // 📤 SHARE
  Widget _buildShareSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 30),
        const Text(
          "Chia sẻ bài viết",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            _shareButton(FontAwesomeIcons.facebookF, Colors.blue),
            const SizedBox(width: 12),
            _shareButton(FontAwesomeIcons.twitter, Colors.lightBlue),
            const SizedBox(width: 12),
            _shareButton(Icons.link, Colors.grey.shade700),
          ],
        ),
      ],
    );
  }

  Widget _shareButton(icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }

  // 🔙 Back
  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(
          child: Text(
            "← Quay lại danh sách",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  // 📰 Related
  Widget _buildRelatedNews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tin tức liên quan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),

        ...related.map((item) => _relatedCard(item)),
      ],
    );
  }

  Widget _relatedCard(TinTuc item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/images/home/banner1.jpg",
              width: 65,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.tieuDe ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
