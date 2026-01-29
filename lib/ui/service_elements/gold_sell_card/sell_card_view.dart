import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/modalsheets/gold_sell_reason_modal_sheet.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_components.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

extension InvestmentTypeX on InvestmentType {
  bool get isGold => this == InvestmentType.AUGGOLD99;
  bool get isSilver => this == InvestmentType.AUGSILVD999;
  bool get isFlo => this == InvestmentType.LENDBOXP2P;

  /// Action button text
  String get actionText => isFlo ? "WITHDRAW" : "SELL";

  /// Sell Card Background Colors
  Color get sellCardColor {
    if (isGold) return UiConstants.goldSellCardColor;
    if (isSilver) return const Color.fromARGB(255, 7, 50, 71);
    return UiConstants.kFloContainerColor;
  }

  /// Does this require KYC before selling?
  bool get requiresKyc => isGold || isSilver;

  /// Does this require Bank Account before selling?
  bool get requiresBank => isGold || isSilver;

  /// For displaying title on Sell UI
  String get displayName {
    if (isGold) return "Gold";
    if (isSilver) return "Silver";
    return "Fello Flo";
  }
}
class SellCardView extends StatelessWidget {
  final InvestmentType investmentType;

  const SellCardView({required this.investmentType, super.key});

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);

    return PropertyChangeProvider<BankAndPanService,
        BankAndPanServiceProperties>(
      value: locator<BankAndPanService>(),
      child: PropertyChangeConsumer<BankAndPanService,
          BankAndPanServiceProperties>(
        properties: const [
          BankAndPanServiceProperties.reachedLockIn,
          BankAndPanServiceProperties.augmontSellDisabled,
          BankAndPanServiceProperties.bankDetailsVerified,
          BankAndPanServiceProperties.kycVerified,
          BankAndPanServiceProperties.ongoing,
        ],
        builder: (ctx, sellService, child) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
              color: investmentType.sellCardColor,
            ),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.padding24),

                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SellText(investmentType: investmentType),
                      SellButton(
                        key: const ValueKey('sellButton'),
                        text: investmentType.actionText,
                        onTap: () {
                          BaseUtil.openModalBottomSheet(
                            backgroundColor:
                                UiConstants.kModalSheetBackgroundColor,
                            isBarrierDismissible: true,
                            addToScreenStack: true,
                            borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(SizeConfig.roundness32),
                              topRight:
                                  Radius.circular(SizeConfig.roundness32),
                            ),
                            content: SellingReasonBottomSheet(
                              investmentType: investmentType,
                            ),
                          );
                        },
                        isActive: sellService!.getButtonAvailibility(),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: SizeConfig.padding10),

                // Show KYC & Bank Pending Text
                if (investmentType.requiresKyc && investmentType.requiresBank)
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.padding24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: sellService.isKYCVerified &&
                              sellService.isBankDetailsAdded
                          ? const SizedBox()
                          : Text(
                              "To withdraw, complete the following steps:",
                              style: TextStyles.sourceSans.body4.colour(
                                Colors.white,
                              ),
                            ),
                    ),
                  ),

                SizedBox(height: SizeConfig.padding12),

                // KYC Button
                if (investmentType.requiresKyc &&
                    (!sellService.isKYCVerified ||
                        sellService.userKycData == null))
                  SellActionButton(
                    key: const ValueKey('kycPending'),
                    title: locale.completeKYCText,
                    onTap: navigateToKycScreen,
                  ),

                // Bank Details Button
                if (investmentType.requiresBank &&
                    (!sellService.isBankDetailsAdded ||
                        sellService.activeBankAccountDetails == null))
                  SellActionButton(
                    key: const ValueKey('bankDetailsPending'),
                    title: locale.addBankDetails,
                    onTap: navigateToBankDetailsScreen,
                  ),

                SizedBox(height: SizeConfig.padding24),
              ],
            ),
          );
        },
      ),
    );
  }

    void navigateToKycScreen() {
    final analyticsService = locator<AnalyticsService>();

    analyticsService
        .track(eventName: AnalyticsEvents.completeKYCTapped, properties: {
      "location": "Felo/Gold Sell card",
      "Total invested amount": AnalyticsProperties.getGoldInvestedAmount() +
          AnalyticsProperties.getFelloFloAmount(),
      "Amount invested in gold": AnalyticsProperties.getGoldInvestedAmount(),
      "Grams of gold owned": AnalyticsProperties.getGoldQuantityInGrams(),
      "Amount invested in Flo": AnalyticsProperties.getFelloFloAmount(),
    });
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: KycDetailsPageConfig,
    );
  }


  void navigateToBankDetailsScreen() {
    final analyticsService = locator<AnalyticsService>();
    analyticsService.track(eventName: AnalyticsEvents.bankDetailsTapped);
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: BankDetailsPageConfig,
    );
  }
}
