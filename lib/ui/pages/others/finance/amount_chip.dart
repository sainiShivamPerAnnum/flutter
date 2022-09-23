import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class AmountChip extends StatelessWidget {
  const AmountChip({
    Key key,
    @required this.isActive,
    @required this.amt,
    @required this.onClick,
  }) : super(key: key);

  final bool isActive;
  final int amt;
  final Function(int val) onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick(amt);
      },
      child: Container(
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
    );
  }
}
