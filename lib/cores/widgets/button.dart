import 'package:flutter/material.dart';

/// 🔹 Button chính — Nút nền màu (Elevated)

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSmall;
  final double? borderRadius;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isSmall = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? 30);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2563EB),
                Color(0xFF0EA5E9),
              ],
            ),
            borderRadius: radius,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 14 : 22,
            vertical: isSmall ? 10 : 14,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,         // full width
            mainAxisAlignment: MainAxisAlignment.center, // 🔥 icon + text vào giữa
            children: [
              Icon(icon, color: Colors.white, size: isSmall ? 14 : 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmall ? 12 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 Button viền — Nút outline (Outlined)
class OutlineButtonCustom extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double? borderRadius;
  final bool bgColor; // 

  const OutlineButtonCustom({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
    this.borderRadius,
    this.bgColor = false, 
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = color ?? Colors.blue[700]!;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: baseColor),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: baseColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: baseColor, width: 1.3),
        backgroundColor: bgColor
            ? baseColor.withValues(alpha: 0.15) // 
            : Colors.white, //
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 30),
        ),
        foregroundColor: baseColor,
      ),
    );
  }
}

class DetailButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final bool isSmall;

  const DetailButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? Colors.blue[700];

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor,
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 14 : 22,
          vertical: isSmall ? 8 : 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 🔹 Bo góc nhỏ hơn
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 12 : 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, size: isSmall ? 12 : 16, color: Colors.white),
        ],
      ),
    );
  }
}
