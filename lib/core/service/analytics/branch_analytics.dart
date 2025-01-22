import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/base_analytics_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

class BranchAnalytics extends BaseAnalyticsService {
  final CustomLogger _logger = locator<CustomLogger>();
  @override
  Future<void> login({bool? isOnBoarded, BaseUser? baseUser}) async {
    if (isOnBoarded != null && isOnBoarded && baseUser != null) {
      var branchIdentityData = {
        'Name': baseUser.name ?? "",
        'Uid': baseUser.uid!,
        'Identity': baseUser.uid,
        'Email': baseUser.email ?? "",
        'Phone': baseUser.mobile != null ? "+91${baseUser.mobile}" : "",
        'Gender': baseUser.gender ?? "",
        'Signed Up': baseUser.isSimpleKycVerified ?? false,
        "KYC Verified": baseUser.isSimpleKycVerified ?? false,
      };

      FlutterBranchSdk.setIdentity(baseUser.uid!);
      // await FlutterBranchSdk.setUserProperty(
      //     'user_profile', branchIdentityData);
      _logger.d("Branch SERVICE :: User identify properties added.");
    }
  }

  @override
  Future<void> signOut() async {
    FlutterBranchSdk.logout();
    _logger.d("Branch SERVICE :: User logged out.");
  }

  @override
  void track({String? eventName, Map<String, dynamic>? properties}) {
    if (eventName == null) return;

    BranchEvent branchEvent = BranchEvent.customEvent(
      eventName,
    );
    if (properties != null) {
      properties.forEach((key, value) {
        branchEvent.addCustomData(key.toString(), value.toString());
      });
    }

    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: branchEvent);
    _logger.d("Branch :: Event tracked: $eventName");
  }

  @override
  void trackScreen({String? screen, Map<String, dynamic>? properties}) {
    if (screen == null) return;

    BranchEvent branchEvent = BranchEvent.customEvent(
      'Screen Viewed: $screen',
    );
    if (properties != null) {
      properties.forEach((key, value) {
        branchEvent.addCustomData(key, value);
      });
    }

    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: branchEvent);
    _logger.d("Branch :: Screen tracked: $screen");
  }
}
