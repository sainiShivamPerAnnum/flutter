import 'dart:math' as math;

import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/service_elements/leaderboards/referral_leaderboard.dart';
import 'package:felloapp/ui/service_elements/leaderboards/winners_leaderboard.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

//Following is a dummy list to populate the Fello News section for now
List<Map<String, dynamic>> dummyFelloNews = [
  {
    'title': 'Parul won an iPad',
    'subTitle':
        'She referred 112 of his friends to Fello and was the referrer of the month',
    'color': 0xffF79780,
    'asset': Assets.winScreenWinnerAsset,
  },
  {
    'title': 'Fello Autosave is on fire',
    'subTitle':
        'Mre than 40,000 users are now automating their savings using Fello Autosave',
    'color': 0xffEFAF4E,
    'asset': Assets.winScreenAllGamesAsset,
  },
  {
    'title': 'Aaryan is on a hot streak',
    'subTitle':
        'He has been saving daily and consistently for 70 days straight!',
    'color': 0xff93B5FE,
    'asset': Assets.winScreenReferalAsset,
  },
];

class Win extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);

    return BaseView<WinViewModel>(
      onModelReady: (model) {
        model.init();
      },
      onModelDispose: (model) {
        model.clear();
      },
      builder: (ctx, model, child) {
        return PropertyChangeConsumer<UserService, UserServiceProperties>(
            properties: [UserServiceProperties.myUserFund],
            builder: (context, m, property) {
              double currentWinning = m.userFundWallet?.unclaimedBalance ?? 0;
              return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: FAppBar(
                  type: FaqsType.win,
                ),
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Current Winnings section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(SizeConfig.roundness12),
                            bottomRight:
                                Radius.circular(SizeConfig.roundness12),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(SizeConfig.padding24,
                            SizeConfig.padding44, SizeConfig.padding24, 0.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current Winnings',
                                      style: TextStyles.rajdhaniSB
                                          .copyWith(fontSize: SizeConfig.body0),
                                    ),
                                    Text(
                                      '₹ ${currentWinning.toString() ?? '-'}',
                                      style: TextStyles.title1.extraBold
                                          .colour(Colors.white),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding32,
                                    ),
                                    currentWinning >= model.minWithdrawPrizeAmt
                                        ? AppPositiveBtn(
                                            height:
                                                SizeConfig.screenWidth * 0.12,
                                            btnText: "Redeem",
                                            onPressed: () {
                                              model.showConfirmDialog(
                                                  PrizeClaimChoice.GOLD_CREDIT);
                                            },
                                            width:
                                                SizeConfig.screenWidth * 0.32)

                                        // : m.userFundWallet
                                        //             .processingRedemptionBalance >
                                        //         0
                                        //     ? Text(
                                        //         "We're processing your rewards.",
                                        //         style: TextStyles
                                        //             .sourceSans.body3
                                        //             .colour(UiConstants
                                        //                 .kTextColor2),
                                        //       )
                                        : Text(
                                            'Rewards can be\nredeemed at Rs. ${model.minWithdrawPrizeAmt}',
                                            style: TextStyles.sourceSans.body3
                                                .colour(
                                                    UiConstants.kTextColor2),
                                          ),
                                  ],
                                ),
                                if (m.userFundWallet != null)
                                  Expanded(
                                    child: SvgPicture.asset(
                                        model.getRedeemAsset(
                                            m.userFundWallet.unclaimedBalance)),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.padding54,
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 0.3,
                            ),
                            SizedBox(
                              height: SizeConfig.padding16,
                            ),
                            TextButton(
                              onPressed: () {
                                model.navigateToMyWinnings();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          Assets.unredemmedGoldenTicketBG,
                                          height: SizeConfig.padding38),
                                      SizedBox(
                                        width: SizeConfig.padding8,
                                      ),
                                      Text(
                                        'Golden Tickets',
                                        style: TextStyles.sourceSans.body2
                                            .colour(Colors.white),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'See All',
                                        style: TextStyles.sourceSans.body3
                                            .colour(Colors.white),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.padding10,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      //Refer and Earn
                      Container(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  SizeConfig.padding24,
                                  SizeConfig.padding44,
                                  SizeConfig.padding24,
                                  (SizeConfig.screenWidth * 0.15) / 2),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: UiConstants.kSecondaryBackgroundColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(SizeConfig.roundness12))),
                              child: Container(
                                padding: EdgeInsets.all(
                                  SizeConfig.padding24,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      child: SvgPicture.asset(
                                          Assets.referAndEarn,
                                          height: SizeConfig.padding90 +
                                              SizeConfig.padding10),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding28,
                                    ),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text: 'Earn upto Rs.50 and',
                                              style: TextStyles.sourceSans.body3
                                                  .colour(
                                                      UiConstants.kTextColor3)),
                                          WidgetSpan(
                                              child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    SizeConfig.padding4),
                                            height: 17,
                                            width: 17,
                                            child: SvgPicture.asset(
                                              Assets.token,
                                            ),
                                          )),
                                          TextSpan(
                                              text:
                                                  '200 from every Golden Ticket. Win an iPad every month.',
                                              style: TextStyles.sourceSans.body3
                                                  .colour(
                                                      UiConstants.kTextColor3)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.padding28,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig.padding32,
                                              vertical: SizeConfig.padding6),
                                          decoration: BoxDecoration(
                                              color: UiConstants
                                                  .kArowButtonBackgroundColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    SizeConfig.roundness8),
                                              ),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 0.6)),
                                          child: Text(
                                            model.loadingRefCode
                                                ? '-'
                                                : model.refCode,
                                            style: TextStyles.rajdhaniEB.title2
                                                .colour(Colors.white),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  model.copyReferCode();
                                                },
                                                icon: Icon(
                                                  Icons.copy,
                                                  color: UiConstants
                                                      .kTabBorderColor,
                                                  size: SizeConfig.padding28,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  if (model
                                                          .isShareAlreadyClicked ==
                                                      false) model.shareLink();
                                                },
                                                icon: Icon(
                                                  Icons.share,
                                                  color: UiConstants
                                                      .kTabBorderColor,
                                                  size: SizeConfig.padding28,
                                                ),
                                              )
                                            ],
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
                            Container(
                              width: SizeConfig.screenWidth * 0.17,
                              height: SizeConfig.screenWidth * 0.17,
                              decoration: BoxDecoration(
                                color: UiConstants.kSecondaryBackgroundColor,
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  model.navigateToRefer();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(SizeConfig.padding6),
                                  padding: EdgeInsets.all(SizeConfig.padding8),
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color:
                                        UiConstants.kArowButtonBackgroundColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    Assets.chevRonRightArrow,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: SizeConfig.padding32,
                      ),
                      ReferralLeaderboard(
                        count: 2,
                      ),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      //Fello News
                      FelloNewsComponent(),

                      SizedBox(
                        height: SizeConfig.padding44,
                      ),

                      //Leader Board
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.padding24,
                        ),
                        child: Text(
                          "LeaderBoard",
                          style: TextStyles.sourceSans.semiBold
                              .colour(Colors.white)
                              .title3,
                        ),
                      ),
                      WinnerboardView(
                        count: 4,
                      ),

                      SizedBox(
                        height: SizeConfig.navBarHeight,
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}

class FelloNewsComponent extends StatelessWidget {
  const FelloNewsComponent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.padding24,
            ),
            child: Text(
              "This Week’s Highlights",
              style: TextStyles.sourceSans.semiBold.colour(Colors.white).title3,
            ),
          ),
          SizedBox(height: SizeConfig.padding24),
          Container(
            width: double.infinity,
            height: SizeConfig.screenWidth * 0.4026,
            child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: dummyFelloNews.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(
                      left: index == 0 ? 0.0 : SizeConfig.padding20,
                      right: SizeConfig.padding20),
                  height: double.maxFinite,
                  width: SizeConfig.screenWidth * 0.8,
                  margin: EdgeInsets.only(
                      left: SizeConfig.padding24,
                      right: index == dummyFelloNews.length - 1
                          ? SizeConfig.padding24
                          : 0.0),
                  decoration: BoxDecoration(
                    color: Color(dummyFelloNews[index]['color']),
                    borderRadius: BorderRadius.all(
                        Radius.circular(SizeConfig.roundness12)),
                  ),
                  child: Row(
                    crossAxisAlignment: index == 0
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        dummyFelloNews[index]['asset'],
                        width: index == 0
                            ? SizeConfig.screenWidth * 0.25
                            : SizeConfig.screenWidth * 0.2,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: SizeConfig.padding16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                dummyFelloNews[index]['title'],
                                style: TextStyles.rajdhaniSB.body1
                                    .colour(UiConstants.kBackgroundColor),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.padding16,
                            ),
                            Flexible(
                              child: Text(
                                dummyFelloNews[index]['subTitle'],
                                style: TextStyles.sourceSans.body4
                                    .colour(UiConstants.kBackgroundColor),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ReferAndEarnComponent extends StatelessWidget {
  ReferAndEarnComponent({
    Key key,
    @required this.model,
  }) : super(key: key);

  final WinViewModel model;

  bool isShareButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
                SizeConfig.padding24,
                SizeConfig.padding44,
                SizeConfig.padding24,
                (SizeConfig.screenWidth * 0.15) / 2),
            width: double.infinity,
            decoration: BoxDecoration(
                color: UiConstants.kSecondaryBackgroundColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(SizeConfig.roundness12))),
            child: Container(
              padding: EdgeInsets.all(
                SizeConfig.padding24,
              ),
              child: Column(
                children: [
                  Container(
                    child: SvgPicture.asset(Assets.referAndEarn,
                        height: SizeConfig.padding90 + SizeConfig.padding10),
                  ),
                  SizedBox(
                    height: SizeConfig.padding28,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Earn upto Rs.50 and',
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
                            text:
                                '200 from every Golden Ticket. Win an iPad every month.',
                            style: TextStyles.sourceSans.body3
                                .colour(UiConstants.kTextColor3)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding28,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding32,
                            vertical: SizeConfig.padding6),
                        decoration: BoxDecoration(
                            color: UiConstants.kArowButtonBackgroundColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.roundness8),
                            ),
                            border:
                                Border.all(color: Colors.white, width: 0.6)),
                        child: Text(
                          model.loadingRefCode ? '-' : model.refCode,
                          style:
                              TextStyles.rajdhaniEB.title2.colour(Colors.white),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                model.copyReferCode();
                              },
                              icon: Icon(
                                Icons.copy,
                                color: UiConstants.kTabBorderColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                model.shareLink();
                              },
                              icon: Icon(
                                Icons.share,
                                color: UiConstants.kTabBorderColor,
                              ),
                            )
                          ],
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
          Container(
            width: SizeConfig.screenWidth * 0.17,
            height: SizeConfig.screenWidth * 0.17,
            decoration: BoxDecoration(
              color: UiConstants.kSecondaryBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onTap: () {
                model.navigateToRefer();
              },
              child: Container(
                margin: EdgeInsets.all(SizeConfig.padding6),
                padding: EdgeInsets.all(SizeConfig.padding8),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: UiConstants.kArowButtonBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  Assets.chevRonRightArrow,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RewardsAvatar extends StatelessWidget {
  final Color color;
  final String asset;

  RewardsAvatar({this.asset, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.24,
      margin: EdgeInsets.only(right: SizeConfig.padding16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness56),
        color: color,
        image: DecorationImage(image: AssetImage(asset), fit: BoxFit.fitWidth),
      ),
    );
  }
}

Widget referralTile(String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: 20.0),
    child: Row(
      children: [
        Icon(
          Icons.brightness_1,
          size: 12,
          color: UiConstants.primaryColor,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyles.body3,
          ),
        ),
      ],
    ),
  );
}
