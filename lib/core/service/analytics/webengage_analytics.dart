import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class WebEngageAnalytics extends BaseAnalyticsService {
  final _logger = locator<CustomLogger>();

  Future<void> login({bool isOnboarded, BaseUser baseUser}) async {
    if (isOnboarded != null && isOnboarded && baseUser != null) {
      _logger.d(baseUser);

      WebEngagePlugin.userLogin(baseUser.uid);
      WebEngagePlugin.setUserPhone(baseUser.mobile ?? '');
      WebEngagePlugin.setUserFirstName(baseUser.name ?? '');
      WebEngagePlugin.setUserEmail(baseUser.email ?? '');
      WebEngagePlugin.setUserBirthDate(baseUser.dob ?? '0');
      WebEngagePlugin.setUserGender(_getGender(baseUser.gender));
      WebEngagePlugin.setUserAttribute(
          "Signed Up", getSignupDate(baseUser.createdOn));
      WebEngagePlugin.setUserAttribute(
          "KYC Verified", baseUser.isSimpleKycVerified ?? false);

      _logger.d("Analytics SERVICE :: User identify properties added.");
    }
  }

  String _getGender(String s) {
    if (s == 'M') return 'male';
    if (s == 'F') return 'female';

    return 'other';
  }

  void signOut() {
    try {
      WebEngagePlugin.userLogout();
    }catch(e) {
      _logger.e(e);
    }
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

  void trackScreen({String screen, Map<String, dynamic> properties}) {
    try {
      _logger.d('analytics : $screen');
      WebEngagePlugin.trackScreen(screen, properties);
    } catch (e) {
      String error = e ?? "Unable to track screen event: $screen";
      _logger.e(error);
    }
  }
}
