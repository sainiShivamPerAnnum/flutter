import 'dart:async';
import 'package:felloapp/core/model/shorts/shorts_notification.dart';
import 'package:felloapp/core/repository/shorts_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/bloc_pagination/bloc_pagination.dart';

class ShortsNotificationWrapperBloc
    extends PaginationBloc<dynamic, ShortsNotification, int, Object> {
  final ShortsRepository _shortsRepository;
  ShortsNotificationWrapperBloc({
    required ShortsRepository shortsRepository,
  })  : _shortsRepository = shortsRepository,
        super(
          initialPageReference: 1,
          resultConverterCallback: (result) {
            return result.notifications;
          },
          paginationCallBack: (pageReference) async {
            ApiResponse<ShortsNotification> response = await shortsRepository
                .getShortsNotification(page: pageReference);
            if (response.isSuccess()) {
              return PaginationResult.success(
                result: response.model!,
              );
            } else {
              return PaginationResult.failure(
                error: response.errorMessage ?? 'Failed to load notifications',
              );
            }
          },
          referenceConverterCallBack: (result, previousState, interrupter) {
            if (result.totalPages <= result.page) {
              interrupter.call();
            }
            return result.page + 1;
          },
        );

  final Set<String> unseenNotificationIds = {};

  Future<void> batchUpdateNotifications(
    List<String> notificationIds,
  ) async {
    await _shortsRepository.updateNotifications(notifications: notificationIds);
    unseenNotificationIds.clear();
  }

  void trackUnseenNotification(String notificationId) {
    unseenNotificationIds.add(notificationId);
  }

  @override
  void dispose() {
    super.dispose();
    if (unseenNotificationIds.isNotEmpty) {
      batchUpdateNotifications(unseenNotificationIds.toList());
    }
  }
}
