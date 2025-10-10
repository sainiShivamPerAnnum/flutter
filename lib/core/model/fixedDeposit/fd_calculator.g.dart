// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fd_calculator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FDInterestModel _$FDInterestModelFromJson(Map<String, dynamic> json) =>
    FDInterestModel(
      success: json['success'] as bool,
      data: json['data'] == null
          ? null
          : FDCalculator.fromJson(json['data'] as Map<String, dynamic>),
    );

FDCalculator _$FDCalculatorFromJson(Map<String, dynamic> json) => FDCalculator(
      totalInterest: json['totalInterest'] as String?,
      maturityAmount: json['maturityAmount'] as String?,
      interestRate: json['interestRate'] as num?,
    );
