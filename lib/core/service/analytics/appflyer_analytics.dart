import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class AppFlyerAnalytics extends BaseAnalyticsService {
  AppsflyerSdk _appsflyerSdk;
  final _logger = locator<CustomLogger>();

  Future<void> login({bool isOnBoarded, BaseUser baseUser}) async {
    _appsflyerSdk.setCustomerUserId(baseUser.uid);
  }

  AppFlyerAnalytics() {
    init();
  }

  void signOut() {}

  void track({String eventName, Map<String, dynamic> properties}) {
    try {
      _appsflyerSdk.logEvent(eventName, properties);
    } catch (e) {
      String error = e ?? "Unable to track event: $eventName";
      _logger.e(error);
    }
  }

  void trackScreen({String screen, Map<String, dynamic> properties}) {
    try {
      _logger.d('analytics : $screen');
      WebEngagePlugin.trackScreen(screen, properties);
    } catch (e) {
      String error = e ?? "Unable to track screen event: $screen";
      _logger.e(error);
    }
  }

  void init() async {
    try {
      AppsFlyerOptions appsFlyerOptions = new AppsFlyerOptions(
        afDevKey: AnalyticsService.appFlierKey,
        appId: Platform.isIOS ? '1558445254' : 'in.fello.felloapp',
        showDebug: FlavorConfig.isDevelopment(),
        disableAdvertisingIdentifier: false,
        timeToWaitForATTUserAuthorization: 0,
      );

      _appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
      await _appsflyerSdk.initSdk();

      _logger.d('appflyer initialized');
    } catch (e) {
      _logger.e(e.toString());
    }
  }
}
