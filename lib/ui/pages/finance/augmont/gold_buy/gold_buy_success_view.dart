import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/asset_selection.dart';
import 'package:felloapp/ui/pages/finance/transaction_faqs.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_pro_card.dart';
import 'package:felloapp/ui/service_elements/user_service/user_fund_quantity_se.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class GoldBuySuccessView extends StatefulWidget {
  const GoldBuySuccessView({Key? key}) : super(key: key);

  @override
  State<GoldBuySuccessView> createState() => _GoldBuySuccessViewState();
}

class _GoldBuySuccessViewState extends State<GoldBuySuccessView> {
  final AugmontTransactionService _augTxnService =
      locator<AugmontTransactionService>();

  @override
  void initState() {
    super.initState();
    AppState.blockNavigation();
    locator<TambolaService>().getBestTambolaTickets(forced: true);
    Future.delayed(const Duration(seconds: 3), showGoldProNudgeIfEligible);
  }

  String _getButtonLabel(S locale, bool hasSuperFelloInStack) {
    if (hasSuperFelloInStack) {
      return 'Go back to Super Fello';
    }

    return PowerPlayService.powerPlayDepositFlow
        ? "Make another prediction"
        : locale.obDone;
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

    await _augTxnService.showGtIfAvailable();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);

    final superFelloIndex = AppState.delegate!.pages.indexWhere(
      (element) => element.name == FelloBadgeHomeViewPageConfig.path,
    );

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.padding32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          AppState.isRepeated = true;
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
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Lottie.network(
                        Assets.goldDepostSuccessLottie,
                        fit: BoxFit.cover,
                        height: SizeConfig.screenHeight! * .3,
                      ),
                    ),
                    if (_augTxnService.currentTxnAmount! > 0)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.screenHeight! * .1,
                            left: SizeConfig.padding60,
                            bottom: SizeConfig.padding24,
                          ),
                          child: Lottie.network(
                            Assets.floatingTokenIslandLottie,
                            width: SizeConfig.screenWidth! * 0.24,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    if (_augTxnService.currentTxnScratchCardCount > 0)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.screenHeight! * .1,
                            right: SizeConfig.padding60,
                          ),
                          child: Lottie.network(
                            Assets.floatingScratchCardIslandLottie,
                            width: SizeConfig.screenWidth! * 0.2,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    if (_augTxnService.currentTxnTambolaTicketsCount > 0)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Lottie.network(
                          Assets.floatingTambolaTicketIslandLottie,
                          width: SizeConfig.screenWidth! * 0.2,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
                Text(
                  locale.btnCongratulations,
                  style: TextStyles.rajdhaniB.title2,
                ),
                SizedBox(height: SizeConfig.padding12),
                if (_augTxnService.transactionResponseModel?.data?.txnDisplayMsg
                        ?.isNotEmpty ??
                    false)
                  SizedBox(
                    width: SizeConfig.screenWidth! * 0.8,
                    child: Text(
                      _augTxnService
                              .transactionResponseModel?.data?.txnDisplayMsg ??
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
                        Border.all(width: 0.5, color: UiConstants.kTextColor2),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(SizeConfig.roundness12),
                      topLeft: Radius.circular(SizeConfig.roundness12),
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: SizeConfig.pageHorizontalMargins,
                                top: SizeConfig.padding16,
                                bottom: SizeConfig.padding16,
                                right: SizeConfig.padding8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(locale.invested,
                                    style: TextStyles.sourceSans.body2
                                        .colour(UiConstants.kTextColor2)),
                                SizedBox(height: SizeConfig.padding16),
                                Text(
                                    "₹ ${BaseUtil.getIntOrDouble(_augTxnService.currentTxnAmount!)}",
                                    style: TextStyles.rajdhaniB.title3),
                                SizedBox(height: SizeConfig.padding12),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          width: 3,
                          thickness: 0.5,
                          color: UiConstants.kTextColor2,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: SizeConfig.pageHorizontalMargins,
                                top: SizeConfig.padding16,
                                bottom: SizeConfig.padding16,
                                right: SizeConfig.padding16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(locale.bought,
                                    style: TextStyles.sourceSans.body2
                                        .colour(UiConstants.kTextColor2)),
                                SizedBox(height: SizeConfig.padding16),
                                Text(
                                    "${_augTxnService.currentTxnGms}${locale.gm}",
                                    style: TextStyles.rajdhaniB.title4),
                                SizedBox(height: SizeConfig.padding12),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(SizeConfig.roundness12),
                      bottomRight: Radius.circular(SizeConfig.roundness12),
                    ),
                    // color: UiConstants.kModalSheetSecondaryBackgroundColor,
                    border:
                        Border.all(width: 0.5, color: UiConstants.kTextColor2),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins,
                    vertical: SizeConfig.padding12,
                  ),
                  child: Row(children: [
                    Text(
                      locale.balanceText,
                      style: TextStyles.rajdhani.body3
                          .colour(UiConstants.kTextColor3),
                    ),
                    const Spacer(),
                    UserFundQuantitySE(
                      style: TextStyles.sourceSans.body2
                          .colour(UiConstants.kTextColor),
                    )
                  ]),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.padding20,
                    right: SizeConfig.pageHorizontalMargins,
                    left: SizeConfig.pageHorizontalMargins,
                  ),
                  child: Row(
                    children: [
                      if (_augTxnService.currentTxnScratchCardCount > 0)
                        WinningChips(
                            title: _augTxnService.currentTxnScratchCardCount > 1
                                ? locale.scratchCards
                                : locale.scratchCard,
                            tooltip: locale.winChipsTitle2,
                            asset: Assets.unredemmedScratchCardBG,
                            qty: _augTxnService.currentTxnScratchCardCount),
                      if (_augTxnService.currentTxnTambolaTicketsCount > 0)
                        SizedBox(width: SizeConfig.padding12),
                      if (_augTxnService.currentTxnTambolaTicketsCount > 0)
                        WinningChips(
                            title: 'Tickets',
                            tooltip: '',
                            asset: Assets.singleTmbolaTicket,
                            qty: _augTxnService.currentTxnTambolaTicketsCount)
                    ],
                  ),
                ),
                const TransactionFAQSection(
                  faqsType: FaqsType.digitalGold,
                ),
                const AutopaySetupWidget(),
                SizedBox(
                  height: SizeConfig.padding100,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.center,
            height: SizeConfig.padding64,
            width: double.infinity,
            color: UiConstants.kBackgroundColor2,
            child: TextButton(
              onPressed: () => _onPressed(superFelloIndex != -1),
              child: Text(
                _getButtonLabel(locale, superFelloIndex != -1),
                style: TextStyles.rajdhaniSB.body0.copyWith(
                  color: UiConstants.primaryColor,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showGoldProNudgeIfEligible() {
    if ((locator<UserService>().userFundWallet?.augGoldQuantity ?? 0) >
            AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[0]
                .toDouble() &&
        locator<UserService>().userFundWallet!.wAugFdQty == 0) {
      BaseUtil.openModalBottomSheet(
        isBarrierDismissible: true,
        addToScreenStack: true,
        hapticVibrate: true,
        content: const GoldProEligibleModalSheet(),
      );
    }
  }
}

class GoldProEligibleModalSheet extends StatelessWidget {
  const GoldProEligibleModalSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Transform.scale(
        scale: 1.02,
        child: Container(
          height: SizeConfig.screenWidth! * 0.8,
          decoration: BoxDecoration(
            border: Border.all(
              color: UiConstants.KGoldProPrimaryDark,
              width: 2,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.roundness24),
              topRight: Radius.circular(SizeConfig.roundness24),
            ),
            color: UiConstants.kGoldProBgColor,
          ),
          child: Stack(
            children: [
              const Opacity(
                opacity: 0.5,
                child: GoldShimmerWidget(size: ShimmerSizeEnum.large),
              ),
              Container(
                width: SizeConfig.screenWidth,
                margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: SizeConfig.padding8),
                    Text(
                      "You are eligible for",
                      style: TextStyles.rajdhaniM.body2.colour(Colors.white),
                    ),
                    SizedBox(height: SizeConfig.padding8),
                    Text(
                      "${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% Extra Returns every year with Gold Pro",
                      style: TextStyles.rajdhaniM.title3
                          .colour(UiConstants.kGoldProPrimary),
                      textAlign: TextAlign.center,
                    ),
                    // SizedBox(height: SizeConfig.padding14),
                    Expanded(
                      child: Transform.scale(
                        scale: 1.6,
                        child: SvgPicture.asset(
                          Assets.goldAsset,
                        ),
                      ),
                    ),
                    // SizedBox(height: SizeConfig.padding14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: MaterialButton(
                            height: SizeConfig.padding44,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1.5, color: Colors.white),
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness5),
                            ),
                            child: Text(
                              "KNOW MORE",
                              style: TextStyles.rajdhaniB.body1
                                  .colour(Colors.white),
                            ),
                            onPressed: () {
                              AppState.isRepeated = true;
                              AppState.unblockNavigation();
                              AppState.backButtonDispatcher!.didPopRoute();
                              AppState.backButtonDispatcher!.didPopRoute();
                              AppState.delegate!
                                  .parseRoute(Uri.parse('goldProDetails'));
                              locator<AnalyticsService>().track(
                                eventName: AnalyticsEvents
                                    .paymentSuccessGoldProUpsellCardTapped,
                                properties: {
                                  'cta tapped': "KNOW MORE",
                                  'current Gold Balance': locator<UserService>()
                                          .userFundWallet
                                          ?.augGoldQuantity ??
                                      0
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(width: SizeConfig.padding12),
                        Expanded(
                          flex: 6,
                          child: Stack(
                            children: [
                              MaterialButton(
                                minWidth: SizeConfig.padding156,
                                color: Colors.white,
                                height: SizeConfig.padding44,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness5),
                                ),
                                child: Text(
                                  "SWITCH TO GOLD PRO",
                                  style: TextStyles.rajdhaniB.body1
                                      .colour(Colors.black),
                                ),
                                onPressed: () {
                                  AppState.isRepeated = true;
                                  AppState.unblockNavigation();
                                  AppState.backButtonDispatcher!.didPopRoute();
                                  AppState.backButtonDispatcher!.didPopRoute();
                                  BaseUtil().openGoldProBuyView(
                                      location: "Payment Success Upsell");
                                  locator<AnalyticsService>().track(
                                    eventName: AnalyticsEvents
                                        .paymentSuccessGoldProUpsellCardTapped,
                                    properties: {
                                      'cta tapped': "SWITCH TO GOLD PRO",
                                      'current Gold Balance':
                                          locator<UserService>()
                                                  .userFundWallet
                                                  ?.augGoldQuantity ??
                                              0
                                    },
                                  );
                                },
                              ),
                              Transform.translate(
                                offset: Offset(0, -SizeConfig.padding12),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: SizeConfig.padding16,
                                    ),
                                    width: SizeConfig.screenWidth! * 0.39,
                                    child: AvailabilityOfferWidget(
                                        color: UiConstants.kBlogTitleColor,
                                        text:
                                            "*${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% Extra Returns*"),
                                  ),
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
            ],
          ),
        ),
      ),
      onWillPop: () async {
        AppState.removeOverlay();
        return Future.value(true);
      },
    );
  }
}

class WinningChips extends StatelessWidget {
  final String title;
  final String asset;
  final int qty;
  final String tooltip;
  final EdgeInsets? margin;
  final Color? color;
  final Widget? widget;

  const WinningChips(
      {required this.title,
      required this.asset,
      required this.qty,
      required this.tooltip,
      Key? key,
      this.widget,
      this.color,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) => Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          message: tooltip,
          child: Container(
            // height: SizeConfig.padding80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              color: color ?? UiConstants.darkPrimaryColor2,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
              vertical: SizeConfig.padding12,
            ),
            margin: margin ?? EdgeInsets.zero,
            child: constraints.maxWidth < SizeConfig.screenWidth! / 3
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyles.sourceSans.body4),
                      SizedBox(height: SizeConfig.padding6),
                      Row(
                        children: [
                          widget ??
                              SvgPicture.asset(
                                asset,
                                width: SizeConfig.padding20,
                                height: SizeConfig.padding20,
                              ),
                          SizedBox(
                            width: SizeConfig.padding6,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: SizeConfig.screenWidth! * 0.08),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(qty.toString(),
                                  style: TextStyles.rajdhaniB.title3),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Expanded(
                          child:
                              Text(title, style: TextStyles.sourceSans.body4),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: SizeConfig.padding12,
                            ),
                            SvgPicture.asset(
                              asset,
                              width: SizeConfig.padding20,
                              height: SizeConfig.padding20,
                            ),
                            SizedBox(
                              width: SizeConfig.padding6,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: SizeConfig.screenWidth! * 0.09),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(qty.toString(),
                                    style: TextStyles.rajdhaniB.title3),
                              ),
                            ),
                          ],
                        )
                      ]),
          ),
        ),
      ),
    );
  }
}

class AutopaySetupWidget extends StatelessWidget {
  const AutopaySetupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SubService, AllSubscriptionModel?>(
        selector: (_, subService) => subService.subscriptionData,
        builder: (context, subState, child) {
          if (subState != null) return Container();
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            padding: EdgeInsets.all(SizeConfig.padding12),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 0.5,
                    color: const Color(0xff627F8E).withOpacity(0.4)),
                borderRadius: BorderRadius.circular(SizeConfig.roundness12)),
            child: Row(
              children: [
                Text(
                  'Want to save a hassle\nfree automated way?',
                  style: TextStyles.sourceSans.body3
                      .colour(Colors.white.withOpacity(0.5)),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // locator<SubService>().handleTap();
                  },
                  child: Text(
                    "Setup Autopay".toUpperCase(),
                    style: TextStyles.rajdhaniSB.body0.colour(Colors.white),
                  ),
                )
              ],
            ),
          );
        });
  }
}
