import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
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
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferralDetailsViewModel extends BaseModel {
  final CustomLogger _logger = locator<CustomLogger>();
  final _fcmListener = locator<FcmListener>();
  final _userService = locator<UserService>();
  final _analyticsService = locator<AnalyticsService>();
  final _appFlyer = locator<AppFlyerAnalytics>();
  final _userRepo = locator<UserRepository>();
  final _refRepo = locator<ReferralRepo>();
  final _dbModel = locator<DBModel>();

  PageController _pageController;
  int _tabNo = 0;

  int get tabNo => _tabNo;
  set tabNo(value) {
    this._tabNo = value;
    notifyListeners();
  }

  double _tabPosWidthFactor = SizeConfig.pageHorizontalMargins;

  double get tabPosWidthFactor => _tabPosWidthFactor;
  set tabPosWidthFactor(value) {
    this._tabPosWidthFactor = value;
    notifyListeners();
  }

  PageController get pageController => _pageController;

  BaseUtil baseProvider;
  DBModel dbProvider;

  List<ReferralDetail> _referalList;

  List<ReferralDetail> get referalList => _referalList;

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

  bool _isReferalsFetched = false;

  get refUrl => _refUrl;
  get refCode => _refCode;
  get isReferalsFetched => _isReferalsFetched;

  init(BuildContext context) {
    this.generateLink().then((value) {
      _refUrl = value;
    });
    _pageController = PageController(initialPage: 0);

    this.fetchReferralCode();
    this.fetchReferalsList(context);
  }

  void copyReferCode() {
    Haptic.vibrate();
    _analyticsService.track(eventName: AnalyticsEvents.referCodeCopied);
    Clipboard.setData(ClipboardData(text: _refCode)).then((_) {
      BaseUtil.showPositiveAlert("Code: $_refCode", "Copied to Clipboard");
    });
  }

  Future<void> fetchReferralCode() async {
    final ApiResponse res = await _refRepo.getReferralCode();
    if (res.code == 200) {
      _refCode = res.model;
    }
    _shareMsg = (appShareMessage != null && appShareMessage.isNotEmpty)
        ? appShareMessage
        : 'Hey I am gifting you ₹10 and 200 gaming tokens. Lets start saving and playing together! Share this code: $_refCode with your friends.\n';

    loadingRefCode = false;
    refresh();
  }

  switchTab(int tab) {
    if (tab == tabNo) return;

    tabPosWidthFactor = tabNo == 0
        ? SizeConfig.screenWidth / 2 + SizeConfig.pageHorizontalMargins
        : SizeConfig.pageHorizontalMargins;

    _pageController.animateToPage(
      tab,
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    tabNo = tab;
  }

  fetchReferalsList(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    final _referralRepo = locator<ReferralRepo>();

    if (!baseProvider.referralsFetched) {
      _referralRepo.getReferralHistory().then((refHisModel) {
        baseProvider.referralsFetched = true;
        baseProvider.userReferralsList = refHisModel.model ?? [];
        _referalList = baseProvider.userReferralsList;

        notifyListeners();
      });
    } else {
      if (_referalList == null) {
        _referalList = [];
      }

      notifyListeners();
    }
  }

  Future<String> generateLink() async {
    if (_refUrl != "") return _refUrl;

    String url;
    try {
      final link = await _appFlyer.inviteLink();
      if (link['status'] == 'success') {
        url = link['payload']['userInviteUrl'];
        if (url == null) url = link['payload']['userInviteURL'];
      }
      _logger.d('appflyer invite link as $url');
    } catch (e) {
      _logger.e(e);
    }
    return url;
  }

  Future getProfileDpWithUid(String uid) async {
    return await _dbModel.getUserDP(uid) ?? "";
  }

  String getUserMembershipDate(Timestamp tmp) {
    if (tmp != null) {
      DateTime _dt = tmp.toDate();
      return DateFormat("dd MMM, yyyy").format(_dt);
    } else {
      return '\'Unavailable\'';
    }
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

  bool bonusUnlockedReferalPresent(List<ReferralDetail> list) {
    for (ReferralDetail e in list) {
      if (e.isRefereeBonusUnlocked) {
        return true;
      }
    }

    return false;
  }

  bool bonusLockedReferalPresent(List<ReferralDetail> list) {
    for (ReferralDetail e in list) {
      if (e.isRefereeBonusUnlocked == false) {
        return true;
      }
    }

    return false;
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

    if (url == null) {
      BaseUtil.showNegativeAlert(
        'Generating link failed',
        'Please try again in some time',
      );
      return;
    } else
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
