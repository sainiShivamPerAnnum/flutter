import 'package:felloapp/core/model/BaseUser.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class BaseAnalytics{
  static FirebaseAnalytics _analytics;
  static FirebaseAnalyticsObserver _observer;

  static const String PAGE_FINANCE = 'finance';
  static const String PAGE_GAME = 'game';
  static const String PAGE_HOME = 'home';
  static const String PAGE_PROFILE = 'profile';
  static const String PAGE_TAMBOLA = 'tambola';

  static init() {
    _analytics = FirebaseAnalytics();
    _observer =
    FirebaseAnalyticsObserver(analytics: _analytics);
  }
  
  static logUserProfile(BaseUser user) {
    try{
      _analytics.setUserId(user.uid);
    }catch(e) {
      print('User ID Analytics failed');
    }
    _analytics.setUserProperty(name: 'user_gender', value: user.gender);
    _analytics.setUserProperty(name: 'fresh_investor', value: (user.isInvested)?'N':'Y');
  }
  
  static logIciciStarted() {
    _analytics.logEvent(name: 'icici_reg_started',parameters: <String, dynamic>{
      'option': true
    });
  }

  static logIciciRegistered() {
    _analytics.logEvent(name: 'icici_reg_comp',parameters: <String, dynamic>{
      'option': true
    });
  }

  static logAugmontStarted() {
    _analytics.logEvent(name: 'aug_reg_started',parameters: <String, dynamic>{
      'option': true
    });
  }

  static logAugmontRegistered() {
    _analytics.logEvent(name: 'aug_reg_comp',parameters: <String, dynamic>{
      'option': true
    });
  }

  static FirebaseAnalytics get analytics => _analytics;
}