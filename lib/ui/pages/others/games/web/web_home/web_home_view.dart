import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/reward_leaderboard_view.dart';
import 'package:felloapp/ui/pages/others/games/web/web_home/web_home_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/service_elements/leaderboards/leaderboard_view/allParticipants_referal_winners.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/widgets/default_avatar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class WebHomeView extends StatelessWidget {
  const WebHomeView({Key key, @required this.game}) : super(key: key);
  final String game;

  @override
  Widget build(BuildContext context) {
    StreamController controller = StreamController.broadcast();

    ScrollController _controller = ScrollController();

    return BaseView<WebHomeViewModel>(
      onModelReady: (model) {
        model.init(game);
      },
      onModelDispose: (model) {
        model.clear();
      },
      builder: (ctx, model, child) {
        return RefreshIndicator(
          color: UiConstants.primaryColor,
          backgroundColor: Colors.black,
          onRefresh: () => model.refreshLeaderboard(),
          child: Scaffold(
            body: Stack(
              children: [
                NewSquareBackground(),
                CustomScrollView(
                  controller: _controller,
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverLayoutBuilder(
                      builder: (context, constraints) {
                        final scrolled = constraints.scrollOffset > 0;
                        print(constraints.scrollOffset);
                        return SliverAppBar(
                          title: AnimatedOpacity(
                            duration: Duration(milliseconds: 100),
                            curve: Curves.easeIn,
                            opacity: constraints.scrollOffset >
                                    (SizeConfig.screenWidth * 0.35)
                                ? 1
                                : 0, //constraints.scrollOffset.clamp(0, 1),
                            child: Text(
                              model.currentGameModel.gameName,
                              style: TextStyles.rajdhaniB.title5
                                  .colour(Colors.white),
                            ),
                          ),
                          pinned: true,
                          centerTitle: false,
                          backgroundColor: model.currentGameModel.shadowColor,
                          actions: [
                            Padding(
                              padding:
                                  EdgeInsets.only(right: SizeConfig.padding4),
                              child: Row(
                                children: [
                                  FelloCoinBar(svgAsset: Assets.token),
                                ],
                              ),
                            ),
                          ],
                          expandedHeight: SizeConfig.screenWidth * 0.45,
                          flexibleSpace: FlexibleSpaceBar(
                            background: model.isLoading
                                ? Shimmer.fromColors(
                                    baseColor:
                                        UiConstants.kUserRankBackgroundColor,
                                    highlightColor:
                                        UiConstants.kBackgroundColor,
                                    child: Container(
                                      color: Colors.grey,
                                    ),
                                  )
                                : Container(
                                    color: model.currentGameModel.shadowColor,
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.viewInsets.top +
                                            SizeConfig.padding12,
                                        left: SizeConfig.pageHorizontalMargins *
                                            2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  model
                                                      .currentGameModel.gameName
                                                      .split(' ')
                                                      .first,
                                                  style: TextStyles
                                                      .rajdhaniB.title1),
                                              Text(
                                                  model
                                                      .currentGameModel.gameName
                                                      .split(' ')
                                                      .last,
                                                  style: TextStyles
                                                      .rajdhaniSB.title3),
                                              SizedBox(
                                                  height: SizeConfig.padding16),
                                            ]),
                                        Spacer(),
                                        SvgPicture.network(
                                            model.currentGameModel.icon,
                                            fit: BoxFit.cover,
                                            height:
                                                SizeConfig.screenWidth * 0.5,
                                            width:
                                                SizeConfig.screenWidth * 0.5),
                                        SizedBox(
                                          width:
                                              SizeConfig.pageHorizontalMargins,
                                        )
                                      ],
                                    ),
                                  ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ),
                        );
                      },
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(height: SizeConfig.padding40),
                          model.isLoading
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor:
                                          UiConstants.kUserRankBackgroundColor,
                                      highlightColor:
                                          UiConstants.kBackgroundColor,
                                      child: Container(
                                        width: SizeConfig.screenWidth * 0.155,
                                        height: SizeConfig.screenWidth * 0.120,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    //
                                    Shimmer.fromColors(
                                      baseColor:
                                          UiConstants.kUserRankBackgroundColor,
                                      highlightColor:
                                          UiConstants.kBackgroundColor,
                                      child: Container(
                                        width: SizeConfig.screenWidth * 0.155,
                                        height: SizeConfig.screenWidth * 0.120,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    //
                                    Shimmer.fromColors(
                                      baseColor:
                                          UiConstants.kUserRankBackgroundColor,
                                      highlightColor:
                                          UiConstants.kBackgroundColor,
                                      child: Container(
                                        width: SizeConfig.screenWidth * 0.155,
                                        height: SizeConfig.screenWidth * 0.120,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //StreamBuilder
                                    StreamView(model: model, game: game),
                                    GameInfoBlock(
                                      coin:
                                          '${NumberFormat.compact().format(model.currentGameModel.prizeAmount)}',
                                      coinText: 'Win upto',
                                      assetHeight: SizeConfig.padding20,
                                      assetUrl: Assets.rewardGameAsset,
                                    ),
                                    GameInfoBlock(
                                      coin:
                                          '${model.currentGameModel.playCost}',
                                      coinText: 'Per Game',
                                      assetHeight: SizeConfig.padding20,
                                      assetUrl: Assets.token,
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: SizeConfig.padding32,
                          ),
                          model.isLoading
                              ? Shimmer.fromColors(
                                  baseColor:
                                      UiConstants.kUserRankBackgroundColor,
                                  highlightColor: UiConstants.kBackgroundColor,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.all(SizeConfig.padding4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade600,
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.roundness5),
                                        ),
                                        width: SizeConfig.screenWidth,
                                        height: SizeConfig.screenWidth * 0.021,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.all(SizeConfig.padding2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade600,
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.roundness5),
                                        ),
                                        width: SizeConfig.screenWidth / 2,
                                        height: SizeConfig.screenWidth * 0.021,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding16),
                                  child: Text(
                                    'Swing your wicket, throw fast pitches, and win upto ? Rs. 25,000 in one of our many free, online games!',
                                    style: TextStyles.sourceSans.body3
                                        .colour(Colors.grey.shade600),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                          if (model.currentCoinValue <
                              model.currentGameModel.playCost)
                            RechargeOptions(model: model),
                          SizedBox(
                            height: SizeConfig.padding32,
                          ),
                          RewardLeaderboardView(game: game),
                          if (model.currentCoinValue >=
                              model.currentGameModel.playCost)
                            RechargeOptions(model: model),
                          SizedBox(
                            height: SizeConfig.padding80 * 2,
                          ),
                          PastWeekWinners(count: 5, model: model),
                          SizedBox(
                            height: SizeConfig.padding80 * 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.padding24),
                    child: ReactivePositiveAppButton(
                      btnText: 'Play',
                      onPressed: () async {
                        Haptic.vibrate();
                        if (await model.setupGame()) model.launchGame();

                        // model.pageController.jumpToPage(1);
                      },
                    ),
                  ),
                ),
                model.currentCoinValue < model.currentGameModel.playCost
                    ? PlayButtonOverlapper()
                    : SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RechargeOptions extends StatelessWidget {
  final WebHomeViewModel model;
  const RechargeOptions({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.padding32),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
          child: Text(
            'Recharge Options',
            style: TextStyles.sourceSansSB.title5,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: SizeConfig.padding24,
          ),
          height: SizeConfig.screenWidth * 0.125,
          width: SizeConfig.screenWidth,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: model.rechargeOptions.length,
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
            itemBuilder: (ctx, i) {
              return RechargeBox(
                rechargeOption: model.rechargeOptions[i],
              );
            },
          ),
        ),
      ],
    );
  }
}

class PlayButtonOverlapper extends StatelessWidget {
  final _analytics = locator<AnalyticsService>();

  PlayButtonOverlapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (JourneyService.isAvatarAnimationInProgress) return;
              _analytics.track(eventName: AnalyticsEvents.addFLCTokensTopRight);
              BaseUtil.openModalBottomSheet(
                addToScreenStack: true,
                backgroundColor: UiConstants.gameCardColor,
                content: WantMoreTicketsModalSheet(),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness24),
                  topRight: Radius.circular(SizeConfig.roundness24),
                ),
                hapticVibrate: true,
                isScrollControlled: true,
                isBarrierDismissable: true,
              );
            },
            child: Container(
              height: SizeConfig.navBarHeight + SizeConfig.padding64,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: UiConstants.kBackgroundColor.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.roundness24),
                      topRight: Radius.circular(SizeConfig.roundness24))),
            ),
          ),
          Container(
            padding: EdgeInsets.all(SizeConfig.padding12),
            width: double.infinity,
            decoration: BoxDecoration(
                color: UiConstants.kBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.roundness24),
                    topRight: Radius.circular(SizeConfig.roundness24))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: SizeConfig.padding12),
                  width: SizeConfig.padding10,
                  height: SizeConfig.padding10,
                  decoration: BoxDecoration(
                    color: UiConstants.kSnackBarNegativeContentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  "You don’t have enough tokens to play",
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.kTextColor2),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StreamView extends StatelessWidget {
  StreamView({Key key, @required this.model, @required this.game})
      : super(key: key);

  final WebHomeViewModel model;
  String game;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: null,
      stream: model.getRealTimePlayingStream(game),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return GameInfoBlock(
            coin: "-",
            coinText: 'Playing',
            assetHeight: SizeConfig.padding16,
            isDot: true,
          );
        }

        if ((snapshot.data as DatabaseEvent).snapshot.value != null) {
          Map<Object, Object> fetchedData = Map<dynamic, dynamic>.from(
              (snapshot.data as DatabaseEvent).snapshot.value
                  as Map<dynamic, dynamic>);
          String fieldToFetch = fetchedData['field'] as String;

          Map<Object, Object> requiredTimeData = fetchedData[fieldToFetch];

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: GameInfoBlock(
              coin:
                  "${model.sortPlayerNumbers(requiredTimeData['value'].toString())} +",
              coinText: 'Playing',
              assetHeight: SizeConfig.padding16,
              isDot: true,
              key: ValueKey<String>(requiredTimeData['value'].toString()),
            ),
          );
        } else {
          return GameInfoBlock(
            coin: "50+",
            coinText: 'Playing',
            assetHeight: SizeConfig.padding16,
            isDot: true,
          );
        }
      },
    );
  }
}

class RechargeBox extends StatelessWidget {
  final RechargeOption rechargeOption;

  const RechargeBox({Key key, this.rechargeOption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return rechargeOption.isCustom
        ? InkWell(
            onTap: () {
              return BaseUtil().openDepositOptionsModalSheet();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding20,
                  vertical: SizeConfig.padding8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 0.4),
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
              ),
              child: Icon(
                Icons.add,
                size: SizeConfig.screenWidth * 0.08,
                color: Colors.white,
              ),
            ),
          )
        : InkWell(
            onTap: () {
              return BaseUtil()
                  .openDepositOptionsModalSheet(amount: rechargeOption.amount);
            },
            child: Container(
              margin: EdgeInsets.only(right: SizeConfig.padding12),
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding20,
                  vertical: SizeConfig.padding8),
              decoration: BoxDecoration(
                color: UiConstants.gameCardColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "+  ",
                    style: TextStyles.sourceSansSB.body1.bold,
                  ),
                  SvgPicture.asset(
                    Assets.token,
                    height: SizeConfig.padding24,
                  ),
                  SizedBox(width: SizeConfig.padding4),
                  Text(
                    rechargeOption.amount.toString(),
                    style: TextStyles.sourceSansSB.body1,
                  ),
                ],
              ),
            ),
          );
  }
}

class GameInfoBlock extends StatelessWidget {
  final String coin, coinText, assetUrl;
  final double assetHeight;
  final bool isDot;

  const GameInfoBlock({
    Key key,
    this.coin,
    this.coinText,
    this.assetHeight,
    this.isDot = false,
    this.assetUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: SizeConfig.screenWidth * 0.155,
      // height: SizeConfig.screenWidth * 0.120,
      child: Column(
        children: [
          Row(
            children: [
              isDot
                  ? CircleAvatar(
                      backgroundColor: UiConstants.primaryColor,
                      radius: SizeConfig.padding4)
                  : SvgPicture.asset(
                      assetUrl,
                      height: assetHeight,
                    ),
              SizedBox(width: SizeConfig.padding8),
              Text(
                coin,
                style:
                    TextStyles.sourceSans.title5.bold.colour(Color(0xffBDBDBE)),
              ),
            ],
          ),
          Text(
            coinText,
            style: TextStyles.sourceSans.body3,
          ),
        ],
      ),
    );
  }
}

class PastWeekWinners extends StatelessWidget {
  const PastWeekWinners({Key key, @required this.count, @required this.model})
      : super(key: key);
  final int count;
  final WebHomeViewModel model;

  getLength(int listLength) {
    if (count != null) {
      if (listLength < count)
        return listLength;
      else
        return count;
    } else
      return listLength;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        //1
        Container(
          margin: EdgeInsets.only(top: SizeConfig.padding32),
          width: SizeConfig.screenWidth * 0.5,
          height: SizeConfig.screenWidth * 0.5,
          decoration: BoxDecoration(
            color: UiConstants.kSecondaryBackgroundColor,
            shape: BoxShape.circle,
          ),
        ),
        //2
        Container(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding20,
              horizontal: SizeConfig.pageHorizontalMargins),
          margin: EdgeInsets.fromLTRB(
              SizeConfig.padding14,
              SizeConfig.screenWidth * 0.15 + SizeConfig.padding32,
              SizeConfig.padding14,
              0.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: UiConstants.kSecondaryBackgroundColor,
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.roundness12)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.padding32,
              ),

              //Old code to refactor starts here
              Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      padding: EdgeInsets.only(top: SizeConfig.padding8),
                      child: model.pastWeekParticipants == null
                          ? Container(
                              width: SizeConfig.screenWidth,
                              color: Colors.transparent,
                              margin: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding24),
                              alignment: Alignment.center,
                              child: FullScreenLoader(
                                size: SizeConfig.screenWidth * 0.5,
                              ),
                            )
                          : (model.pastWeekParticipants.isEmpty
                              ? Container(
                                  width: SizeConfig.screenWidth,
                                  color: Colors.transparent,
                                  margin: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding24),
                                  child: NoRecordDisplayWidget(
                                    topPadding: false,
                                    assetSvg: Assets.noWinnersAsset,
                                    text: " Leaderboard will be updated soon",
                                  ),
                                )
                              : Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "#",
                                          style: TextStyles.sourceSans.body3
                                              .colour(UiConstants.kTextColor2),
                                        ),
                                        SizedBox(width: SizeConfig.padding12),
                                        SizedBox(width: SizeConfig.padding12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Names",
                                                  style: TextStyles
                                                      .sourceSans.body3
                                                      .colour(UiConstants
                                                          .kTextColor2)),
                                              SizedBox(
                                                  height: SizeConfig.padding4),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "Points",
                                          style: TextStyles.sourceSans.body3
                                              .colour(UiConstants.kTextColor2),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding14,
                                    ),
                                    Column(
                                      children: List.generate(
                                        getLength(
                                            model.pastWeekParticipants.length),
                                        (i) {
                                          return Container(
                                            width: SizeConfig.screenWidth,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${i + 1}",
                                                      style: TextStyles
                                                          .rajdhani.body3
                                                          .colour(Colors.white),
                                                    ),
                                                    SizedBox(
                                                        width: SizeConfig
                                                            .padding12),
                                                    FutureBuilder(
                                                      future: model
                                                          .getProfileDpWithUid(model
                                                              .pastWeekParticipants[
                                                                  i]
                                                              .userid),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot.hasData ||
                                                            snapshot.connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                          return DefaultAvatar();
                                                        }

                                                        String imageUrl =
                                                            snapshot.data
                                                                as String;

                                                        return ClipOval(
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: imageUrl,
                                                            fit: BoxFit.cover,
                                                            width: SizeConfig
                                                                .iconSize5,
                                                            height: SizeConfig
                                                                .iconSize5,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(
                                                              width: SizeConfig
                                                                  .iconSize5,
                                                              height: SizeConfig
                                                                  .iconSize5,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.grey,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (a, b, c) {
                                                              return DefaultAvatar();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(
                                                        width: SizeConfig
                                                            .padding12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              model
                                                                      .pastWeekParticipants[
                                                                          i]
                                                                      .username
                                                                      .replaceAll(
                                                                          '@',
                                                                          '.') ??
                                                                  "username",
                                                              style: TextStyles
                                                                  .rajdhani
                                                                  .body3
                                                                  .colour(Colors
                                                                      .white)),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      "${model.pastWeekParticipants[i].score.toInt().toString() ?? "00"} points",
                                                      style: TextStyles
                                                          .rajdhani.body3
                                                          .colour(Colors.white),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: SizeConfig.padding10,
                                                ),
                                                if (i + 1 <
                                                    getLength(model
                                                        .pastWeekParticipants
                                                        .length))
                                                  Divider(
                                                    color: Colors.white,
                                                    thickness: 0.2,
                                                  ),
                                                SizedBox(
                                                  height: SizeConfig.padding10,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding16,
                                    ),
                                    if (model.pastWeekParticipants.length >
                                        getLength(
                                            model.pastWeekParticipants.length))
                                      GestureDetector(
                                        onTap: () {
                                          Haptic.vibrate();
                                          AppState.delegate.appState
                                              .currentAction = PageAction(
                                            state: PageState.addWidget,
                                            widget:
                                                AllParticipantsWinnersTopReferers(
                                              isForTopReferers: true,
                                              showPoints: true,
                                              referralLeaderBoard:
                                                  model.pastWeekParticipants,
                                            ),
                                            page:
                                                AllParticipantsWinnersTopReferersConfig,
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: SizeConfig.padding2,
                                              ),
                                              child: Text('See All',
                                                  style: TextStyles
                                                      .rajdhaniSB.body2),
                                            ),
                                            SvgPicture.asset(
                                                Assets.chevRonRightArrow,
                                                height: SizeConfig.padding24,
                                                width: SizeConfig.padding24,
                                                color: UiConstants.primaryColor)
                                          ],
                                        ),
                                      )
                                  ],
                                )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //3
        Container(
          margin: EdgeInsets.only(right: SizeConfig.padding14),
          child: SvgPicture.asset(
            Assets.winScreenHighestScorers,
            width: SizeConfig.screenWidth * 0.3,
          ),
        ),
      ],
    );
  }
}
