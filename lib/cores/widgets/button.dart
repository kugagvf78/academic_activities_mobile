import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// 🔹 Button chính — Nút nền màu (Elevated)
class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final bool isSmall;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: isSmall ? 12 : 16, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(
          fontSize: isSmall ? 12 : 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.blue[700],
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 14 : 22,
          vertical: isSmall ? 8 : 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 2,
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

  const OutlineButtonCustom({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: color ?? Colors.blue[700]),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.blue[700],
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color ?? Colors.blue[700]!, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        foregroundColor: color ?? Colors.blue[700],
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
          Icon(
            icon,
            size: isSmall ? 12 : 16,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}