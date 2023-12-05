import 'package:felloapp/core/model/badges_leader_board_model.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/badges_custom_painters.dart';
import 'package:felloapp/feature/fello_badges/ui/widgets/user_badge_custom_painter.dart';
import 'package:felloapp/ui/elements/default_avatar.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class BadgesTopUserWidget extends StatelessWidget {
  const BadgesTopUserWidget({
    required this.leaderBoard,
    super.key,
  });

  final LeaderBoard? leaderBoard;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(SizeConfig.screenWidth! * 0.27, SizeConfig.padding144),
          painter: RPSCustomPainter(),
        ),
        Transform.translate(
          offset: Offset(SizeConfig.padding16, -SizeConfig.padding8),
          child: Align(
            alignment: Alignment.topRight,
            child: CustomPaint(
              size: Size(SizeConfig.padding26, SizeConfig.padding34),
              painter: UserBadgeCustomPainter(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Transform.translate(
            offset: Offset(SizeConfig.padding3, 0),
            child: Container(
              width: SizeConfig.padding68,
              height: SizeConfig.padding68,
              padding: const EdgeInsets.all(2),
              decoration: ShapeDecoration(
                shape: OvalBorder(
                  side: BorderSide(
                      width: 1.70, color: Colors.white.withOpacity(0.4)),
                ),
              ),
              child: DefaultAvatar(),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, SizeConfig.padding10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              leaderBoard?.name ?? 'User',
              textAlign: TextAlign.center,
              style: TextStyles.sourceSans.body4.colour(
                Colors.white,
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, SizeConfig.padding26),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              leaderBoard?.totalSaving.toString() ?? "",
              style: TextStyles.sourceSans.body4.colour(
                const Color(0xFFBDBDBE).withOpacity(0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
