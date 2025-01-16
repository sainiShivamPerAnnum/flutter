import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter_facebook_sdk/flutter_facebook_sdk.dart';

class FacebookAnalytics extends BaseAnalyticsService {
  final CustomLogger _logger = locator<CustomLogger>();

  @override
  Future<void> login({bool? isOnBoarded, BaseUser? baseUser}) async {}

  @override
  void signOut() {}

  @override
  void track({String? eventName, Map<String, dynamic>? properties}) {
    try {
      if (FlavorConfig.isProduction()) {
        if (properties != null && properties.isNotEmpty) {
          FlutterFacebookSdk()
              .logEvent(eventName: eventName!, parameters: properties);
        } else {
          FlutterFacebookSdk().logEvent(eventName: eventName!);
        }
      }
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  @override
  void trackScreen({String? screen, Map<String, dynamic>? properties}) {}
}
