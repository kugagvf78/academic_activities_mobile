import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SectionTag extends StatelessWidget {
  final String label;
  final Color? color;
  final bool bgColor;
  final double? borderRadius;
  final IconData? icon;

  const SectionTag({
    super.key,
    required this.label,
    this.color,
    this.bgColor = false,
    this.borderRadius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final mainColor = color ?? Colors.blue[700]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor ? mainColor.withValues(alpha: 0.15) : Colors.transparent,
        border: Border.all(color: mainColor, width: 1),
        borderRadius: BorderRadius.circular(borderRadius ?? 50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            FaIcon(icon, size: 17, color: mainColor),
            const SizedBox(width: 10),
          ],
          Flexible(
            // ✅ cho phép xuống dòng nếu text dài
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: mainColor,
                letterSpacing: 1.2,
              ),
              overflow: TextOverflow
                  .visible, 
              softWrap: true, 
            ),
          ),
        ],
      ),
    );
  }
}
