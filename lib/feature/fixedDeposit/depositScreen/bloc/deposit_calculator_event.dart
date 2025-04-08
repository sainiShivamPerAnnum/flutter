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

  const UpdateFDVariables({
    required this.investmentAmount,
    required this.investmentPeriod,
    required this.isSeniorCitizen,
    required this.payoutFrequency,
    required this.isFemale,
    required this.issuerId,
  });
}

class OnProceed extends FDCalculatorEvents {
  final String issuerId;
  final String blostemId;
  const OnProceed({
    required this.issuerId,
    required this.blostemId,
  });
}

class RestoreLastFDCalculation extends FDCalculatorEvents {
  final double? investmentAmount;
  final int? investmentPeriod;
  final bool? isSeniorCitizen;
  final String? payoutFrequency;
  final bool? isFemale;
  final String? issuerId;

  const RestoreLastFDCalculation({
    this.investmentAmount,
    this.investmentPeriod,
    this.isSeniorCitizen,
    this.payoutFrequency,
    this.isFemale,
    this.issuerId,
  });
}
