import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/widgets/default_avatar.dart';
import 'package:firebase_database/firebase_database.dart' as rdb;

import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_details/save_assets_view.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/enums/page_state_enum.dart';
import '../../../../../navigator/router/ui_pages.dart';
import '../../../../service_elements/user_service/profile_image.dart';
import '../../../../widgets/helpers/height_adaptive_pageview.dart';
import '../../../hometabs/play/play_components/play_info_section.dart';
import '../../../static/app_widget.dart';
import '../../../static/game_card.dart';
import '../../../static/new_square_background.dart';
import 'all_participants.dart';

extension TruncateDoubles on double {
  double truncateToDecimalPlaces(int fractionalDigits) =>
      (this * math.pow(10, fractionalDigits)).truncate() /
      math.pow(10, fractionalDigits);
}

class CampaignView extends StatelessWidget {
  StreamController controller = StreamController();

  final String eventType;
  final bool isGameRedirected;
  CampaignView({this.eventType, this.isGameRedirected = false});

  final TextStyle selectedTextStyle =
      TextStyles.sourceSansSB.body1.colour(UiConstants.titleTextColor);

  final TextStyle unselectedTextStyle = TextStyles.sourceSansSB.body1
      .colour(UiConstants.titleTextColor.withOpacity(0.6));

  bool isInteger(num value) => value is int || value == value.roundToDouble();

  ScrollController _controller = ScrollController();

  bool showStreamBuilder = false;

  @override
  Widget build(BuildContext context) {
    return BaseView<TopSaverViewModel>(
      onModelReady: (model) {
        model.init(eventType, isGameRedirected);
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.kBackgroundColor,
          body: Stack(
            children: [
              NewSquareBackground(),
              model.state == ViewState.Busy
                  ? Center(
                      child: FullScreenLoader(),
                    )
                  : CustomScrollView(
                      controller: _controller,
                      physics: BouncingScrollPhysics(),
                      slivers: [
                        SliverLayoutBuilder(
                          builder: (context, constraints) {
                            final scrolled = constraints.scrollOffset > 0;
                            return SliverAppBar(
                              title: scrolled
                                  ? Text(
                                      model.appbarTitle,
                                      style: TextStyles.rajdhaniSB.title4
                                          .colour(Colors.white),
                                    )
                                  : SizedBox.shrink(),
                              pinned: true,
                              backgroundColor: UiConstants.kBackgroundColor,
                              leading: IconButton(
                                onPressed: () {
                                  AppState.backButtonDispatcher.didPopRoute();
                                },
                                icon: Icon(Icons.arrow_back_ios),
                              ),
                              expandedHeight:
                                  SizeConfig.sliverAppExpandableSize,
                              flexibleSpace: FlexibleSpaceBar(
                                background: Padding(
                                  padding: EdgeInsets.only(
                                    // left: SizeConfig.padding24,
                                    // right: SizeConfig.padding24,
                                    bottom: SizeConfig.padding24,
                                  ),
                                  child: CampaignCard(
                                    event: model.event,
                                    subText: Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.padding10,
                                      ),
                                      child: _realtimeView(model),
                                    ),
                                    isLoading: model.event == null,
                                    topPadding: 90,
                                    leftPadding: SizeConfig.padding38,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "DAY ${model.weekDay.toString().padLeft(2, '0')}",
                                    style: TextStyles.rajdhaniB.title5
                                        .colour(Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: SizeConfig.boxWidthLarge,
                                        width: SizeConfig.boxWidthLarge,
                                        padding: EdgeInsets.fromLTRB(
                                            SizeConfig.padding24,
                                            0,
                                            SizeConfig.padding34,
                                            0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                SizeConfig.roundness12),
                                          ),
                                          color: UiConstants.kDarkBoxColor,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ProfileImageSE(
                                              radius: SizeConfig.profileDPSize,
                                              reactive: false,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Your Savings",
                                              style: TextStyles.body3
                                                  .colour(Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            FittedBox(
                                              child: Text(
                                                model.userDisplayAmount ?? '-',
                                                style: TextStyles.body1.bold
                                                    .colour(Colors.white),
                                                maxLines: 1,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: SizeConfig.boxWidthLarge,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  SizeConfig.roundness12),
                                            ),
                                            color: Colors.transparent,
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      SizeConfig
                                                          .boxDividerMargins,
                                                      0,
                                                      0,
                                                      (SizeConfig
                                                              .boxDividerMargins) /
                                                          2),
                                                  padding: EdgeInsets.all(
                                                      SizeConfig.padding16),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(SizeConfig
                                                          .roundness12),
                                                    ),
                                                    color: UiConstants
                                                        .kDarkBoxColor,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Highest\nSaving",
                                                        style: TextStyles.body3
                                                            .colour(
                                                                Colors.white),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          model.highestSavings ??
                                                              '-',
                                                          style: TextStyles
                                                              .body2.bold
                                                              .colour(
                                                                  Colors.white),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              //RANK
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      SizeConfig
                                                          .boxDividerMargins,
                                                      (SizeConfig
                                                              .boxDividerMargins) /
                                                          2,
                                                      0,
                                                      0),
                                                  padding: EdgeInsets.all(
                                                      SizeConfig.padding16),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(SizeConfig
                                                          .roundness12),
                                                    ),
                                                    color: UiConstants
                                                        .kDarkBoxColor,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                          child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            Assets
                                                                .rewardGameAsset,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "Rank",
                                                            style: TextStyles
                                                                .body3
                                                                .colour(Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      )),
                                                      Flexible(
                                                        child: Text(
                                                          model.userRank == 0
                                                              ? 'N/A'
                                                              : model.userRank
                                                                  .toString()
                                                                  .padLeft(
                                                                      2, '0'),
                                                          style: TextStyles
                                                              .body2.bold
                                                              .colour(
                                                                  Colors.white),
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.end,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    SizeConfig.pageHorizontalMargins * 1.2),
                            decoration: BoxDecoration(
                              gradient:
                                  UiConstants.kCampaignBannerBackgrondGradient,
                            ),
                            height: SizeConfig.bannerHeight,
                            width: SizeConfig.screenWidth,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    // height: SizeConfig.bannerHeight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "WIN",
                                          style: TextStyles
                                              .rajdhaniSB.body0.bold
                                              .colour(Colors.white),
                                        ),
                                        Text(
                                          "₹ ${model?.event?.maxWin ?? 250}",
                                          style: TextStyles
                                              .rajdhaniB.title0.bold
                                              .colour(UiConstants
                                                  .kWinnerPlayerPrimaryColor),
                                        ),
                                        Text(
                                          "Win amazing rewards\nin digital gold.",
                                          style: TextStyles.body3
                                              .colour(Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: SizeConfig.screenWidth * 0.3,
                                  height: SizeConfig.bannerHeight,
                                  decoration: BoxDecoration(),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: SizeConfig.bannerHeight * 0.15,
                                        child: Container(
                                          width: SizeConfig.screenWidth * 0.3,
                                          height:
                                              (SizeConfig.bannerHeight) / 3.9,
                                          decoration: BoxDecoration(
                                              gradient:
                                                  UiConstants.kTrophyBackground,
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  topRight:
                                                      Radius.circular(10.0))),
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        "assets/svg/trophy_banner.svg",
                                        width: double.maxFinite,
                                        fit: BoxFit.fitWidth,
                                        height: double.maxFinite,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                            child: model.state == ViewState.Idle
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding34),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () =>
                                                    model.switchTab(0),
                                                child: Text(
                                                  'Leaderboard',
                                                  style: model.tabNo == 0
                                                      ? selectedTextStyle
                                                      : unselectedTextStyle, // TextStyles.sourceSansSB.body1,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () =>
                                                    model.switchTab(1),
                                                child: Text(
                                                  'Past Winners',
                                                  style: model.tabNo == 1
                                                      ? selectedTextStyle
                                                      : unselectedTextStyle, // style: TextStyles.sourceSansSB.body1,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              height: 5,
                                              width: model.tabPosWidthFactor,
                                            ),
                                            Container(
                                              color:
                                                  UiConstants.kTabBorderColor,
                                              height: 5,
                                              width:
                                                  SizeConfig.screenWidth * 0.38,
                                            )
                                          ],
                                        ),
                                        HeightAdaptivePageView(
                                          controller: model.pageController,
                                          onPageChanged: (int page) {
                                            model.switchTab(page);
                                          },
                                          children: [
                                            //Current particiapnts
                                            CurrentParticipantsLeaderBoard(
                                              model: model,
                                            ),

                                            //Current particiapnts
                                            PastWinnersLeaderBoard(
                                              model: model,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink()),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              InfoComponent(
                                  heading: model.boxHeading,
                                  assetList: model.boxAssets,
                                  titleList: model.boxTitlles,
                                  onStateChanged: () {
                                    _controller.animateTo(
                                        _controller.position.maxScrollExtent,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }),
                              SizedBox(
                                height:
                                    SizeConfig.padding54 + SizeConfig.padding54,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.padding34),
                  child: ReactivePositiveAppButton(
                    btnText: 'Start Saving',
                    onPressed: () {
                      AppState.delegate.appState.currentAction = PageAction(
                          widget: SaveAssetView(),
                          page: SaveAssetsViewConfig,
                          state: PageState.addWidget);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Row _realtimeView(TopSaverViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          width: SizeConfig.padding10,
          height: SizeConfig.padding10,
          decoration: const BoxDecoration(
            color: UiConstants.kPrimaryColor,
            shape: BoxShape.circle,
          ),
        ),
        StreamBuilder(
          stream: model.getRealTimeFinanceStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                "${model.getDeafultRealTimeStat(eventType)} Participants",
                style: TextStyles.body3.colour(Colors.white),
              );
            }

            if (!snapshot.hasData) {
              return Text(
                "${model.getDeafultRealTimeStat(eventType)} Participants",
                style: TextStyles.body3.colour(Colors.white),
              );
            }

            if ((snapshot.data as rdb.DatabaseEvent).snapshot.value != null) {
              final fetchedData = Map<dynamic, dynamic>.from(
                  (snapshot.data as DatabaseEvent).snapshot.value
                      as Map<dynamic, dynamic>);

              Map<dynamic, dynamic> sortedData =
                  fetchedData[model.getPathForRealTimeFinanceStats(eventType)];

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Text(
                  "${model.sortPlayerNumbers(sortedData['value'].toString())}+  Participants",
                  style: TextStyles.body3.colour(Colors.white),
                  key: ValueKey<String>(sortedData['value'].toString()),
                ),
              );
            } else {
              return Text(
                "${model.getDeafultRealTimeStat(eventType)} Participants",
                style: TextStyles.body3.colour(Colors.white),
              );
            }
          },
        ),
      ],
    );
  }
}

//To generate page with current participamnts list
class CurrentParticipantsLeaderBoard extends StatelessWidget {
  final TopSaverViewModel model;
  CurrentParticipantsLeaderBoard({this.model});

  bool isInteger(num value) => value is int || value == value.roundToDouble();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.kDarkBoxColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.roundness32),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.padding16),
            model.currentParticipants != null
                ? (model.currentParticipants.isNotEmpty
                    ? Column(
                        children: [
                          Column(
                            children: List.generate(
                              // model.currentParticipants.length,
                              model.currentParticipants.length > 3
                                  ? 3
                                  : model.currentParticipants.length,
                              (index) => Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding20,
                                  horizontal: SizeConfig.padding2,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            '${index + 1}',
                                            style: TextStyles.rajdhaniSB.body2,
                                          ),
                                          SizedBox(
                                            width: SizeConfig.padding20,
                                          ),
                                          FutureBuilder(
                                            future: model.getProfileDpWithUid(
                                                model.currentParticipants[index]
                                                    .userid),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting)
                                                return DefaultAvatar();
                                              if (!snapshot.hasData)
                                                return DefaultAvatar();

                                              String imageUrl =
                                                  snapshot.data as String;

                                              return ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: imageUrl,
                                                  fit: BoxFit.cover,
                                                  width: SizeConfig.iconSize5,
                                                  height: SizeConfig.iconSize5,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    width: SizeConfig.iconSize5,
                                                    height:
                                                        SizeConfig.iconSize5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  errorWidget: (a, b, c) {
                                                    return DefaultAvatar();
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            width: SizeConfig.padding12,
                                          ),
                                          Expanded(
                                            child: Text(
                                              model.currentParticipants[index]
                                                  .username,
                                              style: TextStyles.sourceSans.body3
                                                  .setOpecity(0.8),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      model.currentParticipants[index]
                                              ?.displayScore ??
                                          '',
                                      style: TextStyles.rajdhaniM.body3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          (model.currentParticipants.length > 3)
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.padding16,
                                      top: SizeConfig.padding32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          AppState.delegate
                                                  .appState.currentAction =
                                              PageAction(
                                                  widget: AllParticipantsView(
                                                    model: model,
                                                    forPastWinners: false,
                                                  ),
                                                  page:
                                                      AllParticipantsViewPageConfig,
                                                  state: PageState.addWidget);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'See All',
                                              style:
                                                  TextStyles.rajdhaniSB.body2,
                                            ),
                                            SizedBox(
                                              width: SizeConfig.padding6,
                                            ),
                                            SvgPicture.asset(
                                              Assets.chevRonRightArrow,
                                              width: SizeConfig.iconSize1,
                                              height: SizeConfig.iconSize1,
                                              color: UiConstants.primaryColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(height: SizeConfig.padding8)
                        ],
                      )
                    : Container(
                        width: SizeConfig.screenWidth,
                        margin: EdgeInsets.only(
                            top: SizeConfig.padding16,
                            bottom: SizeConfig.padding32),
                        child: Opacity(
                          opacity: 0.3,
                          child: NoRecordDisplayWidget(
                            assetSvg: Assets.noWinnersAsset,
                            text: "Leaderboard will be updated soon",
                            topPadding: false,
                            bottomPadding: true,
                          ),
                        ),
                      ))
                : FullScreenLoader(
                    bottomPadding: true,
                  )
          ],
        ),
      ),
    );
  }
}

//To generate page with current participamnts list
class PastWinnersLeaderBoard extends StatelessWidget {
  final TopSaverViewModel model;
  PastWinnersLeaderBoard({this.model});

  bool isInteger(num value) => value is int || value == value.roundToDouble();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.kDarkBoxColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.roundness32),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.padding16),
            model.pastWinners != null
                ? (model.pastWinners.isNotEmpty
                    ? Column(
                        children: [
                          Column(
                            children: List.generate(
                              // model.currentParticipants.length,
                              model.pastWinners.length > 3
                                  ? 3
                                  : model.pastWinners.length,
                              (index) => Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding20,
                                  horizontal: SizeConfig.padding2,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            '${index + 1}',
                                            style: TextStyles.rajdhaniSB.body2,
                                          ),
                                          SizedBox(
                                            width: SizeConfig.padding20,
                                          ),
                                          FutureBuilder(
                                            future: model.getProfileDpWithUid(
                                                model
                                                    .pastWinners[index].userid),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                      ConnectionState.waiting ||
                                                  !snapshot.hasData) {
                                                return DefaultAvatar();
                                              }

                                              String imageUrl =
                                                  snapshot.data as String;

                                              return ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: imageUrl,
                                                  fit: BoxFit.cover,
                                                  width: SizeConfig.iconSize5,
                                                  height: SizeConfig.iconSize5,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    width: SizeConfig.iconSize5,
                                                    height:
                                                        SizeConfig.iconSize5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  errorWidget: (a, b, c) {
                                                    return DefaultAvatar();
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            width: SizeConfig.padding12,
                                          ),
                                          Expanded(
                                            child: Text(
                                              model.pastWinners[index].username,
                                              style: TextStyles.sourceSans.body3
                                                  .setOpecity(0.8),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "${model.pastWinners[index].score.truncateToDecimalPlaces(3)} gm",
                                      style: TextStyles.rajdhaniM.body3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          (model.pastWinners.length > 3)
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.padding16,
                                      top: SizeConfig.padding32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          AppState.delegate
                                                  .appState.currentAction =
                                              PageAction(
                                                  widget: AllParticipantsView(
                                                    model: model,
                                                    forPastWinners: true,
                                                  ),
                                                  page:
                                                      AllParticipantsViewPageConfig,
                                                  state: PageState.addWidget);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'See All',
                                              style:
                                                  TextStyles.rajdhaniSB.body2,
                                            ),
                                            SizedBox(
                                              width: SizeConfig.padding6,
                                            ),
                                            SvgPicture.asset(
                                              Assets.chevRonRightArrow,
                                              width: SizeConfig.iconSize1,
                                              height: SizeConfig.iconSize1,
                                              color: UiConstants.primaryColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(height: SizeConfig.padding8)
                        ],
                      )
                    : Container(
                        width: SizeConfig.screenWidth,
                        margin: EdgeInsets.only(
                            top: SizeConfig.padding16,
                            bottom: SizeConfig.padding32),
                        child: Opacity(
                          opacity: 0.3,
                          child: NoRecordDisplayWidget(
                            assetSvg: Assets.noWinnersAsset,
                            text: "Leaderboard will be updated soon",
                            topPadding: false,
                            bottomPadding: true,
                          ),
                        ),
                      ))
                : FullScreenLoader(
                    bottomPadding: true,
                  )
          ],
        ),
      ),
    );
  }
}
