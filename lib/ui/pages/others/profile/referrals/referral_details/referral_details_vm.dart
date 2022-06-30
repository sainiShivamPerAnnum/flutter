import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/appflyer_analytics.dart';
import 'package:felloapp/core/service/analytics/base_analytics.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:share_plus/share_plus.dart';

class ReferralDetailsViewModel extends BaseModel {
  final CustomLogger _logger = locator<CustomLogger>();
  final _fcmListener = locator<FcmListener>();
  final _userService = locator<UserService>();
  final _analyticsService = locator<AnalyticsService>();
  final _appFlyer = locator<AppFlyerAnalytics>();
  final _userRepo = locator<UserRepository>();

  String appShareMessage =
      BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.APP_SHARE_MSG);
  String unlockReferralBonus = BaseRemoteConfig.remoteConfig
      .getString(BaseRemoteConfig.UNLOCK_REFERRAL_AMT);

  String _refUrl = "";
  String _refCode = "";

  String _shareMsg;
  bool shareWhatsappInProgress = false;
  bool shareLinkInProgress = false;
  bool loadingRefCode = true;

  get refUrl => _refUrl;
  get refCode => _refCode;

  init() {
    this.generateLink().then((value) {
      _refUrl = value;
    });
    this.fetchReferralCode();
    _shareMsg = (appShareMessage != null && appShareMessage.isNotEmpty)
        ? '$appShareMessage Share this code: $_refCode with your friends. '
        : 'Hey I am gifting you ₹10 and 200 gaming tokens. Lets start saving and playing together! Share this code: $_refCode with your friends. ';
  }

  void copyReferCode() {
    _analyticsService.track(eventName: AnalyticsEvents.referCodeCopied);
    Clipboard.setData(ClipboardData(text: _refCode)).then((_) {
      BaseUtil.showPositiveAlert("Code: $_refCode", "Copied to Clipboard");
    });
  }

  Future<void> fetchReferralCode() async {
    final ApiResponse res = await _userRepo.getReferralCode();
    _logger.d('asdasd $res');
    if (res.code == 200) {
      _refCode = res.model;
    }

    loadingRefCode = false;
    refresh();
  }

  Future<String> generateLink() async {
    if (_refUrl != "") return _refUrl;

    String url;
    final link = await _appFlyer.inviteLink();
    if (link['status'] == 'success') {
      url = link['payload']['userInviteUrl'];
    }
    _logger.d('appflyer invite link as $url');
    return url;
  }

  Future<void> shareLink() async {
    if (shareLinkInProgress) return;
    if (await BaseUtil.showNoInternetAlert()) return;

    _fcmListener.addSubscription(FcmTopic.REFERRER);
    BaseAnalytics.analytics.logShare(
      contentType: 'referral',
      itemId: _userService.baseUser.uid,
      method: 'message',
    );

    _analyticsService.track(eventName: AnalyticsEvents.shareReferralLink);
    shareLinkInProgress = true;
    refresh();

    String url = await this.generateLink();

    shareLinkInProgress = false;
    refresh();

    if (url == null) {
      BaseUtil.showNegativeAlert(
        'Generating link failed',
        'Please try again in some time',
      );
    } else {
      if (Platform.isIOS) {
        Share.share(_shareMsg + url);
      } else {
        FlutterShareMe().shareToSystem(msg: _shareMsg + url).then((flag) {
          _logger.d(flag);
        });
      }
    }
  }

  Future<void> shareWhatsApp() async {
    if (await BaseUtil.showNoInternetAlert()) return;
    _fcmListener.addSubscription(FcmTopic.REFERRER);
    BaseAnalytics.analytics.logShare(
      contentType: 'referral',
      itemId: _userService.baseUser.uid,
      method: 'whatsapp',
    );
    shareWhatsappInProgress = true;
    refresh();

    String url = await this.generateLink();
    shareWhatsappInProgress = false;
    refresh();

    if (url == null)
      return;
    else
      _logger.d(url);
    try {
      _analyticsService.track(eventName: AnalyticsEvents.whatsappShare);
      FlutterShareMe().shareToWhatsApp(msg: _shareMsg + url).then((flag) {
        if (flag == "false") {
          FlutterShareMe()
              .shareToWhatsApp4Biz(msg: _shareMsg + url)
              .then((flag) {
            _logger.d(flag);
            if (flag == "false") {
              BaseUtil.showNegativeAlert(
                  "Whatsapp not detected", "Please use other option to share.");
            }
          });
        }
      });
    } catch (e) {
      _logger.d(e.toString());
    }
  }
}
