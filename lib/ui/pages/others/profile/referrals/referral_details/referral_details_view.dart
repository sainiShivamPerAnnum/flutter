import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/referrals/referral_details/referral_details_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/default_avatar.dart';
import 'package:felloapp/ui/widgets/helpers/height_adaptive_pageview.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class ReferralDetailsView extends StatelessWidget {
  ScrollController _controller = ScrollController();

  var _selectedTextStyle =
      TextStyles.sourceSansSB.body1.colour(UiConstants.titleTextColor);

  var _unselectedTextStyle = TextStyles.sourceSans.body1
      .colour(UiConstants.titleTextColor.withOpacity(0.6));

  List<Shadow> shadowDrawerList = [
    Shadow(
      offset: Offset(0.0, 5.0),
      blurRadius: 3.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    Shadow(
      offset: Offset(0.0, 5.0),
      blurRadius: 3.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  ];

  getHeadingCustomTextStyle(Color color) {
    return TextStyles.rajdhaniEB.title50
        .colour(color)
        .copyWith(shadows: shadowDrawerList);
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<ReferralDetailsViewModel>(
        onModelReady: (model) => model.init(context),
        builder: (ctx, model, child) {
          return Scaffold(
            body: Stack(
              children: [
                NewSquareBackground(),
                SingleChildScrollView(
                  controller: _controller,
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        elevation: 0.0,
                        automaticallyImplyLeading: false,
                        backgroundColor: UiConstants.kArowButtonBackgroundColor,
                        leading: IconButton(
                            onPressed: () {
                              AppState.backButtonDispatcher.didPopRoute();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            )),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: UiConstants.kArowButtonBackgroundColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(SizeConfig.roundness12),
                            bottomRight:
                                Radius.circular(SizeConfig.roundness12),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding54,
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      child: SvgPicture.asset(
                                          Assets.refreAndEarnBackgroundAsset,
                                          width: SizeConfig.screenWidth * 0.5),
                                    ),
                                    Image.asset(Assets.iPadPNG,
                                        fit: BoxFit.cover,
                                        width: SizeConfig.screenWidth * 0.3)
                                  ],
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'REFER ',
                                        style: getHeadingCustomTextStyle(
                                            UiConstants.kTabBorderColor)),
                                    TextSpan(
                                        text: '& ',
                                        style: getHeadingCustomTextStyle(
                                            Colors.white)),
                                    TextSpan(
                                        text: 'EARN',
                                        style: getHeadingCustomTextStyle(
                                            UiConstants
                                                .kWinnerPlayerPrimaryColor)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.padding16,
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'Earn upto ₹' +
                                            BaseRemoteConfig.remoteConfig
                                                .getString(BaseRemoteConfig
                                                    .REFERRAL_BONUS) +
                                            ' and ',
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor3)),
                                    WidgetSpan(
                                        child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: SizeConfig.padding4),
                                      height: 17,
                                      width: 17,
                                      child: SvgPicture.asset(
                                        Assets.token,
                                      ),
                                    )),
                                    TextSpan(
                                        text: BaseRemoteConfig.remoteConfig
                                                .getString(BaseRemoteConfig
                                                    .REFERRAL_FLC_BONUS) +
                                            ' from every Golden Ticket. Win an iPad every month!',
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor3)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.padding28,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.padding12,
                                        vertical: SizeConfig.padding6),
                                    decoration: BoxDecoration(
                                      color:
                                          UiConstants.kSecondaryBackgroundColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              SizeConfig.roundness8)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          model.loadingRefCode
                                              ? '-'
                                              : model.refCode,
                                          style: TextStyles.rajdhaniEB.title2
                                              .colour(Colors.white),
                                        ),
                                        SizedBox(
                                          width: SizeConfig.padding24,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            model.copyReferCode();
                                          },
                                          child: Row(
                                            children: [
                                              Text("COPY",
                                                  style: TextStyles
                                                      .sourceSans.body3
                                                      .colour(UiConstants
                                                          .kTextColor3
                                                          .withOpacity(0.7))),
                                              SizedBox(
                                                width: SizeConfig.padding6,
                                              ),
                                              Icon(
                                                Icons.copy,
                                                color: UiConstants.kTextColor3
                                                    .withOpacity(0.7),
                                                size: SizeConfig.padding24,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding20,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.padding12,
                                        vertical: SizeConfig.padding12),
                                    decoration: BoxDecoration(
                                      color:
                                          UiConstants.kSecondaryBackgroundColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (model.isShareAlreadyClicked ==
                                            false) model.shareLink();
                                      },
                                      child: Icon(
                                        Icons.share,
                                        color: UiConstants.kTabBorderColor,
                                        size: SizeConfig.padding28,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: SizeConfig.padding32,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.pageHorizontalMargins,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.pageHorizontalMargins,
                        ),
                        child: Text(
                          "My Referrals",
                          style: TextStyles.sourceSans.semiBold
                              .colour(Colors.white)
                              .title3,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.pageHorizontalMargins,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white.withOpacity(0.5), width: 0.5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.roundness12),
                          ),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.padding16,
                            horizontal: SizeConfig.padding16),
                        child: Row(
                          children: [
                            ProfileImageSE(
                              reactive: false,
                            ),
                            SizedBox(
                              width: SizeConfig.padding12,
                            ),
                            PropertyChangeConsumer<UserService,
                                UserServiceProperties>(
                              properties: [
                                UserServiceProperties.myUserName,
                                UserServiceProperties.myJourneyStats
                              ],
                              builder: (context, m, properties) {
                                return FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "${m?.myUserName?.split(" ")?.first ?? ''}",
                                    style: TextStyles.sourceSans.body1.colour(
                                      Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      model.referalList == null
                                          ? '-'
                                          : "${model.referalList.length} referrals",
                                      style: TextStyles.body3
                                          .colour(UiConstants.kTextColor2)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      model.referalList == null
                          ? Container(
                              width: SizeConfig.screenWidth,
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.pageHorizontalMargins),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FullScreenLoader(),
                                  SizedBox(height: SizeConfig.padding20),
                                  Text(
                                    "Fetching your referals. Please wait..",
                                    style: TextStyles.sourceSans.body2
                                        .colour(Colors.white),
                                  ),
                                ],
                              ),
                            )
                          : model.referalList.isEmpty
                              ? Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: SizeConfig.padding34),
                                      SvgPicture.asset(Assets.noReferalAsset),
                                      SizedBox(height: SizeConfig.padding34),
                                      Text(
                                        "No referrals yet",
                                        style: TextStyles.sourceSans.body2
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(height: SizeConfig.padding34),
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                    top: SizeConfig.padding34,
                                    bottom: SizeConfig.padding12,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () =>
                                                  model.switchTab(0),
                                              child: Text(
                                                'Successful',
                                                style: model.tabNo == 0
                                                    ? _selectedTextStyle
                                                    : _unselectedTextStyle, // TextStyles.sourceSansSB.body1,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeConfig.padding16,
                                          ),
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () =>
                                                  model.switchTab(1),
                                              child: Text(
                                                'Have not saved',
                                                style: model.tabNo == 1
                                                    ? _selectedTextStyle
                                                    : _unselectedTextStyle, // style: TextStyles.sourceSansSB.body1,
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
                                            color: UiConstants.kTabBorderColor,
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
                                          BonusUnlockedReferals(
                                            model: model,
                                          ),

                                          //Current particiapnts
                                          BonusLockedReferals(
                                            model: model,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        child: Divider(color: Colors.white, thickness: 0.5),
                      ),
                      HowToEarnComponment(
                        model: model,
                        locale: locale,
                        onStateChanged: () {
                          _controller.animateTo(
                              _controller.position.maxScrollExtent,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.padding80,
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: UiConstants.kBackgroundColor,
                    padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                    child: AppPositiveBtn(
                      btnText: "SHARE",
                      width: SizeConfig.screenWidth -
                          SizeConfig.pageHorizontalMargins * 2,
                      onPressed: () {
                        if (!model.isShareAlreadyClicked) model.shareLink();
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class BonusLockedReferals extends StatelessWidget {
  const BonusLockedReferals({
    Key key,
    @required this.model,
  }) : super(key: key);

  final ReferralDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    return model.referalList.isEmpty
        ? Column(
            children: [
              SizedBox(height: SizeConfig.padding16),
              SvgPicture.asset(Assets.noReferalAsset),
              SizedBox(height: SizeConfig.padding16),
              Text(
                "No referrals yet",
                style: TextStyles.sourceSans.body2.colour(Colors.white),
              ),
              SizedBox(height: SizeConfig.padding16),
            ],
          )
        : model.bonusLockedReferalPresent(model.referalList)
            ? Padding(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Referals",
                          style:
                              TextStyles.sourceSans.body2.colour(Colors.white),
                        ),
                        Text(
                          "My Reward",
                          style:
                              TextStyles.sourceSans.body2.colour(Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding24,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          if (!(model.referalList[i].isUserBonusUnlocked)) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: SizeConfig.padding24),
                              child: Row(
                                children: [
                                  FutureBuilder(
                                    future: model.getProfileDpWithUid(
                                        model.referalList[i].uid),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          !snapshot.hasData) {
                                        return DefaultAvatar();
                                      }

                                      String imageUrl = snapshot.data as String;

                                      return ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          width: SizeConfig.iconSize5,
                                          height: SizeConfig.iconSize5,
                                          placeholder: (context, url) =>
                                              Container(
                                            width: SizeConfig.iconSize5,
                                            height: SizeConfig.iconSize5,
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
                                    width: SizeConfig.padding10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(model.referalList[i].userName,
                                          style: TextStyles.sourceSans.body1
                                              .colour(
                                            Colors.white,
                                          )),
                                      Text(
                                        model.referalList[i].timestamp ==
                                                    null ||
                                                model.referalList[i].timestamp
                                                    .toDate()
                                                    .isBefore(Constants
                                                        .VERSION_2_RELEASE_DATE)
                                            ? '-'
                                            : '${model.getUserMembershipDate(model.referalList[i].timestamp)}',
                                        style: TextStyles.body4
                                            .colour(UiConstants.kTextColor2),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // SvgPicture.asset(
                                          //   Assets.unredemmedGoldenTicketBG,
                                          //   width: SizeConfig.padding32,
                                          // ),
                                          SizedBox(
                                            width: SizeConfig.padding12,
                                          ),
                                          Text("🔒",
                                              style: TextStyles
                                                  .sourceSans.body1.bold
                                                  .colour(
                                                Colors.white,
                                              )),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                        itemCount: model.referalList.length),
                  ],
                ),
              )
            : Column(
                children: [
                  SizedBox(height: SizeConfig.padding16),
                  SvgPicture.asset(Assets.noReferalAsset),
                  SizedBox(height: SizeConfig.padding16),
                  Text(
                    "No referrals yet",
                    style: TextStyles.sourceSans.body2.colour(Colors.white),
                  ),
                  SizedBox(height: SizeConfig.padding16),
                ],
              );
  }
}

class BonusUnlockedReferals extends StatelessWidget {
  const BonusUnlockedReferals({
    Key key,
    @required this.model,
  }) : super(key: key);

  final ReferralDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    return model.referalList.isEmpty
        ? Column(
            children: [
              SizedBox(height: SizeConfig.padding16),
              SvgPicture.asset(Assets.noReferalAsset),
              SizedBox(height: SizeConfig.padding16),
              Text(
                "No referrals yet",
                style: TextStyles.sourceSans.body2.colour(Colors.white),
              ),
              SizedBox(height: SizeConfig.padding16),
            ],
          )
        : model.bonusUnlockedReferalPresent(model.referalList)
            ? Padding(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Referals",
                          style:
                              TextStyles.sourceSans.body2.colour(Colors.white),
                        ),
                        Text(
                          "My Reward",
                          style:
                              TextStyles.sourceSans.body2.colour(Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding24,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          if (model.referalList[i].isUserBonusUnlocked) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: SizeConfig.padding24),
                              child: Row(
                                children: [
                                  FutureBuilder(
                                    future: model.getProfileDpWithUid(
                                        model.referalList[i].uid),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          !snapshot.hasData)
                                        return DefaultAvatar();

                                      String imageUrl = snapshot.data as String;

                                      return ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          width: SizeConfig.iconSize5,
                                          height: SizeConfig.iconSize5,
                                          placeholder: (context, url) =>
                                              Container(
                                            width: SizeConfig.iconSize5,
                                            height: SizeConfig.iconSize5,
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
                                    width: SizeConfig.padding10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(model.referalList[i].userName,
                                          style: TextStyles.sourceSans.body1
                                              .colour(
                                            Colors.white,
                                          )),
                                      Text(
                                        model.referalList[i].timestamp ==
                                                    null ||
                                                model.referalList[i].timestamp
                                                    .toDate()
                                                    .isBefore(Constants
                                                        .VERSION_2_RELEASE_DATE)
                                            ? '-'
                                            : '${model.getUserMembershipDate(model.referalList[i].timestamp)}',
                                        style: TextStyles.body4
                                            .colour(UiConstants.kTextColor2),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SvgPicture.asset(
                                            Assets.unredemmedGoldenTicketBG,
                                            width: SizeConfig.padding32,
                                          ),
                                          SizedBox(
                                            width: SizeConfig.padding12,
                                          ),
                                          Text("1",
                                              style: TextStyles
                                                  .sourceSans.body1.bold
                                                  .colour(
                                                Colors.white,
                                              )),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                        itemCount: model.referalList.length),
                  ],
                ),
              )
            : Column(
                children: [
                  SizedBox(height: SizeConfig.padding16),
                  SvgPicture.asset(Assets.noReferalAsset),
                  SizedBox(height: SizeConfig.padding16),
                  Text(
                    "No referrals yet",
                    style: TextStyles.sourceSans.body2.colour(Colors.white),
                  ),
                  SizedBox(height: SizeConfig.padding16),
                ],
              );
  }
}

class HowToEarnComponment extends StatefulWidget {
  HowToEarnComponment({
    @required this.onStateChanged,
    @required this.model,
    @required this.locale,
    Key key,
  }) : super(key: key);

  final Function onStateChanged;
  final ReferralDetailsViewModel model;
  var locale;

  @override
  State<HowToEarnComponment> createState() => _InfoComponentState();
}

class _InfoComponentState extends State<HowToEarnComponment> {
  bool isBoxOpen = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              //Chaning the state of the box on click

              setState(() {
                isBoxOpen = !isBoxOpen;
              });

              Future.delayed(const Duration(milliseconds: 200), () {
                widget.onStateChanged();
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.locale.refHIW,
                  style: TextStyles.rajdhaniSB.title5,
                ),
                SizedBox(
                  width: SizeConfig.padding24,
                ),
                Icon(
                  isBoxOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          isBoxOpen
              ? Column(
                  children: [
                    InfoTile(
                      title: widget.locale.refstep1,
                      leadingAsset: Assets.paperClip,
                    ),
                    // InfoTile(
                    //   title:
                    //       "Once your friend completes their KYC verification, you receive a new Golden Ticket.",
                    //   leadingAsset: Assets.wmtsaveMoney,
                    // ),
                    InfoTile(
                      title:
                          "Once your friend makes their first investment of ₹${widget.model.unlockReferralBonus}, you and your friend both receive ₹${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.REFERRAL_BONUS)} and ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.REFERRAL_FLC_BONUS)} Fello tokens.",
                      leadingAsset: Assets.tickets,
                    ),
                    SizedBox(height: SizeConfig.padding8),
                    // InfoTile(
                    //   title:
                    //       "Once your friend plays Cricket or Pool Club more than 10 times, you receive a new Golden Ticket.",
                    //   leadingAsset: Assets.wmtShare,
                    // ),
                    // SizedBox(height: SizeConfig.padding8),
                    // Center(
                    //   child: Text(
                    //     "You can win upto ₹150 and 600 Fello tokens from each referral!",
                    //     style: TextStyles.body3.bold.colour(Colors.white),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    SizedBox(
                      height: SizeConfig.screenWidth * 0.3,
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String leadingAsset;
  final IconData leadingIcon;
  final String title;
  final double leadSize;

  InfoTile({this.leadingIcon, this.leadingAsset, this.title, this.leadSize});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding6),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: UiConstants.kTabBorderColor.withOpacity(0.1),
            radius: leadSize ?? SizeConfig.padding24,
            child: leadingIcon != null
                ? Icon(
                    leadingIcon,
                    size: SizeConfig.padding20,
                    color: UiConstants.tertiarySolid,
                  )
                : SvgPicture.asset(
                    leadingAsset ?? "assets/vectors/icons/tickets.svg",
                    height: SizeConfig.padding20,
                    width: SizeConfig.padding20,
                    color: UiConstants.kTabBorderColor,
                  ),
          ),
          SizedBox(
            width: SizeConfig.padding12,
          ),
          Expanded(
            child: Text(
              title ?? "title",
              style: TextStyles.body3.colour(UiConstants.kFAQsAnswerColor),
            ),
          ),
        ],
      ),
    );
  }
}
