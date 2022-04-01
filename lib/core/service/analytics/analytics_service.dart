import 'dart:io';

import 'package:app_install_date/app_install_date_imp.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/core/service/analytics/mixpanel_analytics.dart';
import 'package:felloapp/core/service/analytics/webengage_analytics.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';

class AnalyticsService extends BaseAnalyticsService {
  static const appFlierKey = 'fyD5pxiiDw5DrwynP52oT9';

  final _mixpanel = locator<MixpanelAnalytics>();
  final _webengage = locator<WebEngageAnalytics>();
  final _logger = locator<CustomLogger>();
  AppsflyerSdk _appsflyerSdk;

  AnalyticsService() {
    init();
  }

  Future<void> login({bool isOnBoarded, BaseUser baseUser}) async {
    await _mixpanel.login(isOnBoarded: isOnBoarded, baseUser: baseUser);
    _webengage.login(isOnBoarded: isOnBoarded, baseUser: baseUser);
    _appsflyerSdk.setCustomerUserId(baseUser.uid);

    // for daily session event
    DateTime now = DateTime.now();
    final lastDateOpened =
        PreferenceHelper.getInt(PreferenceHelper.DATE_APP_OPENED);

    if (lastDateOpened == null || now.day != lastDateOpened) {
      track(eventName: AnalyticsEvents.openAppFirstTimeInADay);
      PreferenceHelper.setInt(PreferenceHelper.DATE_APP_OPENED, now.day);
    }
  }

  void init() {
    new WebEngagePlugin();
    _initAppFLyer();
  }

  void signOut() {
    _mixpanel.signOut();
    _webengage.signOut();
  }

  void track({String eventName, Map<String, dynamic> properties}) {
    try {
      _logger.d(eventName);
      _mixpanel.track(eventName: eventName, properties: properties);
      _webengage.track(eventName: eventName, properties: properties);

      if (eventName == AnalyticsEvents.signupComplete ||
          eventName == AnalyticsEvents.kycVerificationSuccessful ||
          eventName == AnalyticsEvents.buyGoldSuccess) {
        _appsflyerSdk.logEvent(eventName, properties);
      }
    } catch (e) {
      String error = e ?? "Unable to track event: $eventName";
      _logger.e(error);
    }
  }

  void trackScreen({String screen, Map<String, dynamic> properties}) {
    _mixpanel.track(eventName: screen, properties: properties);
    _webengage.track(eventName: screen, properties: properties);
  }

  void trackSignup(String userId) async {
    try {
      final campaignId =
          PreferenceHelper.getString(PreferenceHelper.CAMPAIGN_ID);

      if (campaignId == null) return;

      Map<String, dynamic> body = {
        "type": Constants.SIGNUP_TRACKING,
        "uid": userId,
        "clickId": campaignId,
      };

      await APIService.instance.postData(
        ApiPath.acquisitionTracking,
        body: body,
      );
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  void trackInstall(String campaignId) async {
    if (campaignId == null) return;
    try {
      if (campaignId != null)
        PreferenceHelper.setString(PreferenceHelper.CAMPAIGN_ID, campaignId);

      // for installation event
      DateTime now = DateTime.now();
      final installationDate = await AppInstallDate().installDate;
      final installationDay =
          PreferenceHelper.getInt(PreferenceHelper.INSTALLATION_DAY);

      if (installationDay == null && now.day == installationDate.day) {
        PreferenceHelper.setInt(PreferenceHelper.INSTALLATION_DAY, now.day);

        Map<String, dynamic> body = {
          "type": Constants.INSTALL_TRACKING,
          "clickId": campaignId,
        };

        await APIService.instance.postData(
          ApiPath.acquisitionTracking,
          body: body,
        );
      }
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  void _initAppFLyer() async {
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
