import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class LendboxPrincipleValue extends StatelessWidget {
  final String prefix;
  final TextStyle style;

  LendboxPrincipleValue({
    this.prefix,
    this.style,
  });

  String getQuantity(UserFundWallet fund) {
    final quantity = fund?.wLbPrinciple;

    if (quantity != null) {
      if (quantity == 0.0) {
        if (prefix != null) return "$prefix 0";
        return "0";
      } else if (prefix != null)
        return "$prefix ${quantity.toStringAsFixed(2)}";
      return "${quantity.toStringAsFixed(2)}";
    } else
      return "--";
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: [
        UserServiceProperties.myUserFund,
        UserServiceProperties.myUserWallet
      ],
      builder: (context, model, property) => Text(
        "${getQuantity(model.userFundWallet)}",
        style: style ??
            GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.largeTextSize,
            ),
      ),
    );
  }
}
