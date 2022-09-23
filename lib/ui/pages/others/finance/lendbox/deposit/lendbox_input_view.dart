import "dart:math" as math;

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/buy_input_view.dart';
import 'package:felloapp/ui/pages/others/finance/lendbox/deposit/lendbox_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
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
        RechargeModalSheetAppBar(
          isEnabled: !model.isBuyInProgress,
        ),
        SizedBox(height: SizeConfig.padding32),
        BuyInputView(
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

class RechargeModalSheetAppBar extends StatelessWidget {
  final bool isEnabled;
  const RechargeModalSheetAppBar({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: SizeConfig.screenWidth * 0.168,
        height: SizeConfig.screenWidth * 0.168,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              UiConstants.primaryColor.withOpacity(0.4),
              UiConstants.primaryColor.withOpacity(0.2),
              UiConstants.primaryColor.withOpacity(0.04),
              Colors.transparent,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Image.asset(
            Assets.felloFlo,
            width: SizeConfig.screenWidth * 0.27,
            height: SizeConfig.screenWidth * 0.27,
          ),
        ),
      ),
      title: Text('Fello Flo', style: TextStyles.rajdhaniSB.body2),
      subtitle: Text(
        "10% returns on investment",
        style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
      ),
      trailing: !isEnabled
          ? SizedBox()
          : IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                AppState.backButtonDispatcher.didPopRoute();
              },
            ),
    );
  }
}
