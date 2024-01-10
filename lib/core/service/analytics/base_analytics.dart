import 'package:felloapp/core/model/base_user_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class BaseAnalytics {
  static FirebaseAnalytics? _analytics;

  static const String PAGE_FINANCE = 'finance';
  static const String PAGE_GAME = 'game';
  static const String PAGE_HOME = 'home';
  static const String PAGE_PROFILE = 'profile';
  static const String PAGE_TAMBOLA = 'tambola';

  static init() async {
    _analytics = FirebaseAnalytics.instance;
  }

  static logUserProfile(BaseUser user) async {
    try {
      await _analytics!.setUserId(id: user.uid);
    } catch (e) {
      print('User ID Analytics failed');
    }
    await _analytics!.setUserProperty(name: 'user_gender', value: user.gender);
    await _analytics!.setUserProperty(
        name: 'fresh_investor', value: (user.isInvested!) ? 'N' : 'Y');
  }

  static logProfilePictureAdded() {
    _analytics!.logEvent(
        name: 'has_profile_pic', parameters: <String, dynamic>{'option': true});
  }

  static FirebaseAnalytics? get analytics => _analytics;
}
