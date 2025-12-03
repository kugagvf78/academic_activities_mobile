import 'package:flutter/material.dart';

class SuccessToast {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _SuccessToastWidget(
        message: message,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

class _SuccessToastWidget extends StatefulWidget {
  final String message;
  final VoidCallback onDismiss;

  const _SuccessToastWidget({
    required this.message,
    required this.onDismiss,
  });

  @override
  State<_SuccessToastWidget> createState() => _SuccessToastWidgetState();
}

class _SuccessToastWidgetState extends State<_SuccessToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4)),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
