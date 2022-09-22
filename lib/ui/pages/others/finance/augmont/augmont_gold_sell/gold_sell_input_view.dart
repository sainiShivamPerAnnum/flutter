//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'dart:math' as math;
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/new_augmont_buy_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_gold_sell/gold_sell_vm.dart';
import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/transaction_loader.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//Pub Imports
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class GoldSellInputView extends StatelessWidget {
  final GoldSellViewModel model;
  final AugmontTransactionService augTxnservice;

  const GoldSellInputView(
      {Key key, @required this.model, @required this.augTxnservice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: SizeConfig.padding16),
        RechargeModalSheetAppBar(txnService: augTxnservice),
        SizedBox(
          height: SizeConfig.padding54,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding12,
              horizontal: SizeConfig.pageHorizontalMargins * 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saleable Gold Balance',
                style:
                    TextStyles.sourceSans.body3.colour(UiConstants.kTextColor2),
              ),
              PropertyChangeConsumer<UserService, UserServiceProperties>(
                properties: [UserServiceProperties.myUserFund],
                builder: (ctx, model, child) => Text(
                  locale.saveGoldBalanceValue(
                      model.userFundWallet.augGoldQuantity ?? 0.0),
                  style: TextStyles.sourceSansSB.body0
                      .colour(UiConstants.kTextColor),
                ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: SizeConfig.screenWidth * 0.5,
                width: SizeConfig.screenWidth * 0.42,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        SizeConfig.roundness12,
                      ),
                      bottomLeft: Radius.circular(
                        SizeConfig.roundness12,
                      )),
                  child: TextField(
                    focusNode: model.sellFieldNode,
                    enabled: !model.isGoldSellInProgress,
                    controller: model.goldAmountController,
                    enableInteractiveSelection: false,
                    textAlign: TextAlign.center,
                    cursorHeight: SizeConfig.padding46,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    style: TextStyles.rajdhaniB.title2,
                    onChanged: (val) {
                      model.goldSellGrams = double.tryParse(val);
                      model.updateGoldAmount();
                    },
                    autofocus: true,
                    showCursor: false,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding24,
                          horizontal: SizeConfig.padding28),
                      fillColor: UiConstants.kFAQDividerColor.withOpacity(0.5),
                      filled: true,
                      suffix: Padding(
                        padding: EdgeInsets.only(right: SizeConfig.padding10),
                        child: Text("g",
                            style: TextStyles.rajdhaniB.title2
                                .colour(UiConstants.kTextColor)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              SizeConfig.roundness12,
                            ),
                            bottomLeft: Radius.circular(
                              SizeConfig.roundness12,
                            )),
                        borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                            color: Colors.transparent),
                      ),
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                width: SizeConfig.screenWidth * 0.4,
                height: SizeConfig.screenWidth * 0.22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(SizeConfig.roundness12),
                    bottomRight: Radius.circular(SizeConfig.roundness12),
                  ),
                  color: UiConstants.kModalSheetBackgroundColor,
                ),
                padding: EdgeInsets.only(left: SizeConfig.padding10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      alignment: Alignment.center,
                      child: Text(
                        "₹ ${model.goldAmountFromGrams.toStringAsFixed(1)}",
                        style: TextStyles.sourceSansSB.body1.colour(
                            UiConstants.kModalSheetMutedTextBackgroundColor),
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
        Spacer(),
        Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.padding34,
                right: SizeConfig.padding34,
                bottom: MediaQuery.of(context).viewInsets.bottom * 0.5 ?? 0),
            child: Text(
              _buildNonWithdrawString(model),
              style: TextStyles.body4.colour(Colors.grey),
              textAlign: TextAlign.center,
            )),
        SizedBox(
          height: SizeConfig.padding24,
        ),
        Container(
          margin:
              EdgeInsets.symmetric(vertical: SizeConfig.pageHorizontalMargins),
          child: ReactivePositiveAppButton(
            btnText: 'SELL',
            onPressed: () async {
              if (!model.isGoldSellInProgress && !model.isQntFetching) {
                FocusScope.of(context).unfocus();
                bool isDetailComplete = await model.verifyGoldSaleDetails();
                if (isDetailComplete)
                  BaseUtil.openDialog(
                    addToScreenStack: true,
                    hapticVibrate: true,
                    isBarrierDismissable: false,
                    content: ConfirmationDialog(
                      title: 'Are you sure you want\nto sell?',
                      asset: SvgPicture.asset(Assets.magicalSpiritBall),
                      description:
                          'Your ${model.goldSellGrams} gms could have grown to\n${(model.goldSellGrams * 12).toStringAsPrecision(2)} gms by 2025',
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
    );
  }

  _buildNonWithdrawString(GoldSellViewModel model) {
    DateTime _dt = new DateTime.now()
        .add(Duration(days: Constants.AUG_GOLD_WITHDRAW_OFFSET));
    String _dtStr = DateFormat("dd MMMM").format(_dt);
    int _hrs = Constants.AUG_GOLD_WITHDRAW_OFFSET * 24;

    return model.withdrawalbeQtyMessage.isNotEmpty
        ? model.withdrawalbeQtyMessage
        : ""; //'${model.nonWithdrawableQnt} grams is locked. Digital Gold can be withdrawn after $_hrs hours of successful deposit.';
  }
}
