// ignore_for_file: one_member_abstracts

import 'dart:async';

import 'package:felloapp/core/service/fcm/fcm_handler_v2/payload.dart';
import 'package:felloapp/util/custom_logger.dart';

import '../in_app_notification/in_app_notification_handler.dart'
    as in_app_handler;

class FcmHandlerV2 {
  const FcmHandlerV2(this._logger);
  final CustomLogger _logger;

  Future<void> call(Map<String, dynamic> data) async {
    try {
      final v2 = NotificationPayloadV2.fromJson(data);
      final handler = NotificationHandler.fromNotificationType(v2.type);
      await handler(v2.payload);
    } catch (e, stack) {
      _logger.e('FcmHandlerV2: failed to handle notification', e, stack);
    }
  }
}

abstract interface class NotificationHandler {
  const NotificationHandler();

  factory NotificationHandler.fromNotificationType(NotificationType type) {
    switch (type) {
      case NotificationType.inApp:
        return InAppNotificationHandler();
    }
  }

  FutureOr<void> call(Map<String, dynamic> data);
}

final class InAppNotificationHandler implements NotificationHandler {
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
