import 'package:felloapp/core/model/power_play_models/season_leaderboard_model.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class UserRank extends StatelessWidget {
  const UserRank({
    required this.currentUserScore,
    required this.currentUserRank,
    Key? key,
  }) : super(key: key);

  final SeasonLeaderboardItemModel currentUserScore;
  final int currentUserRank;
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
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
                  reactive: false,
                ),
                SizedBox(
                  width: SizeConfig.padding12,
                ),
                Text(
                  locale.you,
                  style: TextStyles.rajdhaniSB.body2,
                )
              ],
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: locale.bestPoints,
                    style: TextStyles.rajdhani.body3,
                  ),
                  TextSpan(
                    text: " ${currentUserScore.value} ",
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
