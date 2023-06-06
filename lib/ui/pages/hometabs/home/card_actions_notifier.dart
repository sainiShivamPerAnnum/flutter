import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/foundation.dart';

class CardActionsNotifier extends ChangeNotifier {
  bool _isVerticalView = false;
  bool _isHorizontalView = false;
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final UserService _userService = locator<UserService>();
  bool get isHorizontalView => _isHorizontalView;

  set isHorizontalView(bool value) {
    // if (_isHorizontalView != value) {
    _isHorizontalView = value;
    Haptic.vibrate();
    notifyListeners();
    if (_isHorizontalView == true) {
      _analyticsService.track(
          eventName: AnalyticsEvents.balanceCardHorizontalSwiped,
          properties: {
            "fello balance": _userService.userPortfolio.absolute.balance
          });
    }
    // }
  }

  bool get isVerticalView => _isVerticalView;

  set isVerticalView(bool value) {
    // if (_isVerticalView != value) {
    _isVerticalView = value;
    Haptic.vibrate();
    notifyListeners();
    if (_isVerticalView == true) {
      _analyticsService.track(
          eventName: AnalyticsEvents.balanceCardVerticalSwiped,
          properties: {
            "fello balance": _userService.userPortfolio.absolute.balance
          });
    }
    // }
  }
}
