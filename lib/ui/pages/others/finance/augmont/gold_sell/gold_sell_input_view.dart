//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/gold_buy/gold_buy_input_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/gold_sell/gold_sell_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/service_elements/bank_details_card.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_components.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//Pub Imports
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class GoldSellInputView extends StatelessWidget {
  final GoldSellViewModel model;
  final AugmontTransactionService augTxnservice;

  const GoldSellInputView(
      {Key key, @required this.model, @required this.augTxnservice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.padding16),
            RechargeModalSheetAppBar(txnService: augTxnservice),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            if (model.nonWithdrawableQnt != null &&
                model.nonWithdrawableQnt != 0)
              SellCardInfoStrips(content: model.withdrawableQtyMessage),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding12,
                  horizontal: SizeConfig.pageHorizontalMargins),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Withdrawable Gold Balance',
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor2),
                  ),
                  Text(
                    model.withdrawableQnt.toString(),
                    style: TextStyles.sourceSansSB.body0
                        .colour(UiConstants.kTextColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.padding6,
            ),
            Container(
              height: SizeConfig.screenWidth * 0.22,
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.4),
                      width: 0.5,
                      style: BorderStyle.solid)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: model.sellFieldNode.requestFocus,
                      child: Container(
                        height: SizeConfig.screenWidth * 0.5,
                        // width: SizeConfig.screenWidth * 0.6,
                        decoration: BoxDecoration(
                          color: UiConstants.kFAQDividerColor.withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.roundness12),
                            bottomLeft: Radius.circular(SizeConfig.roundness12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 0),
                              curve: Curves.easeIn,
                              width: model.fieldWidth,
                              child: TextField(
                                focusNode: model.sellFieldNode,
                                enabled: !augTxnservice.isGoldSellInProgress,
                                controller: model.goldAmountController,
                                // enableInteractiveSelection: false,
                                textAlign: TextAlign.center,
                                cursorHeight: SizeConfig.padding35,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                style: TextStyles.rajdhaniB.title2,
                                onChanged: (val) => model.updateGoldAmount(val),
                                autofocus: true,
                                showCursor: true,
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'),
                                  )
                                ],
                                decoration: InputDecoration(
                                  // contentPadding: EdgeInsets.symmetric(
                                  //     vertical: SizeConfig.padding24,
                                  //     horizontal: SizeConfig.padding28),
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            Text("g",
                                style: TextStyles.rajdhaniB.title2
                                    .colour(UiConstants.kTextColor))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: SizeConfig.screenWidth * 0.36,
                    height: SizeConfig.screenWidth * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(SizeConfig.roundness12),
                        bottomRight: Radius.circular(SizeConfig.roundness12),
                      ),
                      color: UiConstants.kModalSheetBackgroundColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FittedBox(
                          alignment: Alignment.center,
                          child: Text(
                            "₹ ${model.goldAmountFromGrams.toStringAsFixed(2)}",
                            style: TextStyles.sourceSansSB.body1.colour(
                                UiConstants
                                    .kModalSheetMutedTextBackgroundColor),
                          ),
                        ),
                        FittedBox(
                          alignment: Alignment.center,
                          child: CurrentPriceWidget(
                            fetchGoldRates: model.fetchGoldRates,
                            goldprice: model.goldSellPrice ?? 0.0,
                            isFetching: model.isGoldRateFetching,
                            mini: true,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (model.showMaxCap)
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding8,
                    horizontal: SizeConfig.pageHorizontalMargins * 1.5),
                child: Text(
                  "Upto ₹ 50,000 can be sold at one go.",
                  style: TextStyles.sourceSans.body4.bold
                      .colour(UiConstants.primaryColor),
                ),
              ),
            if (model.showMinCap)
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding8,
                    horizontal: SizeConfig.pageHorizontalMargins * 1.5),
                child: Text(
                  "Minimum sell amount is ₹ 10",
                  style:
                      TextStyles.sourceSans.body4.bold.colour(Colors.red[400]),
                ),
              ),
            Spacer(),
            augTxnservice.isGoldSellInProgress
                ? Center(
                    child: Container(
                      height: SizeConfig.screenWidth * 0.1556,
                      alignment: Alignment.center,
                      width: SizeConfig.screenWidth * 0.7,
                      child: LinearProgressIndicator(
                        color: UiConstants.primaryColor,
                        backgroundColor: UiConstants.kDarkBackgroundColor,
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                    child: ReactivePositiveAppButton(
                      btnText: 'SELL',
                      onPressed: () async {
                        if (!augTxnservice.isGoldSellInProgress &&
                            !model.isQntFetching) {
                          FocusScope.of(context).unfocus();
                          bool isDetailComplete =
                              await model.verifyGoldSaleDetails();
                          if (isDetailComplete)
                            BaseUtil.openDialog(
                              addToScreenStack: true,
                              hapticVibrate: true,
                              isBarrierDismissable: false,
                              content: ConfirmationDialog(
                                title: 'Are you sure you want\nto sell?',
                                // asset: SvgPicture.asset(Assets.magicalSpiritBall),
                                asset: BankDetailsCard(),
                                description:
                                    '₹${BaseUtil.digitPrecision(model.goldAmountFromGrams, 2)} will be credited to your linked bank account instantly',
                                buttonText: 'SELL',
                                confirmAction: () async {
                                  AppState.backButtonDispatcher.didPopRoute();
                                  await model.initiateSell();
                                },
                                cancelAction: () {
                                  AppState.backButtonDispatcher.didPopRoute();
                                },
                              ),
                            );
                        }
                      },
                    ),
                  ),
          ],
        ),
        CustomKeyboardSubmitButton(
          onSubmit: () => model.sellFieldNode.unfocus(),
        ),
        if (model.state == ViewState.Busy)
          Container(
            decoration: BoxDecoration(
              color: UiConstants.kDarkBackgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.roundness12),
                topRight: Radius.circular(SizeConfig.roundness12),
              ),
            ),
            child: SpinKitFadingCircle(
              color: UiConstants.kTextColor2,
              size: SizeConfig.padding80,
            ),
          ),
      ],
    );
  }

//   _buildRow(String key, String value){
//  return Row(children: [
//   Expanded(child: Text(key,style:TextStyles.sourceSansB),)
//  ],)
//   }

}
