import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
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

  @override
  Widget build(BuildContext context) {
    S locale = locator<S>();
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.pageHorizontalMargins),
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
                      top: SizeConfig.pageHorizontalMargins),
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: UiConstants.kGoldProBorder),
                    borderRadius: BorderRadius.all(
                      Radius.circular(SizeConfig.roundness12),
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: SizeConfig.padding14),
                              Text("Leased Amount",
                                  style: TextStyles.sourceSans.body2
                                      .colour(UiConstants.kTextColor2)),
                              SizedBox(height: SizeConfig.padding12),
                              Text(
                                  "₹ ${BaseUtil.getIntOrDouble(widget.txnService.currentGoldPurchaseDetails.goldBuyAmount!)}",
                                  style: TextStyles.rajdhaniSB.title3
                                      .colour(UiConstants.kGoldProPrimary)),
                              SizedBox(height: SizeConfig.padding14),
                            ],
                          ),
                        ),
                        VerticalDivider(
                          width: 3,
                          thickness: 1,
                          color: UiConstants.kGoldProBorder,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(locale.bought,
                                  style: TextStyles.sourceSans.body2
                                      .colour(UiConstants.kTextColor2)),
                              SizedBox(height: SizeConfig.padding12),
                              Text(
                                  "${BaseUtil.digitPrecision(widget.txnService.currentTxnGms!, 2, false)} gms",
                                  style: TextStyles.rajdhaniSB.title3),
                            ],
                          ),
                        )
                      ],
                    ),
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
                      WinningChips(
                          title: locale.felloTokens,
                          tooltip: locale.winChipsTitle1,
                          asset: Assets.token,
                          qty: widget.txnService.currentTxnAmount!.toInt()),
                      // if (widget.txnService.currentTxnScratchCardCount > 0)
                      SizedBox(width: SizeConfig.padding12),
                      // if (widget.txnService.currentTxnScratchCardCount > 0)
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
                const AutopaySetupWidget(),
                Spacer(),
                TextButton(
                  onPressed: () {
                    AppState.isRepeated = true;
                    AppState.unblockNavigation();
                    AppState.backButtonDispatcher!.didPopRoute();
                    AppState.delegate!.appState.setCurrentTabIndex =
                        DynamicUiUtils.navBar
                            .indexWhere((element) => element == 'SV');

                    locator<TambolaService>().getBestTambolaTickets();

                    widget.txnService.showGtIfAvailable();
                  },
                  child: Text(
                    locale.obDone,
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
