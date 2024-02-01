// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculator_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculatorDetails _$CalculatorDetailsFromJson(Map<String, dynamic> json) =>
    CalculatorDetails(
      sipAmount: json['sipAmount'] == null
          ? null
          : SipAmount.fromJson(json['sipAmount'] as Map<String, dynamic>),
      timePeriod: json['timePeriod'] == null
          ? null
          : SipAmount.fromJson(json['timePeriod'] as Map<String, dynamic>),
      interest: json['interest'] as Map<String, dynamic>?,
      numberOfPeriodsPerYear: json['numberOfPeriodsPerYear'] as int?,
    );
