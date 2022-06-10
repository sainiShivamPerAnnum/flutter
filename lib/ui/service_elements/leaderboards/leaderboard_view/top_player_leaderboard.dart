import 'dart:developer';

import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/components/user_rank.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/components/winner_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class TopPlayerLeaderboardView extends StatelessWidget {
  const TopPlayerLeaderboardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<LeaderboardService,
        LeaderBoardServiceProperties>(
      properties: [LeaderBoardServiceProperties.WebGameLeaderBoard],
      builder: (context, m, properties) {
        return TopPlayer(
          model: m.WebGameLeaderBoard,
          userProfilePicUrl: m.userProfilePicUrl,
          currentUserRank: m.currentUserRank,
          isUserInTopThree: m.isUserInTopThree,
        );
      },
    );
  }
}

class TopPlayer extends StatelessWidget {
  const TopPlayer({
    @required this.model,
    @required this.userProfilePicUrl,
    @required this.currentUserRank,
    @required this.isUserInTopThree,
  });

  final LeaderBoardModal model;
  final List<String> userProfilePicUrl;
  final bool isUserInTopThree;
  final int currentUserRank;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.padding20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.only(right: SizeConfig.padding20),
                      child: SvgPicture.asset('assets/temp/chevron_left.svg'),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Leaderboard",
                        style: TextStyles.rajdhaniSB.title4,
                      ),
                      Text(
                        "Updated on: ${DateFormat('dd-MMM-yyyy | hh:mm:ss').format(model.lastupdated.toDate())}",
                        style: TextStyles.sourceSans.body3
                            .colour(UiConstants.kLastUpdatedTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(height: SizeConfig.padding20),
            WinnerWidgets(
              scoreboard: model.scoreboard,
              userProfilePicUrl: userProfilePicUrl,
            ),
            AllPlayerList(
                model: model,
                currentUserRank: currentUserRank,
                isUserInTopThree: isUserInTopThree),
          ],
        ),
      ),
    );
  }
}

class AllPlayerList extends StatelessWidget {
  AllPlayerList({
    Key key,
    @required this.model,
    @required this.currentUserRank,
    @required this.isUserInTopThree,
  }) : super(key: key);

  final LeaderBoardModal model;
  final bool isUserInTopThree;
  final int currentUserRank;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.597,
      padding: EdgeInsets.only(
        top: SizeConfig.padding24,
        left: SizeConfig.padding24,
        right: SizeConfig.padding24,
      ),
      decoration: BoxDecoration(
        color: UiConstants.kLeaderBoardBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.roundness24),
          topRight: Radius.circular(SizeConfig.roundness24),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${model.scoreboard.length} Players",
                  style: TextStyles.sourceSans.body3,
                ),
                Text(
                  "All Time",
                  style: TextStyles.sourceSans.body3,
                ),
              ],
            ),
          ),
          if (model.scoreboard.length >= 7 &&
              !isUserInTopThree &&
              currentUserRank != 0)
            UserRank(
              currentUserScore: model.scoreboard[currentUserRank - 1],
              currentUserRank: currentUserRank,
            ),
          Expanded(
            child: Scrollbar(
              radius: Radius.circular(SizeConfig.roundness24),
              child: ListView.builder(
                itemCount: model.scoreboard.length - 3,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  int countedIndex = index + 3;
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
                                width: SizeConfig.padding12,
                              ),
                              Expanded(
                                child: Text(
                                  '${model.scoreboard[countedIndex - 1].username}',
                                  style: TextStyles.sourceSans.body3
                                      .setOpecity(0.8),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          '${model.scoreboard[countedIndex - 1].score} points',
                          style: TextStyles.rajdhaniM.body3,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
