// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fd_deposit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FdCalculator _$FdCalculatorFromJson(Map<String, dynamic> json) => FdCalculator(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      investmentOptions: (json['investmentOptions'] as List<dynamic>)
          .map((e) => InvestmentOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      lockInTenure: (json['lockInTenure'] as List<dynamic>)
          .map((e) => LockInTenure.fromJson(e as Map<String, dynamic>))
          .toList(),
      interestRates: (json['interestRates'] as List<dynamic>)
          .map((e) => InterestRate.fromJson(e as Map<String, dynamic>))
          .toList(),
      interestPayout: json['interestPayout'] as String,
      estimatedPayout: EstimatedPayout.fromJson(
          json['estimatedPayout'] as Map<String, dynamic>),
      cta: Cta.fromJson(json['cta'] as Map<String, dynamic>),
    );

InvestmentOption _$InvestmentOptionFromJson(Map<String, dynamic> json) =>
    InvestmentOption(
      amount: json['amount'] as String,
    );

LockInTenure _$LockInTenureFromJson(Map<String, dynamic> json) => LockInTenure(
      range: json['range'] as String,
    );

InterestRate _$InterestRateFromJson(Map<String, dynamic> json) => InterestRate(
      tenure: json['tenure'] as String,
      general: json['general'] as String,
      seniorCitizen: json['seniorCitizen'] as String,
    );

EstimatedPayout _$EstimatedPayoutFromJson(Map<String, dynamic> json) =>
    EstimatedPayout(
      amount: json['amount'] as String,
      returns: json['returns'] as String,
    );

Cta _$CtaFromJson(Map<String, dynamic> json) => Cta(
      investNow: json['investNow'] as String,
      bookACall: json['bookACall'] as String,
      bookNow: json['bookNow'] as String,
      appointmentCount: json['appointmentCount'] as String,
    );
