import 'dart:async';
import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
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
  Future<String> _appFlyerId;
  BaseUser _baseUser;

  Future<String> get appFlyerId => _appFlyerId;

  Future<void> login({bool isOnBoarded, BaseUser baseUser}) async {
    _baseUser = baseUser;
    _appsflyerSdk.setCustomerUserId(baseUser.uid);
  }

  AppFlyerAnalytics() {
    _appFlyerId = init();
  }

  void signOut() {}

  void track({String eventName, Map<String, dynamic> properties}) {
    try {
      _appsflyerSdk.logEvent(eventName, properties ?? {});
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

  Future<String> init() async {
    String id = '';

    try {
      AppsFlyerOptions appsFlyerOptions = new AppsFlyerOptions(
        afDevKey: AnalyticsService.appFlierKey,
        appId: Platform.isIOS ? '1558445254' : 'in.fello.felloapp',
        showDebug: true,
        disableAdvertisingIdentifier: false,
        timeToWaitForATTUserAuthorization: 0,
      );

      _appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
      _appsflyerSdk.setAppInviteOneLinkID('uxu0', (res) {
        _logger.d("appsflyer setAppInviteOneLinkID callback:" + res.toString());
      });

      await _appsflyerSdk.initSdk();
      id = await _appsflyerSdk.getAppsFlyerUID();

      _appsflyerSdk.onDeepLinking((DeepLinkResult result) {
        _logger.d('appflyer deeplink $result');
      });

      _logger.d('appflyer initialized');
    } catch (e) {
      _logger.e('appflyer $e');
    }

    return id;
  }

// TTL for link generated is 31 days, so we can cache this link for 31 days.
  Future<dynamic> inviteLink() async {
    final inviteLinkParams = new AppsFlyerInviteLinkParams(
      channel: 'User_invite',
      campaign: 'Referral',
      referrerName: _baseUser.name,
      customerID: _baseUser.uid,
      customParams: {"code": 'vABo'},
    );

    final Completer<dynamic> completer = Completer();
    _appsflyerSdk.generateInviteLink(inviteLinkParams, (success) {
      _logger.d('appflyer invite link $success');
      completer.complete(success);
    }, (error) {
      _logger.d('appflyer invite link $error');
      completer.completeError(error);
    });

    return completer.future;
  }
}
