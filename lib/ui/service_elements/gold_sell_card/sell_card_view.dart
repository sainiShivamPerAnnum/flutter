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

class SellCardView extends StatelessWidget {
  final InvestmentType investmentType;

  const SellCardView({required this.investmentType, Key? key})
      : super(key: key);

  Color get color => investmentType == InvestmentType.AUGGOLD99
      ? UiConstants.goldSellCardColor
      : UiConstants.kFloContainerColor;

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
        builder: (ctx, sellService, child) => Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
            color: color,
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.padding24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SellText(
                      investmentType: investmentType,
                    ),
                    SellButton(
                      text: investmentType == InvestmentType.AUGGOLD99
                          ? "SELL"
                          : "WITHDRAW",
                      onTap: () {
                        BaseUtil.openModalBottomSheet(
                          backgroundColor:
                              UiConstants.kModalSheetBackgroundColor,
                          isBarrierDismissible: true,
                          addToScreenStack: true,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.roundness32),
                            topRight: Radius.circular(SizeConfig.roundness32),
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
              SizedBox(
                height: SizeConfig.padding10,
              ),
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
                          textAlign: TextAlign.start,
                        ),
                ),
              ),
              SizedBox(height: SizeConfig.padding12),
              if (!sellService.isKYCVerified || sellService.userKycData == null)
                SellActionButton(
                  title: locale.completeKYCText,
                  onTap: navigateToKycScreen,
                ),
              if (!sellService.isBankDetailsAdded ||
                  sellService.activeBankAccountDetails == null)
                SellActionButton(
                  title: locale.addBankDetails,
                  onTap: navigateToBankDetailsScreen,
                ),
              // SizedBox(height: SizeConfig.padding12),
              // if (sellService.sellNotice != null &&
              //     sellService.sellNotice.isNotEmpty)
              //   SellCardInfoStrips(
              //     leadingIcon: Icon(
              //       Icons.warning_amber_rounded,
              //       color: UiConstants.tertiarySolid.withOpacity(0.5),
              //     ),
              //     content: sellService.sellNotice,
              //     textColor: Colors.amber,
              //     backgroundColor: Colors.amber.withOpacity(0.16),
              //   ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
            ],
          ),
        ),
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
