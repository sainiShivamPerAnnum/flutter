import 'package:felloapp/core/model/action.dart';
import 'package:json_annotation/json_annotation.dart';

part 'in_app_notification_payload.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

enum InAppNotificationType {
  popUp,
  snackbar,
}

@_deserializable
class InAppNotificationPayload {
  final InAppNotificationType type;
  final Map<String, dynamic> payload;

  const InAppNotificationPayload(
    this.type,
    this.payload,
  );

  factory InAppNotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$InAppNotificationPayloadFromJson(json);
}

@_deserializable
class PopupNotification {
  final String image;
  final Action? action;

  const PopupNotification(
    this.image,
    this.action,
  );

  factory PopupNotification.fromJson(Map<String, dynamic> json) =>
      _$PopupNotificationFromJson(json);
}

@_deserializable
class SnackbarNotification {
  final String title;
  final String subTitle;

  const SnackbarNotification(
    this.title,
    this.subTitle,
  );

  factory SnackbarNotification.fromJson(Map<String, dynamic> json) =>
      _$SnackbarNotificationFromJson(json);
}
