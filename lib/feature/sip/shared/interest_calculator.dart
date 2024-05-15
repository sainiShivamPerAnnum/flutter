import 'dart:math';

import 'package:collection/collection.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/sip_model/select_asset_options.dart';
import 'package:felloapp/feature/sip/cubit/sip_data_holder.dart';

class SipCalculation {
  static int calculateMaturityValue(
      int principal, double interest, int numberOfInvestments) {
    double compoundInterest =
        ((pow(1 + interest, numberOfInvestments) - 1) / interest) *
            (1 + interest);
    double M = principal * compoundInterest;
    return M.round();
  }

  static String getReturn({
    required int formAmount,
    required bool interestOnly,
    AssetOptions? currentAsset,
    int? currentTab,
    int? numberOfYears,
    String? frequency,
    num? interestSelection,
  }) {
    int numberOfPeriodsPerYear = SipDataHolder
        .instance
        .data
        .amountSelectionScreen
        .data[frequency ??
            SipDataHolder
                .instance.data.amountSelectionScreen.options[currentTab ?? 0]]!
        .numberOfPeriodsPerYear;

    num? interest = interestSelection ??
        SipDataHolder.instance.data.selectAssetScreen.options
            .firstWhereOrNull((element) => element.type == currentAsset!.type)
            ?.interest ??
        8;
    if (interest == null) {
      return 'N/A';
    }
    double interestRate = (interest * .01) / numberOfPeriodsPerYear;
    int numberOfYear = numberOfYears ?? 5;

    int numberOfInvestments = numberOfYear * numberOfPeriodsPerYear;
    int totalPrincipal = formAmount * numberOfInvestments;
    final maturityValue =
        calculateMaturityValue(formAmount, interestRate, numberOfInvestments);
    final totalValue =
        interestOnly ? maturityValue - totalPrincipal : maturityValue;
    return BaseUtil.formatCompactRupees(double.parse(totalValue.toString()));
  }

  static int getPrincipal({
    required int formAmount,
    required int? currentTab,
    int? numberOfYears,
  }) {
    int numberOfPeriodsPerYear = SipDataHolder
        .instance
        .data
        .amountSelectionScreen
        .data[SipDataHolder
            .instance.data.amountSelectionScreen.options[currentTab ?? 0]]!
        .numberOfPeriodsPerYear;

    int numberOfYear = numberOfYears ?? 5;

    int numberOfInvestments = numberOfYear * numberOfPeriodsPerYear;
    int totalPrincipal = formAmount * numberOfInvestments;
    return totalPrincipal;
  }
}
