import 'package:flutter/material.dart';

// class TicketPainter extends CustomClipper<Path> {
//   const TicketPainter();
//   @override
//   Path getClip(Size size) {
//     Path path = Path();

//     path.lineTo(0.0, size.height);
//     path.lineTo(size.width, size.height);
//     path.lineTo(size.width, 0.0);

//     path.addOval(Rect.fromCircle(center: const Offset(0.0, 65), radius: 10.0));
//     path.addOval(Rect.fromCircle(center: Offset(size.width, 65), radius: 10.0));

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => true;
// }

class TicketPainter extends CustomPainter {
  final Color borderColor;
  const TicketPainter({this.borderColor = Colors.transparent});
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.01980198);
    path_0.cubicTo(0, size.height * 0.008865644, size.width * 0.008527905, 0,
        size.width * 0.01904762, 0);
    path_0.lineTo(size.width * 0.9809524, 0);
    path_0.cubicTo(size.width * 0.9914714, 0, size.width,
        size.height * 0.008865644, size.width, size.height * 0.01980198);
    path_0.lineTo(size.width, size.height * 0.2178218);
    path_0.cubicTo(
        size.width * 0.9842190,
        size.height * 0.2178218,
        size.width * 0.9714286,
        size.height * 0.2311203,
        size.width * 0.9714286,
        size.height * 0.2475248);
    path_0.cubicTo(
        size.width * 0.9714286,
        size.height * 0.2639292,
        size.width * 0.9842190,
        size.height * 0.2772277,
        size.width,
        size.height * 0.2772277);
    path_0.lineTo(size.width, size.height * 0.9801980);
    path_0.cubicTo(size.width, size.height * 0.9911337, size.width * 0.9914714,
        size.height, size.width * 0.9809524, size.height);
    path_0.lineTo(size.width * 0.01904762, size.height);
    path_0.cubicTo(size.width * 0.008527905, size.height, 0,
        size.height * 0.9911337, 0, size.height * 0.9801980);
    path_0.lineTo(0, size.height * 0.2772277);
    path_0.cubicTo(
        size.width * 0.01577957,
        size.height * 0.2772277,
        size.width * 0.02857143,
        size.height * 0.2639292,
        size.width * 0.02857143,
        size.height * 0.2475248);
    path_0.cubicTo(
        size.width * 0.02857143,
        size.height * 0.2311203,
        size.width * 0.01577957,
        size.height * 0.2178218,
        0,
        size.height * 0.2178218);
    path_0.lineTo(0, size.height * 0.01980198);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff30363C).withOpacity(1.0);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path_0, paint0Fill);
    canvas.drawPath(path_0, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

/// "New" & "New Week" Banner Tag Ui
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9921622, size.height * 0.1363627);
    path_0.lineTo(0, size.height * 0.1363627);
    path_0.lineTo(size.width * 0.03635122, size.height * 0.01045364);
    path_0.lineTo(size.width * 0.9558108, size.height * 0.01045364);
    path_0.lineTo(size.width * 0.9921622, size.height * 0.1363627);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff3D4A77).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.8987824, size.height * 0.9709091);
    path_1.lineTo(size.width * 0.1205399, size.height * 0.9709091);
    path_1.cubicTo(
        size.width * 0.08148581,
        size.height * 0.9709091,
        size.width * 0.04986405,
        size.height * 0.8645455,
        size.width * 0.04986405,
        size.height * 0.7331818);
    path_1.lineTo(size.width * 0.04986405, size.height * 0.1363636);
    path_1.lineTo(size.width * 0.9694581, size.height * 0.1363636);
    path_1.lineTo(size.width * 0.9694581, size.height * 0.7331818);
    path_1.cubicTo(
        size.width * 0.9694581,
        size.height * 0.8645455,
        size.width * 0.9378365,
        size.height * 0.9709091,
        size.width * 0.8987824,
        size.height * 0.9709091);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.03635054, size.height * 0.009543682);
    path_2.lineTo(size.width * 0.9559446, size.height * 0.009543682);
    path_2.lineTo(size.width * 0.9559446, size.height * 0.6931818);
    path_2.cubicTo(
        size.width * 0.9559446,
        size.height * 0.8213636,
        size.width * 0.9250000,
        size.height * 0.9250000,
        size.width * 0.8870270,
        size.height * 0.9250000);
    path_2.lineTo(size.width * 0.1054046, size.height * 0.9250000);
    path_2.cubicTo(
        size.width * 0.06729649,
        size.height * 0.9250000,
        size.width * 0.03648581,
        size.height * 0.8209091,
        size.width * 0.03648581,
        size.height * 0.6931818);
    path_2.lineTo(size.width * 0.03648581, size.height * 0.009543682);
    path_2.lineTo(size.width * 0.03635054, size.height * 0.009543682);
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = const Color(0xff3D4A77).withOpacity(1.0);
    canvas.drawPath(path_2, paint2Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
