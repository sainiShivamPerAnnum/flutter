// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SipOptions _$SipOptionsFromJson(Map<String, dynamic> json) => SipOptions(
      order: (json['order'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toInt() ?? 0,
      best: json['best'] as bool? ?? false,
    );
