import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_vm.dart';
import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CricketHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<CricketHomeViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Stack(
              children: [
                WhiteBackground(
                  color: Color(0xffF1F6FF),
                  height: kToolbarHeight * 2.6,
                ),
                RefreshIndicator(
                  onRefresh: model.getLeaderboard,
                  child: SafeArea(
                    child: Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          SizedBox(height: SizeConfig.padding40),
                          GameCard(
                            gameData: model.gameData,
                          ),
                          SizedBox(height: SizeConfig.padding8),
                          Container(
                            height: SizeConfig.screenHeight * 0.8,
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
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 10,
                                            itemBuilder: (ctx, i) {
                                              return FelloBriefTile(
                                                leadingIcon: Icons.first_page,
                                                title: "First Prize",
                                                trailingIcon: Icons.next_plan,
                                              );
                                            }),
                                        model.isLeaderboardLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      UiConstants.primaryColor,
                                                ),
                                              )
                                            : (model.cricLb == null
                                                ? Center(
                                                    child: Text("No data"),
                                                  )
                                                : LeaderBoardView(
                                                    model: model.cricLb,
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
                      onPressed: () async {
                        if (await model.openWebView())
                          model.startGame();
                        else
                          BaseUtil.showNegativeAlert(
                              "Something went wrong", model.message);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class GameChips extends StatelessWidget {
  final CricketHomeViewModel model;
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

class LeaderBoardView extends StatelessWidget {
  final LeaderBoardModal model;
  LeaderBoardView({this.model});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.padding8),
        Padding(
          padding: EdgeInsets.all(SizeConfig.padding8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Last updated on: ${DateFormat('dd-MMM-yyyy | hh:mm:ss').format(model.lastupdated.toDate())}",
                style: TextStyles.body4.colour(Colors.grey),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: model.scoreboard.length,
            itemBuilder: (ctx, i) {
              return Container(
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.all(SizeConfig.padding12),
                margin: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
                decoration: BoxDecoration(
                  color: UiConstants.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: UiConstants.primaryColor,
                      radius: SizeConfig.padding16,
                      child: Text(
                        "${i + 1}",
                        style: TextStyles.body4.colour(Colors.white),
                      ),
                    ),
                    SizedBox(width: SizeConfig.padding12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(model.scoreboard[i].username ?? "Username",
                              style: TextStyles.body3),
                          SizedBox(height: SizeConfig.padding4),
                          Text(
                            "Tambola",
                            style: TextStyles.body4
                                .colour(UiConstants.primaryColor),
                          )
                        ],
                      ),
                    ),
                    TextButton.icon(
                        icon: CircleAvatar(
                          radius: SizeConfig.screenWidth * 0.029,
                          backgroundColor: UiConstants.tertiaryLight,
                          child: SvgPicture.asset(Assets.tickets,
                              height: SizeConfig.iconSize3),
                        ),
                        label: Text(
                            model.scoreboard[i].score.toString() ?? "00",
                            style: TextStyles.body3.colour(Colors.black54)),
                        onPressed: () {}),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
