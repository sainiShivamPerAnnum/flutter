part of 'deposit_calculator_bloc.dart';

sealed class FDCalculatorEvents {
  const FDCalculatorEvents();
}

class LoadFDCalculator extends FDCalculatorEvents {
  const LoadFDCalculator();
}

class UpdateFDVariables extends FDCalculatorEvents {
  final double investmentAmount;
  final int investmentPeriod;
  final bool isSeniorCitizen;
  final String payoutFrequency;
  final bool isFemale;
  final String issuerId;
  final num minAmount;

  const UpdateFDVariables({
    required this.investmentAmount,
    required this.investmentPeriod,
    required this.isSeniorCitizen,
    required this.payoutFrequency,
    required this.isFemale,
    required this.issuerId,
    required this.minAmount,
  });
}

class OnProceed extends FDCalculatorEvents {
  final String issuerId;
  final String blostemId;
  final num minAmount;
  final double investmentAmount;
  const OnProceed({
    required this.issuerId,
    required this.blostemId,
    required this.minAmount,
    required this.investmentAmount,
  });
}

class RestoreLastFDCalculation extends FDCalculatorEvents {
  final double? investmentAmount;
  final int? investmentPeriod;
  final bool? isSeniorCitizen;
  final String? payoutFrequency;
  final bool? isFemale;
  final String? issuerId;
  final num? minAmount;

  const RestoreLastFDCalculation({
    this.investmentAmount,
    this.investmentPeriod,
    this.isSeniorCitizen,
    this.payoutFrequency,
    this.isFemale,
    this.issuerId,
    this.minAmount,
  });
}
