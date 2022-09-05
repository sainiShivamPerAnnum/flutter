import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class CustomCylinderOuter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //Center layer
    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = UiConstants.kProfileBorderColor;
    canvas.drawRect(
        Rect.fromLTWH(
            0, size.height * 0.06908769, size.width, size.height * 0.8609389),
        paint_1_fill);

    //Top layer
    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Colors.white;
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5010593, size.height * 0.06953056),
            width: size.width * 0.9978814,
            height: size.height * 0.1390611),
        paint_2_fill);

    //Bottom layer
    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = UiConstants.kProfileBorderColor;
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5010593, size.height * 0.9304694),
            width: size.width * 0.9978814,
            height: size.height * 0.1390611),
        paint_3_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomCylinderInner extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //Center layer
    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xffFFD979);
    canvas.drawRect(
        Rect.fromLTWH(
            0, size.height * 0.06908769, size.width, size.height * 0.8609389),
        paint_1_fill);

    //Bottom layer
    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffFFD979);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5010593, size.height * 0.9304694),
            width: size.width * 0.9978814,
            height: 20),
        paint_3_fill);

    //Top layer
    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xffFFD979);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.5010593, size.height * 0.06953056),
            width: size.width * 0.9978814,
            height: 20),
        paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
