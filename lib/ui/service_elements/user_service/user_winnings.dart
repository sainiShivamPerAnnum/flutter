import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserWinningsSE extends StatelessWidget {
  final TextStyle? style;
  const UserWinningsSE({this.style});

  @override
  Widget build(BuildContext context) {
    S? locale = S.of(context);
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [
        UserServiceProperties.myUserFund,
        UserServiceProperties.myUserWallet
      ],
      builder: (context, model, property) {
        // double lockedBal = model.userFundWallet.lockedPrizeBalance ?? 0.0;
        double unclaimedBal = model!.userFundWallet?.prizeBalance ?? 0.0;
        return Text(
          locale.saveWinningsValue((unclaimedBal).toInt() ?? "-"),
          style: style ?? TextStyles.body3.bold.colour(Colors.white),
        );
      },
    );
  }
}
