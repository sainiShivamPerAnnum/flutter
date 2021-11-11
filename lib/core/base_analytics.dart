import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class BaseAnalytics {
  static FirebaseAnalytics _analytics;
  static FirebaseAnalyticsObserver _observer;

  static Mixpanel _mixpanel;

  static const String PAGE_FINANCE = 'finance';
  static const String PAGE_GAME = 'game';
  static const String PAGE_HOME = 'home';
  static const String PAGE_PROFILE = 'profile';
  static const String PAGE_TAMBOLA = 'tambola';

  static const String DEV_TOKEN = "6bc0994f4244fc5b193213df643f14dc";
  static const String PROD_TOKEN = "03de57e684d04e87999e089fd605fcdd";

  static init()async {
    _analytics = FirebaseAnalytics();
    _observer = FirebaseAnalyticsObserver(analytics: _analytics);

     _mixpanel = await Mixpanel.init(FlavorConfig.instance.values.mixpanelToken, optOutTrackingDefault: false);
    _mixpanel.track("tester");
    _mixpanel.track('Plan Selected', properties: {'Plan': 'Shourya'});
  }

  static logUserProfile(BaseUser user) async {
    try {
      await _analytics.setUserId(user.uid);
    } catch (e) {
      print('User ID Analytics failed');
    }
    await _analytics.setUserProperty(name: 'user_gender', value: user.gender);
    await _analytics.setUserProperty(
        name: 'fresh_investor', value: (user.isInvested) ? 'N' : 'Y');
  }

  static logProfilePictureAdded() {
    _analytics.logEvent(
        name: 'has_profile_pic', parameters: <String, dynamic>{'option': true});
  }

  static logIciciStarted() {
    _analytics.logEvent(
        name: 'icici_reg_started',
        parameters: <String, dynamic>{'option': true});
  }

  static logIciciRegistered() {
    _analytics.logEvent(
        name: 'icici_reg_comp', parameters: <String, dynamic>{'option': true});
  }

  static logAugmontStarted() {
    _analytics.logEvent(
        name: 'aug_reg_started', parameters: <String, dynamic>{'option': true});
  }

  static logAugmontRegistered() {
    _analytics.logEvent(
        name: 'aug_reg_comp', parameters: <String, dynamic>{'option': true});
  }

  static FirebaseAnalytics get analytics => _analytics;
}
