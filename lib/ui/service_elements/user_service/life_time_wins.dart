import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class LifeTimeWin extends StatelessWidget {
  final TextStyle style;

  LifeTimeWin({
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: [
        UserServiceProperties.myUserFund,
        UserServiceProperties.myUserWallet
      ],
      builder: (context, model, property) => Text(
        "₹ ${BaseUtil.getIntOrDouble(model?.userFundWallet?.prizeLifetimeWin ?? 0) ?? '-'}",
        style: style ?? TextStyles.sourceSansSB.title4,
      ),
    );
  }
}
