import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final String label;
  final String hint;
  final Function(String)? onChanged;
  final bool required;
  final TextEditingController? controller;
  final bool enabled; // ← THÊM PARAMETER NÀY

  const PasswordInput({
    super.key,
    required this.label,
    required this.hint,
    this.onChanged,
    this.required = true,
    this.controller,
    this.enabled = true, // ← DEFAULT = TRUE
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LABEL + OPTIONAL *
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
                fontSize: 16,
              ),
            ),

            if (widget.required) ...[
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

        // PASSWORD INPUT
        TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: _obscureText,
          enabled: widget.enabled, // ← SỬ DỤNG ENABLED
          style: TextStyle(
            fontSize: 16,
            color: widget.enabled ? const Color(0xFF111827) : Colors.grey.shade500, // ← ĐỔI MÀU
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),

            prefixIcon: Icon(
              Icons.lock_outline,
              size: 20,
              color: widget.enabled ? Colors.grey.shade500 : Colors.grey.shade400, // ← ĐỔI MÀU ICON
            ),

            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: widget.enabled ? Colors.grey.shade500 : Colors.grey.shade400, // ← ĐỔI MÀU ICON
                size: 20,
              ),
              onPressed: widget.enabled ? _toggleVisibility : null, // ← DISABLE NÚT KHI DISABLED
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            // ← THÊM STYLE CHO DISABLED
            filled: !widget.enabled,
            fillColor: !widget.enabled ? Colors.grey.shade100 : null,

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