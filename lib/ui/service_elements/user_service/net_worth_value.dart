import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class NetWorthValue extends StatelessWidget {
  final TextStyle? style;

  const NetWorthValue({
    this.style,
  });

  String getQuantity(UserFundWallet? fund) {
    final quantity = fund?.netWorth;
    const prefix = "₹";

    if (quantity != null) {
      if (quantity == 0.0) {
        return "$prefix 0";
      } else {
        return "$prefix ${quantity.toStringAsFixed(2)}";
      }
    } else {
      return "--";
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
        getQuantity(model!.userFundWallet),
        style: style ?? TextStyles.sourceSansSB.title4,
      ),
    );
  }
}
