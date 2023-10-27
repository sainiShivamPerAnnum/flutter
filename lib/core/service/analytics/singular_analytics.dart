import 'dart:convert';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:singular_flutter_sdk/singular.dart';
import 'package:singular_flutter_sdk/singular_config.dart';
import 'package:singular_flutter_sdk/singular_link_params.dart';

class SingularAnalytics extends BaseAnalyticsService {
  final CustomLogger _logger = locator<CustomLogger>();

  static const String PROD_KEY = "fello_e0df8eee";
  static const String PROD_SECRET = "5d6cbcc07d99deba39125f456c552de0";

  SingularConfig? _singularConfig;

  //required for installs
  void connectFcm(String token) {
    try {
      if (FlavorConfig.isProduction() &&
          token.isNotEmpty &&
          _singularConfig != null) {
        Singular.registerDeviceTokenForUninstall(token);
      }
    } catch (e) {
      _logger!.e('Singular implementation failed to capture fcm token');
    }
  }

  @override
  Future<void> login({bool? isOnBoarded, BaseUser? baseUser}) async {
    if (FlavorConfig.isProduction()) {
      _singularConfig = SingularConfig(PROD_KEY, PROD_SECRET);
      _singularConfig!.customUserId = baseUser!.uid;
      Singular.start(_singularConfig!);
      _singularConfig!.singularLinksHandler = (SingularLinkParams params) {
        String? deeplink = params.deeplink!;
        String? passthrough = params.passthrough!;
        bool? isDeferred = params.isDeferred!;
        // Add your code here to handle the deep link

        if (passthrough.isNotEmpty) {
          Map<String, dynamic> responseMap = jsonDecode(passthrough);
          if (responseMap.containsKey("uid")) {
            BaseUtil.referrerUserId = responseMap["uid"];
            BaseUtil.referredCode = responseMap["refCode"];
          }
        }
      };
      _singularConfig!.skAdNetworkEnabled = true;
      _singularConfig!.manualSkanConversionManagement = true;
      _singularConfig!.conversionValueUpdatedCallback = (conversionValue) {
        _logger!.d('Conversion value updated: $conversionValue');
      };
    }
  }

  @override
  void signOut() {
    if (FlavorConfig.isProduction()) {
      try {
        Singular.stopAllTracking();
        Singular.clearGlobalProperties();
        Singular.unsetCustomUserId();
      } catch (e) {
        _logger!.e('Singular implementation failed to sign out');
      }
    }
  }

  @override
  void track({String? eventName, Map<String, dynamic>? properties}) {
    if (FlavorConfig.isProduction()) {
      try {
        if (properties == null || properties.isEmpty) {
          Singular.event(eventName!);
        } else {
          Singular.eventWithArgs(eventName!, properties);
        }
      } catch (e) {
        _logger!.e('Singular tracking failed: ', e.toString());
      }
    }
  }

  @override
  void trackScreen({String? screen, Map<String, dynamic>? properties}) {
    //not required for Singular
  }
}
