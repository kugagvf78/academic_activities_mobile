import 'package:flutter/material.dart';

class SectionTag extends StatelessWidget {
  final String label;
  final Color? color;

  const SectionTag({
    super.key,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final mainColor = color ?? Colors.blue[700]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: mainColor, width: 1.5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: mainColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
