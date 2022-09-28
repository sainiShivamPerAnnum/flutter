import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/modals_sheets/gold_sell_reason_modal_sheet.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_components.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class SellCardView extends StatelessWidget {
  final InvestmentType investmentType;

  const SellCardView({Key key, @required this.investmentType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<BankAndPanService,
        BankAndPanServiceProperties>(
      properties: [
        BankAndPanServiceProperties.reachedLockIn,
        BankAndPanServiceProperties.augmontSellDisabled,
        BankAndPanServiceProperties.bankDetailsVerified,
        BankAndPanServiceProperties.kycVerified,
        BankAndPanServiceProperties.ongoing,
      ],
      builder: (ctx, sellService, child) => Container(
        margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.black.withOpacity(0),
              Colors.white.withOpacity(0.3),
            ],
          ),
        ),
        width: SizeConfig.screenWidth,
        child: Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
            color: UiConstants.kSecondaryBackgroundColor,
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
                      onTap: () {
                        BaseUtil.openModalBottomSheet(
                          backgroundColor:
                              UiConstants.kModalSheetBackgroundColor,
                          isBarrierDismissable: true,
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
                      isActive: sellService.getButtonAvailibility(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: SizeConfig.padding24),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: sellService.isKYCVerified &&
                          sellService.isBankDetailsAdded
                      ? SizedBox()
                      : Text(
                          'To enable sell,\ncomplete the following:',
                          style: TextStyles.sourceSans.body4.colour(
                            UiConstants.primaryColor,
                          ),
                          textAlign: TextAlign.end,
                        ),
                ),
              ),
              SizedBox(height: SizeConfig.padding12),
              if (!sellService.isKYCVerified || sellService.userPan == null)
                SellActionButton(
                  title: 'Complete KYC',
                  onTap: navigateToKycScreen,
                ),
              if (!sellService.isBankDetailsAdded ||
                  sellService.activeBankAccountDetails == null)
                SellActionButton(
                  title: 'Add Bank Details',
                  onTap: navigateToBankDetailsScreen,
                ),
              SizedBox(height: SizeConfig.padding12),
              if (sellService.sellNotice != null)
                SellCardInfoStrips(
                  leadingIcon: Icon(
                    Icons.warning_amber_rounded,
                    color: UiConstants.tertiarySolid.withOpacity(0.5),
                  ),
                  content: "sellService.sellNotice",
                  textColor: Colors.amber,
                  backgroundColor: Colors.amber.withOpacity(0.16),
                ),
              SizedBox(
                height: SizeConfig.padding24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  navigateToKycScreen() =>
      AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addPage,
        page: KycDetailsPageConfig,
      );

  navigateToBankDetailsScreen() =>
      AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addPage,
        page: BankDetailsPageConfig,
      );
}
