import 'package:flutter/material.dart';

class CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff00E5FF).withOpacity(0.15)
      ..strokeWidth = 1.2;

    for (double i = 0; i < size.width; i += 32) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double j = 0; j < size.height; j += 32) {
      canvas.drawLine(
        Offset(0, j),
        Offset(size.width, j),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
