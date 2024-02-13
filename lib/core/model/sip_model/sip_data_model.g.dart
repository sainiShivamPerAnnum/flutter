// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SipData _$SipDataFromJson(Map<String, dynamic> json) => SipData(
      selectAssetScreen: SelectAssetScreen.fromJson(
          json['selectAssetScreen'] as Map<String, dynamic>),
      calculatorScreen: CalculatorScreen.fromJson(
          json['calculatorScreen'] as Map<String, dynamic>),
      amountSelectionScreen: SipAmountSelection.fromJson(
          json['amountSelectionScreen'] as Map<String, dynamic>),
    );
