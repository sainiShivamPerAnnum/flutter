import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/components/winner_widget.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class NewWebGameLeaderBoardView extends StatelessWidget {
  const NewWebGameLeaderBoardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<LeaderboardService,
        LeaderBoardServiceProperties>(
      properties: [LeaderBoardServiceProperties.WebGameLeaderBoard],
      builder: (context, m, properties) {
        return m.WebGameLeaderBoard == null || m.userProfilePicUrl.isEmpty
            ? NoRecordDisplayWidget(
                asset: "images/leaderboard.png",
                text: "Leaderboard will be updated soon",
              )
            : NewLeaderBoardView(
                model: m.WebGameLeaderBoard,
                userProfilePicUrl: m.userProfilePicUrl,
              );
      },
    );
  }
}

class NewLeaderBoardView extends StatelessWidget {
  NewLeaderBoardView({@required this.model, @required this.userProfilePicUrl});

  final LeaderBoardModal model;
  final List<String> userProfilePicUrl;
  final _userService = locator<UserService>();
  @override
  Widget build(BuildContext context) {
    log(userProfilePicUrl.toString());
    bool isUserInTopThree = false;
    int currentUserRank = 0;

    for (var i = 0; i < model.scoreboard.length; i++) {
      if (model.scoreboard[i].userid == _userService.baseUser.uid) {
        currentUserRank = i + 1;
        break;
      }
    }

    if (currentUserRank <= 3 && currentUserRank > 0) {
      isUserInTopThree = true;
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness5,
        ),
        color: UiConstants.kLeaderBoardBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (model.scoreboard.length >= 3)
            WinnerWidgets(
              scoreboard: model.scoreboard,
              userProfilePicUrl: userProfilePicUrl,
            ),
          if (model.scoreboard.length >= 7 &&
              !isUserInTopThree &&
              currentUserRank != 0)
            UserRank(
              currentUserScore: model.scoreboard[currentUserRank - 1],
              currentUserRank: currentUserRank,
            ),
          RemainingRank(model: model, userProfilePicUrl: userProfilePicUrl),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          if (model.scoreboard.length >= 7)
            TextButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'See All',
                    style: TextStyles.rajdhaniSB.body2,
                  ),
                  SizedBox(
                    width: SizeConfig.padding6,
                  ),
                  Image.asset(
                    'assets/temp/chevron_right.png',
                    width: SizeConfig.iconSize1,
                    height: SizeConfig.iconSize1,
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

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

class RemainingRank extends StatelessWidget {
  const RemainingRank(
      {Key key, @required this.model, @required this.userProfilePicUrl})
      : super(key: key);
  final LeaderBoardModal model;
  final List<String> userProfilePicUrl;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: model.scoreboard.length <= 2
            ? model.scoreboard.length
            : model.scoreboard.length <= 6
                ? model.scoreboard.length - 3
                : 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          int countedIndex = model.scoreboard.length <= 2 ? index : index + 3;
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding20,
              horizontal: SizeConfig.padding24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '${countedIndex + 1}',
                        style: TextStyles.rajdhaniSB.body2,
                      ),
                      SizedBox(
                        width: SizeConfig.padding20,
                      ),
                      userProfilePicUrl[countedIndex] == null
                          ? Image.asset(
                              Assets.profilePic,
                              width: SizeConfig.iconSize5,
                              height: SizeConfig.iconSize5,
                            )
                          : CachedNetworkImage(
                              imageUrl: userProfilePicUrl[countedIndex],
                              width: SizeConfig.iconSize5,
                              height: SizeConfig.iconSize5,
                            ),
                      SizedBox(
                        width: SizeConfig.padding12,
                      ),
                      Expanded(
                        child: Text(
                          '${model.scoreboard[countedIndex].username}',
                          style: TextStyles.sourceSans.body3.setOpecity(0.8),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  '${model.scoreboard[countedIndex].score} points',
                  style: TextStyles.rajdhaniM.body3,
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: SizeConfig.dividerHeight, // 0.5
            color: UiConstants.kDividerColor,
          );
        },
      ),
    );
  }
}
