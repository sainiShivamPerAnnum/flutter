import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/recharge_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/reward_leaderboard_view.dart';
import 'package:felloapp/ui/pages/others/games/web/web_home/web_home_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';

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
          onRefresh: () => model.refreshLeaderboard(),
          child: Scaffold(
            body: Stack(
              children: [
                NewSquareBackground(),
                CustomScrollView(
                  controller: _controller,
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverLayoutBuilder(builder: (context, constraints) {
                      final scrolled = constraints.scrollOffset > 0;
                      return SliverAppBar(
                        title: scrolled
                            ? Text(
                                model.currentGameModel.gameName,
                                style: TextStyles.rajdhaniB.title5
                                    .colour(Colors.white),
                              )
                            : SizedBox.shrink(),
                        pinned: true,
                        centerTitle: false,
                        backgroundColor:
                            UiConstants.kSliverAppBarBackgroundColor,
                        leading: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  AppState.backButtonDispatcher.didPopRoute();
                                },
                                icon: Icon(Icons.arrow_back_ios)),
                          ],
                        ),
                        actions: [
                          FelloCoinBar(svgAsset: Assets.aFelloToken),
                        ],
                        expandedHeight: SizeConfig.sliverAppExpandableSize,
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
                                : Hero(
                                    tag: model.currentGameModel.code,
                                    child: SvgPicture.network(
                                      model.currentGameModel.thumbnailUri,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                      );
                    }),
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
                                      assetUrl: Assets.aFelloToken,
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
                                    style: TextStyles.sourceSans.body2
                                        .colour(Colors.grey.shade600),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                          SizedBox(
                            height: SizeConfig.padding32,
                          ),
                          //   ],
                          // ),
                          RewardLeaderboardView(game: game),
                          SizedBox(height: SizeConfig.padding40),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding16),
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
                                  itemCount: 3,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding12),
                                  itemBuilder: (ctx, i) {
                                    return RechargeBox(
                                      rechargeOption: model.rechargeOptions[i],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.padding80 * 2,
                              ),
                            ],
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
                        if (await model.setupGame()) {
                          model.launchGame();
                        } else {
                          model.earnMoreTokens();
                        }
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

class PlayButtonOverlapper extends StatelessWidget {
  const PlayButtonOverlapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          Container(
            height: SizeConfig.navBarHeight + SizeConfig.padding64,
            width: double.infinity,
            decoration: BoxDecoration(
                color: UiConstants.kBackgroundColor.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.roundness24),
                    topRight: Radius.circular(SizeConfig.roundness24))),
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
            assetUrl: Assets.circleGameAsset,
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
              assetUrl: Assets.circleGameAsset,
              key: ValueKey<String>(requiredTimeData['value'].toString()),
            ),
          );
        } else {
          return GameInfoBlock(
            coin: "50+",
            coinText: 'Playing',
            assetHeight: SizeConfig.padding16,
            isDot: true,
            assetUrl: Assets.circleGameAsset,
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
              return BaseUtil.openModalBottomSheet(
                addToScreenStack: true,
                enableDrag: false,
                hapticVibrate: true,
                isBarrierDismissable: false,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                content: RechargeModalSheet(),
              );
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
              return BaseUtil.openModalBottomSheet(
                addToScreenStack: true,
                enableDrag: false,
                hapticVibrate: true,
                isBarrierDismissable: false,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                content: RechargeModalSheet(
                  amount: rechargeOption.amount,
                ),
              );
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
                    Assets.aFelloToken,
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
