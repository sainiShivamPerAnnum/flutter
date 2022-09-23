import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/scoreboard_model.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/components/leaderboard_shimmer.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/components/user_rank.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/components/winner_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class NewWebGameLeaderBoardView extends StatelessWidget {
  const NewWebGameLeaderBoardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<LeaderboardService,
        LeaderBoardServiceProperties>(
      properties: [
        LeaderBoardServiceProperties.WebGameLeaderBoard,
        LeaderBoardServiceProperties.LeaderBoardState
      ],
      builder: (context, m, properties) {
        return m.isLeaderboardLoading
            ? LeaderboardShimmer()
            : (m.WebGameLeaderBoard != null &&
                    m.WebGameLeaderBoard.scoreboard != null
                // &&
                // (m.userProfilePicUrl.length >=
                //     m.WebGameLeaderBoard.scoreboard.length)
                ? NewLeaderBoardView(
                    scoreBoard: m.WebGameLeaderBoard.scoreboard,
                    userProfilePicUrl: m.userProfilePicUrl,
                    currentUserRank: m.currentUserRank,
                    isUserInTopThree: m.isUserInTopThree,
                  )
                : Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                    decoration: BoxDecoration(
                      color: UiConstants.gameCardColor,
                      borderRadius: BorderRadius.circular(
                        SizeConfig.roundness8,
                      ),
                    ),
                    padding: EdgeInsets.only(bottom: SizeConfig.padding80 * 3),
                    child: NoRecordDisplayWidget(
                      asset: "images/leaderboard.png",
                      text: "Leaderboard will be updated soon",
                    ),
                  ));
      },
    );
  }
}

class NewLeaderBoardView extends StatelessWidget {
  NewLeaderBoardView({
    @required this.scoreBoard,
    @required this.userProfilePicUrl,
    @required this.isUserInTopThree,
    @required this.currentUserRank,
  });

  final List<ScoreBoard> scoreBoard;
  final List<String> userProfilePicUrl;
  final bool isUserInTopThree;
  final int currentUserRank;
  @override
  Widget build(BuildContext context) {
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
        color: UiConstants.kSecondaryBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (scoreBoard.length >= 3)
            WinnerWidgets(
              scoreboard: scoreBoard,
              userProfilePicUrl: userProfilePicUrl,
            ),
          if (scoreBoard.length >= 7 &&
              !isUserInTopThree &&
              currentUserRank != 0)
            UserRank(
              currentUserScore: scoreBoard[currentUserRank - 1],
              currentUserRank: currentUserRank,
            ),
          RemainingRank(
            userProfilePicUrl: userProfilePicUrl,
            scoreboard: scoreBoard,
          ),
          if (scoreBoard.length >= 7)
            SizedBox(
              height: SizeConfig.padding12,
            ),
          if (scoreBoard.length >= 7)
            TextButton(
              onPressed: () {
                AppState.delegate.appState.currentAction = PageAction(
                  state: PageState.addPage,
                  page: TopPlayerLeaderboardPageConfig,
                );
              },
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
                  SvgPicture.asset(
                    Assets.chevRonRightArrow,
                    color: Colors.white,
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

//
class RemainingRank extends StatelessWidget {
  RemainingRank({
    Key key,
    @required this.userProfilePicUrl,
    @required this.scoreboard,
  }) : super(key: key);
  final List<String> userProfilePicUrl;
  final _userService = locator<UserService>();
  final List<ScoreBoard> scoreboard;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: scoreboard.length <= 2
          ? scoreboard.length
          : scoreboard.length <= 6
              ? scoreboard.length - 3
              : 3,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        int countedIndex = scoreboard.length <= 2 ? index : index + 3;
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
                        ? SvgPicture.asset(
                            getDefaultProfilePicture(countedIndex),
                            width: SizeConfig.iconSize5,
                            height: SizeConfig.iconSize5,
                            fit: BoxFit.cover,
                          )
                        : ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: userProfilePicUrl[countedIndex],
                              width: SizeConfig.iconSize5,
                              height: SizeConfig.iconSize5,
                              fit: BoxFit.cover,
                            ),
                          ),
                    SizedBox(
                      width: SizeConfig.padding12,
                    ),
                    Expanded(
                      child: Text(
                        '${_userService.diplayUsername(scoreboard[countedIndex].username)}',
                        style: TextStyles.sourceSans.body3.setOpecity(0.8),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                '${(scoreboard[countedIndex].score).toInt()} points',
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
    );
  }

  getDefaultProfilePicture(int rank) {
    switch (rank) {
      case 4:
        return Assets.cvtar4;
      case 5:
        return Assets.cvtar4;
      case 6:
        return Assets.cvtar1;
      default:
        return Assets.profilePic;
    }
  }
}
