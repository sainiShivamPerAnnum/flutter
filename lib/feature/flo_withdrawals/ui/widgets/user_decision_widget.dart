import 'package:felloapp/feature/flo_withdrawals/ui/reinvestment_sheet.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class UserDecisionWidget extends StatelessWidget {
  const UserDecisionWidget({
    required this.decision,
    required this.fundType,
    required this.isLendboxOldUser,
    super.key,
  });

  final UserDecision decision;
  final String fundType;
  final bool isLendboxOldUser;

  String getText() {
    switch (decision) {
      case UserDecision.REINVEST:
        return "You had chosen to re-invest to ${fundType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 12 : 10}%";
      case UserDecision.WITHDRAW:
        return "You have chosen to withdraw to bank";
      case UserDecision.MOVETOFLEXI:
        return 'You have chosen to move to ${isLendboxOldUser ? 10 : 8}% Flo';
      case UserDecision.NOTDECIDED:
        return 'You have a decision pending for this investment';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.padding56,
      width: SizeConfig.screenWidth,
      decoration: ShapeDecoration(
        color: Colors.black.withOpacity(0.27),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
      ),
      child: Center(
        child: Text(
          getText(),
          style: TextStyles.sourceSans.body3.colour(Colors.white),
        ),
      ),
    );
  }
}
