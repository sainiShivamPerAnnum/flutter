import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
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
    // log(SizeConfig.screenWidth.toString());
    return Stack(
      children: [
        if (rank == 1)
          CustomPaint(
            painter: WinnerBackGroundPainter(context: context),
            size: Size(
              SizeConfig.screenWidth * 0.3333, // 120
              SizeConfig.screenWidth * 0.6666, // 240
            ),
          ),
        Padding(
          padding: EdgeInsets.only(
            left: rank == 1 ? SizeConfig.screenWidth * 0.04444 : 0,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: rank == 1
                      ? SizeConfig.screenWidth * 0.125
                      : SizeConfig.screenWidth * 0.194,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    SizeConfig.screenWidth * 0.125,
                  ),
                  border: Border.all(
                    color: rank == 1
                        ? UiConstants.kWinnerPlayerPrimaryColor
                        : UiConstants.kOtherPlayerPrimaryColor.withOpacity(0.4),
                    width: SizeConfig.border2,
                  ),
                ),
                padding: EdgeInsets.all(
                  rank == 1
                      ? SizeConfig.screenWidth * 0.0055
                      : SizeConfig.screenWidth * 0.0083,
                ),
                child: Image.asset(
                  'assets/temp/$image',
                  width: rank == 1
                      ? SizeConfig.screenWidth * 0.2222
                      : SizeConfig.screenWidth * 0.2083,
                  height: rank == 1
                      ? SizeConfig.screenWidth * 0.2222
                      : SizeConfig.screenWidth * 0.2083,
                ),
              ),
              SizedBox(
                height: SizeConfig.padding4,
              ),
              Text(
                '$rank${rank == 1 ? "st" : rank == 2 ? "nd" : "rd"}',
                style: TextStyles.rajdhaniB.body2,
              ),
              SizedBox(
                height: SizeConfig.padding6,
              ),
              Text(
                name,
                style: TextStyles.rajdhaniM.body4,
              ),
              Text(
                '($score)',
                style: TextStyles.rajdhani.body4.setOpecity(0.6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WinnerBackGroundPainter extends CustomPainter {
  BuildContext context;
  WinnerBackGroundPainter({this.context});
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    Paint bgPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    bgPaint.shader = ui.Gradient.linear(
      Offset(w * 0.5, 0),
      Offset(w * 0.5, h * 0.50),
      [
        UiConstants.kWinnerPlayerPrimaryColor.withOpacity(0.78),
        UiConstants.kWinnerPlayerPrimaryColor.withOpacity(0),
      ],
    );

    /// Drawing the background
    Path path0 = Path();
    path0.moveTo(w * 0.5 - 30, 0);
    path0.lineTo(0, h * 0.5);
    path0.lineTo(w, h * 0.5);
    path0.lineTo(w * 0.5 + 30, 0);
    path0.close();
    canvas.drawPath(path0, bgPaint);

    /// Drawing the circle
    canvas.drawCircle(
      Offset(w * 0.78, h * 0.18),
      4,
      Paint()..color = UiConstants.kWinnerPlayerPrimaryColor,
    );
    canvas.drawCircle(
      Offset(w * 0.14, h * 0.28),
      2,
      Paint()..color = UiConstants.kWinnerPlayerLightPrimaryColor,
    );
    canvas.drawCircle(
      Offset(w * 0.89, h * 0.28),
      2,
      Paint()..color = UiConstants.kWinnerPlayerLightPrimaryColor,
    );
    canvas.drawCircle(
      Offset(w * 0.15, h * 0.5),
      4,
      Paint()..color = UiConstants.kWinnerPlayerPrimaryColor,
    );
    canvas.drawCircle(
      Offset(w * 0.75, h * 0.55),
      2,
      Paint()..color = UiConstants.kWinnerPlayerLightPrimaryColor,
    );

    /// Drawing the taj
    canvas.translate(w * -0.1416, h * 0.175); // -17, 42
    canvas.rotate(-0.6); // -0.6

    Path path1 = Path();
    path1.moveTo(w * 0.1666, h * 0.0833); // 20, 20
    path1.lineTo(w * 0.2083, h * 0.14583); // 25, 35
    path1.lineTo(w * 0.3750, h * 0.14583); // 45, 35
    path1.lineTo(w * 0.4166, h * 0.0833); // 50, 20
    path1.lineTo(w * 0.3333, h * 0.1166); // 40, 28
    path1.lineTo(w * 0.2875, h * 0.0833); // 34.5, 20
    path1.lineTo(w * 0.2416, h * 0.1166); // 29, 28
    path1.close();
    canvas.drawPath(
      path1,
      Paint()
        ..strokeWidth = SizeConfig.screenWidth * 0.0083
        ..color = UiConstants.kWinnerPlayerPrimaryColor
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
