import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserFundQuantitySE extends StatelessWidget {
  final TextStyle? style;
  final InvestmentType investmentType;

  const UserFundQuantitySE({
    this.style,
    this.investmentType = InvestmentType.AUGGOLD99,
  });

  String getQuantity(UserFundWallet? fund) {
    final suffix = investmentType == InvestmentType.AUGGOLD99 ? " gm" : '';
    final prefix = investmentType == InvestmentType.AUGGOLD99 ? '' : '₹ ';
    final quantity = investmentType == InvestmentType.AUGGOLD99
        ? fund?.augGoldQuantity
        : fund?.wLbBalance;

    if (quantity != null) {
      if (quantity == 0.0) {
        return "${prefix}0$suffix";
        return "0 $suffix";
      } else {
        if (investmentType == InvestmentType.AUGGOLD99) {
          return "$prefix${quantity.toStringAsFixed(4)}$suffix";
        } else {
          return "$prefix${quantity.toStringAsFixed(2)}$suffix";
        }
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

class LboxGrowthArrow extends StatelessWidget {
  const LboxGrowthArrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: const [
          UserServiceProperties.myUserFund,
          UserServiceProperties.myUserWallet
        ],
        builder: (context, model, property) =>
            (model!.userFundWallet?.wLbBalance ?? 0) > 0
                ? Icon(
                    Icons.arrow_upward,
                    size: SizeConfig.padding16,
                    color: UiConstants.primaryColor,
                  )
                : const SizedBox());
  }
}
