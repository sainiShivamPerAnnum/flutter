// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculator_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculatorData _$CalculatorDataFromJson(Map<String, dynamic> json) =>
    CalculatorData(
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      data: (json['data'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, CalculatorDetails.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );
