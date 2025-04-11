// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rps_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RpsData _$RpsDataFromJson(Map<String, dynamic> json) => RpsData(
      uid: json['uid'] as String,
      principleAmount: (json['principleAmount'] as num).toDouble(),
      fundType: json['fundType'] as String,
      tenure: (json['tenure'] as num).toInt(),
      accuredInterest: (json['accuredInterest'] as num).toDouble(),
      rps: (json['rps'] as List<dynamic>)
          .map((e) => Rps.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$RpsDataToJson(RpsData instance) => <String, dynamic>{
      'uid': instance.uid,
      'principleAmount': instance.principleAmount,
      'fundType': instance.fundType,
      'tenure': instance.tenure,
      'accuredInterest': instance.accuredInterest,
      'rps': instance.rps,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

Rps _$RpsFromJson(Map<String, dynamic> json) => Rps(
      timeline: json['timeline'] as String,
      scheduledAmount: (json['scheduledAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      paidInterest: (json['paidInterest'] as num).toDouble(),
      isPaid: json['isPaid'] as bool,
    );

Map<String, dynamic> _$RpsToJson(Rps instance) => <String, dynamic>{
      'timeline': instance.timeline,
      'scheduledAmount': instance.scheduledAmount,
      'paidAmount': instance.paidAmount,
      'paidInterest': instance.paidInterest,
      'isPaid': instance.isPaid,
    };
