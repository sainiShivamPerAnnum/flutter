import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class ReferralService {
  final ReferralRepo _refRepo = locator<ReferralRepo>();
  final UserService _userService = locator<UserService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  Future<dynamic> verifyReferral() async {
    if (BaseUtil.referrerUserId != null) {
      if (PreferenceHelper.getBool(
        PreferenceHelper.REFERRAL_PROCESSED,
        def: false,
      )) return;

      await _refRepo.createReferral(
        _userService.baseUser!.uid,
        BaseUtil.referrerUserId,
      );
      _logger.d('referral processed from link');
      PreferenceHelper.setBool(PreferenceHelper.REFERRAL_PROCESSED, true);
    } else if (BaseUtil.manualReferralCode != null) {
      if (BaseUtil.manualReferralCode!.length == 4) {
        _verifyFirebaseManualReferral();
      } else {
        _verifyOneLinkManualReferral();
      }
    }
  }

  Future<dynamic> _verifyOneLinkManualReferral() async {
    final referrerId = await _refRepo
        .getUserIdByRefCode(BaseUtil.manualReferralCode!.toUpperCase());

    if (referrerId.code == 200) {
      await _refRepo.createReferral(
        _userService.baseUser!.uid,
        referrerId.model,
      );
    } else {
      BaseUtil.showNegativeAlert(referrerId.errorMessage, '');
    }
  }

  Future<dynamic> _verifyFirebaseManualReferral() async {
    try {
      PendingDynamicLinkData? dynamicLinkData =
          await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(
              '${FlavorConfig.instance!.values.dynamicLinkPrefix}/app/referral/${BaseUtil.manualReferralCode}'));
      Uri? deepLink = dynamicLinkData?.link;
      _logger.d(deepLink.toString());
      if (deepLink != null)
        return _processDynamicLink(_userService.baseUser!.uid, deepLink);
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<bool> _submitReferral(
      String? userId, String? userName, String deepLink) async {
    try {
      String prefix = 'https://fello.in/';
      if (deepLink.startsWith(prefix)) {
        String referee = deepLink.replaceAll(prefix, '');
        _logger.d(referee);
        if (prefix.length > 0 && prefix != userId) {
          return _refRepo.createReferral(userId, referee).then((res) {
            return res.model!;
          });
        } else
          return false;
      } else
        return false;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<dynamic> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink..listen(((event) {
      final Uri? deepLink = event.link;
      if (deepLink == null) return null;
      _logger.d('Received deep link. Process the referral');
      return _processDynamicLink(_userService.baseUser!.uid, deepLink);
    })
    
    );

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      _logger.d('Received deep link. Process the referral');
      return _processDynamicLink(_userService.baseUser!.uid, deepLink);
    }
  }

  _processDynamicLink(String? userId, Uri deepLink) async {
    String _uri = deepLink.toString();

    if (_uri.startsWith(Constants.APP_DOWNLOAD_LINK)) {
      _submitTrack(_uri);
    } else if (_uri.startsWith(Constants.APP_NAVIGATION_LINK)) {
      try {
        final path =
            _uri.substring(Constants.APP_NAVIGATION_LINK.length, _uri.length);
        if (AppState.isRootAvailableForIncomingTaskExecution) {
          AppState.delegate!.parseRoute(Uri.parse(path));
          AppState.isRootAvailableForIncomingTaskExecution = false;
        }
      } catch (error) {
        _logger.e(error);
      }
    } else {
      BaseUtil.manualReferralCode =
          null; //make manual Code null in case user used both link and code

      //Referral dynamic link
      bool _flag = await _submitReferral(
        _userService.baseUser!.uid,
        _userService.myUserName,
        _uri,
      );

      if (_flag) {
        //TODO: REFRESH ROOT CALL
        _logger.d('Rewards added');
      }
    }
  }

  bool _submitTrack(String deepLink) {
    try {
      String prefix = '${Constants.APP_DOWNLOAD_LINK}/campaign/';
      if (deepLink.startsWith(prefix)) {
        String campaignId = deepLink.replaceAll(prefix, '');
        if (campaignId.isNotEmpty || campaignId == null) {
          _logger.d(campaignId);
          _analyticsService.trackInstall(campaignId);
          return true;
        }
      }
      return false;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }
}
