import 'dart:developer';

import 'package:felloapp/ui/pages/others/games/web/new_game_home/leaderboard/leaderboard_view.dart';
import 'package:felloapp/ui/pages/others/games/web/new_game_home/reward/reward_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class NewGameHomeView extends StatelessWidget {
  const NewGameHomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WebGameHome();
  }
}

class WebGameHome extends StatefulWidget {
  const WebGameHome({Key key}) : super(key: key);

  @override
  State<WebGameHome> createState() => _WebGameHomeState();
}

class _WebGameHomeState extends State<WebGameHome>
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
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  "Some Widgets",
                  style: SansPro.style.body3,
                ),
              ),
            ),
            Column(
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
                  unselectedLabelColor:
                      UiConstants.titleTextColor.withOpacity(0.6),
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 30),
                  tabs: [
                    Tab(
                      child: Text(
                        'Rewards',
                        style: SansPro.style.body1.semiBold,
                      ),
                      height: SizeConfig.navBarHeight,
                    ),
                    Tab(
                      child: Text(
                        'Laderboard',
                        style: SansPro.style.body1.semiBold,
                      ),
                      height: SizeConfig.navBarHeight,
                    ),
                  ],
                ),
                _buildTabView(context, 0),
              ],
            ),
            SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  "Some Widgets",
                  style: SansPro.style.body3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTabView(BuildContext context, int i) {
    log(SizeConfig.screenWidth.toString()); // 360, 780
    double rewardSize = (SizeConfig.screenHeight * 0.3462) +
        (SizeConfig.screenHeight * 0.0872 * 5); // 300 + (68 * 7)
    double leaderboardSize = SizeConfig.screenHeight * 0.74; // 570
    return SizedBox(
      height: _tabController.index == 0
          ? rewardSize < leaderboardSize
              ? leaderboardSize
              : rewardSize
          : leaderboardSize,
      child: TabBarView(
        children: const [
          RewardView(),
          LeaderBoardView(),
        ],
        controller: _tabController,
      ),
    );
  }
}
