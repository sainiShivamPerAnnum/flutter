import 'dart:math';

import 'package:collection/collection.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/util/locator.dart';

extension ReturnInvestments on int {
  String getReturns(
    InvestmentType investmentType,
    double amount,
    num? interest, [
    decimalPoint = 2,
  ]) {
    final month = this;
    final num returnPercentage =
        investmentType == InvestmentType.AUGGOLD99 ? 8 : (interest ?? 10);

    return (amount +
            (calculatePercentageInterest(month, returnPercentage) * amount))
        .toStringAsFixed(decimalPoint);
  }

  String calculateCompoundInterest(
    InvestmentType investmentType,
    double principalAmount,
    num? interest,
  ) {
    final period = this;
    final interestRate =
        investmentType == InvestmentType.AUGGOLD99 ? 8 : (interest ?? 10);

    return (principalAmount * (pow(1 + interestRate / 100, period)))
        .toStringAsFixed(0);
  }

  double calculatePercentageInterest(int month, num percentage) =>
      ((percentage * month) / 12) / 100;

  String calculateAmountAfterMaturity(String amount, int year) {
    List<LendboxAssetConfiguration> lendboxDetails =
        AppConfigV2.instance.lbV2.values.toList();
    final floAssetType = locator<LendboxTransactionService>().floAssetType;
    int interest = 1;

    interest = (lendboxDetails
                .firstWhereOrNull((element) => element.fundType == floAssetType)
                ?.interest ??
            10)
        .toInt();

    double principal = double.tryParse(amount) ?? 0.0;
    double rateOfInterest = interest / 100.0;

    double amountAfterYear = principal * pow(1 + rateOfInterest, year);

    return amountAfterYear.toInt().toString();
  }
}
