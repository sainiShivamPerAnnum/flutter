import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class WebEngageAnalytics extends AnalyticsService {
  final _logger = locator<CustomLogger>();

  Future<void> login({bool isOnboarded, BaseUser baseUser}) async {
    if (isOnboarded != null && isOnboarded && baseUser != null) {
      WebEngagePlugin.userLogin(baseUser.uid);
      WebEngagePlugin.setUserPhone(baseUser.mobile ?? '');
      WebEngagePlugin.setUserFirstName(baseUser.name ?? '');
      WebEngagePlugin.setUserEmail(baseUser.email ?? '');
      WebEngagePlugin.setUserBirthDate(getAge(baseUser.dob, _logger).toString() ?? '0');
      WebEngagePlugin.setUserGender(baseUser.gender ?? '0');
      WebEngagePlugin.setUserAttribute(
          "Signed Up", getSignupDate(baseUser.createdOn));
      WebEngagePlugin.setUserAttribute(
          "KYC Verified", baseUser.isSimpleKycVerified ?? false);

      _logger.d("MIXPANEL SERVICE :: User identify properties added.");
    }
  }

  void signOut() {
    WebEngagePlugin.userLogout();
  }

  void track({String eventName, Map<String, dynamic> properties}) {
    try {
      if (properties != null && properties.isNotEmpty) {
        WebEngagePlugin.trackEvent(eventName, properties);
        _logger.i(
            "Event: $eventName, Properties: ${properties.toString()}. Successfully tracked");
      } else {
        WebEngagePlugin.trackEvent(eventName);
      }
    } catch (e) {
      String error = e ?? "Unable to track event: $eventName";
      _logger.e(error);
    }
  }
}
