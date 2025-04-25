import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter_meta_sdk/flutter_meta_sdk.dart';

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
          FlutterMetaSdk().logEvent(name: eventName!, parameters: properties);
        } else {
          FlutterMetaSdk().logEvent(name: eventName!);
        }
      }
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  @override
  void updateUserProperty({required String key, value}) {}

  @override
  void trackScreen({String? screen, Map<String, dynamic>? properties}) {}
}
