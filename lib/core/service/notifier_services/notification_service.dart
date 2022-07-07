import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/alert_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class NotificationService extends ChangeNotifier {
  final logger = locator<CustomLogger>();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://6w37rw51hj.execute-api.ap-south-1.amazonaws.com/dev"
      : "";
  Future<bool> checkIfUserHasNewNotifications(String userId) async {
    try {
      logger.i("CALLING: checkForLatestNotification");
      logger.i("KUNJ: checkForLatestAnnouncment");

      final latestNotificationsResponse = await APIService.instance.getData(
            ApiPath.getLatestNotication(userId),
            cBaseUrl: _baseUrl,
          ) ??
          {};

      List<AlertModel> notifications = [];

      for (var element in latestNotificationsResponse["data"] ?? []) {
        notifications.add(AlertModel.fromMap(element));
      }

      String latestNotifTime = await CacheManager.readCache(
          key: CacheManager.CACHE_LATEST_NOTIFICATION_TIME);
      if (latestNotifTime != null) {
        int latestTimeInSeconds = int.tryParse(latestNotifTime);
        AlertModel latestAlert = notifications[0].createdTime.seconds >
                notifications[1].createdTime.seconds
            ? notifications[0]
            : notifications[1];
        if (latestAlert.createdTime.seconds > latestTimeInSeconds)
          return true;
        else
          return false;
      } else {
        logger.d("No past notification time found");
        return false;
      }
    } catch (e) {
      logger.e(e);
    }
    return false;
  }

  Future<Map<String, dynamic>> getUserNotifications(
      String userId, String lastDocId, bool more) async {
    List<AlertModel> notifications = [];
    String lastAlertDoc;
    logger.d("user id - $userId");

    try {
      logger.i("CALLING: getUserNotifications");
      final userNotifications = await APIService.instance.getData(
            ApiPath.getNotications(userId),
            cBaseUrl: _baseUrl,
            queryParams: {
              "lastDocId": lastDocId,
            },
          ) ??
          [];

      for (var element in userNotifications["data"] ?? []) {
        notifications.add(AlertModel.fromMap(element));
      }
      if (notifications.isNotEmpty)
        lastAlertDoc = notifications.last.id;
      else
        lastAlertDoc = "";
    } catch (e) {
      logger.e(e);
    }

    // notifications
    //     .sort((a, b) => b.createdTime.seconds.compareTo(a.createdTime.seconds));

    return {
      'notifications': notifications,
      'lastAlertDoc': lastAlertDoc,
      'alertsLength': 0,
    };
  }
}
