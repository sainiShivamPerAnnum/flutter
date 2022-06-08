import 'dart:developer';

import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/components/leaderboard_shimmer.dart';
import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/components/reward_shimmer.dart';
import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/reward_leaderboard_vm.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/reward_view/new_web_game_reward_view.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/new_web_game_leaderboard.dart';
import 'package:felloapp/ui/widgets/helpers/height_adaptive_pageview.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class RewardLeaderboardView extends StatelessWidget {
  RewardLeaderboardView({Key key, @required this.game}) : super(key: key);
  final String game;

  final TextStyle selectedTextStyle =
      TextStyles.sourceSansSB.body1.colour(UiConstants.titleTextColor);

  final TextStyle unselectedTextStyle = TextStyles.sourceSansSB.body1
      .colour(UiConstants.titleTextColor.withOpacity(0.6));

  @override
  Widget build(BuildContext context) {
    return BaseView<RewardLeaderboardViewModel>(
      onModelReady: (model) {
        model.init(game);
      },
      onModelDispose: (model) {
        model.clear();
      },
      builder: (context, model, child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => model.switchTab(0),
                    child: Container(
                      height: SizeConfig.navBarHeight,
                      alignment: Alignment.center,
                      child: Text(
                        'Rewards',
                        style: model.tabNo == 0
                            ? selectedTextStyle
                            : unselectedTextStyle, // TextStyles.sourceSansSB.body1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => model.switchTab(1),
                    child: Container(
                      height: SizeConfig.navBarHeight,
                      alignment: Alignment.center,
                      child: Text(
                        'Leaderboard',
                        style: model.tabNo == 1
                            ? selectedTextStyle
                            : unselectedTextStyle, // style: TextStyles.sourceSansSB.body1,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: 5,
                  width: model.tabPosWidthFactor,
                ),
                Container(
                  color: UiConstants.kTabBorderColor,
                  height: 5,
                  width: SizeConfig.screenWidth * 0.4,
                )
              ],
            ),
            _buildTabView(model),
          ],
        );
      },
    );
  }

  _buildTabView(RewardLeaderboardViewModel model) {
    return HeightAdaptivePageView(
      controller: model.pageController,
      onPageChanged: (int page) {
        model.switchTab(page);
      },
      children: [
        model.isPrizesLoading
            ? RewardShimmer()
            : (model.prizes == null)
                ? NoRecordDisplayWidget(
                    asset: "images/week-winners.png",
                    text: "Prizes will be updates soon",
                  )
                : RewardView(model: model.prizes),
        model.isLeaderboardLoading
            ? LeaderboardShimmer()
            : NewWebGameLeaderBoardView(),
      ],
    );
  }
}
