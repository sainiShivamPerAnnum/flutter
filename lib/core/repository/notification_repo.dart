import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/alert_model.dart';
import 'package:felloapp/core/model/user_notification_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class NotificationRepository extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://6w37rw51hj.execute-api.ap-south-1.amazonaws.com/dev"
      : "";

  Future<ApiResponse<bool>> checkIfUserHasNewNotifications() async {
    try {
      final latestNotificationsResponse = await APIService.instance.getData(
        ApiPath.getLatestNotication(this.userService.baseUser.uid),
        cBaseUrl: _baseUrl,
      );

      List<AlertModel> notifications = [];

      for (var element in latestNotificationsResponse["data"]) {
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
          return ApiResponse<bool>(model: true, code: 200);
        else
          return ApiResponse<bool>(model: false, code: 200);
      } else {
        logger.d("No past notification time found");
        return ApiResponse<bool>(model: false, code: 200);
      }
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(
        "Unable to fetch checkIfUserHasNewNotifications",
        400,
      );
    }
  }

  Future<ApiResponse<UserNotificationModel>> getUserNotifications(
    String lastDocId,
  ) async {
    List<AlertModel> notifications = [];
    String lastAlertDoc;
    try {
      final userNotifications = await APIService.instance.getData(
        ApiPath.getNotications(this.userService.baseUser.uid),
        cBaseUrl: _baseUrl,
        queryParams: {
          "lastDocId": lastDocId,
        },
      );

      for (var element in userNotifications["data"]) {
        notifications.add(AlertModel.fromMap(element));
      }
      if (notifications.isNotEmpty)
        lastAlertDoc = notifications.last.id;
      else
        lastAlertDoc = "";

      return ApiResponse<UserNotificationModel>(
        model: UserNotificationModel.fromMap(
          {
            "notifications": notifications,
            "lastDocId": lastAlertDoc,
            "alertsLength": notifications.length,
          },
        ),
        code: 200,
      );
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(
        "Unable to fetch user notifications",
        400,
      );
    }
  }
}
