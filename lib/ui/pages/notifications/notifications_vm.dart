import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/alert_model.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';

class NotificationsViewModel extends BaseViewModel {
  //dependencies
  final UserService _userService = locator<UserService>();
  final UserRepository _userRepo = locator<UserRepository>();
  final CustomLogger _logger = locator<CustomLogger>();

  //local variables
  List<AlertModel>? notifications;
  final ScrollController _scrollController = ScrollController();
  bool hasMoreAlerts = true;
  String? lastAlertDocumentId;
  bool _isMoreNotificationsLoading = false;
  int postHighlightIndex = 0;
  String? lastReadLatestNotificationTime;
  int newNotificationsCount = 0;

  bool get isMoreNotificationsLoading => _isMoreNotificationsLoading;

  ScrollController get scrollController => _scrollController;

  set isMoreNotificationsLoading(bool val) {
    _isMoreNotificationsLoading = val;
    notifyListeners();
  }

  void init() async {
    setState(ViewState.Busy);
    lastReadLatestNotificationTime = await (CacheManager.readCache(
        key: CacheManager.CACHE_LATEST_NOTIFICATION_TIME));
    await fetchNotifications(false);
    _scrollController.addListener(() async {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        if (hasMoreAlerts && state == ViewState.Idle) {
          _logger!.d("fetching more alerts...");
          fetchNotifications(true);
        }
      }
    });
    setState(ViewState.Idle);
  }

  fetchNotifications(bool more) async {
    if (more) isMoreNotificationsLoading = true;

    ApiResponse<List<AlertModel>> userNotifications =
        await _userRepo!.getUserNotifications(
      lastAlertDocumentId,
    );
    if (userNotifications.code == 200) {
      _logger!.d("no of alerts fetched: ${userNotifications.model!.length}");
      if (notifications == null || notifications!.length == 0) {
        notifications = userNotifications.model;
      } else {
        postHighlightIndex = notifications!.length - 1;
        appendNotifications(userNotifications.model!);
      }
      lastAlertDocumentId = userNotifications.model!.last.id;
      hasMoreAlerts = userNotifications.model!.length == 20;
      if (!more) {
        await CacheManager.writeCache(
            key: CacheManager.CACHE_LATEST_NOTIFICATION_TIME,
            value: notifications!.first.createdTime!.seconds.toString(),
            type: CacheType.string);
      }
      highlightNewNotifications(postHighlightIndex);
      if (more) isMoreNotificationsLoading = false;
    }
  }

  appendNotifications(List<AlertModel> list) {
    notifications!.addAll(list);
    notifications!.sort(
        (a, b) => b.createdTime!.seconds.compareTo(a.createdTime!.seconds));
    _logger!.d("total alerts now: ${notifications!.length}");
    notifyListeners();
    notifications!.forEach((e) {
      print(e.title);
    });
  }

  highlightNewNotifications(int indexPostHighlight) {
    if (lastReadLatestNotificationTime == null) return;
    for (int i = indexPostHighlight; i < notifications!.length; i++) {
      if (notifications![i].createdTime!.seconds >
          int.tryParse(lastReadLatestNotificationTime!)!) {
        notifications![i].isHighlighted = true;
      }
      newNotificationsCount++;
    }
  }

  updateHighlightStatus(int index) {
    notifications![index].isHighlighted = false;
    notifyListeners();
  }

  String getNotificationAsset(String title) {
    if (title.startsWith(Constants.GOLDEN_TICKET_NOTIFICATION)) {
      return Assets.scratchCardAsset;
    } else if (title.startsWith(Constants.COUPONS_APPLIED_NOTIFICATION)) {
      return Assets.couponsAsset;
    } else if (title.startsWith(Constants.DEPOSIT_COMPLETE_NOTIFICATION)) {
      return Assets.depositCompleteAsset;
    } else {
      return Assets.logoShortform;
    }
  }
}
