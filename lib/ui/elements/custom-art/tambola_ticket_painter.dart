import 'package:flutter/material.dart';

class TicketPainter extends CustomPainter {
  final double puchRadius;
  final Color color;

  const TicketPainter({this.puchRadius, this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paintMain = Paint();

    paintMain.color = color;
    paintMain.style = PaintingStyle.fill;

    var pathMain = Path();

    pathMain.moveTo(0, 0);

    pathMain.moveTo(size.width, 0);
    pathMain.moveTo(size.width, size.height / 2 - puchRadius);
    pathMain.quadraticBezierTo(size.width - puchRadius * 1.5, size.height / 2,
        size.width, size.height / 2 + puchRadius);
    pathMain.moveTo(size.width, size.height);
    pathMain.moveTo(0, size.height);
    pathMain.moveTo(0, size.height / 2 + puchRadius);
    pathMain.quadraticBezierTo(
        puchRadius * 1.5, size.height / 2, 0, size.height / 2 - puchRadius);
    pathMain.close();

    canvas.drawPath(pathMain, paintMain);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
