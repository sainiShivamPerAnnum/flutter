import 'package:felloapp/core/model/game_model4.0.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/web/reward_leaderboard/reward_leaderboard_view.dart';
import 'package:felloapp/ui/pages/others/games/web/web_home/web_home_vm.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class WebHomeView extends StatelessWidget {
  const WebHomeView({Key key, @required this.game}) : super(key: key);
  final String game;
  @override
  Widget build(BuildContext context) {
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
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      delegate: model.isLoading
                          ? MySliverAppBar(
                              expandedHeight: SizeConfig.screenHeight * 0.32,
                              game: model.currentGameData,
                              isLoading: true,
                            )
                          : MySliverAppBar(
                              expandedHeight: SizeConfig.screenHeight * 0.32,
                              game: model.currentGameData,
                            ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: SizeConfig.screenWidth * 0.266 / 2 +
                                SizeConfig.padding20,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: model.isLoading
                                ? Shimmer.fromColors(
                                    baseColor:
                                        UiConstants.kUserRankBackgroundColor,
                                    highlightColor:
                                        UiConstants.kBackgroundColor,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade600,
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.roundness5),
                                      ),
                                      width: SizeConfig.screenWidth * 0.213,
                                      height: SizeConfig.screenWidth * 0.053,
                                    ),
                                  )
                                : Text(
                                    model.currentGameData.gameName,
                                    style: TextStyles.rajdhaniB.title2,
                                  ),
                          ),
                          SizedBox(
                            height: SizeConfig.padding35,
                          ),
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
                                    GameInfoBlock(
                                      coin: '2K+',
                                      coinText: 'Playing',
                                      assetHeight: SizeConfig.padding16,
                                      isDot: true,
                                      assetUrl: 'assets/svg/circle_svg.svg',
                                    ),
                                    GameInfoBlock(
                                      coin: '${NumberFormat.compact().format(model.currentGameData.prizeAmount)}',
                                      coinText: 'Win upto',
                                      assetHeight: SizeConfig.padding20,
                                      assetUrl: 'assets/svg/reward_svg.svg',
                                    ),
                                    GameInfoBlock(
                                      coin: '${model.currentGameData.playCost}',
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
                                        height: SizeConfig.screenWidth*0.021,
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
                                        height: SizeConfig.screenWidth*0.021,
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
                                height: SizeConfig.screenWidth * 0.277,
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
                                height: SizeConfig.padding16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
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
            onTap: () {},
            child: Container(
              height: SizeConfig.screenWidth * 0.277,
              width: SizeConfig.screenWidth * 0.317,
              decoration: BoxDecoration(
                color: rechargeOption.color,
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.add,
                    size: SizeConfig.screenWidth * 0.1,
                    color: Colors.grey,
                  ),
                  Text(
                    'Custom',
                    style: TextStyles.sourceSans.body3,
                  )
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: SizeConfig.padding12),
              height: SizeConfig.screenWidth * 0.277,
              width: SizeConfig.screenWidth * 0.317,
              decoration: BoxDecoration(
                color: rechargeOption.color,
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
              ),
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding8,
                        vertical: SizeConfig.padding8),
                    width: SizeConfig.screenWidth * 0.148,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness8),
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                  ),
                  Spacer(),
                  Container(
                    height: SizeConfig.screenWidth * 0.085,
                    width: SizeConfig.screenWidth * 0.261,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness8)),
                    child: Center(
                      child: Text(
                        '₹${rechargeOption.amount}',
                        style: TextStyles.rajdhaniB.body3,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding12,
                  )
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

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final GameData game;
  final bool isLoading;
  MySliverAppBar({
    @required this.expandedHeight,
    @required this.game,
    this.isLoading = false,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Opacity(
          opacity: (1 - shrinkOffset / expandedHeight),
          child: isLoading
              ? Shimmer.fromColors(
                  baseColor: UiConstants.kUserRankBackgroundColor,
                  highlightColor: UiConstants.kBackgroundColor,
                  child: Container(
                    color: Colors.grey,
                  ),
                )
              : Image.network(
                  game.thumbnailUri,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          top: expandedHeight -
              SizeConfig.screenWidth * 0.266 / 2 -
              shrinkOffset,
          left: SizeConfig.screenWidth / 2 - SizeConfig.screenWidth * 0.266 / 2,
          child: Opacity(
            opacity: 1, //(1 - shrinkOffset / expandedHeight),
            child: isLoading
                ? Shimmer.fromColors(
                    baseColor: UiConstants.kUserRankBackgroundColor,
                    highlightColor: UiConstants.kBackgroundColor,
                    child: Container(
                      height: SizeConfig.screenWidth * 0.266,
                      width: SizeConfig.screenWidth * 0.266,
                      color: Colors.grey,
                    ),
                  )
                : Container(
                    height: SizeConfig.screenWidth * 0.266,
                    width: SizeConfig.screenWidth * 0.266,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness16),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(game.thumbnailUri),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + SizeConfig.viewInsets.top;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
