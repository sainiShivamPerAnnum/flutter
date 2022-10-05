import 'dart:math' as math;

import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_viewModel.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/service_elements/leaderboards/referral_leaderboard.dart';
import 'package:felloapp/ui/service_elements/leaderboards/winners_leaderboard.dart';
import 'package:felloapp/ui/service_elements/new/unscratched_gt_count.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:shimmer/shimmer.dart';

List<Color> randomColors = [
  Color(0xffF79780),
  Color(0xffEFAF4E),
  Color(0xff93B5FE),
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
                  physics: BouncingScrollPhysics(),
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
                            SizeConfig.padding34, SizeConfig.padding24, 0.0),
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
                                        : currentWinning > 0
                                            ? Text(
                                                'Rewards can be\nredeemed at Rs. ${model.minWithdrawPrizeAmt}',
                                                style: TextStyles
                                                    .sourceSans.body3
                                                    .colour(UiConstants
                                                        .kTextColor2),
                                              )
                                            : SizedBox(),
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
                              height: SizeConfig.padding24,
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
                                model.navigateToMyWinnings(model);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          Assets.unredemmedGoldenTicketBG,
                                          height: SizeConfig.padding32),
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
                                      UnscratchedGTCountChip(model: model),
                                      SizedBox(
                                        width: SizeConfig.padding10,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: SizeConfig.padding24,
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
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              model.navigateToRefer();
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  SizeConfig.padding24,
                                  SizeConfig.padding24,
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
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig.padding12,
                                              vertical: SizeConfig.padding6),
                                          decoration: BoxDecoration(
                                            color: UiConstants
                                                .kArowButtonBackgroundColor,
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
                                                style: TextStyles
                                                    .rajdhaniEB.title2
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
                                                                .withOpacity(
                                                                    0.7))),
                                                    SizedBox(
                                                      width:
                                                          SizeConfig.padding6,
                                                    ),
                                                    Icon(
                                                      Icons.copy,
                                                      color: UiConstants
                                                          .kTextColor3
                                                          .withOpacity(0.7),
                                                      size:
                                                          SizeConfig.padding24,
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
                                            color: UiConstants
                                                .kArowButtonBackgroundColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (model.isShareAlreadyClicked ==
                                                  false) model.shareLink();
                                            },
                                            child: Icon(
                                              Icons.share,
                                              color:
                                                  UiConstants.kTabBorderColor,
                                              size: SizeConfig.padding28,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: SizeConfig.pageHorizontalMargins +
                                SizeConfig.padding14,
                            right: SizeConfig.pageHorizontalMargins +
                                SizeConfig.padding14,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: SizeConfig.padding28,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),

                      ReferralLeaderboard(
                        count: 2,
                      ),
                      SizedBox(
                        height: SizeConfig.padding24,
                      ),
                      //Fello News
                      FelloNewsComponent(
                        model: model,
                      ),

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
  final WinViewModel model;
  const FelloNewsComponent({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
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
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenWidth * 0.4026,
            child: model.isFelloFactsLoading
                ? FullScreenLoader(
                    size: SizeConfig.screenWidth * 0.4,
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: model.fellofacts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 0.0 : SizeConfig.padding20,
                            right: SizeConfig.padding20),
                        height: double.maxFinite,
                        width: SizeConfig.screenWidth * 0.8,
                        margin: EdgeInsets.only(
                            left: SizeConfig.padding24,
                            right: index == model.fellofacts.length - 1
                                ? SizeConfig.padding24
                                : 0.0),
                        decoration: BoxDecoration(
                          color: model.fellofacts[index].bgColor == null
                              ? randomColors[
                                  math.Random().nextInt(randomColors.length)]
                              : model.fellofacts[index].bgColor.toColor(),
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.roundness12)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              model.fellofacts[index].asset,
                              width: SizeConfig.screenWidth * 0.25,
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
                                      model.fellofacts[index].title,
                                      style: TextStyles.rajdhaniSB.body1
                                          .colour(UiConstants.kBackgroundColor),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding16,
                                  ),
                                  Flexible(
                                    child: Text(
                                      model.fellofacts[index].subTitle,
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
