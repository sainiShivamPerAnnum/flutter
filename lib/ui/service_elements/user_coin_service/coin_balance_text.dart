import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoinBalanceTextSE extends StatelessWidget {
  final TextStyle? style;
  const CoinBalanceTextSE({this.style});
  @override
  Widget build(BuildContext context) {
    return Consumer<UserCoinService>(
      builder: (context, model, property) => Text(
          model.flcBalance != null ? model.flcBalance.toString() : "0",
          style: style != null
              ? style!.copyWith(color: Colors.white)
              : TextStyles.rajdhaniSB.body2.colour(Colors.white)),
    );
  }
}
