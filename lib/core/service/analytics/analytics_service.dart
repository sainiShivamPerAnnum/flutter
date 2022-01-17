import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/core/service/analytics/mixpanel_analytics.dart';
import 'package:felloapp/core/service/analytics/webengage_analytics.dart';
import 'package:felloapp/util/locator.dart';

class AnalyticsService extends BaseAnalyticsService {
  final _mixpanel = locator<MixpanelAnalytics>();
  final _webengage = locator<WebEngageAnalytics>();

  Future<void> login({bool isOnboarded, BaseUser baseUser}) async {
    _mixpanel.login(isOnboarded: isOnboarded, baseUser: baseUser);
    _webengage.login(isOnboarded: isOnboarded, baseUser: baseUser);
  }

  void signOut() {
    _mixpanel.signOut();
    _webengage.signOut();
  }

  void track({String eventName, Map<String, dynamic> properties}) {
    _mixpanel.track(eventName: eventName, properties: properties);
    _webengage.track(eventName: eventName, properties: properties);
  }

  void trackScreen({String screen, Map<String, dynamic> properties}) {
    _mixpanel.track(eventName: screen, properties: properties);
    _webengage.track(eventName: screen, properties: properties);
  }
}
