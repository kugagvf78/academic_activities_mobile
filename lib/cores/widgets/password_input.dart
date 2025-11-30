import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final String label;
  final String hint;
  final Function(String)? onChanged;

  const PasswordInput({
    super.key,
    required this.label,
    required this.hint,
    this.onChanged,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LABEL
        Row(
          children: [
            Text(
              "Mật khẩu",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
                fontSize: 16,
              ),
            ),

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
        ),
        const SizedBox(height: 6),

        TextField(
          obscureText: _obscure,
          onChanged: widget.onChanged,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF111827),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),

            // 🔒 Prefix icon ổ khóa
            prefixIcon: Icon(Icons.lock, color: Colors.grey.shade500, size: 20),

            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade500,
                size: 20,
              ),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

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

            isDense: true,
          ),
        ),
      ],
    );
  }
}
