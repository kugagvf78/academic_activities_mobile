import 'package:flutter/material.dart';

class LabeledInput extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? icon;
  final Function(String)? onChanged;
  final bool required;
  final TextEditingController? controller;
  final bool enabled; // ← THÊM PARAMETER NÀY

  const LabeledInput({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.onChanged,
    this.required = true,
    this.controller,
    this.enabled = true, // ← DEFAULT = TRUE
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LABEL + OPTIONAL *
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
                fontSize: 16,
              ),
            ),

            if (required) ...[
              const SizedBox(width: 4),
              const Text(
                "*",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 6),

        // INPUT
        TextField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled, // ← SỬ DỤNG ENABLED
          style: TextStyle(
            fontSize: 16,
            color: enabled ? const Color(0xFF111827) : Colors.grey.shade500, // ← ĐỔI MÀU KHI DISABLED
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),

            prefixIcon: icon != null
                ? Icon(
                    icon, 
                    size: 20, 
                    color: enabled ? Colors.grey.shade500 : Colors.grey.shade400, // ← ĐỔI MÀU ICON
                  )
                : null,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            // ← THÊM STYLE CHO DISABLED
            filled: !enabled,
            fillColor: !enabled ? Colors.grey.shade100 : null,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.4,
              ),
            ),
            disabledBorder: OutlineInputBorder( // ← THÊM BORDER CHO DISABLED
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}