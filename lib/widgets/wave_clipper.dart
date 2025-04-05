// lib/widgets/wave_clipper.dart
import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  final double waveHeight;
  final int waves;

  WaveClipper({this.waveHeight = 20.0, this.waves = 4});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - waveHeight);

    // إنشاء موجات متعددة
    final waveWidth = size.width / waves;
    for (int i = 0; i < waves; i++) {
      double startX = i * waveWidth;
      double endX = (i + 1) * waveWidth;

      if (i % 2 == 0) {
        path.quadraticBezierTo(
            startX + waveWidth / 2,
            size.height,
            endX,
            size.height - waveHeight
        );
      } else {
        path.quadraticBezierTo(
            startX + waveWidth / 2,
            size.height - waveHeight * 2,
            endX,
            size.height - waveHeight
        );
      }
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class CurvedBackground extends StatelessWidget {
  final Widget child;
  final Color color;
  final double height;

  const CurvedBackground({
    Key? key,
    required this.child,
    required this.color,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}