// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advisor_upcoming_call.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvisorCall _$AdvisorCallFromJson(Map<String, dynamic> json) => AdvisorCall(
      scheduledOn: DateTime.parse(json['scheduledOn'] as String),
      duration: json['duration'] as String,
      userName: json['userName'] as String?,
      hostCode: json['hostCode'] as String?,
      detailsQA: (json['detailsQA'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AdvisorCallToJson(AdvisorCall instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'scheduledOn': instance.scheduledOn.toIso8601String(),
      'duration': instance.duration,
      'hostCode': instance.hostCode,
      'detailsQA': instance.detailsQA,
    };
