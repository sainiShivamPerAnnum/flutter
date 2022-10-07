import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/fello_facts_model.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/golden_ticket_repo.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/prizing_repo.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/analytics/appflyer_analytics.dart';
import 'package:felloapp/core/service/analytics/base_analytics.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/hometabs/win/redeem_sucessfull_screen.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_view.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

class WinViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _logger = locator<CustomLogger>();
  final _analyticsService = locator<AnalyticsService>();
  final _journeyRepo = locator<JourneyRepository>();
  final _baseUtil = locator<BaseUtil>();
  final _refRepo = locator<ReferralRepo>();
  final _appFlyer = locator<AppFlyerAnalytics>();
  final _winnerService = locator<WinnerService>();
  final _lbService = locator<LeaderboardService>();
  final userRepo = locator<UserRepository>();
  final _transactionHistoryService = locator<TransactionHistoryService>();
  final _internalOpsService = locator<InternalOpsService>();
  final _prizingRepo = locator<PrizingRepo>();
  final _campaignRepo = locator<CampaignRepo>();
  final _gtRepo = locator<GoldenTicketRepository>();
  int _unscratchedGTCount = 0;
  bool _showUnscratchedCount = true;

  Timer _timer;
  bool _showOldView = false;
  bool get showOldView => this._showOldView;
  String _refCode = "";
  final GlobalKey imageKey = GlobalKey();

  bool _isShareAlreadyClicked = false;

  bool get isShareAlreadyClicked => _isShareAlreadyClicked;

  PrizeClaimChoice _choice;
  get choice => this._choice;

  set choice(value) {
    this._choice = value;
    notifyListeners();
  }

  String _shareMsg;
  bool shareWhatsappInProgress = false;
  bool shareLinkInProgress = false;
  bool loadingRefCode = true;
  bool _isWinningHistoryLoading = false;
  bool _isShareLoading = false;

  List<UserTransaction> _winningHistory;

  List<UserTransaction> get winningHistory => this._winningHistory;
  set winningHistory(List<UserTransaction> value) {
    this._winningHistory = value;
    notifyListeners();
  }

  List<FelloFactsModel> fellofacts = [];

  bool _isFelloFactsLoading = false;
  get isFelloFactsLoading => this._isFelloFactsLoading;

  set isFelloFactsLoading(value) {
    this._isFelloFactsLoading = value;
    notifyListeners();
  }

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

  //GETTERS SETTERS
  bool get isShareLoading => _isShareLoading;

  get isWinningHistoryLoading => this._isWinningHistoryLoading;
  set isWinningHistoryLoading(value) {
    this._isWinningHistoryLoading = value;
    notifyListeners();
  }

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

  // static PanelController _panelController = PanelController();

  List<EventModel> get ongoingEvents => this._ongoingEvents;

  set ongoingEvents(List<EventModel> value) {
    this._ongoingEvents = value;
    notifyListeners();
  }

  // PanelController get panelController => _panelController;

  // set panelController(val) {
  //   _panelController = val;
  //   notifyListeners();
  // }

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

  get unscratchedGTCount => this._unscratchedGTCount;

  set unscratchedGTCount(int count) {
    this._unscratchedGTCount = count;
    notifyListeners();
    print("Unscratched gt count: $_unscratchedGTCount");
  }

  bool get showUnscratchedCount => this._showUnscratchedCount;

  set showUnscratchedCount(bool value) {
    this._showUnscratchedCount = value;
    notifyListeners();
  }

  double get getUnclaimedPrizeBalance =>
      _userService.userFundWallet.unclaimedBalance;

  init() {
    // setupAutoEventScroll();
    _pageController = PageController(initialPage: 0);

    fetchReferralCode();
    fetchBasicConstantValues();
    getUnscratchedGTCount();
    // _baseUtil.fetchUserAugmontDetail();
    getFelloFacts();
    _lbService.fetchReferralLeaderBoard();

    _winnerService.fetchWinners();
  }

  Future<void> shareLink() async {
    _isShareAlreadyClicked = true;
    notifyListeners();

    // _getterrepo.getGoldenTickets(); //TR

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

    Future.delayed(Duration(seconds: 3), () {
      _isShareAlreadyClicked = false;
      notifyListeners();
    });
  }

  startShareLoading() {
    _isShareLoading = true;
    notifyListeners();
  }

  stopShareLoading() {
    _isShareLoading = false;
    notifyListeners();
  }

  fetchBasicConstantValues() {
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

  void navigateToMyWinnings(WinViewModel model) {
    showUnscratchedCount = false;
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: MyWinnigsPageConfig,
        widget: MyWinningsView(winModel: model));
  }

  void navigateToRefer() {
    if (_userService.userJourneyStats.mlIndex == 1)
      BaseUtil.openDialog(
        addToScreenStack: true,
        isBarrierDismissable: true,
        hapticVibrate: false,
        content: FelloInfoDialog(
          title: 'Complete Profile',
          subtitle:
              'Please complete your profile to win your first reward and to start saving',
          action: Container(
            width: SizeConfig.screenWidth,
            child: FelloButtonLg(
              child: Text(
                "Complete Profile",
                style: TextStyles.body2.bold.colour(Colors.white),
              ),
              onPressed: () => AppState.backButtonDispatcher.didPopRoute(),
            ),
          ),
        ),
      );
    _analyticsService.track(eventName: AnalyticsEvents.winReferral);
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: ReferralDetailsPageConfig,
    );
  }

  showConfirmDialog(PrizeClaimChoice choice) {
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissable: false,
      hapticVibrate: true,
      content: ConfirmationDialog(
        confirmAction: () async {
          await claim(choice, _userService.userFundWallet.unclaimedBalance);
        },
        title: "Confirmation",
        description: choice == PrizeClaimChoice.AMZ_VOUCHER
            ? "Are you sure you want to redeem ₹ ${_userService.userFundWallet.unclaimedBalance} as an Amazon gift voucher?"
            : "Are you sure you want to redeem ₹ ${_userService.userFundWallet.unclaimedBalance} as Digital Gold?",
        buttonText: "Yes",
        cancelBtnText: "No",
        cancelAction: AppState.backButtonDispatcher.didPopRoute,
      ),
    );
  }

  getUnscratchedGTCount() async {
    final ApiResponse<List<GoldenTicket>> res =
        await _gtRepo.getUnscratchedGoldenTickets();
    if (res.isSuccess()) {
      unscratchedGTCount = res.model.length;
    }
  }

  getWinningHistory() async {
    isWinningHistoryLoading = true;
    ApiResponse<List<UserTransaction>> temp =
        await userRepo.getWinningHistory(_userService.baseUser.uid);
    temp.model.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    isWinningHistoryLoading = false;
    if (temp != null)
      winningHistory = temp.model;
    else
      BaseUtil.showNegativeAlert(
          "Winning History fetch failed", "Please try again after sometime");
  }

  showSuccessPrizeWithdrawalDialog(
      PrizeClaimChoice choice, String subtitle, double claimPrize) async {
    //Starting the redemption sucessfull screen
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addWidget,
      widget: RedeemSucessfulScreen(
        subTitleWidget: getSubtitleWidget(subtitle),
        claimPrize: claimPrize,
        dpUrl: _userService.myUserDpUrl,
        choice: choice,
      ),
      page: RedeemSucessfulScreenPageConfig,
    );
  }

  sharePrizeDetails() async {
    startShareLoading();
    try {
      String url = await _userService.createDynamicLink(true, 'Other');
      caputure(
          'Hey, I won ₹${_userService.userFundWallet.prizeBalance.toInt()} on Fello! \nLet\'s save and play together: $url');
    } catch (e) {
      _logger.e(e.toString());
      BaseUtil.showNegativeAlert("An error occured!", "Please try again");
    }
    stopShareLoading();
  }

  claim(PrizeClaimChoice choice, double claimPrize) {
    // double _claimAmt = claimPrize;
    _registerClaimChoice(choice).then((flag) {
      AppState.backButtonDispatcher.didPopRoute();
      if (flag) {
        getWinningHistory();
        showSuccessPrizeWithdrawalDialog(
            choice,
            choice == PrizeClaimChoice.AMZ_VOUCHER ? "amazon" : "gold",
            claimPrize);
      }
    });

    _analyticsService.track(eventName: AnalyticsEvents.winRedeemWinnings);
  }

// SET AND GET CLAIM CHOICE
  Future<bool> _registerClaimChoice(PrizeClaimChoice choice) async {
    if (choice == PrizeClaimChoice.NA) return false;
    final response = await _prizingRepo.claimPrize(
      _userService.userFundWallet.unclaimedBalance,
      choice,
    );

    if (response.isSuccess()) {
      _userService.getUserFundWalletData();
      _transactionHistoryService.updateTransactions(InvestmentType.AUGGOLD99);
      notifyListeners();
      await _localDBModel.savePrizeClaimChoice(choice);

      return true;
    } else {
      BaseUtil.showNegativeAlert(
        'Withdrawal Failed',
        response.errorMessage ?? "Please try again after sometime",
      );
      return false;
    }
  }

  Widget getSubtitleWidget(String subtitle) {
    if (subtitle == "gold" || subtitle == "amazon")
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: subtitle == "gold"
              ? "The gold in grams shall be credited to your wallet in the next "
              : "You will receive the gift card on your registered email and mobile in the next ",
          style: TextStyles.body3.colour(Colors.white),
          children: [
            TextSpan(
              text: "1-2 business working days",
              style: TextStyles.body3.colour(Colors.white),
            )
          ],
        ),
      );
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: TextStyles.body2.colour(Colors.white),
    );
  }

// Capture Share card Logic
  caputure(String shareMessage) {
    Future.delayed(Duration(seconds: 1), () {
      captureCard().then((image) {
        AppState.backButtonDispatcher.didPopRoute();
        if (image != null)
          shareCard(image, shareMessage);
        else {
          try {
            if (Platform.isIOS) {
              Share.share(shareMessage).catchError((onError) {
                if (_userService.baseUser.uid != null) {
                  Map<String, dynamic> errorDetails = {
                    'error_msg': 'Share reward text in My winnings failed'
                  };
                  _internalOpsService.logFailure(_userService.baseUser.uid,
                      FailType.FelloRewardTextShareFailed, errorDetails);
                }
                _logger.e(onError);
              });
            } else {
              FlutterShareMe()
                  .shareToSystem(msg: shareMessage)
                  .catchError((onError) {
                if (_userService.baseUser.uid != null) {
                  Map<String, dynamic> errorDetails = {
                    'error_msg': 'Share reward text in My winnings failed'
                  };
                  _internalOpsService.logFailure(_userService.baseUser.uid,
                      FailType.FelloRewardTextShareFailed, errorDetails);
                }
                _logger.e(onError);
              });
            }
          } catch (e) {
            _logger.e(e.toString());
          }
        }
      });
    });
  }

  Future<Uint8List> captureCard() async {
    try {
      RenderRepaintBoundary imageObject =
          imageKey.currentContext.findRenderObject();
      final image = await imageObject.toImage(pixelRatio: 2);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData.buffer.asUint8List();

      return pngBytes;
    } catch (e) {
      if (_userService.baseUser.uid != null) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Share reward card creation failed'
        };
        _internalOpsService.logFailure(_userService.baseUser.uid,
            FailType.FelloRewardCardShareFailed, errorDetails);
      }

      AppState.backButtonDispatcher.didPopRoute();
      print(e.toString());
      BaseUtil.showNegativeAlert(
          "Task Failed", "Unable to capture the card at the moment");
    }
    return null;
  }

  shareCard(Uint8List image, String shareMessage) async {
    try {
      if (Platform.isAndroid) {
        final directory = (await getExternalStorageDirectory()).path;
        String dt = DateTime.now().toString();
        File imgg = new File('$directory/fello-reward-$dt.png');
        imgg.writeAsBytesSync(image);
        Share.shareFiles(
          [imgg.path],
          subject: 'Fello Rewards',
          text: shareMessage ?? "",
        ).catchError((onError) {
          if (_userService.baseUser.uid != null) {
            Map<String, dynamic> errorDetails = {
              'error_msg': 'Share reward card in card.dart failed'
            };
            _internalOpsService.logFailure(_userService.baseUser.uid,
                FailType.FelloRewardCardShareFailed, errorDetails);
          }
          print(onError);
        });
      } else if (Platform.isIOS) {
        String dt = DateTime.now().toString();

        final directory = await getTemporaryDirectory();
        if (!await directory.exists()) await directory.create(recursive: true);

        final File imgg =
            await new File('${directory.path}/fello-reward-$dt.jpg').create();
        imgg.writeAsBytesSync(image);

        _logger.d("Image file created and sharing, ${imgg.path}");

        Share.shareFiles(
          [imgg.path],
          subject: 'Fello Rewards',
          text: shareMessage ?? "",
        ).catchError((onError) {
          if (_userService.baseUser.uid != null) {
            Map<String, dynamic> errorDetails = {
              'error_msg': 'Share reward card in card.dart failed'
            };
            _internalOpsService.logFailure(_userService.baseUser.uid,
                FailType.FelloRewardCardShareFailed, errorDetails);
          }
          print(onError);
        });
      }
    } catch (e) {
      // backButtonDispatcher.didPopRoute();
      print(e.toString());
      BaseUtil.showNegativeAlert(
          "Task Failed", "Unable to share the picture at the moment");
    }
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

  double calculateFillHeight(
      double winningAmount, double containerHeight, int redeemAmount) {
    double fillPercent = (winningAmount / redeemAmount) * 100;
    double heightToFill = (fillPercent / 100) * containerHeight;

    return heightToFill;
  }

  getFelloFacts() async {
    isFelloFactsLoading = true;
    final res = await _campaignRepo.getFelloFacts();
    if (res.isSuccess()) {
      fellofacts = res.model;
      _logger.d("Fello Facts Fetched Length: ${fellofacts.length}");
    } else {
      fellofacts = [];
    }
    _logger.d("Fello Facts Length: ${fellofacts.length}");
    isFelloFactsLoading = false;
  }

  getRedeemAsset(double walletBalnce) {
    if (walletBalnce == 0) {
      return Assets.prizeClaimAssets[0];
    } else if (walletBalnce <= 10) {
      return Assets.prizeClaimAssets[1];
    } else if (walletBalnce > 10 && walletBalnce <= 20) {
      return Assets.prizeClaimAssets[2];
    } else if (walletBalnce > 20 && walletBalnce <= 30) {
      return Assets.prizeClaimAssets[3];
    } else if (walletBalnce > 30 && walletBalnce <= 40) {
      return Assets.prizeClaimAssets[4];
    } else if (walletBalnce > 40 && walletBalnce <= 50) {
      return Assets.prizeClaimAssets[5];
    } else if (walletBalnce > 50 && walletBalnce <= 100) {
      return Assets.prizeClaimAssets[6];
    } else if (walletBalnce > 100 && walletBalnce <= minWithdrawPrizeAmt - 1) {
      return Assets.prizeClaimAssets[7];
    } else if (walletBalnce >= minWithdrawPrizeAmt) {
      return Assets.prizeClaimAssets[8];
    }
  }
}
