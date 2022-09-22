import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sell_service_enum.dart';
import 'package:felloapp/core/service/payments/sell_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/gold_sell_reason_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/save_assets_view.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/gold_sell_card_components.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class GoldSellCardView extends StatelessWidget {
  const GoldSellCardView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<SellService, SellServiceProperties>(
      properties: [
        SellServiceProperties.reachedLockIn,
        SellServiceProperties.augmontSellDisabled,
        SellServiceProperties.bankDetailsVerified,
        SellServiceProperties.kycVerified,
        SellServiceProperties.ongoingTransaction,
      ],
      builder: (ctx, sellService, child) =>
          //  BaseView<GoldSellCardViewModel>(
          //   onModelReady: (model) {},
          //   onModelDispose: (model) {},
          //   builder: (ctx, model, child) =>
          Container(
        width: SizeConfig.screenWidth,
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
                    SellGoldText(),
                    SellButton(
                        onTap: () {
                          BaseUtil.openModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isBarrierDismissable: true,
                              addToScreenStack: true,
                              content: SellingReasonBottomSheet());
                        },
                        isActive: sellService.getButtonAvailibility()),
                  ]),
            ),
            // Padding(
            //   padding: EdgeInsets.only(right: SizeConfig.padding24),
            //   child: Align(
            //     alignment: Alignment.centerRight,
            //     child: sellService.isKYCVerified && sellService.isVPAVerified
            //         ? SizedBox()
            //         : Text(
            //             'To enable selling gold,\ncomplete the following:',
            //             style: TextStyles.sourceSans.body4
            //                 .colour(Colors.grey.withOpacity(0.7)),
            //             textAlign: TextAlign.end,
            //           ),
            //   ),
            // ),
            SizedBox(height: SizeConfig.padding12),

            if (!sellService.isKYCVerified)
              SellActionButton(
                title: 'Complete KYC',
                onTap: navigateToKycScreen,
              ),
            if (!sellService.isBankDetailsAdded)
              SellActionButton(
                title: 'Add Bank Details',
                onTap: navigateToBankDetailsScreen,
              ),
            SizedBox(height: SizeConfig.padding12),

            if (sellService.isSellLocked)
              SellCardInfoStrips(
                leadingIcon: Icon(Icons.warning_amber_rounded,
                    color: Colors.red.withOpacity(0.8)),
                content: sellService.sellNotice,
                textColor: Colors.red,
                backgroundColor: Colors.red.withOpacity(0.16),
              ),

            if (sellService.sellNotice != null && !sellService.isSellLocked)
              SellCardInfoStrips(
                leadingIcon: Icon(Icons.warning_amber_rounded,
                    color: UiConstants.tertiarySolid.withOpacity(0.5)),
                content: sellService.sellNotice,
                textColor: Colors.amber,
                backgroundColor: Colors.amber.withOpacity(0.16),
              ),

            //Lock in reached section
            if (sellService.nonWithdrawableQnt != null &&
                sellService.nonWithdrawableQnt != 0)
              SellCardInfoStrips(
                leadingIcon: Icon(Icons.warning_amber_rounded,
                    color: UiConstants.kTextColor2),
                content:
                    '${sellService.nonWithdrawableQnt}g is locked. Digital Gold can be withdrawn after 48 hours of successful deposit',
              ),

            if (sellService.isOngoingTransaction)
              SellCardInfoStrips(
                leadingIcon: SpinKitFadingCircle(
                  size: SizeConfig.iconSize0,
                  color: UiConstants.kTextColor2,
                ),
                content: 'Your Digital Gold withdrawal is being processsed',
              ),

            SizedBox(
              height: SizeConfig.padding24,
            ),
          ],
        ),
      ),
    );
  }

  navigateToKycScreen() => AppState.delegate.appState.currentAction =
      PageAction(state: PageState.addPage, page: KycDetailsPageConfig);

  navigateToBankDetailsScreen() => AppState.delegate.appState.currentAction =
      PageAction(state: PageState.addPage, page: BankDetailsPageConfig);
}
