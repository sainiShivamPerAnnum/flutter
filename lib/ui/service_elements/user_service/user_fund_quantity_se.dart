import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserFundQuantitySE extends StatelessWidget {
  final TextStyle style;
  final InvestmentType investmentType;

  UserFundQuantitySE({
    this.style,
    this.investmentType = InvestmentType.AUGGOLD99,
  });

  String getQuantity(UserFundWallet fund) {
    final suffix = investmentType == InvestmentType.AUGGOLD99 ? "gm" : '';
    final prefix = investmentType == InvestmentType.AUGGOLD99 ? '' : '₹';
    final quantity = investmentType == InvestmentType.AUGGOLD99
        ? fund?.augGoldQuantity
        : fund?.wLbBalance;

    if (quantity != null) {
      if (quantity == 0.0) {
        if (prefix != null) return "$prefix 0 $suffix";
        return "0 $suffix";
      } else {
        if (investmentType == InvestmentType.AUGGOLD99)
          return "$prefix ${quantity.toStringAsFixed(4)} $suffix";
        else
          return "$prefix ${quantity.toStringAsFixed(2)} $suffix";
      }
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
