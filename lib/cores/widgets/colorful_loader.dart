import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Package cho spinner màu sắc

// StatefulWidget để hỗ trợ animation
class ColorfulLoader extends StatefulWidget {
  @override
  _ColorfulLoaderState createState() => _ColorfulLoaderState();
}

class _ColorfulLoaderState extends State<ColorfulLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller; // AnimationController với vsync

  @override
  void initState() {
    super.initState();
    // Tạo AnimationController với vsync: this (nhờ mixin)
    _controller = AnimationController(
      vsync: this, // Sửa lỗi ở đây: sử dụng 'this' thay vì VsyncProvider
      duration: const Duration(seconds: 2),
    )..repeat(); // Lặp animation liên tục
  }

  @override
  void dispose() {
    _controller.dispose(); // Giải phóng tài nguyên để tránh memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Spinner màu sắc với animation
          SpinKitFadingCircle(
            color: Colors.blue, // Màu chính, có thể thay bằng gradient nếu muốn
            size: 50.0,
            controller: _controller, // Kết nối với AnimationController
          ),
          const SizedBox(height: 16),
          const Text(
            'Đang tải...',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}