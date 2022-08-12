import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/enums/page_state_enum.dart';
import '../../../../../navigator/router/ui_pages.dart';
import '../../../../service_elements/user_service/profile_image.dart';
import '../../../hometabs/play/play_components/play_info_section.dart';
import '../../../onboarding/blocked_user.dart';
import '../../../onboarding/update_screen.dart';
import '../../profile/my_winnings/my_winnings_view.dart';

extension TruncateDoubles on double {
  double truncateToDecimalPlaces(int fractionalDigits) =>
      (this * pow(10, fractionalDigits)).truncate() / pow(10, fractionalDigits);
}

class CampaignView extends StatelessWidget {
  final String eventType;
  final bool isGameRedirected;
  CampaignView({this.eventType, this.isGameRedirected = false});
  @override
  Widget build(BuildContext context) {
    return BaseView<TopSaverViewModel>(
      onModelReady: (model) {
        model.init(eventType, isGameRedirected);
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.kBackgroundColor,
          body: CustomScrollView(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model.appbarTitle,
                                    style:
                                        TextStyles.body1.colour(Colors.white),
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
                                  style: TextStyles.body3.colour(Colors.white),
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
                          style:
                              TextStyles.rajdhaniB.title5.colour(Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              height: SizeConfig.boxWidthLarge,
                              width: SizeConfig.boxWidthLarge,
                              padding: EdgeInsets.fromLTRB(SizeConfig.padding24,
                                  0, SizeConfig.padding34, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(SizeConfig.roundness12),
                                ),
                                color: UiConstants.kDarkBoxColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style:
                                        TextStyles.body3.colour(Colors.white),
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
                                            (SizeConfig.boxDividerMargins) / 2),
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
                                              MainAxisAlignment.spaceBetween,
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
                                                overflow: TextOverflow.ellipsis,
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
                                            (SizeConfig.boxDividerMargins) / 2,
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
                                              MainAxisAlignment.spaceBetween,
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
                                                overflow: TextOverflow.ellipsis,
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
                                style: TextStyles.rajdhaniB.title0.bold.colour(
                                    UiConstants.kWinnerPlayerPrimaryColor),
                              ),
                              Text(
                                "Win amazing rewards\nin digital gold.",
                                style: TextStyles.body3.colour(Colors.white),
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
                  padding: EdgeInsets.all(SizeConfig.padding34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Past Winners",
                        style: TextStyles.body0.bold.colour(Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      model.profileUrlList.isEmpty
                          ? ListLoader(bottomPadding: true)
                          : PastWinnersList(
                              model: model,
                              listLenght: model.pastWinners.length < 3
                                  ? model.pastWinners.length
                                  : 3,
                              showProfileImage: true,
                            ),
                      TextButton(
                        onPressed: () {
                          BaseUtil.openModalBottomSheet(
                            addToScreenStack: true,
                            backgroundColor: UiConstants.kBackgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SizeConfig.roundness32),
                              topRight: Radius.circular(SizeConfig.roundness32),
                            ),
                            isScrollControlled: true,
                            hapticVibrate: true,
                            isBarrierDismissable: true,
                            content: model.profileUrlList.isEmpty
                                ? ListLoader(bottomPadding: true)
                                : Container(
                                    padding:
                                        EdgeInsets.all(SizeConfig.padding34),
                                    child: PastWinnersList(
                                      model: model,
                                      listLenght: model.pastWinners.length,
                                      showProfileImage: false,
                                    ),
                                  ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'See All',
                              style: TextStyles.rajdhaniSB.body2,
                            ),
                            SizedBox(
                              width: SizeConfig.padding6,
                            ),
                            SvgPicture.asset(
                              Assets.chevronAsset,
                              width: SizeConfig.iconSize1,
                              height: SizeConfig.iconSize1,
                              color: UiConstants.primaryColor,
                            )
                          ],
                        ),
                      ),
                    ],
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
        );
      },
    );
  }
}

class PastWinnersList extends StatelessWidget {
  PastWinnersList(
      {Key key,
      @required this.model,
      @required this.listLenght,
      @required this.showProfileImage})
      : super(key: key);
  final TopSaverViewModel model;
  final int listLenght;
  final bool showProfileImage;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: listLenght,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
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
                      '${index + 1}',
                      style: TextStyles.rajdhaniSB.body2,
                    ),
                    SizedBox(
                      width: SizeConfig.padding20,
                    ),
                    showProfileImage
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: model.profileUrlList[index],
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
                                return Container(
                                    width: SizeConfig.iconSize5,
                                    height: SizeConfig.iconSize5,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ));
                              },
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      width: SizeConfig.padding12,
                    ),
                    Expanded(
                      child: Text(
                        model.pastWinners[index].username,
                        style: TextStyles.sourceSans.body3.setOpecity(0.8),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                "${model.pastWinners[index].score.truncateToDecimalPlaces(3)} gms"
                    .toString(),
                style: TextStyles.rajdhaniM.body3,
              ),
            ],
          ),
        );
      },
    );
  }
}
