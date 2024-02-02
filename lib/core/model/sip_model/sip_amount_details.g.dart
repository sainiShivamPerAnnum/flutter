// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_amount_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SipAmountDetails _$SipAmountDetailsFromJson(Map<String, dynamic> json) =>
    SipAmountDetails(
      minamount: json['minamount'] as int?,
      numberOfPeriodsPerYear: json['numberOfPeriodsPerYear'] as int?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => SipOptions.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
