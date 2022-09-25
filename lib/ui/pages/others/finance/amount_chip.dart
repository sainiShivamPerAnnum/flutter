import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AmountChip extends StatelessWidget {
  const AmountChip({
    Key key,
    @required this.isActive,
    @required this.amt,
    this.isBest = false,
    @required this.onClick,
  }) : super(key: key);

  final bool isActive;
  final int amt;
  final bool isBest;
  final Function(int val) onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.padding44,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                onClick(amt);
              },
              child: Container(
                height: SizeConfig.padding40,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding8,
                  horizontal: SizeConfig.padding12,
                ),
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  border: Border.all(
                    color: isActive
                        ? Color(0xFFFEF5DC)
                        : Color(0xFFFEF5DC).withOpacity(0.2),
                    width: SizeConfig.border0,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "₹ ${amt.toInt()}",
                  style: TextStyles.sourceSansL.body2.colour(Colors.white),
                ),
              ),
            ),
          ),
          if (isBest)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding4,
                    vertical: SizeConfig.padding2),
                decoration: BoxDecoration(color: UiConstants.primaryColor),
                child: Text(
                  "BEST",
                  style: TextStyles.rajdhaniSB.body5,
                ),
              ),
            )
        ],
      ),
    );
  }
}
