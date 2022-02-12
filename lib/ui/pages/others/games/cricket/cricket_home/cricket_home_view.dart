import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/service/analytics/analytics_events.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/service_elements/leaderboards/cric_leaderboard.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class CricketHomeView extends StatelessWidget {
  final _analyticsService = locator<AnalyticsService>();
  @override
  Widget build(BuildContext context) {
    return BaseView<CricketHomeViewModel>(
      onModelReady: (model) {
        model.init();
        model.scrollController.addListener(() {
          model.udpateCardOpacity();
        });
      },
      builder: (ctx, model, child) {
        return RefreshIndicator(
          onRefresh: () => model.refreshLeaderboard(),
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
                            onTap: () async {
                              if (await BaseUtil.showNoInternetAlert()) return;
                              if (model.state == ViewState.Idle) {
                                if (await model.openWebView())
                                  model.startGame();
                                else
                                  earnMoreTokens();
                              }
                            },
                            child: Opacity(
                              opacity: model.cardOpacity ?? 1,
                              child: GameCard(
                                gameData: BaseUtil.gamesList[0],
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
                                            ? ListLoader()
                                            : (model.cPrizes == null
                                                ? NoRecordDisplayWidget(
                                                    asset:
                                                        "images/week-winners.png",
                                                    text:
                                                        "Prizes will be updates soon",
                                                  )
                                                : PrizesView(
                                                    model: model.cPrizes,
                                                    controller:
                                                        model.scrollController,
                                                    subtitle: BaseRemoteConfig
                                                            .remoteConfig
                                                            .getString(
                                                                BaseRemoteConfig
                                                                    .GAME_CRICKET_ANNOUNCEMENT) ??
                                                        'The highest scorers of the week win prizes every Sunday at midnight',
                                                    leading: List.generate(
                                                        model.cPrizes.prizesA
                                                            .length,
                                                        (i) => Text(
                                                              "${i + 1}",
                                                              style: TextStyles
                                                                  .body3.bold
                                                                  .colour(UiConstants
                                                                      .primaryColor),
                                                            )),
                                                  )),
                                        CricketLeaderboardView()
                                      ]),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (model.state == ViewState.Idle)
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.scaffoldMargin,
                            vertical: 16),
                        child: FelloButtonLg(
                            child:
                                //  (model.state == ViewState.Idle)
                                //     ?
                                Text(
                              'PLAY',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: Colors.white),
                            ),
                            // : SpinKitThreeBounce(
                            //     color: UiConstants.spinnerColor2,
                            //     size: 18.0,
                            //   ),
                            onPressed: () async {
                              if (model.state == ViewState.Idle) {
                                if (await model.openWebView())
                                  model.startGame();
                                else
                                  earnMoreTokens();
                              }
                            }),
                      ),
                    ),
                  if (model.state == ViewState.Busy)
                    Container(
                      color: Colors.white.withOpacity(0.5),
                      child: SafeArea(
                        child: Center(
                          child: SpinKitWave(
                            color: UiConstants.primaryColor,
                            size: SizeConfig.padding32,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void earnMoreTokens() {
    _analyticsService.track(eventName: AnalyticsEvents.earnMoreTokens);
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      content: WantMoreTicketsModalSheet(
        isInsufficientBalance: true,
      ),
      hapticVibrate: true,
      backgroundColor: Colors.transparent,
      isBarrierDismissable: true,
    );
  }
}

class NoRecordDisplayWidget extends StatelessWidget {
  final String asset;
  final String assetSvg;
  final String assetLottie;
  final String text;
  final bool topPadding;

  NoRecordDisplayWidget(
      {this.asset,
      this.text,
      this.assetSvg,
      this.assetLottie,
      this.topPadding = true});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (topPadding) SizedBox(height: SizeConfig.screenHeight * 0.1),
        if (asset != null)
          Image.asset(
            asset,
            height: SizeConfig.screenHeight * 0.16,
          ),
        if (assetSvg != null)
          SvgPicture.asset(
            assetSvg,
            height: SizeConfig.screenHeight * 0.16,
          ),
        if (assetLottie != null)
          Lottie.asset(
            assetLottie,
            repeat: false,
            height: SizeConfig.screenHeight * 0.26,
          ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyles.body2.bold,
        )
      ],
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

class PrizesView extends StatelessWidget {
  final PrizesModel model;
  final ScrollController controller;
  final List<Widget> leading;
  final String subtitle;

  PrizesView({this.model, this.leading, this.controller, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollNotification>(
      onNotification: (OverscrollNotification value) {
        if (value.overscroll < 0 && controller.offset + value.overscroll <= 0) {
          if (controller.offset != 0) controller.jumpTo(0);
          return true;
        }
        if (controller.offset + value.overscroll >=
            controller.position.maxScrollExtent) {
          if (controller.offset != controller.position.maxScrollExtent)
            controller.jumpTo(controller.position.maxScrollExtent);
          return true;
        }
        controller.jumpTo(controller.offset + value.overscroll);
        return true;
      },
      child: ListView.builder(
        itemCount: model.prizesA.length + 1,
        padding: EdgeInsets.only(bottom: SizeConfig.navBarHeight),
        itemBuilder: (ctx, i) {
          if (i == 0)
            return Container(
              margin: EdgeInsets.only(top: SizeConfig.padding8),
              decoration: BoxDecoration(
                color: UiConstants.tertiaryLight,
                // image: DecorationImage(
                //   image: AssetImage("assets/images/confetti.png"),
                //   fit: BoxFit.cover,
                //   colorFilter: new ColorFilter.mode(
                //       UiConstants.tertiaryLight.withOpacity(0.1),
                //       BlendMode.dstATop),
                // ),
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              ),
              padding: EdgeInsets.all(SizeConfig.padding16),
              child: Stack(
                children: [
                  //Image.asset("assets/images/confetti.png"),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyles.body3.light,
                  ),
                ],
              ),
            );
          else {
            i--;
            return Container(
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.all(SizeConfig.padding12),
              margin: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
              decoration: BoxDecoration(
                color: UiConstants.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: SizeConfig.padding24,
                      backgroundColor:
                          UiConstants.primaryColor.withOpacity(0.3),
                      child: leading[i]),
                  SizedBox(width: SizeConfig.padding12),
                  Expanded(
                    child: Text(
                      model.prizesA[i].displayName ?? "Prize ${i + 1}",
                      style: TextStyles.body3.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrizeChip(
                        color: UiConstants.tertiarySolid,
                        svg: Assets.tokens,
                        text: "${model.prizesA[i].flc}",
                      ),
                      SizedBox(width: SizeConfig.padding16),
                      PrizeChip(
                        color: UiConstants.primaryColor,
                        png: Assets.moneyIcon,
                        text: "₹ ${model.prizesA[i].amt}",
                      )
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class PrizeChip extends StatelessWidget {
  final String svg, png, text;
  final Color color;
  final double opacity;
  final bool svgPaint;

  PrizeChip(
      {this.color,
      this.png,
      this.svg,
      this.text,
      this.opacity = 0.2,
      this.svgPaint = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CircleAvatar(
            radius: SizeConfig.iconSize3,
            backgroundColor: color.withOpacity(opacity),
            child: svg != null
                ? (svgPaint
                    ? SvgPicture.asset(
                        svg,
                        height: SizeConfig.iconSize3,
                        color: color,
                      )
                    : SvgPicture.asset(
                        svg,
                        height: SizeConfig.iconSize3,
                      ))
                : Image.asset(
                    png,
                    height: SizeConfig.iconSize3,
                  ),
          ),
          SizedBox(width: SizeConfig.padding8),
          Text(text, style: TextStyles.body3)
        ],
      ),
    );
  }
}
