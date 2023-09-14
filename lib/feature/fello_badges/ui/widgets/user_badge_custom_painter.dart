import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class UserBadgeCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(18.4473, 31.2161);
    path_0.lineTo(13.0029, 28.8004);
    path_0.lineTo(7.56177, 31.2161);
    path_0.lineTo(7.56177, 18.1104);
    path_0.lineTo(18.4473, 18.1104);
    path_0.lineTo(18.4473, 31.2161);
    path_0.close();

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01903558;
    paint_0_stroke.color = const Color(0xff101626).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xffFFDA72).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(13.0033, 28.6269);
    path_1.lineTo(7.72119, 30.973);
    path_1.lineTo(7.72119, 18.2715);
    path_1.lineTo(18.2886, 18.2715);
    path_1.lineTo(18.2886, 30.973);
    path_1.lineTo(13.0033, 28.6269);
    path_1.close();

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01903558;
    paint_1_stroke.color = const Color(0xff101626).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_stroke);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = const Color(0xffFFDA72).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(15.8936, 22.7233);
    path_2.cubicTo(21.1332, 21.1274, 24.087, 15.5861, 22.4911, 10.3465);
    path_2.cubicTo(20.8952, 5.10691, 15.3539, 2.15312, 10.1143, 3.74903);
    path_2.cubicTo(4.87472, 5.34493, 1.92093, 10.8862, 3.51684, 16.1258);
    path_2.cubicTo(5.11274, 21.3654, 10.654, 24.3192, 15.8936, 22.7233);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.1187269, size.height * 0.4137562),
        Offset(size.width * 0.8817577, size.height * 0.4137562), [
      const Color(0xffFFF5A8).withOpacity(1),
      const Color(0xffBD8100).withOpacity(1),
      const Color(0xffE0BE58).withOpacity(1),
      const Color(0xffF1DC83).withOpacity(1)
    ], [
      0,
      0.31,
      0.76,
      1
    ]);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(21.4563, 17.7864);
    path_3.cubicTo(23.9657, 13.1162, 22.214, 7.29587, 17.5437, 4.78644);
    path_3.cubicTo(12.8734, 2.27701, 7.05315, 4.02872, 4.54372, 8.699);
    path_3.cubicTo(2.03429, 13.3693, 3.786, 19.1896, 8.45628, 21.699);
    path_3.cubicTo(13.1266, 24.2084, 18.9468, 22.4567, 21.4563, 17.7864);
    path_3.close();

    Paint paint_3_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02855335;
    paint_3_stroke.color = const Color(0xff101626).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_stroke);

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = const Color(0xffFFDA72).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(12.7488, 8.83796);
    path_4.cubicTo(12.9369, 8.43011, 13.5165, 8.43011, 13.7047, 8.83796);
    path_4.lineTo(14.7026, 11.0016);
    path_4.cubicTo(14.7793, 11.1678, 14.9368, 11.2822, 15.1186, 11.3038);
    path_4.lineTo(17.4847, 11.5843);
    path_4.cubicTo(17.9307, 11.6372, 18.1099, 12.1885, 17.7801, 12.4934);
    path_4.lineTo(16.0308, 14.1111);
    path_4.cubicTo(15.8964, 14.2354, 15.8362, 14.4206, 15.8719, 14.6002);
    path_4.lineTo(16.3363, 16.9371);
    path_4.cubicTo(16.4238, 17.3777, 15.9548, 17.7184, 15.5629, 17.499);
    path_4.lineTo(13.4838, 16.3352);
    path_4.cubicTo(13.3241, 16.2458, 13.1294, 16.2458, 12.9696, 16.3352);
    path_4.lineTo(10.8905, 17.499);
    path_4.cubicTo(10.4986, 17.7184, 10.0296, 17.3777, 10.1172, 16.9371);
    path_4.lineTo(10.5815, 14.6002);
    path_4.cubicTo(10.6172, 14.4206, 10.557, 14.2354, 10.4226, 14.1111);
    path_4.lineTo(8.67334, 12.4934);
    path_4.cubicTo(8.34358, 12.1885, 8.52271, 11.6372, 8.96873, 11.5843);
    path_4.lineTo(11.3348, 11.3038);
    path_4.cubicTo(11.5166, 11.2822, 11.6741, 11.1678, 11.7508, 11.0016);
    path_4.lineTo(12.7488, 8.83796);
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
