import 'package:app_install_date/app_install_date_imp.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/appflyer_analytics.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/core/service/analytics/clever_tap_analytics.dart';
import 'package:felloapp/core/service/analytics/mixpanel_analytics.dart';
import 'package:felloapp/core/service/analytics/singular_analytics.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalyticsService extends BaseAnalyticsService {
  static const appFlierKey = 'fyD5pxiiDw5DrwynP52oT9';

  final MixpanelAnalytics _mixpanel = locator<MixpanelAnalytics>();
  final AppFlyerAnalytics _appFlyer = locator<AppFlyerAnalytics>();
  final SingularAnalytics _singular = locator<SingularAnalytics>();
  final CleverTapAnalytics _cleverTap = locator<CleverTapAnalytics>();
  final CustomLogger _logger = locator<CustomLogger>();

  @override
  Future<void> login({bool? isOnBoarded, BaseUser? baseUser}) async {
    await _mixpanel.login(isOnBoarded: isOnBoarded, baseUser: baseUser);
    _appFlyer.login(isOnBoarded: isOnBoarded, baseUser: baseUser);
    _singular.login(isOnBoarded: isOnBoarded, baseUser: baseUser);
    _cleverTap.login(isOnBoarded: isOnBoarded, baseUser: baseUser);
    // for daily session event
    DateTime now = DateTime.now();
    final lastDateOpened =
        PreferenceHelper.getInt(PreferenceHelper.DATE_APP_OPENED);

    if (now.day != lastDateOpened) {
      track(eventName: AnalyticsEvents.openAppFirstTimeInADay);
      PreferenceHelper.setInt(PreferenceHelper.DATE_APP_OPENED, now.day);
    }
  }

  @override
  void signOut() {
    _mixpanel.signOut();
    _appFlyer.signOut();
    _singular.signOut();
    _cleverTap.signOut();
  }

  @override
  void track({
    String? eventName,
    Map<String, dynamic>? properties,
    bool mixpanel = true,
    bool webEngage = true,
    bool appFlyer = true,
    bool singular = true,
    bool cleverTap = true,
    bool apxor = false,
  }) {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        String? phone = FirebaseAuth.instance.currentUser!.phoneNumber;
        if (uid != '' && uid.isNotEmpty) properties!['uid'] = uid;
        if (phone != null && phone.isNotEmpty) properties!['mobile'] = phone;
      }
    } catch (e) {}
    try {
      _logger.d(eventName);
      if (mixpanel) {
        _mixpanel.track(eventName: eventName, properties: properties);
      }
      if (appFlyer) {
        _appFlyer.track(eventName: eventName, properties: properties);
      }
      if (singular) {
        _singular.track(eventName: eventName, properties: properties);
      }
      if (cleverTap) {
        _cleverTap.track(eventName: eventName, properties: properties);
      }
    } catch (e) {
      String error = e as String ?? "Unable to track event: $eventName";
      _logger.e(error);
    }
  }

  @override
  void trackScreen({String? screen, Map<String, dynamic>? properties}) {
    _mixpanel.track(eventName: screen, properties: properties);
    _cleverTap.track(eventName: screen, properties: properties);
  }

  Future<void> trackSignup(String? userId) async {
    try {
      final campaignId =
          PreferenceHelper.getString(PreferenceHelper.CAMPAIGN_ID);

      if (campaignId.isEmpty) return;

      Map<String, dynamic> body = {
        "type": Constants.SIGNUP_TRACKING,
        "uid": userId,
        "clickId": campaignId,
      };

      await APIService.instance.postData(
        ApiPath.acquisitionTracking,
        apiName: 'optAnalytics',
        body: body,
      );
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  void trackInstall(String campaignId) async {
    if (campaignId == '') return;
    try {
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
          apiName: 'optAnalytics',
          body: body,
        );
      }
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  void trackUninstall(String token) {
    //only singular does this
    _singular.connectFcm(token);
  }
}
