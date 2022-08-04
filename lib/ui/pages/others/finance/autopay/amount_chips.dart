import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AmountChips extends StatelessWidget {
  final model;
  final int amount;
  final bool isBestSeller;
  AmountChips({
    this.model,
    this.amount,
    this.isBestSeller = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        Haptic.vibrate();
        model.amountFieldController.text = amount.toString();
        model.onAmountValueChanged(amount.toString());
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding8,
              horizontal: SizeConfig.padding16,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: int.tryParse(model.amountFieldController.text) == amount
                    ? UiConstants.primaryColor
                    : Color(0xFFFEF5DC).withOpacity(0.2),
                width: SizeConfig.border0,
              ),
              borderRadius: BorderRadius.circular(SizeConfig.roundness5),
              // color: UiConstants.primaryLight.withOpacity(0.5),
            ),
            alignment: Alignment.center,
            child: Text(
              " ₹ ${amount.toInt()} ",
              style: TextStyles.sourceSansL.body2,
            ),
          ),
          if (isBestSeller)
            Transform.translate(
              offset: Offset(0, -SizeConfig.padding8),
              child: Container(
                decoration: BoxDecoration(
                  color: UiConstants.primaryColor,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding6,
                    vertical: SizeConfig.padding4),
                child: Text(
                  'BEST',
                  style: TextStyles.rajdhaniB.body4
                      .colour(Colors.white)
                      .letterSpace(SizeConfig.padding2),
                ),
              ),
            )
        ],
      ),
    );
  }
}
