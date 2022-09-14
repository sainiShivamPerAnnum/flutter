import 'dart:async';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/base_analytics.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:felloapp/core/repository/journey_repo.dart';

import '../../../../core/base_remote_config.dart';
import '../../../../core/repository/referral_repo.dart';
import '../../../../core/service/analytics/appflyer_analytics.dart';
import '../../../../core/service/fcm/fcm_listener_service.dart';
import '../../../../util/api_response.dart';

class WinViewModel extends BaseModel {
  final _userService = locator<UserService>();
  final _logger = locator<CustomLogger>();
  final _analyticsService = locator<AnalyticsService>();
  final _campaignRepo = locator<CampaignRepo>();
  final _journeyRepo = locator<JourneyRepository>();
  final _baseUtil = locator<BaseUtil>();
  final _refRepo = locator<ReferralRepo>();
  final _appFlyer = locator<AppFlyerAnalytics>();
  final _winnerService = locator<WinnerService>();
  final _lbService = locator<LeaderboardService>();

  Timer _timer;
  bool _showOldView = false;
  bool get showOldView => this._showOldView;
  String _refCode = "";
  String _shareMsg;
  bool shareWhatsappInProgress = false;
  bool shareLinkInProgress = false;
  bool loadingRefCode = true;
  String appShareMessage =
      BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.APP_SHARE_MSG);
  final _fcmListener = locator<FcmListener>();
  PageController _pageController;

  double _tabPosWidthFactor = SizeConfig.pageHorizontalMargins;

  int _tabNo = 0;

  String _minWithdrawPrize;
  String _refUnlock;
  int _refUnlockAmt;
  int _minWithdrawPrizeAmt;

  String get minWithdrawPrize => _minWithdrawPrize;
  String get refUnlock => _refUnlock;
  int get refUnlockAmt => _refUnlockAmt;

  int get minWithdrawPrizeAmt => _minWithdrawPrizeAmt;

  double get tabPosWidthFactor => _tabPosWidthFactor;
  set tabPosWidthFactor(value) {
    this._tabPosWidthFactor = value;
    notifyListeners();
  }

  PageController get pageController => _pageController;

  String _refUrl = "";

  int get tabNo => _tabNo;
  set tabNo(value) {
    this._tabNo = value;
    notifyListeners();
  }

  set showOldView(bool value) {
    this._showOldView = value;
    notifyListeners();
  }

  get refCode => _refCode;
  get refUrl => _refUrl;

  LocalDBModel _localDBModel = locator<LocalDBModel>();
  bool isWinnersLoading = false;
  WinnersModel _winners;
  int _currentPage = 0;
  int get getCurrentPage => this._currentPage;
  final ScrollController eventScrollController = new ScrollController();

  List<EventModel> _ongoingEvents;

  static PanelController _panelController = PanelController();

  List<EventModel> get ongoingEvents => this._ongoingEvents;

  set ongoingEvents(List<EventModel> value) {
    this._ongoingEvents = value;
    notifyListeners();
  }

  PanelController get panelController => _panelController;

  set panelController(val) {
    _panelController = val;
    notifyListeners();
  }

  set setCurrentPage(int currentPage) {
    this._currentPage = currentPage;
    notifyListeners();
  }

  WinnersModel get winners => _winners;

  double get winnings => _userService.userFundWallet.prizeBalance;

  set winners(val) {
    _winners = val;
    notifyListeners();
  }

  double get getUnclaimedPrizeBalance =>
      _userService.userFundWallet.unclaimedBalance;

  init() {
    // setupAutoEventScroll();
    // getOngoingEvents();
    _baseUtil.fetchUserAugmontDetail();
    fetchReferralCode();
    _pageController = PageController(initialPage: 0);
    fectchBasicConstantValues();

    _winnerService.fetchWinners();
  }

  fectchBasicConstantValues() {
    _minWithdrawPrize = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.MIN_WITHDRAWABLE_PRIZE);
    _refUnlock = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.UNLOCK_REFERRAL_AMT);
    _refUnlockAmt = BaseUtil.toInt(_refUnlock);
    _minWithdrawPrizeAmt = BaseUtil.toInt(_minWithdrawPrize);
  }

  cleanJourneyAssetsFiles() {
    _journeyRepo.dump();
  }

  void copyReferCode() {
    Haptic.vibrate();
    _analyticsService.track(eventName: AnalyticsEvents.referCodeCopied);
    Clipboard.setData(ClipboardData(text: _refCode)).then((_) {
      BaseUtil.showPositiveAlert("Code: $_refCode", "Copied to Clipboard");
    });
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

  setupAutoEventScroll() {
    try {
      Future.delayed(Duration(seconds: 6), () {
        _timer = Timer.periodic(Duration(seconds: 6), (Timer timer) {
          if (eventScrollController.position.pixels <
              eventScrollController.position.maxScrollExtent) {
            eventScrollController.animateTo(
                eventScrollController.position.pixels +
                    SizeConfig.screenWidth * 0.64,
                duration: Duration(seconds: 1),
                curve: Curves.decelerate);
          } else {
            eventScrollController.animateTo(0,
                duration: Duration(seconds: 2), curve: Curves.decelerate);
          }
        });
      });
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  void clear() {
    _timer?.cancel();
  }

  String getWinningsButtonText() {
    if (_userService.userFundWallet.isPrizeBalanceUnclaimed())
      return "Redeem";
    else
      return "Share";
  }

  Future<PrizeClaimChoice> getClaimChoice() async {
    return await _localDBModel.getPrizeClaimChoice();
  }

  void navigateToMyWinnings() {
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: MyWinnigsPageConfig);
  }

  void navigateToRefer() {
    _analyticsService.track(eventName: AnalyticsEvents.winReferral);
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: ReferralDetailsPageConfig,
    );
  }

  void navigateToWinnings() {
    _analyticsService.track(eventName: AnalyticsEvents.winReferral);
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: MyWinnigsPageConfig,
    );
  }

  openProfile() {
    _baseUtil.openProfileDetailsScreen();
  }

  openVoucherModal(
    String asset,
    String title,
    String subtitle,
    Color color,
    bool commingsoon,
    List<String> instructions,
  ) {
    if (Platform.isIOS && commingsoon)
      return;
    else
      return BaseUtil.openModalBottomSheet(
        addToScreenStack: true,
        content: VoucherModal(
          color: color,
          asset: asset,
          commingSoon: commingsoon,
          title: title,
          subtitle: subtitle,
          instructions: instructions,
        ),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding24),
            topRight: Radius.circular(SizeConfig.padding24)),
        // backgroundColor: Color(0xffFFDBF6),
        isBarrierDismissable: false,
        hapticVibrate: true,
      );
  }

  double calculateFillHeight(
      double winningAmount, double containerHeight, int redeemAmount) {
    double fillPercent = (winningAmount / redeemAmount) * 100;
    double heightToFill = (fillPercent / 100) * containerHeight;

    return heightToFill;
  }

  getOngoingEvents() async {
    final response = await _campaignRepo.getOngoingEvents();
    if (response.code == 200) {
      ongoingEvents = response.model;
      ongoingEvents.sort((a, b) => a.position.compareTo(b.position));
      ongoingEvents.forEach((element) {
        print(element.toString());
      });
    } else
      ongoingEvents = [];
  }
}
