import 'package:json_annotation/json_annotation.dart';

part 'fd_deposit.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class FdCalculator {
  final String id;
  final String displayName;
  final String description;
  final List<InvestmentOption> investmentOptions;
  final List<LockInTenure> lockInTenure;
  final List<InterestRate> interestRates;
  final String interestPayout;
  final EstimatedPayout estimatedPayout;
  final Cta cta;

  FdCalculator({
    required this.id,
    required this.displayName,
    required this.description,
    required this.investmentOptions,
    required this.lockInTenure,
    required this.interestRates,
    required this.interestPayout,
    required this.estimatedPayout,
    required this.cta,
  });

  factory FdCalculator.fromJson(Map<String, dynamic> json) =>
      _$FdCalculatorFromJson(json);
}

@_deserializable
class InvestmentOption {
  final String amount;

  InvestmentOption({
    required this.amount,
  });

  factory InvestmentOption.fromJson(Map<String, dynamic> json) =>
      _$InvestmentOptionFromJson(json);
}

@_deserializable
class LockInTenure {
  final String range;

  LockInTenure({
    required this.range,
  });

  factory LockInTenure.fromJson(Map<String, dynamic> json) =>
      _$LockInTenureFromJson(json);
}

@_deserializable
class InterestRate {
  final String tenure;
  final String general;
  final String seniorCitizen;

  InterestRate({
    required this.tenure,
    required this.general,
    required this.seniorCitizen,
  });

  factory InterestRate.fromJson(Map<String, dynamic> json) =>
      _$InterestRateFromJson(json);
}

@_deserializable
class EstimatedPayout {
  final String amount;
  final String returns;

  EstimatedPayout({
    required this.amount,
    required this.returns,
  });

  factory EstimatedPayout.fromJson(Map<String, dynamic> json) =>
      _$EstimatedPayoutFromJson(json);
}

@_deserializable
class Cta {
  final String investNow;
  final String bookACall;
  final String bookNow;
  final String appointmentCount;

  Cta({
    required this.investNow,
    required this.bookACall,
    required this.bookNow,
    required this.appointmentCount,
  });

  factory Cta.fromJson(Map<String, dynamic> json) => _$CtaFromJson(json);
}
