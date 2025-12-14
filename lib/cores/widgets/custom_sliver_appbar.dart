import 'package:academic_activities_mobile/screens/navigation.dart';
import 'package:flutter/material.dart';

class CustomHeroSliverAppBar extends StatelessWidget {
  final String title;
  final String? description;
  final String imagePath;
  final String? statusText;
  final double? height;
  final Color? statusColor;
  final List<Widget> metaItems;
  final Widget? action;

  const CustomHeroSliverAppBar({
    super.key,
    required this.title,
    required this.imagePath,
    required this.metaItems,
    this.description,
    this.height,
    this.statusText,
    this.statusColor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final double calculatedHeight = height ?? _calculateDynamicHeight(context);

    return SliverAppBar(
      expandedHeight: calculatedHeight,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      backgroundColor: Colors.blue[700],
      elevation: 0,

      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double currentHeight = constraints.biggest.height;
          final double minHeight =
              kToolbarHeight + MediaQuery.of(context).padding.top;
          final bool collapsed = currentHeight <= minHeight + 20;

          return FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: EdgeInsets.only(
              bottom: 16,
              top: MediaQuery.of(context).padding.top,
            ),

            title: AnimatedOpacity(
              opacity: collapsed ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            background: _buildBackground(context),
          );
        },
      ),

      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      actions: [
  IconButton(
    icon: const Icon(Icons.home_rounded, color: Colors.white),
    onPressed: () {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigation.changeTab(0);
    },
  ),
  if (action != null)
    Padding(
      padding: const EdgeInsets.only(right: 12),
      child: action!,
    ),
  const SizedBox(width: 6),
],
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          color: Colors.black.withOpacity(0.6),
          colorBlendMode: BlendMode.darken,
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

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (statusText != null) _buildStatusTag(),
                const SizedBox(height: 16),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                if (description != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    description!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                Wrap(spacing: 16, runSpacing: 8, children: metaItems),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTag() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: statusColor?.withOpacity(0.3) ?? Colors.white24,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: statusColor ?? Colors.white, width: 1.6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(radius: 4, backgroundColor: Colors.white),
            const SizedBox(width: 6),
            Text(
              statusText!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateDynamicHeight(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width - 48;

    double total = safeTop + 24;

    final titlePainter = TextPainter(
      text: TextSpan(
        text: title,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      maxLines: 10,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);

    total += titlePainter.height + 10;

    if (statusText != null) {
      total += 40;
    }

    if (description != null && description!.isNotEmpty) {
      final descPainter = TextPainter(
        text: TextSpan(
          text: description!,
          style: const TextStyle(fontSize: 15, height: 1.4),
        ),
        maxLines: 10,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: width);

      total += descPainter.height + 10;
    }

    if (metaItems.isNotEmpty) {
      int itemsPerRow = (width / 150).floor().clamp(1, 5);
      int rows = (metaItems.length / itemsPerRow).ceil();

      total += rows * 36 + 10;
    }

    total += 24;

    return total.clamp(280.0, 620.0);
  }
}
