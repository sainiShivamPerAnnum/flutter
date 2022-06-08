import 'dart:developer';

import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/games/web/web_home/web_home_vm.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/reward_view/new_web_game_reward_view.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/new_web_game_leaderboard.dart';
import 'package:felloapp/ui/widgets/helpers/height_adaptive_pageview.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class NewWebHomeView extends StatefulWidget {
  const NewWebHomeView({Key key, @required this.game}) : super(key: key);
  final String game;

  @override
  State<NewWebHomeView> createState() => _NewWebHomeViewState();
}

class _NewWebHomeViewState extends State<NewWebHomeView> {
  PageController _pageController;
  double tabPosWidthFactor = SizeConfig.pageHorizontalMargins;
  int tabNo = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  switchTab(int tab) {
    setState(() {
      tabPosWidthFactor = tabNo == 0
          ? SizeConfig.screenWidth / 2 + SizeConfig.pageHorizontalMargins
          : SizeConfig.pageHorizontalMargins;
    });
    _pageController.animateToPage(tab,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
    tabNo = tab;
  }

  TextStyle selectedTextStyle =
      TextStyles.sourceSansSB.body1.colour(UiConstants.titleTextColor);

  TextStyle unselectedTextStyle = TextStyles.sourceSansSB.body1
      .colour(UiConstants.titleTextColor.withOpacity(0.6));

  @override
  Widget build(BuildContext context) {
    return BaseView<WebHomeViewModel>(
      onModelReady: (model) {
        model.init(widget.game);
        model.scrollController.addListener(() {
          model.udpateCardOpacity();
        });
      },
      onModelDispose: (model) {
        model.clear();
      },
      builder: (context, model, child) {
        return RefreshIndicator(
          onRefresh: () => model.refreshLeaderboard(),
          child: Scaffold(
            backgroundColor: UiConstants.kBackgroundColor,
            body: SafeArea(
              child: ListView(
                children: [
                  SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        "Some Widgets",
                        style: TextStyles.sourceSans.body3,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => switchTab(0),
                              child: Container(
                                height: SizeConfig.navBarHeight,
                                alignment: Alignment.center,
                                child: Text(
                                  'Rewards',
                                  style: tabNo == 0
                                      ? selectedTextStyle
                                      : unselectedTextStyle, // TextStyles.sourceSansSB.body1,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => switchTab(1),
                              child: Container(
                                height: SizeConfig.navBarHeight,
                                alignment: Alignment.center,
                                child: Text(
                                  'Leaderboard',
                                  style: tabNo == 1
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
                              width: tabPosWidthFactor),
                          Container(
                            color: UiConstants.kTabBorderColor,
                            height: 5,
                            width: SizeConfig.screenWidth * 0.4,
                          )
                        ],
                      ),
                      HeightAdaptivePageView(
                        controller: _pageController,
                        children: [
                          model.isPrizesLoading
                              ? ListLoader()
                              : (model.prizes == null)
                                  ? NoRecordDisplayWidget(
                                      asset: "images/week-winners.png",
                                      text: "Prizes will be updates soon",
                                    )
                                  : RewardView(model: model.prizes),
                          SizedBox(
                              height: 500, child: NewWebGameLeaderBoardView()),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 800,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        "Some Widgets",
                        style: TextStyles.sourceSans.body3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
