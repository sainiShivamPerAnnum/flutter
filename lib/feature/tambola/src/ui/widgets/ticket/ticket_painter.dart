import 'package:flutter/material.dart';

class TicketPainter extends CustomClipper<Path> {
  const TicketPainter();
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(Rect.fromCircle(center: const Offset(0.0, 65), radius: 10.0));
    path.addOval(Rect.fromCircle(center: Offset(size.width, 65), radius: 10.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
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

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = const Color(0xff3D4A77).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

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

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

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

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = const Color(0xff3D4A77).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
