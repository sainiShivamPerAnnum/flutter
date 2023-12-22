import 'package:flutter/material.dart';

class StarCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4859731, size.height * 0.1438654);
    path_0.cubicTo(
        size.width * 0.5008654,
        size.height * 0.1115788,
        size.width * 0.5467500,
        size.height * 0.1115788,
        size.width * 0.5616423,
        size.height * 0.1438654);
    path_0.lineTo(size.width * 0.6415885, size.height * 0.3171873);
    path_0.cubicTo(
        size.width * 0.6493923,
        size.height * 0.3341054,
        size.width * 0.6654269,
        size.height * 0.3457542,
        size.width * 0.6839269,
        size.height * 0.3479481);
    path_0.lineTo(size.width * 0.8734692, size.height * 0.3704215);
    path_0.cubicTo(
        size.width * 0.9087769,
        size.height * 0.3746077,
        size.width * 0.9229577,
        size.height * 0.4182500,
        size.width * 0.8968538,
        size.height * 0.4423885);
    path_0.lineTo(size.width * 0.7567192, size.height * 0.5719808);
    path_0.cubicTo(
        size.width * 0.7430423,
        size.height * 0.5846308,
        size.width * 0.7369154,
        size.height * 0.6034808,
        size.width * 0.7405500,
        size.height * 0.6217538);
    path_0.lineTo(size.width * 0.7777462, size.height * 0.8089654);
    path_0.cubicTo(
        size.width * 0.7846769,
        size.height * 0.8438385,
        size.width * 0.7475538,
        size.height * 0.8708115,
        size.width * 0.7165269,
        size.height * 0.8534423);
    path_0.lineTo(size.width * 0.5499731, size.height * 0.7602154);
    path_0.cubicTo(
        size.width * 0.5337154,
        size.height * 0.7511115,
        size.width * 0.5139000,
        size.height * 0.7511115,
        size.width * 0.4976423,
        size.height * 0.7602154);
    path_0.lineTo(size.width * 0.3310873, size.height * 0.8534423);
    path_0.cubicTo(
        size.width * 0.3000615,
        size.height * 0.8708115,
        size.width * 0.2629385,
        size.height * 0.8438385,
        size.width * 0.2698677,
        size.height * 0.8089654);
    path_0.lineTo(size.width * 0.3070665, size.height * 0.6217538);
    path_0.cubicTo(
        size.width * 0.3106973,
        size.height * 0.6034808,
        size.width * 0.3045735,
        size.height * 0.5846308,
        size.width * 0.2908946,
        size.height * 0.5719808);
    path_0.lineTo(size.width * 0.1507600, size.height * 0.4423885);
    path_0.cubicTo(
        size.width * 0.1246562,
        size.height * 0.4182500,
        size.width * 0.1388358,
        size.height * 0.3746077,
        size.width * 0.1741438,
        size.height * 0.3704212);
    path_0.lineTo(size.width * 0.3636877, size.height * 0.3479481);
    path_0.cubicTo(
        size.width * 0.3821892,
        size.height * 0.3457542,
        size.width * 0.3982231,
        size.height * 0.3341054,
        size.width * 0.4060269,
        size.height * 0.3171873);
    path_0.lineTo(size.width * 0.4859731, size.height * 0.1438654);
    path_0.close();

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01190477;
    paint0Stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Stroke);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.white.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.4437615, size.height * 0.09873231);
    path_1.cubicTo(
        size.width * 0.4565231,
        size.height * 0.07105808,
        size.width * 0.4958577,
        size.height * 0.07105808,
        size.width * 0.5086192,
        size.height * 0.09873231);
    path_1.lineTo(size.width * 0.5885654, size.height * 0.2720542);
    path_1.cubicTo(
        size.width * 0.5972385,
        size.height * 0.2908523,
        size.width * 0.6150538,
        size.height * 0.3037954,
        size.width * 0.6356077,
        size.height * 0.3062327);
    path_1.lineTo(size.width * 0.8251538, size.height * 0.3287062);
    path_1.cubicTo(
        size.width * 0.8554154,
        size.height * 0.3322946,
        size.width * 0.8675731,
        size.height * 0.3697012,
        size.width * 0.8451962,
        size.height * 0.3903923);
    path_1.lineTo(size.width * 0.7050615, size.height * 0.5199846);
    path_1.cubicTo(
        size.width * 0.6898615,
        size.height * 0.5340385,
        size.width * 0.6830577,
        size.height * 0.5549846,
        size.width * 0.6870923,
        size.height * 0.5752885);
    path_1.lineTo(size.width * 0.7242923, size.height * 0.7625000);
    path_1.cubicTo(
        size.width * 0.7302308,
        size.height * 0.7923885,
        size.width * 0.6984115,
        size.height * 0.8155077,
        size.width * 0.6718192,
        size.height * 0.8006231);
    path_1.lineTo(size.width * 0.5052654, size.height * 0.7073923);
    path_1.cubicTo(
        size.width * 0.4872000,
        size.height * 0.6972808,
        size.width * 0.4651808,
        size.height * 0.6972808,
        size.width * 0.4471154,
        size.height * 0.7073923);
    path_1.lineTo(size.width * 0.2805631, size.height * 0.8006231);
    path_1.cubicTo(
        size.width * 0.2539696,
        size.height * 0.8155077,
        size.width * 0.2221496,
        size.height * 0.7923885,
        size.width * 0.2280892,
        size.height * 0.7625000);
    path_1.lineTo(size.width * 0.2652877, size.height * 0.5752885);
    path_1.cubicTo(
        size.width * 0.2693223,
        size.height * 0.5549808,
        size.width * 0.2625177,
        size.height * 0.5340385,
        size.width * 0.2473192,
        size.height * 0.5199846);
    path_1.lineTo(size.width * 0.1071846, size.height * 0.3903923);
    path_1.cubicTo(
        size.width * 0.08480962,
        size.height * 0.3697012,
        size.width * 0.09696385,
        size.height * 0.3322942,
        size.width * 0.1272281,
        size.height * 0.3287062);
    path_1.lineTo(size.width * 0.3167715, size.height * 0.3062327);
    path_1.cubicTo(
        size.width * 0.3373288,
        size.height * 0.3037954,
        size.width * 0.3551435,
        size.height * 0.2908523,
        size.width * 0.3638142,
        size.height * 0.2720542);
    path_1.lineTo(size.width * 0.4437615, size.height * 0.09873231);
    path_1.close();

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02380954;
    paint1Stroke.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_1, paint1Stroke);

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xffFFD979).withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class FelloBadgeBGCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 1.016000, 0);
    path_0.lineTo(size.width * -0.02666667, size.height * 0.6160714);
    path_0.lineTo(size.width * -0.02666667, size.height * 1.0970238);
    path_0.lineTo(size.width * 1.016000, size.height * 0.5601190);
    path_0.lineTo(size.width * 1.016000, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff023C40).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class FelloBadgeBG2CustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 1.016000, 0);
    path_0.lineTo(size.width * -0.02666667, size.height * 0.9173913);
    path_0.lineTo(size.width * -0.02666667, size.height * 0.9956522);
    path_0.lineTo(size.width * 1.016000, size.height * 0.08260870);
    path_0.lineTo(size.width * 1.016000, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff023C40).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPSCustomPainter extends CustomPainter {
  const RPSCustomPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const rad = 5.0;
    const bottomPadding = 30;
    Path path = Path();

    path.moveTo(rad, 0);
    path.lineTo(size.width - rad, 0);
    path.quadraticBezierTo(size.width, 0, size.width, rad);
    path.lineTo(size.width, size.height - bottomPadding);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height - bottomPadding);
    path.lineTo(0, rad);
    path.quadraticBezierTo(0, 0, rad, 0);

    Paint linePainter = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01549845;
    linePainter.color = const Color(0xff2E8C76).withOpacity(1.0);
    canvas.drawPath(path, linePainter);

    Paint backgroundPainter = Paint()..style = PaintingStyle.fill;
    backgroundPainter.color = const Color(0xff232326).withOpacity(1.0);
    canvas.drawPath(path, backgroundPainter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
