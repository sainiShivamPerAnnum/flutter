// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculator_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculatorDetails _$CalculatorDetailsFromJson(Map<String, dynamic> json) =>
    CalculatorDetails(
      sipAmount: SipAmount.fromJson(json['sipAmount'] as Map<String, dynamic>),
      timePeriod:
          SipAmount.fromJson(json['timePeriod'] as Map<String, dynamic>),
      interest: json['interest'] as Map<String, dynamic>? ?? const {},
      numberOfPeriodsPerYear: json['numberOfPeriodsPerYear'] as int? ?? 1,
    );
