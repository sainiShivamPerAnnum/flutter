import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/foundation.dart';

class CleverTapAnalytics extends BaseAnalyticsService {
  final CustomLogger _logger = locator<CustomLogger>();

  @override
  Future<void> login({bool? isOnBoarded, BaseUser? baseUser}) async {
    await CleverTapPlugin.setDebugLevel(kReleaseMode ? -1 : 1);
    if (isOnBoarded != null && isOnBoarded && baseUser != null) {
      var profile = {
        'Name': baseUser.name ?? "",
        'Uid': baseUser.uid!,
        'Identity': baseUser.uid,
        'Email': baseUser.email ?? "",
        'Phone': baseUser.mobile != null ? "+91${baseUser.mobile}" : "",
        'Gender': baseUser.gender ?? "",
        'Signed Up': baseUser.isSimpleKycVerified ?? false,
        "KYC Verified": baseUser.isSimpleKycVerified ?? false,
      };
      await CleverTapPlugin.onUserLogin(profile);
      _logger.d("CleverTap SERVICE :: User identify properties added.");
    }
  }

  @override
  void signOut() {}

  @override
  void track({String? eventName, Map<String, dynamic>? properties}) {
    CleverTapPlugin.recordEvent(eventName!, properties ?? {});
    _logger.d("CleverTap :: Event tracked: $eventName");
  }

  @override
  void trackScreen({String? screen, Map<String, dynamic>? properties}) {
    CleverTapPlugin.recordScreenView(screen!);
  }
}
