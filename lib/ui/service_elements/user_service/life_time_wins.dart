import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class LifeTimeWin extends StatelessWidget {
  final TextStyle? style;

  const LifeTimeWin({this.style});

  getWinString(double? amt) {
    if (amt == null) {
      return 0;
    } else if (amt == amt.toInt()) {
      return amt.toInt();
    } else if (amt > amt.toInt()) {
      return BaseUtil.digitPrecision(amt, 2, false);
    } else {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [
        UserServiceProperties.myUserFund,
        UserServiceProperties.myUserWallet
      ],
      builder: (context, model, property) => Text(
        "₹ ${getWinString(model?.userFundWallet?.unclaimedBalance)}",
        style: style ?? TextStyles.sourceSansSB.title4,
      ),
    );
  }
}
