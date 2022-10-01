import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/pages/others/finance/amount_input_view.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/lendbox_app_bar.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/withdrawal/lendbox_withdrawal_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/service_elements/gold_sell_card/sell_card_components.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LendboxWithdrawalInputView extends StatelessWidget {
  final LendboxWithdrawalViewModel model;

  const LendboxWithdrawalInputView({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: SizeConfig.padding16),
            LendboxAppBar(
              isEnabled: !model.inProgress,
            ),
            SizedBox(height: SizeConfig.padding32),
            if (model.state == ViewState.Idle &&
                model.withdrawableQuantity.lockedAmount > 0)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                child: SellCardInfoStrips(
                  content: model.withdrawableQuantity.lockedMessage,
                ),
              ),
            SizedBox(height: SizeConfig.padding32),
            AmountInputView(
              amountController: model.amountController,
              focusNode: model.fieldNode,
              chipAmounts: [],
              isEnabled: !model.inProgress,
              maxAmount: model.withdrawableQuantity?.amount ?? 2,
              maxAmountMsg: "You can't withdraw more than available balance",
              minAmount: model.minAmount,
              minAmountMsg: "how are you gonna withdraw less than 1?",
              notice: model.buyNotice,
              bestChipIndex: 1,
              onAmountChange: (int amount) {},
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding38),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Withdrawable Balance',
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor2),
                  ),
                  Text(
                    '₹ ${model.withdrawableQuantity?.amount ?? 0}',
                    style: TextStyles.sourceSansSB.body0.colour(
                      UiConstants.kTextColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.padding32,
            ),
            model.state == ViewState.Busy || model.inProgress
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
        ),
        CustomKeyboardSubmitButton(
          onSubmit: () => model.fieldNode.unfocus(),
        )
      ],
    );
  }
}
