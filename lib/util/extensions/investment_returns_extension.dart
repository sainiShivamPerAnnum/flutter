import 'dart:math';

import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';

extension ReturnInvestments on int {
  String getReturns(InvestmentType investmentType, double amount, int? interest,
      [decimalPoint = 2]) {
    final month = this;
    final int returnPercentage =
        investmentType == InvestmentType.AUGGOLD99 ? 8 : (interest ?? 10);

    return (amount +
            ((calculatePercentageInterest(month, returnPercentage) * amount)))
        .toStringAsFixed(decimalPoint);
  }

  String calculateCompoundInterest(
      InvestmentType investmentType, double principalAmount, int? interest) {
    final period = this;
    final interestRate =
        investmentType == InvestmentType.AUGGOLD99 ? 8 : (interest ?? 10);

    return (principalAmount * (pow(1 + interestRate / 100, period)))
        .toStringAsFixed(0);
  }

  double calculatePercentageInterest(int month, int percentage) =>
      ((percentage * month) / 12) / 100;

  String calculateAmountAfterMaturity(String amount, int year) {
    final floAssetType = locator<LendboxTransactionService>().floAssetType;

    final bool isLendboxOldUser =
        locator<UserService>().userSegments.contains(Constants.US_FLO_OLD);
    int interest = 1;

    if (floAssetType == Constants.ASSET_TYPE_FLO_FELXI && !isLendboxOldUser) {
      interest = 10;
    } else {
      interest = floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 12 : 10;
    }

    double principal = double.tryParse(amount) ?? 0.0;
    double rateOfInterest = interest / 100.0;

    double amountAfterYear = principal * pow(1 + rateOfInterest, year);

    return amountAfterYear.toInt().toString();
  }
}
