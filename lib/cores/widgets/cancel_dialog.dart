import 'package:flutter/material.dart';

class CancelDialog {
  static Future<void> show({
    required BuildContext context,
    required Future<Map<String, dynamic>> Function() onConfirm,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(24),

          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFDC2626),
                  size: 36,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Xác nhận hủy đăng ký",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,          // 🔥 giống mẫu
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),

          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "Bạn có chắc chắn muốn hủy đăng ký này?\nHành động này không thể hoàn tác.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  // ❌ BUTTON HỦY
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Hủy bỏ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // 🔥 BUTTON XÁC NHẬN
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context); // đóng dialog

                        // 🔥 SHOW LOADING
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        );

                        final res = await onConfirm();

                        if (!context.mounted) return;

                        Navigator.pop(context); // đóng loading
                      },
                      child: const Text(
                        "Xác nhận",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
