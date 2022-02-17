import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserGoldQuantitySE extends StatelessWidget {
  final TextStyle style;
  UserGoldQuantitySE({this.style});

  getGoldQuantity(double quantity) {
    if (quantity != null) {
      if (quantity == 0.0) {
        return "0";
      } else
        return quantity.toStringAsFixed(4);
    } else
      return "--";
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: [UserServiceProperties.myUserFund],
      builder: (context, model, property) => Text(
        "${getGoldQuantity(model.userFundWallet?.augGoldQuantity)} gm" ?? "-",
        style: style ??
            GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.largeTextSize),
      ),
    );
  }
}
