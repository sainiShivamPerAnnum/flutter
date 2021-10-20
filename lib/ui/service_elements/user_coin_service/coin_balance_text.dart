import 'package:felloapp/core/enums/user_coin_service_enum.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class CoinBalanceTextSE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserCoinService, UserCoinServiceProperties>(
      properties: [UserCoinServiceProperties.coinBalance],
      builder: (context, model, property) => Text(
          model.flcBalance != null ? model.flcBalance.toString() : "0",
          style: TextStyles.body2.bold),
    );
  }
}
