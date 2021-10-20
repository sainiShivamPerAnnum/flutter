import 'package:felloapp/base_util.dart';
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
import 'package:flutter_svg/flutter_svg.dart';

class TambolaHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<TambolaHomeViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Stack(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  actions: [
                    FelloCoinBar(),
                    SizedBox(width: 16),
                    NotificationButton(),
                  ],
                ),
                WhiteBackground(
                  color: Color(0xffF1F6FF),
                  height: kToolbarHeight * 2.6,
                ),
                SafeArea(
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    margin: EdgeInsets.only(top: kToolbarHeight),
                    child: ListView(
                      children: [
                        GameCard(
                          gameData: model.gameData,
                        ),
                        SizedBox(height: SizeConfig.padding8),
                        Container(
                          height: SizeConfig.screenHeight * 0.8,
                          padding:
                              EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SizeConfig.roundness40),
                              topRight: Radius.circular(SizeConfig.roundness40),
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
                                    GameChips(
                                      model: model,
                                      text: "LeaderBoard",
                                      page: 1,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: PageView(
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: model.pageController,
                                    children: [
                                      model.isPrizesLoading
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                color: UiConstants.primaryColor,
                                              ),
                                            )
                                          : (model.tPrizes == null
                                              ? NoRecordDisplayWidget(
                                                  asset:
                                                      "images/week-winners.png",
                                                  text:
                                                      "Prizes will be updates soon",
                                                )
                                              : PrizesView(
                                                  model: model.tPrizes,
                                                )),
                                      model.isLeaderboardLoading
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                color: UiConstants.primaryColor,
                                              ),
                                            )
                                          : (model.tlboard == null
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        height: SizeConfig
                                                            .padding32),
                                                    Image.asset(
                                                      "images/leaderboard.png",
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          0.2,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          SizeConfig.padding16,
                                                    ),
                                                    Text(
                                                      "Leaderboard will be updated soon.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyles
                                                          .title5.bold,
                                                    )
                                                  ],
                                                )
                                              : LeaderBoardView(
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
                        )
                        // : SpinKitThreeBounce(
                        //     color: UiConstants.spinnerColor2,
                        //     size: 18.0,
                        //   )
                        ,
                        onPressed: () {
                          BaseUtil().openTambolaHome();
                        },
                      ),
                    ))
              ],
            ),
          ),
        );
      },
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
