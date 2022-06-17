import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class UserRank extends StatelessWidget {
  const UserRank({
    Key key,
    @required this.currentUserScore,
    @required this.currentUserRank,
  }) : super(key: key);

  final Scoreboard currentUserScore;
  final int currentUserRank;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: UiConstants.kUserRankBackgroundColor,
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness5,
        ),
      ),
      margin: EdgeInsets.only(
        bottom: SizeConfig.padding16,
        top: SizeConfig.padding32,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding12,
          horizontal: SizeConfig.padding16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  currentUserRank.toString(),
                  style: TextStyles.rajdhaniB.body2,
                ),
                SizedBox(
                  width: SizeConfig.padding20,
                ),
                ProfileImageSE(
                  radius: SizeConfig.iconSize1,
                ),
                SizedBox(
                  width: SizeConfig.padding12,
                ),
                Text(
                  "YOU",
                  style: TextStyles.rajdhaniSB.body2,
                )
              ],
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Best : ',
                    style: TextStyles.rajdhani.body3,
                  ),
                  TextSpan(
                    text: "${currentUserScore.score} points",
                    style: TextStyles.rajdhaniSB.body3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
