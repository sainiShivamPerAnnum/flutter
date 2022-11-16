import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/campaings.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/components/campaignOverviewWidget.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/components/campaign_participants.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/components/campaign_prize_widget.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_vm.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/widgets/default_avatar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart' as rdb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/enums/page_state_enum.dart';
import '../../../../../navigator/router/ui_pages.dart';
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
                      physics: ClampingScrollPhysics(),
                      slivers: [
                        Platform.isIOS
                            ? SliverToBoxAdapter(
                                child: IOSCampaignCard(
                                  event: model.event,
                                  subText: Padding(
                                    padding: EdgeInsets.only(
                                      top: SizeConfig.padding10,
                                    ),
                                    child: _realtimeView(model),
                                  ),
                                  isLoading: model.event == null,
                                  topPadding: 1,
                                  leftPadding: SizeConfig.padding24,
                                ),
                              )
                            : SliverLayoutBuilder(
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
                                    backgroundColor:
                                        UiConstants.kBackgroundColor,
                                    leading: IconButton(
                                      onPressed: () {
                                        AppState.backButtonDispatcher
                                            .didPopRoute();
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
                        CampaignOverviewWidget(model: model),
                        CampaignPrizeWidget(model: model),
                        CampaignParticipantsWidget(model: model),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              InfoComponent(
                                  heading: model.boxHeading,
                                  assetList: model
                                      .getBoxAssets(model.event.info.length),
                                  titleList:
                                      model.getBoxTitles(model.event.info),
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
              Positioned(
                left: SizeConfig.padding10,
                child: SafeArea(
                  child: CircleAvatar(
                    backgroundColor: UiConstants.kSecondaryBackgroundColor,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                      ),
                      color: Colors.white,
                      onPressed: AppState.backButtonDispatcher.didPopRoute,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.padding34),
                  child: ReactivePositiveAppButton(
                    btnText: 'Start Saving',
                    onPressed: () {
                      BaseUtil().openDepositOptionsModalSheet();
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
                                      "${model.pastWinners[index].displayScore}",
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
