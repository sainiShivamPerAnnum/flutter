// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SipData _$SipDataFromJson(Map<String, dynamic> json) => SipData(
      selectAssetScreen: json['selectAssetScreen'] == null
          ? null
          : SelectAssetScreen.fromJson(
              json['selectAssetScreen'] as Map<String, dynamic>),
      calculatorScreen: json['calculatorScreen'] == null
          ? null
          : CalculatorScreen.fromJson(
              json['calculatorScreen'] as Map<String, dynamic>),
    );
