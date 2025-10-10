// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_amount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SipAmount _$SipAmountFromJson(Map<String, dynamic> json) => SipAmount(
      min: (json['min'] as num?)?.toInt() ?? 0,
      max: (json['max'] as num?)?.toInt() ?? 1000,
      multiples: (json['multiples'] as num?)?.toInt() ?? 1,
      defaultValue: (json['default'] as num?)?.toInt() ?? 1,
    );
