import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/mixpanel_events.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';

class ReferralDetailsViewModel extends BaseModel {
  Logger _logger = new Logger();
  final _baseUtil = locator<BaseUtil>();
  final _dbModel = locator<DBModel>();
  final _razorpayModel = locator<RazorpayModel>();
  final _fcmListener = locator<FcmListener>();
  final _userService = locator<UserService>();
  final _mixpanelService = locator<MixpanelService>();

  String referral_bonus =
      BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.REFERRAL_BONUS);
  String referral_ticket_bonus = BaseRemoteConfig.remoteConfig
      .getString(BaseRemoteConfig.REFERRAL_TICKET_BONUS);
  String referral_flc_bonus = BaseRemoteConfig.remoteConfig
      .getString(BaseRemoteConfig.REFERRAL_FLC_BONUS);
  String _userUrl = "";
  String _userUrlPrefix = "";
  String _userUrlCode = "";

  String _shareMsg;
  bool shareWhatsappInProgress = false;
  bool shareLinkInProgress = false;
  bool loadingUrl = false;

  get userUrl => _userUrl;

  get userUrlCode => _userUrlCode;
  get userUrlPrefix => _userUrlPrefix;

  init() {
    generateLink();
    referral_bonus = (referral_bonus == null || referral_bonus.isEmpty)
        ? '25'
        : referral_bonus;
    referral_ticket_bonus =
        (referral_ticket_bonus == null || referral_ticket_bonus.isEmpty)
            ? '10'
            : referral_ticket_bonus;
    referral_flc_bonus =
        (referral_flc_bonus == null || referral_flc_bonus.isEmpty)
            ? '200'
            : referral_flc_bonus;
    _shareMsg =
        'Hey I am gifting you ₹$referral_bonus and $referral_flc_bonus gaming tokens. Lets start saving and playing together! ';
  }

  Future<void> generateLink() async {
    loadingUrl = true;
    notifyListeners();
    _userUrl =
        await _createDynamicLink(_userService.baseUser.uid, true, 'Other');
    _userUrlPrefix = _userUrl;
    _userUrlCode = _userUrlPrefix.split('/').removeLast();
    List<String> splittedUrl = _userUrlPrefix.split('/');
    splittedUrl.removeLast();
    _userUrlPrefix = splittedUrl.join("/");
    _userUrlPrefix = _userUrlPrefix + '/';
    loadingUrl = false;
    refresh();
  }


  void copyReferCode() {
    _mixpanelService.mixpanel.track(MixpanelEvents.referCodeCopied);
    Clipboard.setData(ClipboardData(text: userUrlCode)).then((_) {
      BaseUtil.showPositiveAlert(
          "Code: $userUrlCode", "Copied to Clipboard");
    });
  }

  shareLink() async {
    if (shareLinkInProgress) return;
    if (await BaseUtil.showNoInternetAlert()) return;

    _fcmListener.addSubscription(FcmTopic.REFERRER);
    BaseAnalytics.analytics.logShare(
        contentType: 'referral',
        itemId: _userService.baseUser.uid,
        method: 'message');
    shareLinkInProgress = true;
    refresh();
    _createDynamicLink(_userService.baseUser.uid, true, 'Other')
        .then((url) async {
      _logger.d(url);
      shareLinkInProgress = false;
  _mixpanelService.mixpanel.track(MixpanelEvents.linkShared);
      refresh();
      if (Platform.isIOS) {
        Share.share(_shareMsg + url);
      } else {
        FlutterShareMe().shareToSystem(msg: _shareMsg + url).then((flag) {
          _logger.d(flag);
        });
      }
    });
  }

  shareWhatsApp() async {
    ////////////////////////////////
    if (await BaseUtil.showNoInternetAlert()) return;
    _fcmListener.addSubscription(FcmTopic.REFERRER);
    BaseAnalytics.analytics.logShare(
        contentType: 'referral',
        itemId: _userService.baseUser.uid,
        method: 'whatsapp');
    shareWhatsappInProgress = true;
    refresh();
    String url;
    try {
      url =
          await _createDynamicLink(_userService.baseUser.uid, true, 'Whatsapp');
    } catch (e) {
      _logger.e('Failed to create dynamic link');
      _logger.e(e);
    }
    shareWhatsappInProgress = false;
    refresh();

    if (url == null)
      return;
    else
      _logger.d(url);
    try {
      _mixpanelService.mixpanel.track(MixpanelEvents.whatsappShare);
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

    // FlutterShareMe()
    //     .shareToWhatsApp4Biz(msg: _shareMsg + url)
    //     .then((value) {
    //   _logger.d(value);
    // }).catchError((err) {
    //  _logger.e('Share to whatsapp biz failed as well');
    // });
  }

  Future<String> _createDynamicLink(
      String userId, bool short, String source) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix:
          '${FlavorConfig.instance.values.dynamicLinkPrefix}/app/referral',
      link: Uri.parse('https://fello.in/$userId'),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Download ${Constants.APP_NAME}',
          description:
              'Fello makes saving fun, and investing a lot more simple!',
          imageUrl: Uri.parse(
              'https://fello-assets.s3.ap-south-1.amazonaws.com/ic_social.png')),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'referrals',
        medium: 'social',
        source: source,
      ),
      androidParameters: AndroidParameters(
        packageName: 'in.fello.felloapp',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
          bundleId: 'in.fello.felloappiOS',
          minimumVersion: '0',
          appStoreId: '1558445254'),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    return url.toString();
  }
}
