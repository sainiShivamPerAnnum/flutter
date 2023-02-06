import 'dart:math';

import 'package:felloapp/core/enums/investment_type.dart';

extension ReturnInvestments on int {
  String getReturns(InvestmentType investmentType, double amount,
      [decimalPoint = 2]) {
    final month = this;
    final int returnPercentage =
        investmentType == InvestmentType.AUGGOLD99 ? 7 : 10;

    return (amount +
            ((calculatePercentageInterest(month, returnPercentage) * amount)))
        .toStringAsFixed(decimalPoint);
  }

  String calculateCompoundInterest(
    InvestmentType investmentType,
    double principalAmount,
  ) {
    final period = this;
    final interestRate = investmentType == InvestmentType.AUGGOLD99 ? 7 : 10;

    return (principalAmount * (pow((1 + interestRate / 100), period)))
        .toStringAsFixed(0);
  }

  double calculatePercentageInterest(int month, int percentage) =>
      ((percentage * month) / 12) / 100;
}
