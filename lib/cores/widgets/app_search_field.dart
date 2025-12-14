import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppSearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final double borderRadius;
  final TextEditingController? controller;

  const AppSearchField({
    super.key,
    this.hint = "Tìm kiếm...",
    this.onChanged,
    this.controller,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: "Tìm kiếm theo tên cuộc thi...",
          hintStyle: TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 14, right: 10, top: 1), // 👈 căn nhẹ
            child: Icon(
              Icons.search,
              size: 22,
              color: Color(0xFF6B7280),
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
