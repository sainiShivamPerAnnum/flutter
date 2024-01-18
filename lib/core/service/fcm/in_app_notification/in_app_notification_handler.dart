// ignore_for_file: one_member_abstracts

import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/fcm/in_app_notification/ui/pop_up_notification.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:flutter/material.dart';

import 'in_app_notification_payload.dart';

export 'in_app_notification_payload.dart';

abstract interface class InAppNotificationHandler {
  const InAppNotificationHandler();

  factory InAppNotificationHandler.fromNotificationType(
      InAppNotificationType type) {
    switch (type) {
      case InAppNotificationType.popUp:
        return PopUpNotificationHandler();
      case InAppNotificationType.snackbar:
        return SnackBarNotificationHandler();
    }
  }

  FutureOr<void> call(Map<String, dynamic> payload);
}

final class SnackBarNotificationHandler implements InAppNotificationHandler {
  @override
  FutureOr<void> call(Map<String, dynamic> payload) {
    final snackBarNotificationData = SnackbarNotification.fromJson(
      payload,
    );

    BaseUtil.showPositiveAlert(
      snackBarNotificationData.title,
      snackBarNotificationData.subTitle,
    );
  }
}

final class PopUpNotificationHandler implements InAppNotificationHandler {
  @override
  FutureOr<void> call(Map<String, dynamic> payload) async {
    final popUpData = PopupNotification.fromJson(
      payload,
    );

    // Caches images in local flutter engine before showing dialog, to avoid
    // image downloading inside Image component as future.
    await precacheImage(
      NetworkImage(popUpData.image),
      AppState.delegate!.navigatorKey.currentContext!,
    );

    await BaseUtil.openDialog(
      isBarrierDismissible: true,
      addToScreenStack: true,
      content: PopupNotificationView(
        popUpData,
      ),
    );
  }
}
