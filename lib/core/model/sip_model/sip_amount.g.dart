// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_amount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SipAmount _$SipAmountFromJson(Map<String, dynamic> json) => SipAmount(
      min: json['min'] as int? ?? 0,
      max: json['max'] as int? ?? 1000,
      multiples: json['multiples'] as int? ?? 1,
      defaultValue: json['default'] as int? ?? 1,
    );
