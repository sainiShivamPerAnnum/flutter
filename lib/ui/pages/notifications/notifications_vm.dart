import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/alert_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';

class NotificationsViewModel extends BaseModel {
  //dependencies
  final _dbModel = locator<DBModel>();
  final _userService = locator<UserService>();
  final _logger = locator<CustomLogger>();

  //local variables
  List<AlertModel> notifications;
  ScrollController _scrollController = new ScrollController();
  bool hasMoreAlerts = true;
  DocumentSnapshot lastAlertDocument;
  bool _isMoreNotificationsLoading = false;
  int postHighlightIndex = 0;
  String lastReadLatestNotificationTime;
  int newNotificationsCount = 0;

  bool get isMoreNotificationsLoading => _isMoreNotificationsLoading;

  ScrollController get scrollController => _scrollController;

  set isMoreNotificationsLoading(bool val) {
    _isMoreNotificationsLoading = val;
    notifyListeners();
  }

  void init() async {
    setState(ViewState.Busy);
    lastReadLatestNotificationTime = await CacheManager.readCache(
        key: CacheManager.CACHE_LATEST_NOTIFICATION_TIME);
    await fetchNotifications(false);
    _scrollController.addListener(() async {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        if (hasMoreAlerts && state == ViewState.Idle) {
          _logger.d("fetching more alerts...");
          fetchNotifications(true);
        }
      }
    });
    setState(ViewState.Idle);
  }

  fetchNotifications(bool more) async {
    if (more) isMoreNotificationsLoading = true;

    Map<String, dynamic> aMap = await _dbModel.getUserNotifications(
        _userService.baseUser.uid, lastAlertDocument, more);
    _logger.d("no of alerts fetched: ${aMap['notifications'].length}");
    if (notifications == null || notifications.length == 0) {
      notifications = aMap['notifications'];
    } else {
      postHighlightIndex = notifications.length - 1;
      appendNotifications(aMap['notifications']);
    }
    lastAlertDocument = aMap['lastAlertDoc'];
    hasMoreAlerts = aMap['alertsLength'] == 20;
    if (!more) {
      await CacheManager.writeCache(
          key: CacheManager.CACHE_LATEST_NOTIFICATION_TIME,
          value:
              notifications.first.createdTime.millisecondsSinceEpoch.toString(),
          type: CacheType.string);
    }
    highlightNewNotifications(postHighlightIndex);
    if (more) isMoreNotificationsLoading = false;
  }

  appendNotifications(List<AlertModel> list) {
    notifications.addAll(list);
    notifications
        .sort((a, b) => b.createdTime.seconds.compareTo(a.createdTime.seconds));
    _logger.d("total alerts now: ${notifications.length}");
    notifyListeners();
    notifications.forEach((e) {
      print(e.title);
    });
  }

  highlightNewNotifications(int indexPostHighlight) {
    if (lastReadLatestNotificationTime == null) return;
    for (int i = indexPostHighlight; i < notifications.length; i++) {
      if (notifications[i].createdTime.millisecondsSinceEpoch >
          int.tryParse(lastReadLatestNotificationTime))
        notifications[i].isHighlighted = true;
      newNotificationsCount++;
    }
  }

  updateHighlightStatus(int index) {
    notifications[index].isHighlighted = false;
    notifyListeners();
  }
}
