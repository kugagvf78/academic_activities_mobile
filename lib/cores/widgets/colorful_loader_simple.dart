import 'package:flutter/material.dart';

class ColorfulLoaderSimple extends StatelessWidget {
  const ColorfulLoaderSimple({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rainbow spinner siêu đẹp, không cần AnimationController
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation(Colors.transparent),
              backgroundColor: Colors.transparent,
            ),
          ).shaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.indigo,
                Colors.purple,
              ],
              tileMode: TileMode.repeated,
            ).createShader(bounds),
          ),
          const SizedBox(height: 20),
          const Text(
            'Đang tải...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
              shadows: [Shadow(color: Colors.purple, blurRadius: 10)],
            ),
          ),
        ],
      ),
    );
  }
}

// Extension để dùng dễ hơn
extension ShaderMaskExtension on Widget {
  Widget shaderMask({required ShaderCallback shaderCallback}) {
    return ShaderMask(
      shaderCallback: shaderCallback,
      blendMode: BlendMode.srcIn,
      child: this,
    );
  }
}