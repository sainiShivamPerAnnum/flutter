import 'dart:math';
import 'dart:ui' as ui;

import 'package:felloapp/core/model/power_play_models/season_leaderboard_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WinnerWidgets extends StatelessWidget {
  WinnerWidgets({
    required this.scoreboard,
    Key? key,
    // required this.userProfilePicUrl,
    this.isSpotLightVisible = true,
  }) : super(key: key);
  final List<SeasonLeaderboardItemModel>? scoreboard;
  // final List<String?> userProfilePicUrl;
  final bool isSpotLightVisible;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        scoreboard!.length >= 2
            ? _buildTopThreeWinner(
                rank: 1,
                context: context,
              )
            : SizedBox(width: SizeConfig.screenWidth! * 0.194),
        if (scoreboard!.isNotEmpty)
          _buildTopThreeWinner(
            rank: 0,
            context: context,
          ),
        scoreboard!.length >= 3
            ? _buildTopThreeWinner(
                rank: 2,
                context: context,
              )
            : SizedBox(width: SizeConfig.screenWidth! * 0.194),
      ],
    );
  }

  final rand = 1 + Random().nextInt(4);

  getDefaultProfilePicture(int rank) {
    switch (rank) {
      case 0:
        return Assets.cvtar1;
      case 1:
        return Assets.cvtar2;
      case 2:
        return Assets.cvtar3;
      default:
        return "assets/vectors/userAvatars/AV$rand.svg";
    }
  }

  Widget _buildTopThreeWinner({
    required int rank,
    BuildContext? context,
  }) {
    return Stack(
      children: [
        if (rank == 0)
          CustomPaint(
            painter: WinnerBackGroundPainter(
              context: context,
              isSpotLightVisible: isSpotLightVisible,
            ),
            size: Size(
              SizeConfig.screenWidth! * 0.3333, // 120
              SizeConfig.screenWidth! * 0.6666, // 240
            ),
          ),
        Padding(
          padding: EdgeInsets.only(
            left: rank == 0 ? SizeConfig.screenWidth! * 0.0400 : 0,
          ),
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(
                    top: rank == 0
                        ? SizeConfig.screenWidth! * 0.130
                        : SizeConfig.screenWidth! * 0.194,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.screenWidth! * 0.125,
                    ),
                    border: Border.all(
                      color: rank == 0
                          ? UiConstants.kWinnerPlayerPrimaryColor
                          : UiConstants.kOtherPlayerPrimaryColor
                              .withOpacity(0.4),
                      width: SizeConfig.border2,
                    ),
                  ),
                  padding: EdgeInsets.all(
                    rank == 0
                        ? SizeConfig.screenWidth! * 0.0055
                        : SizeConfig.screenWidth! * 0.0083,
                  ),
                  child: SvgPicture.asset(
                    getDefaultProfilePicture(rank),
                    width: rank == 0
                        ? SizeConfig.screenWidth! * 0.2344
                        : SizeConfig.screenWidth! * 0.2083,
                    height: rank == 0
                        ? SizeConfig.screenWidth! * 0.2344
                        : SizeConfig.screenWidth! * 0.2083,
                    fit: BoxFit.cover,
                  )),
              SizedBox(
                height: SizeConfig.padding4,
              ),
              Text(
                rank == 0
                    ? '1st'
                    : rank == 1
                        ? '2nd'
                        : '3rd',
                style: TextStyles.rajdhaniB.body2,
              ),
              SizedBox(
                height: SizeConfig.padding6,
              ),
              Text(
                locator<UserService>().diplayUsername(scoreboard![rank].uName),
                style: TextStyles.rajdhaniM.body4,
              ),
              Text(
                '(${scoreboard![rank].value})',
                style: TextStyles.rajdhani.body4.setOpacity(0.6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WinnerBackGroundPainter extends CustomPainter {
  BuildContext? context;
  bool? isSpotLightVisible;
  WinnerBackGroundPainter({this.context, this.isSpotLightVisible});
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

    /// Drawing the Spotlight
    if (isSpotLightVisible!) {
      Path path0 = Path();
      path0.moveTo(w * 0.5 - 30, 0);
      path0.lineTo(0, h * 0.5);
      path0.lineTo(w, h * 0.5);
      path0.lineTo(w * 0.5 + 30, 0);
      path0.close();
      canvas.drawPath(path0, bgPaint);
    }

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

    /// Drawing the Crown
    if (isSpotLightVisible!) {
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
          ..strokeWidth = SizeConfig.screenWidth! * 0.0083
          ..color = UiConstants.kWinnerPlayerPrimaryColor
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
