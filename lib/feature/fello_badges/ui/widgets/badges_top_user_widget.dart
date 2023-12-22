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

  final LeaderBoard leaderBoard;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: const RPSCustomPainter(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding12,
              vertical: SizeConfig.padding12,
            ),
            child: Column(
              children: [
                Container(
                  width: SizeConfig.padding68,
                  height: SizeConfig.padding68,
                  padding: const EdgeInsets.all(2),
                  decoration: ShapeDecoration(
                    shape: OvalBorder(
                      side: BorderSide(
                        width: 1.70,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ),
                  child: const DefaultAvatar(),
                ),
                SizedBox(
                  height: SizeConfig.padding6,
                ),
                Text(
                  leaderBoard.name,
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSans.body4.colour(
                    Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: const Alignment(1.2, -1.2),
          child: CustomPaint(
            size: Size(SizeConfig.padding26, SizeConfig.padding34),
            painter: UserBadgeCustomPainter(),
          ),
        ),
      ],
    );
  }
}
