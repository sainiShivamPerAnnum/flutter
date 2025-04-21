import 'dart:async';

import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class WebEngageAnalytics extends BaseAnalyticsService {
  final CustomLogger _logger = locator<CustomLogger>();
  WebEngageAnalytics() {
    WebEngagePlugin();
  }
  @override
  Future<void> login({bool? isOnBoarded, BaseUser? baseUser}) async {
    if (isOnBoarded != null && isOnBoarded && baseUser != null) {
      final nameParts = (baseUser.name ?? '').split(' ');
      final len = nameParts.length;
      unawaited(WebEngagePlugin.userLogin(baseUser.uid!));
      unawaited(WebEngagePlugin.setUserPhone(baseUser.mobile ?? ''));
      if (len > 0) {
        unawaited(WebEngagePlugin.setUserFirstName(nameParts[0]));
      }
      if (len > 1) {
        unawaited(WebEngagePlugin.setUserLastName(nameParts[len - 1]));
      }
      unawaited(WebEngagePlugin.setUserEmail(baseUser.email ?? ''));
      unawaited(WebEngagePlugin.setUserBirthDate(baseUser.dob ?? '0'));
      unawaited(WebEngagePlugin.setUserGender(_getGender(baseUser.gender)));
      unawaited(
        WebEngagePlugin.setUserAttribute(
          "Signed Up",
          getSignupDate(baseUser.createdOn),
        ),
      );
      unawaited(
        WebEngagePlugin.setUserAttribute(
          "KYC Verified",
          baseUser.isSimpleKycVerified ?? false,
        ),
      );
      unawaited(
        WebEngagePlugin.setUserAttribute(
          "Advisor in cart",
          baseUser.advisorInCart ?? '',
        ),
      );
      _logger.d("Analytics SERVICE :: User identify properties added.");
    }
  }

  @override
  void updateUserProperty({required String key, value}) {
    unawaited(
      WebEngagePlugin.setUserAttribute(
        key,
        value,
      ),
    );
  }

  String _getGender(String? s) {
    if (s == 'M') return 'male';
    if (s == 'F') return 'female';
    return 'other';
  }

  @override
  void signOut() {
    try {
      WebEngagePlugin.userLogout();
    } catch (e) {
      _logger.e(e);
    }
  }

  @override
  void track({String? eventName, Map<String, dynamic>? properties}) {
    try {
      if (properties != null && properties.isNotEmpty) {
        WebEngagePlugin.trackEvent(eventName!, properties);
        // _logger!.i(
        //     "Event: $eventName, Properties: ${properties.toString()}. Successfully tracked");
      } else {
        WebEngagePlugin.trackEvent(eventName!);
      }
    } catch (e) {
      String error = e as String ?? "Unable to track event: $eventName";
      _logger.e(error);
    }
  }

  @override
  void trackScreen({String? screen, Map<String, dynamic>? properties}) {
    try {
      _logger.d('analytics : $screen');
      WebEngagePlugin.trackScreen(screen!, properties);
    } catch (e) {
      String error = e as String ?? "Unable to track screen event: $screen";
      _logger.e(error);
    }
  }
}
