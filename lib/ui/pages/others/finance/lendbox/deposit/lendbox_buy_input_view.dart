import 'package:felloapp/ui/pages/others/finance/amount_input_view.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/lendbox_app_bar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LendboxBuyInputView extends StatelessWidget {
  final int amount;
  final bool skipMl;
  final LendboxBuyViewModel model;

  const LendboxBuyInputView({
    Key key,
    this.amount,
    this.skipMl,
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
          isEnabled: !model.isBuyInProgress,
        ),
        SizedBox(height: SizeConfig.padding32),
        AmountInputView(
          amountController: model.amountController,
          chipAmounts: model.chipAmountList,
          isEnabled: !model.isBuyInProgress,
          maxAmount: 50000,
          minAmount: 10,
          notice: model.buyNotice,
          onAmountChange: (int amount) {},
        ),
        Spacer(),
        SizedBox(
          height: SizeConfig.padding32,
        ),
        model.isBuyInProgress
            ? SpinKitThreeBounce(
                color: Colors.white,
                size: 20,
              )
            : AppPositiveBtn(
                btnText: 'Invest',
                onPressed: () async {
                  if (!model.isBuyInProgress) {
                    FocusScope.of(context).unfocus();
                    model.initiateBuy();
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
