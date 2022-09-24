import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/ui/pages/others/finance/amount_input_view.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/lendbox_app_bar.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/withdrawal/lendbox_withdrawal_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_components.dart';
import 'package:felloapp/ui/service_elements/user_service/lendbox_processing_value.dart';
import 'package:felloapp/ui/service_elements/user_service/user_fund_quantity_se.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LendboxWithdrawalInputView extends StatelessWidget {
  final int amount;
  final LendboxWithdrawalViewModel model;

  const LendboxWithdrawalInputView({
    Key key,
    this.amount,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: SizeConfig.padding16),
        LendboxAppBar(
          isEnabled: !model.inProgress,
        ),
        SizedBox(height: SizeConfig.padding32),
        SellCardInfoStrips(
          leadingIcon: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: UiConstants.kTextColor,
              ),
              SizedBox(
                width: 16,
              ),
              LendboxProcessingValue(
                style: TextStyles.sourceSans.body4.colour(
                  UiConstants.kTextColor2,
                ),
              ),
            ],
          ),
          content: '  amount is processing',
        ),
        SizedBox(height: SizeConfig.padding32),
        AmountInputView(
          amountController: model.amountController,
          chipAmounts: [],
          isEnabled: !model.inProgress,
          maxAmount: 50000,
          minAmount: 0,
          notice: model.buyNotice,
          onAmountChange: (int amount) {},
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Withdrawable Balance',
                style:
                    TextStyles.sourceSans.body3.colour(UiConstants.kTextColor2),
              ),
              UserFundQuantitySE(
                style: TextStyles.sourceSansSB.body0.colour(
                  UiConstants.kTextColor,
                ),
                investmentType: InvestmentType.LENDBOXP2P,
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding32,
        ),
        model.inProgress
            ? SpinKitThreeBounce(
                color: Colors.white,
                size: 20,
              )
            : AppPositiveBtn(
                btnText: 'WITHDRAW',
                onPressed: () async {
                  if (!model.inProgress) {
                    FocusScope.of(context).unfocus();
                    model.initiateWithdraw();
                  }
                },
                width: SizeConfig.screenWidth * 0.813,
              ),
        SizedBox(
          height: SizeConfig.padding32,
        ),
      ],
    );
  }
}
