import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/components/user_rank.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/components/winner_widget.dart';
import 'package:felloapp/util/assets.dart';
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
                currentUserRank: m.currentUserRank,
                isUserInTopThree: m.isUserInTopThree,
              );
      },
    );
  }
}

class NewLeaderBoardView extends StatelessWidget {
  NewLeaderBoardView({
    @required this.model,
    @required this.userProfilePicUrl,
    @required this.isUserInTopThree,
    @required this.currentUserRank,
  });

  final LeaderBoardModal model;
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
                    'assets/temp/chevron_right.svg',
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

class RemainingRank extends StatelessWidget {
  const RemainingRank({
    Key key,
    @required this.model,
    @required this.userProfilePicUrl,
  }) : super(key: key);
  final LeaderBoardModal model;
  final List<String> userProfilePicUrl;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
    );
  }
}
