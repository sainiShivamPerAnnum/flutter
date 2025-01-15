// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_fds.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentModel _$InvestmentModelFromJson(Map<String, dynamic> json) =>
    InvestmentModel(
      current: json['current'] as String,
      invested: json['invested'] as String,
      netReturns: json['netReturns'] as String,
      avgXIRR: json['avgXIRR'] as String,
      status: json['status'] as String,
    );

FixedDeposit _$FixedDepositFromJson(Map<String, dynamic> json) => FixedDeposit(
      name: json['name'] as String,
      current: json['current'] as String,
      invested: json['invested'] as String,
      avgXIRR: json['avgXIRR'] as String,
      tenure: json['tenure'] as String,
    );
