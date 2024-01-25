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
  InAppNotificationType.snackbar: 'snackbar',
};

PopupNotification _$PopupNotificationFromJson(Map<String, dynamic> json) =>
    PopupNotification(
      json['image'] as String,
      json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
    );

SnackbarNotification _$SnackbarNotificationFromJson(
        Map<String, dynamic> json) =>
    SnackbarNotification(
      json['title'] as String,
      json['subTitle'] as String,
    );
