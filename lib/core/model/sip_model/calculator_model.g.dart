// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculatorScreen _$CalculatorScreenFromJson(Map<String, dynamic> json) =>
    CalculatorScreen(
      title: json['title'] as String?,
      imageUrl: json['imageUrl'] as String?,
      calculatorData: json['calculatorData'] == null
          ? null
          : CalculatorData.fromJson(
              json['calculatorData'] as Map<String, dynamic>),
    );
