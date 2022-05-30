import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class WinnerWidgets extends StatelessWidget {
  const WinnerWidgets({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTopThreeWinner(
          image: 'rank_two_profile.png',
          rank: 2,
          name: 'John Doe',
          score: '250 Runs',
          context: context,
        ),
        _buildTopThreeWinner(
          image: 'rank_one_profile.png',
          rank: 1,
          name: 'Pro Player',
          score: '300 Runs',
          context: context,
        ),
        _buildTopThreeWinner(
          image: 'rank_three_profile.png',
          rank: 3,
          name: 'Classy Player',
          score: '200 Runs',
          context: context,
        ),
      ],
    );
  }

  Widget _buildTopThreeWinner({
    String image,
    int rank,
    String name,
    String score,
    BuildContext context,
  }) {
    return Stack(
      children: [
        if (rank == 1)
          CustomPaint(
            painter: WinnerBackGroundPainter(),
            size: const Size(120, 240),
          ),
        Padding(
          padding: EdgeInsets.only(
            left: rank == 1 ? 16 : 0,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: rank == 1 ? 45 : 70,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(
                    color: rank == 1
                        ? const Color(0xFFFFD979)
                        : Colors.white.withOpacity(0.4),
                    width: 1.7,
                  ),
                ),
                padding: EdgeInsets.all(rank == 1 ? 2 : 3),
                child: Image.asset(
                  'assets/temp/$image',
                  width: rank == 1 ? 80 : 75,
                  height: rank == 1 ? 80 : 75,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                '$rank${rank == 1 ? "st" : rank == 2 ? "nd" : "rd"}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                '($score)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WinnerBackGroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Paint bgPaint = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    bgPaint.shader = ui.Gradient.linear(
      Offset(w * 0.5, 0),
      Offset(w * 0.5, h * 0.50),
      [
        const Color(0xFFFFD979).withOpacity(0.78),
        const Color(0xFFFFD979).withOpacity(0),
      ],
    );
    Path path0 = Path();
    path0.moveTo(w * 0.5 - 30, 0);
    path0.lineTo(0, h * 0.5);
    path0.lineTo(w, h * 0.5);
    path0.lineTo(w * 0.5 + 30, 0);
    path0.close();
    canvas.drawPath(path0, bgPaint);

    canvas.drawCircle(
      Offset(w * 0.78, h * 0.18),
      4,
      Paint()..color = const Color(0xFFFFD979),
    );
    canvas.drawCircle(
      Offset(w * 0.14, h * 0.28),
      2,
      Paint()..color = const Color(0xFFFEF5DC),
    );
    canvas.drawCircle(
      Offset(w * 0.89, h * 0.28),
      2,
      Paint()..color = const Color(0xFFFEF5DC),
    );
    canvas.drawCircle(
      Offset(w * 0.15, h * 0.5),
      4,
      Paint()..color = const Color(0xFFF2B826),
    );
    canvas.drawCircle(
      Offset(w * 0.75, h * 0.55),
      2,
      Paint()..color = const Color(0xFFFEF5DC),
    );

    canvas.translate(-17, 42);
    canvas.rotate(-0.6);

    Path path1 = Path();
    path1.moveTo(20, 20);
    path1.lineTo(25, 35);
    path1.lineTo(45, 35);
    path1.lineTo(50, 20);
    path1.lineTo(40, 28);
    path1.lineTo(34.5, 20);
    path1.lineTo(29, 28);
    path1.close();
    canvas.drawPath(
      path1,
      Paint()
        ..strokeWidth = 3
        ..color = const Color(0xFFFFD979)
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
