import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomHeroSliverAppBar extends StatelessWidget {
  final String title;
  final String? description;
  final String imagePath;
  final String? statusText;
  final double height;
  final Color? statusColor;
  final List<Widget> metaItems;

  final Widget? action; 

  const CustomHeroSliverAppBar({
    super.key,
    required this.title,
    required this.imagePath,
    required this.metaItems,
    this.description,
    required this.height,
    this.statusText,
    this.statusColor,
    this.action, 
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: height,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.blue[700],

      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
      ),

      centerTitle: true,

      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          bool collapsed = constraints.biggest.height <= kToolbarHeight + 30;

          return FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            centerTitle: true,
            title: collapsed ? null : Container(),
            background: _buildBackground(context),
          );
        },
      ),

      leading: Container(
        margin: const EdgeInsets.only(left: 12),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      actions: action != null
          ? [
              Container(
                margin: const EdgeInsets.only(right: 12),
                child: action!,
              )
            ]
          : null,
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

        Container(color: Colors.black.withOpacity(0.15)),

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
                    height: 1.2,
                  ),
                ),

                if (description != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    description!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                      height: 1.6,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: metaItems,
                ),
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
          border: Border.all(
            color: statusColor ?? Colors.white,
            width: 1.6,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              statusText!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
