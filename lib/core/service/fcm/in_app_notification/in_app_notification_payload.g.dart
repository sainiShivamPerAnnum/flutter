// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_notification_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InAppNotificationPayload _$InAppNotificationPayloadFromJson(
        Map<String, dynamic> json) =>
    InAppNotificationPayload(
      $enumDecode(_$InAppNotificationTypeEnumMap, json['type']),
      json['payload'] as Map<String, dynamic>,
    );

const _$InAppNotificationTypeEnumMap = {
  InAppNotificationType.popUp: 'popUp',
};

PopupNotification _$PopupNotificationFromJson(Map<String, dynamic> json) =>
    PopupNotification(
      json['image'] as String,
      Action.fromJson(json['action'] as Map<String, dynamic>),
    );
