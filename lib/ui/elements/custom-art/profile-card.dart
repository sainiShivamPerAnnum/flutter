import 'package:flutter/material.dart';

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paintMain = Paint();

    paintMain.color = Color(0xff299F8F).withOpacity(0.8);
    paintMain.style = PaintingStyle.fill;

    var pathMain = Path();

    pathMain.moveTo(size.width, 0);
    pathMain.quadraticBezierTo(
      size.width / 5,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.35,
    );
    pathMain.quadraticBezierTo(
      size.width,
      size.height * 0.4,
      size.width * 0.8,
      size.height * 0.65,
    );
    pathMain.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.98,
      size.width,
      size.height * 0.98,
    );
    pathMain.lineTo(size.width, size.height);

    canvas.drawPath(pathMain, paintMain);

    var paintShadow = Paint();

    paintShadow.color = Color(0xff299F8F).withOpacity(0.5);
    paintShadow.style = PaintingStyle.fill;

    var pathShadow = Path();

    pathShadow.moveTo(size.width, size.height * 0.2);
    pathShadow.quadraticBezierTo(
      size.width / 5,
      size.height * 0.5,
      size.width * 0.5,
      size.height * 0.6,
    );
    pathShadow.quadraticBezierTo(
      size.width,
      size.height * 0.7,
      size.width * 0.8,
      size.height * 0.8,
    );
    pathShadow.lineTo(
      size.width,
      size.height * 0.8,
    );

    canvas.drawPath(pathShadow, paintShadow);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
