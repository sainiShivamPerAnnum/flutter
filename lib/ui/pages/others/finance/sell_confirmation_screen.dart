import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/service_elements/bank_details_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SellConfirmationView extends StatelessWidget {
  final double grams;
  final double amount;
  final interest = 6;
  final Function onSuccess;
  final InvestmentType investmentType;

  double compoundedValue() {
    double val = amount * (math.pow((1 + 0.065), (2030 - DateTime.now().year)));
    print("Compounded value: $val");
    return val;
  }

  const SellConfirmationView(
      {Key? key,
      required this.amount,
      required this.grams,
      required this.onSuccess,
      required this.investmentType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Gold in grams: $grams");
    print("Gold in amount: $amount");
    return Scaffold(
      backgroundColor: UiConstants.kSecondaryBackgroundColor,
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins,
            vertical: SizeConfig.pageHorizontalMargins / 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: SizeConfig.pageHorizontalMargins / 2),
            Text(
              'Are you sure you want to sell?',
              style: TextStyles.rajdhaniB.title3,
              textAlign: TextAlign.center,
            ),
            // Text(
            //   "Stay invested a little longer,\nreap higher rewards",
            //   textAlign: TextAlign.center,
            //   style:
            //       TextStyles.sourceSansSB.body2.colour(UiConstants.kTextColor3),
            // ),
            Expanded(
              child: Lottie.asset(Assets.jarLottie, fit: BoxFit.contain),
            ),
            Transform.translate(
              offset: Offset(0, -SizeConfig.pageHorizontalMargins),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Your",
                    style: TextStyles.body2.colour(UiConstants.kTextColor2),
                    children: [
                      TextSpan(
                        text: investmentType == InvestmentType.AUGGOLD99
                            ? " $grams gms "
                            : " ₹ ${BaseUtil.getIntOrDouble(amount)} ",
                        style: TextStyles.sourceSansB.body2
                            .colour(UiConstants.kTextColor),
                      ),
                      TextSpan(text: "could have grown to "),
                      TextSpan(
                        text: "₹ ${compoundedValue().toInt()} ",
                        style: TextStyles.sourceSansB.body2
                            .colour(UiConstants.kTextColor),
                      ),
                      TextSpan(text: "by 2030")
                    ]),
              ),
            ),
            BankDetailsCard(),
            Text(
              '₹${BaseUtil.digitPrecision(amount, 2)} will be credited to your linked bank account instantly',
              textAlign: TextAlign.center,
              style: TextStyles.body2.colour(
                UiConstants.kTextColor3,
              ),
            ),
            SizedBox(height: SizeConfig.padding32),
            AppPositiveBtn(btnText: "Continue", onPressed: () => onSuccess()),
            SizedBox(height: SizeConfig.padding16),
            AppNegativeBtn(
                width: SizeConfig.screenWidth,
                btnText: "Keep Growing",
                onPressed: () => AppState.backButtonDispatcher!.didPopRoute())
          ],
        ),
      )),
    );
  }
}
