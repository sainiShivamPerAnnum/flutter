import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserWinningsSE extends StatelessWidget {
  final TextStyle style;
  UserWinningsSE({this.style});
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: [UserServiceProperties.myUserFund],
      builder: (context, model, property) => Text(
        locale.saveWinningsValue(
            model.userFundWallet?.prizeBalance?.toInt() ?? "-"),
        style: style ?? TextStyles.body3.bold.colour(Colors.white),
      ),
    );
  }
}
