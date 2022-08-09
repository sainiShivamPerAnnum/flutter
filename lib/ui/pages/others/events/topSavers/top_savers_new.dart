import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
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
import '../../games/web/reward_leaderboard/components/leaderboard_shimmer.dart';
import '../../games/web/reward_leaderboard/components/reward_shimmer.dart';
import 'all_participants.dart';

extension TruncateDoubles on double {
  double truncateToDecimalPlaces(int fractionalDigits) =>
      (this * pow(10, fractionalDigits)).truncate() / pow(10, fractionalDigits);
}

class CampaignView extends StatelessWidget {
  final String eventType;
  final bool isGameRedirected;
  CampaignView({this.eventType, this.isGameRedirected = false});

  final TextStyle selectedTextStyle =
      TextStyles.sourceSansSB.body1.colour(UiConstants.titleTextColor);

  final TextStyle unselectedTextStyle = TextStyles.sourceSansSB.body1
      .colour(UiConstants.titleTextColor.withOpacity(0.6));

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
              CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: UiConstants.kSliverAppBarBackgroundColor,
                    leading: IconButton(
                        onPressed: () {
                          AppState.backButtonDispatcher.didPopRoute();
                        },
                        icon: Icon(Icons.arrow_back_ios)),
                    expandedHeight: SizeConfig.sliverAppExpandableSize,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          SvgPicture.asset(
                            Assets.visualGridAsset,
                            fit: BoxFit.cover,
                            width: double.maxFinite,
                            height: double.maxFinite,
                          ),
                          //The title and sub title
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    Assets.coinsIconAsset,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        model.appbarTitle,
                                        style: TextStyles.body1
                                            .colour(Colors.white),
                                      ),
                                      Text(
                                        model.subTitle,
                                        style: TextStyles.title3
                                            .colour(Colors.white)
                                            .bold,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    0,
                                    SizeConfig.sliverAppBarPaddingLarge,
                                    0,
                                    SizeConfig.sliverAppBarPaddingSmall),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      width: SizeConfig.padding10,
                                      height: SizeConfig.padding10,
                                      decoration: const BoxDecoration(
                                          color: UiConstants.kPrimaryColor,
                                          shape: BoxShape.circle),
                                    ),
                                    Text(
                                      "2K+ Participants",
                                      style:
                                          TextStyles.body3.colour(Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(SizeConfig.padding34),
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
                                      Radius.circular(SizeConfig.roundness12),
                                    ),
                                    color: UiConstants.kDarkBoxColor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ProfileImageSE(
                                        radius: SizeConfig.profileDPSize,
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
                                      Text(
                                        model.userAmount.toString(),
                                        style: TextStyles.body1.bold
                                            .colour(Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: SizeConfig.boxWidthLarge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(SizeConfig.roundness12),
                                      ),
                                      color: Colors.transparent,
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                SizeConfig.boxDividerMargins,
                                                0,
                                                0,
                                                (SizeConfig.boxDividerMargins) /
                                                    2),
                                            padding: EdgeInsets.all(
                                                SizeConfig.padding16),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    SizeConfig.roundness16),
                                              ),
                                              color: UiConstants.kDarkBoxColor,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Highest\nSaving",
                                                  style: TextStyles.body3
                                                      .colour(Colors.white),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "${model.highestSavings.toStringAsFixed(3)} gms",
                                                    style: TextStyles.body2.bold
                                                        .colour(Colors.white),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                SizeConfig.boxDividerMargins,
                                                (SizeConfig.boxDividerMargins) /
                                                    2,
                                                0,
                                                0),
                                            padding: EdgeInsets.all(
                                                SizeConfig.padding16),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    SizeConfig.roundness12),
                                              ),
                                              color: UiConstants.kDarkBoxColor,
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
                                                      Assets.rankIconAsset,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "Rank",
                                                      style: TextStyles.body3
                                                          .colour(Colors.white),
                                                    ),
                                                  ],
                                                )),
                                                Flexible(
                                                  child: Text(
                                                    model.userRank == 0
                                                        ? 'N/A'
                                                        : model.userRank
                                                            .toString()
                                                            .padLeft(2, '0'),
                                                    style: TextStyles.body2.bold
                                                        .colour(Colors.white),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.end,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                      padding: EdgeInsets.all(SizeConfig.padding38),
                      decoration: BoxDecoration(
                        gradient: UiConstants.kCampaignBannerBackgrondGradient,
                      ),
                      height: SizeConfig.bannerHeight,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              // height: SizeConfig.bannerHeight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "WIN",
                                    style: TextStyles.rajdhaniSB.body0.bold
                                        .colour(Colors.white),
                                  ),
                                  Text(
                                    "₹ 250",
                                    style: TextStyles.rajdhaniB.title0.bold
                                        .colour(UiConstants
                                            .kWinnerPlayerPrimaryColor),
                                  ),
                                  Text(
                                    "Win amazing rewards\nin digital gold.",
                                    style:
                                        TextStyles.body3.colour(Colors.white),
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
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    height: (SizeConfig.bannerHeight) / 3.9,
                                    decoration: BoxDecoration(
                                        gradient: UiConstants.kTrophyBackground,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0))),
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
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding34),
                      child: model.pastWinnerProfileList.isEmpty
                          ? ListLoader(bottomPadding: true)
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () => model.switchTab(0),
                                        child: Text(
                                          'LeaderBoard',
                                          style: model.tabNo == 0
                                              ? selectedTextStyle
                                              : unselectedTextStyle, // TextStyles.sourceSansSB.body1,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () => model.switchTab(1),
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
                                      duration: Duration(milliseconds: 500),
                                      height: 5,
                                      width: model.tabPosWidthFactor,
                                    ),
                                    Container(
                                      color: UiConstants.kTabBorderColor,
                                      height: 5,
                                      width: SizeConfig.screenWidth * 0.4,
                                    )
                                  ],
                                ),
                                HeightAdaptivePageView(
                                  controller: model.pageController,
                                  onPageChanged: (int page) {
                                    model.switchTab(page);
                                  },
                                  children: [
                                    model.pastWinners.isEmpty
                                        ? NoRecordDisplayWidget(
                                            asset: "images/week-winners.png",
                                            text: "Prizes will be updates soon",
                                          )
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    SizeConfig.padding34),
                                            child: Column(
                                              children: [
                                                ListView.builder(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          SizeConfig.padding24),
                                                  shrinkWrap: true,
                                                  itemCount: model
                                                              .currentParticipants
                                                              .length >
                                                          3
                                                      ? 3
                                                      : model
                                                          .currentParticipants
                                                          .length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ParticiapntsListItemView(
                                                        s_no: '${index + 1}',
                                                        imageUrl: model
                                                                .currentParticipantsProfileList[
                                                            index],
                                                        username: model
                                                            .currentParticipants[
                                                                index]
                                                            .username,
                                                        score:
                                                            "${model.currentParticipants[index].score.truncateToDecimalPlaces(3)} gms");
                                                  },
                                                  //Current participants
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    AppState.delegate.appState
                                                            .currentAction =
                                                        PageAction(
                                                            widget:
                                                                AllParticipantsView(
                                                              model: model,
                                                              forPastWinners:
                                                                  false,
                                                            ),
                                                            page:
                                                                AllParticipantsViewPageConfig,
                                                            state: PageState
                                                                .addWidget);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'See All',
                                                        style: TextStyles
                                                            .rajdhaniSB.body2,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            SizeConfig.padding6,
                                                      ),
                                                      SvgPicture.asset(
                                                        Assets
                                                            .chevRonRightArrow,
                                                        width: SizeConfig
                                                            .iconSize1,
                                                        height: SizeConfig
                                                            .iconSize1,
                                                        color: UiConstants
                                                            .primaryColor,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                    model.pastWinners.isEmpty
                                        ? NoRecordDisplayWidget(
                                            asset: "images/week-winners.png",
                                            text: "Prizes will be updates soon",
                                          )
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    SizeConfig.padding34),
                                            child: Column(
                                              children: [
                                                ListView.builder(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          SizeConfig.padding24),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      model.pastWinners.length >
                                                              3
                                                          ? 3
                                                          : model.pastWinners
                                                              .length,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ParticiapntsListItemView(
                                                        s_no: '${index + 1}',
                                                        imageUrl: model
                                                                .pastWinnerProfileList[
                                                            index],
                                                        username: model
                                                            .pastWinners[index]
                                                            .username,
                                                        score:
                                                            "${model.pastWinners[index].score.truncateToDecimalPlaces(3)} gms");
                                                  },
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    AppState.delegate.appState
                                                            .currentAction =
                                                        PageAction(
                                                            widget:
                                                                AllParticipantsView(
                                                              model: model,
                                                              forPastWinners:
                                                                  true,
                                                            ),
                                                            page:
                                                                AllParticipantsViewPageConfig,
                                                            state: PageState
                                                                .addWidget);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'See All',
                                                        style: TextStyles
                                                            .rajdhaniSB.body2,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            SizeConfig.padding6,
                                                      ),
                                                      SvgPicture.asset(
                                                        Assets
                                                            .chevRonRightArrow,
                                                        width: SizeConfig
                                                            .iconSize1,
                                                        height: SizeConfig
                                                            .iconSize1,
                                                        color: UiConstants
                                                            .primaryColor,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.padding34),
                      child: ReactivePositiveAppButton(
                        btnText: 'Get Started',
                        onPressed: () {},
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: InfoComponent(
                      heading: model.boxHeading,
                      assetList: model.boxAssets,
                      titleList: model.boxTitlles,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ParticiapntsListItemView extends StatelessWidget {
  const ParticiapntsListItemView(
      {Key key,
      @required this.s_no,
      @required this.imageUrl,
      @required this.username,
      @required this.score})
      : super(key: key);

  final String s_no;
  final String imageUrl;
  final String username;
  final String score;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding20,
        horizontal: SizeConfig.padding2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  s_no,
                  style: TextStyles.rajdhaniSB.body2,
                ),
                SizedBox(
                  width: SizeConfig.padding20,
                ),
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: SizeConfig.iconSize5,
                    height: SizeConfig.iconSize5,
                    placeholder: (context, url) => Container(
                      width: SizeConfig.iconSize5,
                      height: SizeConfig.iconSize5,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    errorWidget: (a, b, c) {
                      return Image.asset(
                        Assets.defaultProfilePlaceholder,
                        width: SizeConfig.iconSize5,
                        height: SizeConfig.iconSize5,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: SizeConfig.padding12,
                ),
                Expanded(
                  child: Text(
                    username,
                    style: TextStyles.sourceSans.body3.setOpecity(0.8),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                )
              ],
            ),
          ),
          Text(
            score.toString(),
            style: TextStyles.rajdhaniM.body3,
          ),
        ],
      ),
    );
  }
}
