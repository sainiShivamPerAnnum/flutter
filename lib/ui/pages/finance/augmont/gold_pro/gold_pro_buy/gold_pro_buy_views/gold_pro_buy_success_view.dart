import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/fello_rich_text.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/gold_buy_success_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GoldProBuySuccessView extends StatefulWidget {
  const GoldProBuySuccessView(
      {required this.model, required this.txnService, super.key});

  final GoldProBuyViewModel model;
  final AugmontTransactionService txnService;

  @override
  State<GoldProBuySuccessView> createState() => _GoldProBuySuccessViewState();
}

class _GoldProBuySuccessViewState extends State<GoldProBuySuccessView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _showLottie = true;

  @override
  void initState() {
    super.initState();
    AppState.isGoldProBuyInProgress = false;
    _animationController = AnimationController(vsync: this);
    _playLottieAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _playLottieAnimation() async {
    await Future.delayed(const Duration(seconds: 4));
  }

  String _getButtonLabel(S locale, bool hasSuperFelloInStack) {
    if (hasSuperFelloInStack) {
      return 'Go back to Super Fello';
    }

    return locale.obDone;
  }

  Future<void> _onPressed(bool hasSuperFelloInStack) async {
    AppState.isRepeated = true;
    AppState.unblockNavigation();

    if (hasSuperFelloInStack) {
      while (AppState.delegate!.pages.last.name !=
          FelloBadgeHomeViewPageConfig.path) {
        await AppState.backButtonDispatcher!.didPopRoute();
      }

      await AppState.backButtonDispatcher!
          .didPopRoute(); // remove super fello page.

      await Future.delayed(const Duration(milliseconds: 100));

      AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addPage,
        page: FelloBadgeHomeViewPageConfig,
      );
    }

    await AppState.backButtonDispatcher!.didPopRoute();
    AppState.delegate!.appState.setCurrentTabIndex =
        DynamicUiUtils.navBar.indexWhere((element) => element == 'SV');

    await locator<TambolaService>().getBestTambolaTickets();

    await widget.txnService.showGtIfAvailable();

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.doneTappedOnGoldProSuccess,
      properties: {
        "grams of gold leased": "${BaseUtil.digitPrecision(
          widget.txnService.currentGoldPurchaseDetails.leaseQty!,
          2,
          false,
        )} gms",
        "Amount leased":
            "₹ ${BaseUtil.getIntOrDouble(widget.txnService.currentGoldPurchaseDetails.goldBuyAmount!)}"
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    S locale = locator<S>();
    final leaseText = widget.model.leaseModel?.subText;
    final responseText =
        widget.txnService.transactionResponseModel?.data?.subText;
    final subText = leaseText ?? responseText;

    final superFelloIndex = AppState.delegate!.pages.indexWhere(
      (element) => element.name == FelloBadgeHomeViewPageConfig.path,
    );

    return Container(
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.pageHorizontalMargins,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.4,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Lottie.network(
                          Assets.goldDepostSuccessLottie,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (widget.txnService.currentTxnAmount! > 0)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: SizeConfig.padding12,
                                bottom: SizeConfig.padding24),
                            child: Lottie.network(
                              Assets.floatingTokenIslandLottie,
                              width: SizeConfig.screenWidth! * 0.3,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (widget.txnService.currentTxnScratchCardCount > 0)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(
                              right: SizeConfig.padding12,
                              top: SizeConfig.padding24,
                            ),
                            child: Lottie.network(
                              Assets.floatingScratchCardIslandLottie,
                              width: SizeConfig.screenWidth! * 0.3,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (widget.txnService.currentTxnTambolaTicketsCount > 0)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            child: Lottie.network(
                              Assets.floatingTambolaTicketIslandLottie,
                              width: SizeConfig.screenWidth! * 0.3,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  locale.btnCongratulations,
                  style: TextStyles.rajdhaniB.title2,
                ),
                SizedBox(height: SizeConfig.padding12),
                if (widget.txnService.transactionResponseModel?.data
                        ?.txnDisplayMsg?.isNotEmpty ??
                    false)
                  SizedBox(
                    width: SizeConfig.screenWidth! * 0.8,
                    child: Text(
                      widget.txnService.transactionResponseModel?.data
                              ?.txnDisplayMsg ??
                          "",
                      textAlign: TextAlign.center,
                      style: TextStyles.sourceSans.body2.setOpacity(0.7),
                    ),
                  )
                else ...[
                  Text(
                    locale.txnInvestmentSuccess,
                    textAlign: TextAlign.center,
                    style: TextStyles.sourceSans.body2.setOpacity(0.7),
                  ),
                ],
                Container(
                  margin: EdgeInsets.only(
                    left: SizeConfig.pageHorizontalMargins,
                    right: SizeConfig.pageHorizontalMargins,
                    top: SizeConfig.pageHorizontalMargins,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: UiConstants.kGoldProBorder,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(SizeConfig.roundness12),
                    ),
                    color: UiConstants.kGoldProPrimary,
                  ),
                  child: Column(
                    children: [
                      if (subText != null &&
                          subText.isNotEmpty &&
                          !widget.model.isGoldProUser)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: FelloRichText(
                            paragraph: subText,
                            style: TextStyles.sourceSansSB.body4.copyWith(
                              color: Colors.black,
                              height: 1.5,
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: UiConstants.kGoldProBorder),
                          borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.roundness12),
                          ),
                          color: Colors.black,
                        ),
                        child: widget.txnService.currentTxnAmount == 0
                            ? Padding(
                                padding: EdgeInsets.all(
                                    SizeConfig.pageHorizontalMargins),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Gold Leased",
                                        style: TextStyles.sourceSans.body2
                                            .colour(
                                                UiConstants.kGoldProPrimary)),
                                    Text(
                                        "${BaseUtil.digitPrecision(
                                          widget
                                              .txnService
                                              .currentGoldPurchaseDetails
                                              .goldInGrams,
                                          2,
                                          false,
                                        )} gms",
                                        style: TextStyles.rajdhaniSB.title3
                                            .colour(
                                                UiConstants.kGoldProPrimary)),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: SizeConfig.padding14),
                                              Text("Leased grams",
                                                  style: TextStyles
                                                      .sourceSans.body2
                                                      .colour(UiConstants
                                                          .kTextColor2)),
                                              SizedBox(
                                                  height: SizeConfig.padding12),
                                              Text(
                                                  "${BaseUtil.digitPrecision(
                                                    widget
                                                            .txnService
                                                            .currentGoldPurchaseDetails
                                                            .leaseQty ??
                                                        0,
                                                    2,
                                                    false,
                                                  )} gms",
                                                  style: TextStyles
                                                      .rajdhaniSB.title3
                                                      .colour(UiConstants
                                                          .kGoldProPrimary)),
                                              SizedBox(
                                                  height: SizeConfig.padding14),
                                            ],
                                          ),
                                        ),
                                        VerticalDivider(
                                          indent: 10,
                                          endIndent: 10,
                                          width: 3,
                                          thickness: 1,
                                          color: UiConstants.kGoldProPrimary
                                              .withOpacity(.4),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Gold Bought",
                                                  style: TextStyles
                                                      .sourceSans.body2
                                                      .colour(UiConstants
                                                          .kTextColor2)),
                                              SizedBox(
                                                  height: SizeConfig.padding12),
                                              Text(
                                                  "${BaseUtil.digitPrecision(
                                                    widget
                                                        .txnService
                                                        .currentGoldPurchaseDetails
                                                        .goldInGrams,
                                                    4,
                                                    false,
                                                  )} gms",
                                                  style: TextStyles
                                                      .rajdhaniSB.title3),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: UiConstants.kGoldProBorder,
                                    height: 1,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.pageHorizontalMargins,
                                      vertical: SizeConfig.padding12,
                                    ),
                                    child: Row(children: [
                                      Text(
                                        "Extra Gold Bought Amount:",
                                        style: TextStyles.rajdhani.body3
                                            .colour(UiConstants.kTextColor3),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "₹ ${BaseUtil.getIntOrDouble(widget.txnService.currentGoldPurchaseDetails.goldBuyAmount!)}",
                                        style: TextStyles.sourceSans.body2
                                            .colour(UiConstants.kTextColor),
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: SizeConfig.padding20,
                      bottom: SizeConfig.padding20,
                      right: SizeConfig.pageHorizontalMargins,
                      left: SizeConfig.pageHorizontalMargins),
                  child: Row(
                    children: [
                      if (widget.txnService.currentTxnScratchCardCount > 0)
                        WinningChips(
                            title:
                                widget.txnService.currentTxnScratchCardCount > 1
                                    ? locale.scratchCards
                                    : locale.scratchCard,
                            tooltip: locale.winChipsTitle2,
                            asset: Assets.unredemmedScratchCardBG,
                            qty: widget.txnService.currentTxnScratchCardCount),
                      if (widget.txnService.currentTxnTambolaTicketsCount > 0)
                        SizedBox(width: SizeConfig.padding12),
                      if (widget.txnService.currentTxnTambolaTicketsCount > 0)
                        WinningChips(
                            title: 'Tickets',
                            tooltip: '',
                            asset: Assets.singleTmbolaTicket,
                            qty:
                                widget.txnService.currentTxnTambolaTicketsCount)
                    ],
                  ),
                ),
                if (!(subText != null && subText.isNotEmpty))
                  const AutopaySetupWidget(),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                TextButton(
                  onPressed: () => _onPressed(superFelloIndex != -1),
                  child: Text(
                    _getButtonLabel(locale, superFelloIndex != -1),
                    style: TextStyles.rajdhaniSB.body0
                        .colour(UiConstants.primaryColor),
                  ),
                )
              ],
            ),
          ),
          if (_showLottie)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Lottie.asset(
                  'assets/lotties/whataFello_lottie.json',
                  controller: _animationController,
                  onLoaded: (composition) {
                    _animationController
                      ..duration = composition.duration
                      ..forward().whenComplete(() {
                        if (mounted) {
                          setState(() {
                            _showLottie = false;
                            AppState.unblockNavigation();
                          });
                        }
                      });
                  },
                ),
              ),
            ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    AppState.unblockNavigation();
                    AppState.backButtonDispatcher!.didPopRoute();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
