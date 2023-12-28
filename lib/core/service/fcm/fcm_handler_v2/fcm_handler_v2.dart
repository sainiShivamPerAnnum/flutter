// ignore_for_file: one_member_abstracts

import 'dart:async';

import 'package:felloapp/core/service/fcm/fcm_handler_v2/payload.dart';

import '../in_app_notification/in_app_notification_handler.dart'
    as in_app_handler;

class FcmHandlerV2 {
  const FcmHandlerV2._();

  static const instance = FcmHandlerV2._();

  Future<void> handle(Map<String, dynamic> data) async {
    final v2 = NotificationPayloadV2.fromJson(data);
    final handler = NotificationHandler.fromNotificationType(v2.type);
    await handler(v2.payload);
  }
}

abstract class NotificationHandler {
  const NotificationHandler();

  factory NotificationHandler.fromNotificationType(NotificationType type) {
    switch (type) {
      case NotificationType.inApp:
        return InAppNotificationHandler();
    }
  }

  FutureOr<void> call(Map<String, dynamic> data);
}

final class InAppNotificationHandler extends NotificationHandler {
  @override
  FutureOr<void> call(Map<String, dynamic> data) async {
    final notification = in_app_handler.InAppNotificationPayload.fromJson(data);
    final handler =
        in_app_handler.InAppNotificationHandler.fromNotificationType(
      notification.type,
    );
    await handler(notification.payload);
  }
}
