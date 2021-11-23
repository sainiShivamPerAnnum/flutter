import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TambolaHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<TambolaHomeViewModel>(
      onModelReady: (model) {
        model.init();
        model.scrollController = new ScrollController();
        model.scrollController.addListener(() {
          model.udpateCardOpacity();
        });
      },
      builder: (ctx, model, child) {
        return RefreshIndicator(
          onRefresh: model.getLeaderboard,
          child: Scaffold(
            backgroundColor: UiConstants.primaryColor,
            body: HomeBackground(
              child: Stack(
                children: [
                  WhiteBackground(
                    color: UiConstants.scaffoldColor,
                    height: SizeConfig.screenHeight * 0.2,
                  ),
                  SafeArea(
                    child: Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight,
                      child: ListView(
                        controller: model.scrollController,
                        children: [
                          SizedBox(height: SizeConfig.screenHeight * 0.1),
                          InkWell(
                            onTap: model.openGame,
                            child: Opacity(
                              opacity: model.cardOpacity ?? 1,
                              child: GameCard(
                                gameData: BaseUtil.gamesList[1],
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.padding8),
                          Container(
                            height: SizeConfig.screenHeight * 0.86 -
                                SizeConfig.viewInsets.top,
                            padding: EdgeInsets.all(
                                SizeConfig.pageHorizontalMargins),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(SizeConfig.roundness40),
                                topRight:
                                    Radius.circular(SizeConfig.roundness40),
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.padding4),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GameChips(
                                        model: model,
                                        text: "Prizes",
                                        page: 0,
                                      ),
                                      SizedBox(width: 16),
                                      // GameChips(
                                      //   model: model,
                                      //   text: "LeaderBoard",
                                      //   page: 1,
                                      // )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: PageView(
                                      physics: NeverScrollableScrollPhysics(),
                                      controller: model.pageController,
                                      children: [
                                        model.isPrizesLoading
                                            ? ListLoader()
                                            : (model.tPrizes == null
                                                ? NoRecordDisplayWidget(
                                                    asset:
                                                        "images/week-winners.png",
                                                    text:
                                                        "Prizes will be updates soon",
                                                  )
                                                : PrizesView(
                                                    model: model.tPrizes,
                                                    controller:
                                                        model.scrollController,
                                                    subtitle:
                                                        "Stand to win big prizes every week by matching your tambola tickets! Winners are announced every Monday",
                                                    leading: [
                                                      Icons.apps,
                                                      Icons.border_top,
                                                      Icons.border_horizontal,
                                                      Icons.border_bottom,
                                                      Icons.border_outer
                                                    ]
                                                        .map((e) => Icon(
                                                              e,
                                                              color: UiConstants
                                                                  .primaryColor,
                                                            ))
                                                        .toList(),
                                                  )),
                                        model.isLeaderboardLoading
                                            ? ListLoader()
                                            : (model.tlboard == null ||
                                                    model.tlboard.scoreboard
                                                        .isEmpty
                                                ? NoRecordDisplayWidget(
                                                    asset:
                                                        "images/leaderboard.png",
                                                    text:
                                                        "Leaderboard will be updated soon",
                                                  )
                                                : LeaderBoardView(
                                                    controller:
                                                        model.scrollController,
                                                    model: model.tlboard,
                                                  ))
                                      ]),
                                ),
                                SizedBox(height: SizeConfig.padding64)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  FelloAppBar(
                    leading: FelloAppBarBackButton(),
                    actions: [
                      FelloCoinBar(),
                      SizedBox(width: 16),
                      NotificationButton(),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.scaffoldMargin, vertical: 16),
                      child: FelloButtonLg(
                        child: Text(
                          'PLAY',
                          style: TextStyles.body2.colour(Colors.white),
                        ),
                        onPressed: model.openGame,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ListLoader extends StatelessWidget {
  const ListLoader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.1),
        SpinKitWave(
          color: UiConstants.primaryColor,
        ),
      ],
    );
  }
}

class GameChips extends StatelessWidget {
  final TambolaHomeViewModel model;
  final String text;
  final int page;
  GameChips({this.model, this.text, this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => model.viewpage(page),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding24, vertical: SizeConfig.padding12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: model.currentPage == page
              ? UiConstants.primaryColor
              : UiConstants.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(text,
            style: model.currentPage == page
                ? TextStyles.body3.bold.colour(Colors.white)
                : TextStyles.body3.colour(UiConstants.primaryColor)),
      ),
    );
  }
}
