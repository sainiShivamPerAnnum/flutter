// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_amount_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SipAmountSelection _$SipAmountSelectionFromJson(Map<String, dynamic> json) =>
    SipAmountSelection(
      title: json['title'] as String?,
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      data: (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, SipAmountDetails.fromJson(e as Map<String, dynamic>)),
      ),
    );
