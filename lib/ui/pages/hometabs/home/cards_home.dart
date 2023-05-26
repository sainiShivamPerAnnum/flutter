import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/fund_breakdown_dialog.dart';
import 'package:felloapp/ui/pages/hometabs/home/card_actions_notifier.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/ui/pages/static/blur_filter.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../util/styles/styles.dart';

class Cards extends StatefulWidget {
  const Cards({Key? key}) : super(key: key);

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> with SingleTickerProviderStateMixin {
  // double bgWidth = SizeConfig.screenWidth!;
  ScrollController? controller;
  Duration duration = const Duration(milliseconds: 300);
  Curve curve = Curves.decelerate;
  bool _hasReachedEnd = false;

  bool get hasReachedEnd => _hasReachedEnd;

  set hasReachedEnd(bool value) {
    _hasReachedEnd = value;
    setState(() {});
  } // Animation<double> gradientAnimation;

  double expandedViewHeightRatio = 1.54;

  AnimationController? gradientController;
  CardActionsNotifier? cardActionsNotifier;

  @override
  void initState() {
    cardActionsNotifier = locator<CardActionsNotifier>();
    gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });

    controller = ScrollController()
      ..addListener(() {
        if (controller!.offset == controller!.position.minScrollExtent) {
          print("Min reached ${controller!.offset}");
          if (!hasReachedEnd) {
            hasReachedEnd = true;
          }
        }
        if (controller!.offset < controller!.position.minScrollExtent) {
          if (cardActionsNotifier!.isHorizontalView) {
            cardActionsNotifier!.isHorizontalView = false;
            hasReachedEnd = false;
            Future.delayed(
              duration,
              () {
                gradientController?.reset();
                gradientController?.forward();
              },
            );
          }
        }
        if (controller!.offset > controller!.position.minScrollExtent) {
          if (hasReachedEnd) hasReachedEnd = false;
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    gradientController?.dispose();
    super.dispose();
  }

  // double _previousOffset = 0.0;

  void navigateToSaveAssetView(
    InvestmentType investmentType,
  ) {
    Haptic.vibrate();

    if (investmentType == InvestmentType.AUGGOLD99) {
      AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: SaveAssetsViewConfig,
        widget: AssetSectionView(
          type: investmentType,
        ),
      );
    } else {
      AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: SaveAssetsViewConfig,
        widget: AssetSectionView(
          type: investmentType,
        ),
      );
    }
  }

  void onRedeemPressed() {
    final referralService = locator<ReferralService>();
    final currentWinnings =
        locator<UserService>().userFundWallet?.unclaimedBalance ?? 0.0;
    if (currentWinnings >= (referralService.minWithdrawPrizeAmt ?? 200)) {
      referralService.showConfirmDialog(PrizeClaimChoice.GOLD_CREDIT);
    } else {
      BaseUtil.showNegativeAlert("Not enough winnings",
          "Winnings can only be redeemed after reaching ₹${referralService.minWithdrawPrizeAmt}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CardActionsNotifier>(
        builder: (context, cardActions, child) {
      final bool isCardsClosed =
          !cardActions.isHorizontalView && !cardActions.isVerticalView;
      return AnimatedContainer(
        duration: duration,
        curve: curve,
        height: SizeConfig.screenWidth! *
            (cardActions.isVerticalView ? expandedViewHeightRatio : 0.8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(SizeConfig.titleSize / 2),
            bottomRight: Radius.circular(SizeConfig.titleSize / 2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(cardActions.isVerticalView ? 0.5 : 0.2),
              blurRadius: 15,
              offset: Offset(0, cardActions.isVerticalView ? 200 : 5),
              spreadRadius: 8,
            )
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (cardActions.isHorizontalView) {
                    cardActions.isHorizontalView = false;
                  }
                  double currentOffset = details.primaryDelta ?? 0;
                  if (details.delta.dy > 0) {
                    if (!cardActions.isVerticalView && mounted) {
                      cardActions.isVerticalView = true;
                    }
                  }
                },
                onHorizontalDragEnd: (_) {
                  if (cardActions.isVerticalView) return;
                  cardActions.isHorizontalView = true;

                  controller?.jumpTo(0);
                },
                onTap: () {
                  if (!cardActions.isVerticalView) {
                    cardActions.isVerticalView = true;
                  }
                },
                child: AnimatedContainer(
                  curve: curve,
                  duration: duration,
                  width: SizeConfig.screenWidth! * (1),
                  height: SizeConfig.screenWidth! *
                      (cardActions.isVerticalView
                          ? expandedViewHeightRatio
                          : 0.78),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedContainer(
                          curve: curve,
                          duration: duration,
                          width: SizeConfig.screenWidth! * (1),
                          height: SizeConfig.screenWidth! *
                              (cardActions.isVerticalView
                                  ? expandedViewHeightRatio
                                  : 0.78),
                          decoration: BoxDecoration(
                            color: UiConstants.kBackgroundColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(SizeConfig.titleSize / 2),
                              bottomRight:
                                  Radius.circular(SizeConfig.titleSize / 2),
                            ),
                          ),
                          child: SingleChildScrollView(
                            controller: controller,
                            physics: cardActions.isHorizontalView
                                ? hasReachedEnd
                                    ? const BouncingScrollPhysics()
                                    : const ClampingScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: AnimatedContainer(
                              curve: curve,
                              duration: duration,
                              padding: cardActions.isVerticalView
                                  ? EdgeInsets.symmetric(
                                      vertical:
                                          SizeConfig.pageHorizontalMargins,
                                      horizontal:
                                          SizeConfig.pageHorizontalMargins)
                                  : EdgeInsets.only(
                                      top: SizeConfig.titleSize / 2,
                                      left: cardActions.isHorizontalView
                                          ? 0
                                          : SizeConfig.titleSize / 2,
                                      right: SizeConfig.titleSize / 2,
                                      bottom: SizeConfig.titleSize / 2),
                              height: SizeConfig.screenWidth! *
                                  (cardActions.isVerticalView
                                      ? expandedViewHeightRatio
                                      : 0.78),
                              width: SizeConfig.screenWidth! *
                                  (cardActions.isHorizontalView ? 2.4 : 1),
                              child: Stack(
                                children: [
                                  AnimatedPositioned(
                                    curve: curve,
                                    duration: duration,
                                    left: cardActions.isVerticalView
                                        ? 0
                                        : cardActions.isHorizontalView
                                            ? SizeConfig.screenWidth! * 1.63
                                            : SizeConfig.screenWidth! *
                                                0.075 *
                                                3,
                                    top: SizeConfig.screenWidth! *
                                        (cardActions.isVerticalView
                                            ? 1.1
                                            : cardActions.isHorizontalView
                                                ? 0.05
                                                : 0.088),
                                    child: GestureDetector(
                                      onVerticalDragUpdate: (details) {
                                        if (details.delta.dy < 0) {
                                          cardActions.isVerticalView = false;
                                        }
                                      },
                                      onTap: () {
                                        Haptic.vibrate();
                                        if (isCardsClosed) {
                                          cardActions.isHorizontalView = true;
                                        } else {
                                          AppState.delegate!.parseRoute(
                                              Uri.parse("/myWinnings"));
                                        }
                                      },
                                      child: Card(
                                        color: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.titleSize / 3),
                                        ),
                                        margin: EdgeInsets.zero,
                                        child: AnimatedContainer(
                                          curve: curve,
                                          duration: duration,
                                          decoration: BoxDecoration(
                                            color: (!cardActions
                                                        .isVerticalView &&
                                                    !cardActions
                                                        .isHorizontalView)
                                                ? UiConstants.kRewardColor
                                                : UiConstants.kRewardDarkColor,
                                            borderRadius: BorderRadius.circular(
                                                SizeConfig.titleSize / 3),
                                          ),
                                          height: SizeConfig.screenWidth! *
                                                  0.45 -
                                              (SizeConfig.screenWidth! *
                                                  0.64 *
                                                  0.03 *
                                                  (cardActions.isVerticalView
                                                      ? 7
                                                      : cardActions
                                                              .isHorizontalView
                                                          ? 0
                                                          : 2)),
                                          width: cardActions.isVerticalView
                                              ? (SizeConfig.screenWidth! -
                                                  SizeConfig
                                                          .pageHorizontalMargins *
                                                      2)
                                              : SizeConfig.screenWidth! * 0.8 -
                                                  (SizeConfig.screenWidth! *
                                                      0.8 *
                                                      0.04 *
                                                      4),
                                          child: CardContent(
                                            isHorizontalView:
                                                cardActions.isHorizontalView,
                                            isVerticalView:
                                                cardActions.isVerticalView,
                                            curve: curve,
                                            duration: duration,
                                            asset: Assets.dailyAppBonusHero,
                                            title: "Fello Rewards",
                                            infoTitle1: "Unclaimed Balance",
                                            infoTitle2: "Processing Balance",
                                            secondaryColor:
                                                UiConstants.kRewardColor,
                                            subtitle:
                                                "Redeem after reaching ₹200",
                                            onButtonPressed: onRedeemPressed,
                                            onCardPressed: () {
                                              AppState.delegate!.parseRoute(
                                                  Uri.parse("/myWinnings"));
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    curve: curve,
                                    duration: duration,
                                    left: cardActions.isVerticalView
                                        ? 0
                                        : cardActions.isHorizontalView
                                            ? SizeConfig.screenWidth! * 0.88
                                            : SizeConfig.screenWidth! *
                                                0.078 *
                                                2,
                                    top: SizeConfig.screenWidth! *
                                        (cardActions.isVerticalView
                                            ? 0.75
                                            : cardActions.isHorizontalView
                                                ? 0.05
                                                : 0.088),
                                    child: GestureDetector(
                                      onVerticalDragUpdate: (details) {
                                        if (details.delta.dy < 0) {
                                          cardActions.isVerticalView = false;
                                        }
                                      },
                                      onTap: () {
                                        if (isCardsClosed) {
                                          cardActions.isHorizontalView = true;
                                        } else {
                                          navigateToSaveAssetView(
                                              InvestmentType.AUGGOLD99);
                                        }
                                      },
                                      child: Card(
                                        color: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.titleSize / 3),
                                        ),
                                        margin: EdgeInsets.zero,
                                        child: AnimatedContainer(
                                          curve: curve,
                                          duration: duration,
                                          decoration: BoxDecoration(
                                            color: (!cardActions
                                                        .isVerticalView &&
                                                    !cardActions
                                                        .isHorizontalView)
                                                ? UiConstants
                                                    .kGoldContainerColor
                                                : UiConstants.kGoldDarkColor,
                                            borderRadius: BorderRadius.circular(
                                                SizeConfig.titleSize / 3),
                                          ),
                                          height: SizeConfig.screenWidth! *
                                                  0.45 -
                                              (SizeConfig.screenWidth! *
                                                  0.64 *
                                                  0.03 *
                                                  (cardActions.isVerticalView
                                                      ? 7
                                                      : cardActions
                                                              .isHorizontalView
                                                          ? 0
                                                          : 2)),
                                          width: cardActions.isVerticalView
                                              ? (SizeConfig.screenWidth! -
                                                  SizeConfig
                                                          .pageHorizontalMargins *
                                                      2)
                                              : SizeConfig.screenWidth! * 0.8 -
                                                  (SizeConfig.screenWidth! *
                                                      0.8 *
                                                      0.04 *
                                                      3),
                                          child: CardContent(
                                            isHorizontalView:
                                                cardActions.isHorizontalView,
                                            isVerticalView:
                                                cardActions.isVerticalView,
                                            curve: curve,
                                            duration: duration,
                                            asset: Assets.goldAsset,
                                            title: "Digital Gold",
                                            infoTitle1: "Gold Value",
                                            infoTitle2: "Gold Amount",
                                            secondaryColor:
                                                UiConstants.kGoldContainerColor,
                                            subtitle:
                                                "Quick Returns • Withdraw anytime",
                                            onButtonPressed: () => BaseUtil()
                                                .openRechargeModalSheet(
                                                    investmentType:
                                                        InvestmentType
                                                            .AUGGOLD99),
                                            onCardPressed: () =>
                                                navigateToSaveAssetView(
                                                    InvestmentType.AUGGOLD99),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    curve: curve,
                                    duration: duration,
                                    left: cardActions.isVerticalView
                                        ? 0
                                        : cardActions.isHorizontalView
                                            ? SizeConfig.screenWidth! * 0.11
                                            : SizeConfig.screenWidth! * 0.09,
                                    top: SizeConfig.screenWidth! *
                                        (cardActions.isVerticalView
                                            ? 0.4
                                            : cardActions.isHorizontalView
                                                ? 0.05
                                                : 0.088),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isCardsClosed) {
                                          cardActions.isHorizontalView = true;
                                        } else {
                                          navigateToSaveAssetView(
                                              InvestmentType.LENDBOXP2P);
                                        }
                                      },
                                      onVerticalDragUpdate: (details) {
                                        if (details.delta.dy < 0) {
                                          cardActions.isVerticalView = false;
                                        }
                                      },
                                      child: Card(
                                        color: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.titleSize / 3),
                                        ),
                                        margin: EdgeInsets.zero,
                                        child: AnimatedContainer(
                                          curve: curve,
                                          duration: duration,
                                          decoration: BoxDecoration(
                                            color: (!cardActions
                                                        .isVerticalView &&
                                                    !cardActions
                                                        .isHorizontalView)
                                                ? UiConstants.darkPrimaryColor3
                                                : UiConstants.darkPrimaryColor4,
                                            borderRadius: BorderRadius.circular(
                                                SizeConfig.titleSize / 3),
                                          ),
                                          height: SizeConfig.screenWidth! *
                                                  0.45 -
                                              (SizeConfig.screenWidth! *
                                                  0.64 *
                                                  0.03 *
                                                  (cardActions.isVerticalView
                                                      ? 7
                                                      : cardActions
                                                              .isHorizontalView
                                                          ? 0
                                                          : 2)),
                                          width: cardActions.isVerticalView
                                              ? (SizeConfig.screenWidth! -
                                                  SizeConfig
                                                          .pageHorizontalMargins *
                                                      2)
                                              : SizeConfig.screenWidth! * 0.8 -
                                                  (SizeConfig.screenWidth! *
                                                      0.8 *
                                                      0.04 *
                                                      2),
                                          child: CardContent(
                                            isHorizontalView:
                                                cardActions.isHorizontalView,
                                            isVerticalView:
                                                cardActions.isVerticalView,
                                            curve: curve,
                                            duration: duration,
                                            asset: Assets.floAsset,
                                            title: "Fello Flo",
                                            infoTitle1: "Flo Balance",
                                            infoTitle2: "Invested",
                                            secondaryColor:
                                                UiConstants.darkPrimaryColor3,
                                            subtitle:
                                                "Quick Returns • Withdraw anytime",
                                            onButtonPressed: () => BaseUtil()
                                                .openRechargeModalSheet(
                                                    investmentType:
                                                        InvestmentType
                                                            .LENDBOXP2P),
                                            onCardPressed: () =>
                                                navigateToSaveAssetView(
                                                    InvestmentType.LENDBOXP2P),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        curve: curve,
                        duration: duration,
                        left: cardActions.isVerticalView
                            ? 0
                            : cardActions.isHorizontalView
                                ? -SizeConfig.screenWidth! * 0.8 * 0.9
                                : SizeConfig.titleSize / 2,
                        top: SizeConfig.screenWidth! *
                            (cardActions.isVerticalView ? 0 : 0.05),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    cardActions.isVerticalView
                                        ? 0
                                        : SizeConfig.titleSize / 3),
                                child: BlurFilter(
                                  sigmaX: 10,
                                  sigmaY: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(
                                          cardActions.isVerticalView
                                              ? 0.8
                                              : 0.4),
                                      borderRadius: BorderRadius.circular(
                                          cardActions.isVerticalView
                                              ? 0
                                              : SizeConfig.titleSize / 3),
                                    ),
                                    height: SizeConfig.screenWidth! *
                                            (cardActions.isVerticalView
                                                ? 0.42
                                                : 0.5) -
                                        1,
                                    width: cardActions.isVerticalView
                                        ? SizeConfig.screenWidth
                                        : SizeConfig.screenWidth! * 0.8 -
                                            (SizeConfig.screenWidth! *
                                                0.8 *
                                                0.04 *
                                                0) -
                                            1,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: SweepGradient(
                                  colors: const [
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                                  // startAngle: 1,
                                  transform: GradientRotation(
                                      gradientController!.value * 6),
                                ),
                                borderRadius: BorderRadius.circular(
                                    cardActions.isVerticalView
                                        ? 0
                                        : SizeConfig.titleSize / 3),
                              ),
                              height: SizeConfig.screenWidth! *
                                  (cardActions.isVerticalView ? 0.42 : 0.5),
                              width: cardActions.isVerticalView
                                  ? SizeConfig.screenWidth
                                  : SizeConfig.screenWidth! * 0.8 -
                                      (SizeConfig.screenWidth! *
                                          0.8 *
                                          0.04 *
                                          0),
                              padding: const EdgeInsets.all(1),
                              child: CustomPaint(
                                painter: GradientBorder(
                                    borderRadius: cardActions.isVerticalView
                                        ? 0
                                        : SizeConfig.titleSize / 3,
                                    isVerticalView: cardActions.isVerticalView,
                                    gradientController: gradientController!),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.pageHorizontalMargins,
                                      vertical:
                                          SizeConfig.pageHorizontalMargins / 2),
                                  decoration: BoxDecoration(
                                    // color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(
                                        cardActions.isVerticalView
                                            ? 0
                                            : SizeConfig.titleSize / 3),
                                  ),
                                  child: Hero(
                                    tag: "main",
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: SizeConfig.padding8),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Fello Balance",
                                                    style: GoogleFonts.rajdhani(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                      fontSize:
                                                          SizeConfig.titleSize *
                                                              0.6,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Sum of all your assets on fello",
                                                    style:
                                                        GoogleFonts.sourceSans3(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey,
                                                      fontSize:
                                                          SizeConfig.titleSize *
                                                              0.4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              cardActions.isVerticalView
                                                  ? OutlinedButton(
                                                      onPressed: () {
                                                        BaseUtil.openDialog(
                                                          isBarrierDismissible:
                                                              false,
                                                          addToScreenStack:
                                                              true,
                                                          hapticVibrate: true,
                                                          barrierColor:
                                                              Colors.black45,
                                                          content:
                                                              const FundBreakdownDialog(),
                                                        );
                                                      },
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        side: const BorderSide(
                                                            width: 1.0,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      child: Text(
                                                        "View Breakdown",
                                                        style: TextStyles
                                                            .rajdhaniM.body3
                                                            .colour(
                                                                Colors.white),
                                                      ),
                                                    )
                                                  : SvgPicture.asset(
                                                      Assets.chevRonRightArrow,
                                                      color: Colors.white,
                                                      width:
                                                          SizeConfig.padding32,
                                                    )
                                            ],
                                          ),
                                          const Spacer(),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Selector<UserService,
                                                  UserFundWallet?>(
                                                builder: (_, wallet, child) =>
                                                    Text(
                                                  "₹${(wallet?.netWorth ?? 0).toInt()}",
                                                  style:
                                                      GoogleFonts.sourceSans3(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white,
                                                    fontSize:
                                                        SizeConfig.titleSize *
                                                            1.2,
                                                  ),
                                                ),
                                                selector: (_, userService) =>
                                                    userService.userFundWallet,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .arrow_drop_up_outlined,
                                                    color: UiConstants
                                                        .primaryColor,
                                                    size: SizeConfig.titleSize,
                                                  ),
                                                  Text(
                                                    "0.05%",
                                                    style:
                                                        GoogleFonts.sourceSans3(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: UiConstants
                                                          .primaryColor,
                                                      fontSize:
                                                          SizeConfig.titleSize *
                                                              0.4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!cardActions.isVerticalView)
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedOpacity(
                  opacity: cardActions.isVerticalView ? 0 : 1,
                  curve: curve,
                  duration: duration,
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: SizeConfig.pageHorizontalMargins * 1.4),
                    child: MaterialButton(
                      minWidth: SizeConfig.screenWidth! -
                          SizeConfig.pageHorizontalMargins * 2,
                      color: Colors.white,
                      onPressed: () =>
                          BaseUtil.openDepositOptionsModalSheet(timer: 100),
                      child: Text(
                        "INVEST",
                        style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            if (!cardActions.isHorizontalView)
              Positioned(
                right: 0,
                top: SizeConfig.screenWidth! * 0.24,
                child: GestureDetector(
                  onTap: () {
                    Haptic.vibrate();
                    if (!cardActions.isHorizontalView &&
                        !cardActions.isVerticalView) {
                      cardActions.isHorizontalView = true;
                    } else if (cardActions.isVerticalView) {
                      cardActions.isVerticalView = false;
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: SizeConfig.pageHorizontalMargins,
                        bottom: SizeConfig.pageHorizontalMargins),
                    child: AnimatedRotation(
                      duration: duration,
                      curve: curve,
                      turns: cardActions.isVerticalView ? 0 : -0.25,
                      child: Lottie.asset(
                        "assets/lotties/swipe.json",
                        width: SizeConfig.titleSize * 1.6,
                        height: SizeConfig.titleSize * 1.6,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class CardContent extends StatelessWidget {
  CardContent({
    required this.isHorizontalView,
    required this.isVerticalView,
    required this.curve,
    required this.duration,
    required this.title,
    required this.subtitle,
    required this.infoTitle1,
    required this.infoTitle2,
    this.message,
    required this.asset,
    required this.secondaryColor,
    required this.onCardPressed,
    required this.onButtonPressed,
    super.key,
  });

  final bool isHorizontalView;
  final bool isVerticalView;
  final Curve curve;
  final Duration duration;
  final String title, subtitle, asset, infoTitle1, infoTitle2;
  final String? message;
  final Color secondaryColor;
  final VoidCallback onCardPressed, onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isHorizontalView || isVerticalView ? 1 : 0,
      curve: curve,
      duration: duration,
      child: Column(
        children: [
          AnimatedContainer(
            curve: curve,
            duration: duration,
            height: (SizeConfig.screenWidth! * 0.45 -
                    (SizeConfig.screenWidth! *
                        0.64 *
                        0.03 *
                        (isVerticalView
                            ? 8
                            : isHorizontalView
                                ? 0
                                : 2))) /
                2,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.titleSize / 3),
                topRight: Radius.circular(SizeConfig.titleSize / 3),
              ),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins / 2),
            child: Row(
              children: [
                if (title != "Fello Rewards")
                  SvgPicture.asset(
                    asset,
                    width: SizeConfig.padding64,
                  ),
                SizedBox(width: SizeConfig.padding8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style:
                                TextStyles.rajdhaniM.body0.colour(Colors.white),
                          ),
                          if (isVerticalView)
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: SizeConfig.iconSize2,
                                color: Colors.white,
                              ),
                            )
                        ],
                      ),
                      if (isHorizontalView)
                        FittedBox(
                          child: Text(
                            subtitle,
                            style: TextStyles.body3.colour(Colors.white54),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: SizeConfig.padding16),
                AnimatedCrossFade(
                  firstChild: MaterialButton(
                    minWidth: SizeConfig.padding40,
                    onPressed: onButtonPressed,
                    color:
                        title == "Fello Rewards" ? Colors.black : Colors.white,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        title == "Fello Rewards" ? "REDEEM" : "SAVE",
                        style: TextStyles.rajdhaniB.body2.colour(
                          title == "Fello Rewards"
                              ? Colors.white
                              : secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  secondChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.chevRonRightArrow,
                        color: Colors.white,
                        width: SizeConfig.iconSize0,
                      ),
                      SizedBox(
                        height: SizeConfig.padding12,
                      )
                    ],
                  ),
                  crossFadeState: isVerticalView
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: duration,
                ),
                SizedBox(width: SizeConfig.padding8),
              ],
            ),
          ),
          AnimatedContainer(
            curve: curve,
            duration: duration,
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding16,
                vertical: SizeConfig.padding6),
            height: (SizeConfig.screenWidth! * 0.45 -
                    (SizeConfig.screenWidth! *
                        0.64 *
                        0.03 *
                        (isVerticalView
                            ? 8
                            : isHorizontalView
                                ? 0
                                : 2))) /
                2,
            child: Row(children: [
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        infoTitle1,
                        style: TextStyles.rajdhaniSB.body3.colour(Colors.grey),
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Selector<UserService, UserFundWallet?>(
                            builder: (_, wallet, child) => Text(
                              getFirstValue(wallet, title),
                              style: TextStyles.sourceSansB.body0
                                  .colour(Colors.white),
                            ),
                            selector: (_, userService) =>
                                userService.userFundWallet,
                          ),
                          if (title != "Fello Rewards")
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.arrow_drop_up_outlined,
                                  color: UiConstants.primaryColor,
                                  size: SizeConfig.padding20,
                                ),
                                Text(
                                  "0.05%",
                                  style: GoogleFonts.sourceSans3(
                                    fontWeight: FontWeight.w500,
                                    color: UiConstants.primaryColor,
                                    fontSize: SizeConfig.body3,
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: SizeConfig.padding16),
              Expanded(
                flex: 4,
                child: Selector<UserService, UserFundWallet?>(
                  builder: (_, wallet, child) => (title == "Fello Rewards" &&
                          (wallet?.processingRedemptionBalance ?? 0) == 0)
                      ? const SizedBox()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                infoTitle2,
                                style: TextStyles.rajdhaniSB.body3
                                    .colour(Colors.grey),
                              ),
                            ),
                            SizedBox(height: SizeConfig.padding2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                getSecondValue(wallet, title),
                                style: TextStyles.sourceSansB.body0
                                    .colour(Colors.white),
                              ),
                            )
                          ],
                        ),
                  selector: (_, userService) => userService.userFundWallet,
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  String getFirstValue(UserFundWallet? wallet, String title) {
    switch (title) {
      case "Fello Flo":
        return "₹${wallet?.wLbBalance ?? 0.0}";
      case "Digital Gold":
        return "₹${wallet?.augGoldBalance ?? 0}";
      case "Fello Rewards":
        return "₹${wallet?.unclaimedBalance ?? 0}";
      default:
        return "-";
    }
  }

  String getSecondValue(UserFundWallet? wallet, String title) {
    switch (title) {
      case "Fello Flo":
        return "₹${wallet?.wLbPrinciple ?? 0.0}";
      case "Digital Gold":
        return "${wallet?.augGoldQuantity ?? 0}g";
      case "Fello Rewards":
        return "₹${wallet?.processingRedemptionBalance ?? 0}";
      default:
        return "-";
    }
  }
}

class GradientBorder extends CustomPainter {
  final AnimationController gradientController;
  final bool isVerticalView;
  final double borderRadius;

  GradientBorder(
      {required this.gradientController,
      required this.isVerticalView,
      required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final strokeWidth = 1.0;
    final gradientColors = [
      Colors.black26,
      isVerticalView ? Colors.black26 : Colors.grey,
      Colors.black26,
    ];

    // Draw the container background
    canvas.drawRect(
      rect,
      Paint()..color = Colors.transparent,
    );

    // Draw the outline border with sweep gradient
    final gradient = SweepGradient(
      colors: gradientColors,
      startAngle: 0.0,
      endAngle: pi * 2,
      transform: GradientRotation(gradientController.value * 6),
    );

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final outerPath = Path.combine(
      PathOperation.difference,
      Path()
        ..addRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(borderRadius))),
      Path()
        ..addRRect(RRect.fromRectAndRadius(
            rect.deflate(strokeWidth / 2), Radius.circular(borderRadius))),
    );

    borderPaint.shader = gradient.createShader(rect);
    canvas.drawPath(outerPath, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
