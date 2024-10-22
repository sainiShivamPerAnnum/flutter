import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/feature/p2p_home/home/ui/p2p_home_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/fund_breakdown_dialog.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/asset_view_section.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class FelloBalanceScreen extends StatelessWidget {
  FelloBalanceScreen({super.key});
  final _analyticsService = locator<AnalyticsService>();
  void onRedeemPressed() {
    final referralService = locator<ReferralService>();
    final currentWinnings =
        locator<UserService>().userFundWallet?.unclaimedBalance ?? 0.0;
    if (currentWinnings >= (referralService.minWithdrawPrizeAmt ?? 200)) {
      referralService.showConfirmDialog(PrizeClaimChoice.GOLD_CREDIT);
    } else {
      BaseUtil.showNegativeAlert(
        "Not enough winnings",
        "Winnings can only be redeemed after reaching ₹${referralService.minWithdrawPrizeAmt}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      showBackgroundGrid: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Fello Balance',
          style: TextStyles.rajdhaniSB.body1.colour(UiConstants.kTextColor),
        ),
        centerTitle: true,
        leading: const BackButton(
          color: UiConstants.kTextColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Fello Balance",
                    style: TextStyles.sourceSansSB.body2,
                  ),
                  TextButton(
                    onPressed: () {
                      BaseUtil.openDialog(
                        isBarrierDismissible: false,
                        addToScreenStack: true,
                        hapticVibrate: true,
                        barrierColor: Colors.black45,
                        content: const FundBreakdownDialog(),
                      );
                      _analyticsService.track(
                        eventName: AnalyticsEvents.viewBreakdownTapped,
                        properties: {
                          "fello balance": locator<UserService>()
                              .userPortfolio
                              .absolute
                              .balance,
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding10,
                        vertical: SizeConfig.padding6,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeConfig.roundness5),
                        ),
                      ),
                    ),
                    child: Text(
                      "View Breakdown",
                      style: TextStyles.sourceSansSB.body4
                          .colour(UiConstants.kTextColor4),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.padding6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
              child: Row(
                children: [
                  Selector<UserService, Portfolio>(
                    builder: (_, portfolio, child) => Text(
                      "₹${getTotalBalance(portfolio)}",
                      style: TextStyles.sourceSansSB.title3.colour(
                        UiConstants.kTextColor,
                      ),
                    ),
                    selector: (_, userService) => userService.userPortfolio,
                  ),
                  SizedBox(width: SizeConfig.padding8),
                  Selector<UserService, Portfolio>(
                    builder: (context, value, child) => Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Transform.translate(
                              offset: Offset(
                                0,
                                -SizeConfig.padding4,
                              ),
                              child: RotatedBox(
                                quarterTurns:
                                    value.absolute.percGains < 0 ? 2 : 0,
                                child: AppImage(
                                  Assets.arrow,
                                  width: SizeConfig.body3,
                                  color: value.absolute.percGains < 0
                                      ? Colors.red
                                      : UiConstants.primaryColor,
                                ),
                              ),
                            ),
                            Text(
                              " ${BaseUtil.digitPrecision(value.absolute.percGains, 2, false)}%",
                              style: TextStyles.sourceSansSB.body3.colour(
                                value.absolute.percGains < 0
                                    ? Colors.red
                                    : UiConstants.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    selector: (p0, p1) => p1.userPortfolio,
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.padding20),
            buildInvestmentSection(
              iconData: Assets.floAsset,
              title: "Fello Flo",
              asset: Assets.floAsset,
              infoTitle1: "Flo Balance",
              infoTitle2: "Invested",
              secondaryColor: UiConstants.darkPrimaryColor3,
              subtitle: "P2P Asset • upto 11% Returns",
              onButtonPressed: () {
                BaseUtil().openRechargeModalSheet(
                  investmentType: InvestmentType.LENDBOXP2P,
                );
                trackSaveButtonAnalytics(
                  InvestmentType.LENDBOXP2P,
                );
              },
              onCardPressed: () => navigateToSaveAssetView(
                InvestmentType.LENDBOXP2P,
              ),
            ),
            buildInvestmentSection(
              iconData: Assets.goldAsset,
              title: "Digital Gold",
              asset: Assets.goldAsset,
              infoTitle1: "Gold Amount",
              infoTitle2: "Gold Value",
              secondaryColor: UiConstants.kGoldContainerColor,
              subtitle: "100% Safe • 99.99% Pure",
              onButtonPressed: () {
                BaseUtil().openRechargeModalSheet(
                  investmentType: InvestmentType.AUGGOLD99,
                );
                trackSaveButtonAnalytics(
                  InvestmentType.AUGGOLD99,
                );
              },
              onCardPressed: () => navigateToSaveAssetView(
                InvestmentType.AUGGOLD99,
              ),
            ),
            buildInvestmentSection(
              iconData: null,
              asset: Assets.dailyAppBonusHero,
              title: "Fello Rewards",
              infoTitle1: "Reward Balance",
              infoTitle2: "Processing Balance",
              secondaryColor: UiConstants.kRewardColor,
              subtitle: getRewardSubText(),
              onButtonPressed: onRedeemPressed,
              onCardPressed: () {
                AppState.delegate!.parseRoute(
                  Uri.parse("/myWinnings"),
                );
              },
            ),
            const Divider(
              color: UiConstants.kDividerColorLight,
            ),
          ],
        ),
      ),
    );
  }

  void navigateToSaveAssetView(
    InvestmentType investmentType,
  ) {
    Haptic.vibrate();

    if (investmentType == InvestmentType.AUGGOLD99) {
      _analyticsService.track(
        eventName: AnalyticsEvents.assetBannerTapped,
        properties: AnalyticsProperties.getDefaultPropertiesMap(
          extraValuesMap: {
            'Asset': 'Gold',
            "Failed transaction count": AnalyticsProperties.getFailedTxnCount(),
            "Successs transaction count":
                AnalyticsProperties.getSucessTxnCount(),
            "Pending transaction count":
                AnalyticsProperties.getPendingTxnCount(),
          },
        ),
      );

      AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: SaveAssetsViewConfig,
        widget: AssetSectionView(
          type: investmentType,
        ),
      );
    } else {
      _analyticsService.track(
        eventName: AnalyticsEvents.assetBannerTapped,
        properties: AnalyticsProperties.getDefaultPropertiesMap(
          extraValuesMap: {
            'Asset': 'Flo',
            "Failed transaction count": AnalyticsProperties.getFailedTxnCount(),
            "Successs transaction count":
                AnalyticsProperties.getSucessTxnCount(),
            "Pending transaction count":
                AnalyticsProperties.getPendingTxnCount(),
          },
        ),
      );

      AppState.delegate!.appState.currentAction = PageAction(
        page: P2PHomePageConfig,
        widget: const P2PHomePage(),
        state: PageState.addWidget,
      );
    }
  }

  void trackSaveButtonAnalytics(InvestmentType type) {
    _analyticsService.track(
      eventName: AnalyticsEvents.saveOnAssetBannerTapped,
      properties: {
        'Asset': type == InvestmentType.AUGGOLD99 ? "Gold" : 'Flo',
      },
    );
  }

  int getTotalBalance(Portfolio portfolio) {
    if (portfolio.absolute.balance != 0) {
      return portfolio.absolute.balance.toInt();
    } else {
      String stringBalance =
          PreferenceHelper.getString(Constants.FELLO_BALANCE);

      double doubleBalance = double.tryParse(stringBalance) ?? 0.0;
      int intBalance = doubleBalance.toInt();
      return intBalance;
    }
  }

  String getRewardSubText() {
    final referralService = locator<ReferralService>();
    final userService = locator<UserService>();
    final currentWinnings = userService.userFundWallet?.unclaimedBalance ?? 0.0;

    if (userService.userFundWallet?.processingRedemptionBalance != null &&
        (userService.userFundWallet?.processingRedemptionBalance ?? 0) > 0) {
      return "Processing ₹${userService.userFundWallet?.processingRedemptionBalance} to Digital Gold...";
    }

    if (currentWinnings >= (referralService.minWithdrawPrizeAmt ?? 200)) {
      return "You can redeem rewards to Digital Gold";
    } else {
      return "Rewards can be redeemed after ₹${referralService.minWithdrawPrizeAmt ?? 200}";
    }
  }

  Widget buildInvestmentSection({
    required String? iconData,
    required String title,
    required String subtitle,
    required String asset,
    required String infoTitle1,
    required String infoTitle2,
    required Color secondaryColor,
    required VoidCallback onCardPressed,
    required VoidCallback onButtonPressed,
    String? message,
  }) {
    bool isRewardButtonEnabled =
        (locator<UserService>().userFundWallet?.unclaimedBalance.toInt() ??
                0) >=
            (locator<ReferralService>().minWithdrawPrizeAmt ?? 200);
    return Column(
      children: [
        const Divider(
          color: UiConstants.kDividerColorLight,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding16,
            horizontal: SizeConfig.padding24,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (iconData != null)
                        AppImage(
                          iconData,
                          height: SizeConfig.padding30,
                          fit: BoxFit.fill,
                        ),
                      if (iconData != null)
                        SizedBox(width: SizeConfig.padding10),
                      Text(
                        title,
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: onButtonPressed,
                    style: TextButton.styleFrom(
                      backgroundColor:
                          title == "Fello Rewards" && !isRewardButtonEnabled
                              ? Colors.white.withOpacity(0.5)
                              : Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding32,
                        vertical: SizeConfig.padding6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeConfig.roundness5),
                        ),
                      ),
                    ),
                    child: Text(
                      title == "Fello Rewards" ? "Redeem" : "Invest",
                      style: TextStyles.sourceSansSB.body4
                          .colour(UiConstants.kTextColor4),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.padding14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        infoTitle1,
                        style: TextStyles.sourceSansSB.body2
                            .colour(UiConstants.kTextColor.withOpacity(.7)),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Selector<UserService,
                                Tuple2<Portfolio, UserFundWallet?>>(
                              builder: (_, value, child) => Text(
                                getFirstValue(value.item1, value.item2, title),
                                style: TextStyles.sourceSansB.body0
                                    .colour(Colors.white),
                              ),
                              selector: (_, userService) => Tuple2(
                                userService.userPortfolio,
                                userService.userFundWallet,
                              ),
                            ),
                            if (title != "Fello Rewards")
                              Column(
                                children: [
                                  Selector<UserService, Portfolio>(
                                    builder: (context, value, child) => Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(width: SizeConfig.padding6),
                                        Transform.translate(
                                          offset:
                                              Offset(0, -SizeConfig.padding6),
                                          child: RotatedBox(
                                            quarterTurns:
                                                getPercValue(value, title) >= 0
                                                    ? 0
                                                    : 2,
                                            child: AppImage(
                                              Assets.arrow,
                                              width: SizeConfig.iconSize3,
                                              color:
                                                  getPercValue(value, title) >=
                                                          0
                                                      ? UiConstants.primaryColor
                                                      : Colors.red,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          " ${BaseUtil.digitPrecision(
                                            getPercValue(value, title),
                                            2,
                                            false,
                                          )}%",
                                          style: TextStyles.sourceSans.body3
                                              .colour(
                                            getPercValue(
                                                      value,
                                                      title,
                                                    ) >=
                                                    0
                                                ? UiConstants.primaryColor
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    selector: (p0, p1) => p1.userPortfolio,
                                  ),
                                  SizedBox(height: SizeConfig.padding2),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Selector<UserService, Tuple2<Portfolio, UserFundWallet?>>(
                    builder: (_, value, child) {
                      return (title == "Fello Rewards" &&
                              (value.item2?.processingRedemptionBalance ?? 0) ==
                                  0)
                          ? const SizedBox.shrink()
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
                                    getSecondValue(
                                      value.item1,
                                      value.item2,
                                      title,
                                    ),
                                    style: TextStyles.sourceSansB.body0
                                        .colour(Colors.white),
                                  ),
                                ),
                              ],
                            );
                    },
                    selector: (_, userService) => Tuple2(
                      userService.userPortfolio,
                      userService.userFundWallet,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getSecondValue(
    Portfolio? portfolio,
    UserFundWallet? wallet,
    String title,
  ) {
    switch (title) {
      case "Fello Flo":
        return "₹${BaseUtil.digitPrecision(portfolio?.flo.principle ?? 0.0, 2)}";
      case "Digital Gold":
        return "${BaseUtil.digitPrecision(wallet?.wAugTotal ?? 0, 4, false)}g";
      case "Fello Rewards":
        return "₹${wallet?.processingRedemptionBalance ?? 0}";
      default:
        return "-";
    }
  }

  String getFirstValue(
    Portfolio? portfolio,
    UserFundWallet? wallet,
    String title,
  ) {
    switch (title) {
      case "Fello Flo":
        return "₹${BaseUtil.digitPrecision(portfolio?.flo.balance ?? 0.0, 2)}";
      case "Digital Gold":
        return "₹${BaseUtil.digitPrecision(portfolio?.augmont.balance ?? 0, 2)}";
      case "Fello Rewards":
        return "₹${wallet?.unclaimedBalance ?? 0}";
      default:
        return "-";
    }
  }

  num getPercValue(Portfolio? portfolio, String title) {
    switch (title) {
      case "Fello Flo":
        return portfolio?.flo.percGain ?? 0.0;
      case "Digital Gold":
        return portfolio?.augmont.gold.percGains ?? 0.0;
      case "Fello Rewards":
        return 0.0;
      default:
        return 0.0;
    }
  }
}
