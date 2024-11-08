import 'package:flutter/material.dart';

class StarCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5184209, size.height);
    path_0.lineTo(size.width * 0.4815791, size.height);
    path_0.cubicTo(
      size.width * 0.4815791,
      size.height * 0.7342100,
      size.width * 0.2657891,
      size.height * 0.5184208,
      0,
      size.height * 0.5184208,
    );
    path_0.lineTo(0, size.height * 0.4815792);
    path_0.cubicTo(
      size.width * 0.2657891,
      size.height * 0.4815792,
      size.width * 0.4815791,
      size.height * 0.2657892,
      size.width * 0.4815791,
      0,
    );
    path_0.lineTo(size.width * 0.5184209, 0);
    path_0.cubicTo(
      size.width * 0.5184209,
      size.height * 0.2657892,
      size.width * 0.7342109,
      size.height * 0.4815792,
      size.width,
      size.height * 0.4815792,
    );
    path_0.lineTo(size.width, size.height * 0.5184208);
    path_0.cubicTo(
      size.width * 0.7342109,
      size.height * 0.5184208,
      size.width * 0.5184209,
      size.height * 0.7342100,
      size.width * 0.5184209,
      size.height,
    );
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
