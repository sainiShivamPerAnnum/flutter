import 'package:felloapp/core/model/shorts/shorts_notification.dart';
import 'package:felloapp/core/repository/shorts_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/bloc_pagination/bloc_pagination.dart';

class ShortsNotificationBloc
    extends PaginationBloc<dynamic, ShortsNotification, int, Object> {
  ShortsNotificationBloc({
    required ShortsRepository shortsRepository,
  }) : super(
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
}
