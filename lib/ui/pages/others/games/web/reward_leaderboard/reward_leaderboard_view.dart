import 'dart:developer';

import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/components/leaderboard_shimmer.dart';
import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/components/reward_shimmer.dart';
import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/reward_leaderboard_vm.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/reward_view/new_web_game_reward_view.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/new_web_game_leaderboard.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RewardLeaderboardView extends StatefulWidget {
  const RewardLeaderboardView({Key key, @required this.game}) : super(key: key);
  final String game;

  @override
  State<RewardLeaderboardView> createState() => _RewardLeaderboardViewState();
}

class _RewardLeaderboardViewState extends State<RewardLeaderboardView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<RewardLeaderboardViewModel>(
      onModelReady: (model) {
        model.init(widget.game);
      },
      onModelDispose: (model) {
        model.clear();
      },
      builder: (context, model, child) {
        return Column(
          children: [
            TabBar(
              controller: _tabController,
              indicator: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: UiConstants.kTabBorderColor,
                    width: 5,
                  ),
                ),
              ),
              labelColor: UiConstants.titleTextColor,
              unselectedLabelColor: UiConstants.titleTextColor.withOpacity(0.6),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 30),
              tabs: [
                Tab(
                  child: Text(
                    'Rewards',
                    style: TextStyles.sourceSansSB.body1,
                  ),
                  height: SizeConfig.navBarHeight,
                ),
                Tab(
                  child: Text(
                    'Laderboard',
                    style: TextStyles.sourceSansSB.body1,
                  ),
                  height: SizeConfig.navBarHeight,
                ),
              ],
            ),
            _buildTabView(context, 0, model),
          ],
        );
      },
    );
  }

  _buildTabView(BuildContext context, int i, RewardLeaderboardViewModel model) {
    // log(SizeConfig.screenWidth.toString()); // 360, 780
    int rewardsCount;
    double rewardSize;

    if (!model.isPrizesLoading) {
      rewardsCount = model.prizes.prizesA.length - 3;
      rewardSize = (SizeConfig.screenHeight * 0.335) +
          (SizeConfig.screenHeight *
              0.0872 *
              rewardsCount); // 300 + (68 * [rewardsCount])
    }

    double leaderboardSize = SizeConfig.screenHeight * 0.74; // 570
    return SizedBox(
      height: model.isPrizesLoading
          ? leaderboardSize
          : _tabController.index == 0
              ? rewardSize < leaderboardSize
                  ? leaderboardSize
                  : rewardSize
              : leaderboardSize,
      child: TabBarView(
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
        controller: _tabController,
      ),
    );
  }
}
