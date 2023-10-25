import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AmountChips extends StatelessWidget {
  final int? amount;
  final bool isSelected;
  final Function onTap;
  final bool? isBestSeller;
  const AmountChips(
      {required this.onTap,
      this.amount,
      this.isBestSeller = false,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding4),
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding8,
                horizontal: SizeConfig.padding16,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? UiConstants.primaryColor
                      : const Color(0xFFFEF5DC).withOpacity(0.2),
                  width: SizeConfig.border0,
                ),
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                // color: UiConstants.primaryLight.withOpacity(0.5),
              ),
              alignment: Alignment.center,
              child: Text(
                " ₹ ${amount!.toInt()} ",
                style: TextStyles.sourceSansL.body2,
              ),
            ),
            if (isBestSeller!)
              Transform.translate(
                offset: Offset(0, -SizeConfig.padding8),
                child: Container(
                  decoration: BoxDecoration(
                    color: UiConstants.primaryColor,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding4,
                      vertical: SizeConfig.padding2),
                  child: Text(
                    locale.best,
                    style: TextStyles.rajdhaniB.body5
                        .colour(Colors.white)
                        .letterSpace(SizeConfig.padding2),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
