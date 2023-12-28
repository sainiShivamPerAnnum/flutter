// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPayloadV2 _$NotificationPayloadV2FromJson(
        Map<String, dynamic> json) =>
    NotificationPayloadV2(
      $enumDecode(_$NotificationTypeEnumMap, json['type']),
      json['payload'] as Map<String, dynamic>,
    );

const _$NotificationTypeEnumMap = {
  NotificationType.inApp: 'inApp',
};
