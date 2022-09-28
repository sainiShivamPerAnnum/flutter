import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/ui/pages/others/finance/amount_input_view.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/lendbox_app_bar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

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
          maxAmount: model.maxAmount,
          maxAmountMsg: "Up to ₹50,000 can be invested at one go.",
          minAmount: model.minAmount,
          minAmountMsg: "Minimum purchase amount is ₹10",
          notice: model.buyNotice,
          onAmountChange: (int amount) {},
        ),
        Spacer(),
        SizedBox(
          height: SizeConfig.padding32,
        ),
        PropertyChangeConsumer<BankAndPanService, BankAndPanServiceProperties>(
          properties: [
            BankAndPanServiceProperties.kycVerified,
          ],
          builder: (ctx, service, child) {
            if (!service.isKYCVerified) return _kycWidget(model);
            return model.isBuyInProgress
                ? Container(
                    height: SizeConfig.screenWidth * 0.1556,
                    alignment: Alignment.center,
                    width: SizeConfig.screenWidth * 0.7,
                    child: LinearProgressIndicator(
                      color: UiConstants.primaryColor,
                      backgroundColor: UiConstants.kDarkBackgroundColor,
                    ),
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
                  );
          },
        ),
        SizedBox(
          height: SizeConfig.padding32,
        ),
      ],
    );
  }

  Widget _kycWidget(LendboxBuyViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              'You need to complete your KYC before you can invest',
              style: TextStyles.sourceSans.body3.colour(
                UiConstants.kTextColor,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          AppNegativeBtn(
            btnText: 'Complete KYC',
            onPressed: model.navigateToKycScreen,
            width: SizeConfig.screenWidth,
          ),
        ],
      ),
    );
  }
}
