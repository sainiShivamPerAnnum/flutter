import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/golden_ticket_claim.dart';
import 'package:felloapp/ui/modals_sheets/security_modal_sheet.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/profile/my_winnings/my_winnings_view.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/journey_page_data.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RootViewModel extends BaseModel {
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final HttpModel _httpModel = locator<HttpModel>();
  final FcmHandler _fcmListener = locator<FcmHandler>();
  final LocalDBModel _localDBModel = locator<LocalDBModel>();
  final UserService _userService = locator<UserService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final LocalDBModel _lModel = locator<LocalDBModel>();
  final DBModel _dbModel = locator<DBModel>();
  final JourneyRepository _journeyRepo = locator<JourneyRepository>();
  final JourneyService _journeyService = locator<JourneyService>();
  int _bottomNavBarIndex = 1;

  final winnerService = locator<WinnerService>();
  final txnService = locator<TransactionService>();
  final _analyticsService = locator<AnalyticsService>();
  final _paytmService = locator<PaytmService>();

  final _refRepo = locator<ReferralRepo>();

  BuildContext rootContext;
  bool _isInitialized = false;
  bool _isUploading = false;

  get isUploading => this._isUploading;
  String _svgSource = '';

  String get svgSource => this._svgSource;
  int get bottomNavBarIndex => this._bottomNavBarIndex;

  set svgSource(value) {
    this._svgSource = value;
    notifyListeners();
  }

  set isUploading(value) {
    this._isUploading = value;
    notifyListeners();
  }

  set bottomNavBarIndex(int index) {
    this._bottomNavBarIndex = index;
    notifyListeners();
  }

  String get myUserDpUrl => _userService.myUserDpUrl;
  //int get currentTabIndex => _appState.rootIndex;

  Future<void> refresh() async {
    if (AppState().getCurrentTabIndex == 2) return;
    await _userCoinService.getUserCoinBalance();
    await _userService.getUserFundWalletData();
    txnService.signOut();
    _paytmService.getActiveSubscriptionDetails();
    await txnService.fetchTransactions();
  }

  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  // List<Widget> pages;

  onInit() {
    // pages = <Widget>[Save(), Play(), Win()];
    // AppState.delegate.appState.setCurrentTabIndex = 1;
    AppState().setRootLoadValue = true;
    _initDynamicLinks(AppState.delegate.navigatorKey.currentContext);
    _verifyReferral(AppState.delegate.navigatorKey.currentContext);
  }

  onDispose() {
    // if (_baseUtil != null) _baseUtil.cancelIncomingNotifications();
    _fcmListener.addIncomingMessageListener(null);
  }

  openAlertsScreen() {
    Haptic.vibrate();
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: NotificationsConfig);
  }

  showDrawer() {
    // print("drawer opened");
    //AppState.screenStack.add(ScreenItem.dialog);
    scaffoldKey.currentState.openDrawer();
    _analyticsService.track(eventName: AnalyticsEvents.profileClicked);
  }

  // showTicketModal(BuildContext context) {
  //   AppState.screenStack.add(ScreenItem.dialog);
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (ctx) {
  //         return WantMoreTicketsModalSheet();
  //       });
  // }

  void onItemTapped(int index) {
    if (JourneyService.isAvatarAnimationInProgress) return;
    switch (index) {
      //TODO: use the analytics event provided for journey.
      case 0:
        print('journey triggered');
        break;
      case 1:
        _analyticsService.track(eventName: AnalyticsEvents.playSection);
        break;
      case 2:
        _analyticsService.track(eventName: AnalyticsEvents.saveSection);
        break;
      case 3:
        _analyticsService.track(eventName: AnalyticsEvents.winSection);
        break;

      default:
    }
    bottomNavBarIndex = index;
    _userService.buyFieldFocusNode.unfocus();
    AppState.delegate.appState.setCurrentTabIndex = index;
    Haptic.vibrate();
    notifyListeners();
    if (AppState.delegate.appState.getCurrentTabIndex == 0)
      _journeyService.checkAndAnimateAvatar();
  }

  _initAdhocNotifications() {
    if (_fcmListener != null && _baseUtil != null) {
      _fcmListener.addIncomingMessageListener((valueMap) {
        if (valueMap['title'] != null && valueMap['body'] != null) {
          BaseUtil.showPositiveAlert(valueMap['title'], valueMap['body'],
              seconds: 5);
        }
      });
    }
  }

  // uploadMilestone(){

  // }

  downloadJourneyPage() {
    _journeyRepo.fetchJourneyPages(1, JourneyRepository.PAGE_DIRECTION_UP);
  }

  uploadJourneyPage() async {
    // await _journeyRepo.uploadJourneyPage(jourenyPages.first);
    log(json.encode(jourenyPages.last.toMap()));
  }

  uploadMilestones() async {
    // jourenyPages.forEach((page) => page.milestones.forEach((milestone) {
    //       log(milestone.toMap().toString());
    //     }));
    log(json.encode(jourenyPages
        .map((e) => e.milestones.map((m) => m.toMap(e.page)).toList())
        .toList()));
  }

  // completeNViewDownloadSaveLViewAsset() async {
  //   if (_journeyRepo.checkIfAssetIsAvailableLocally('b1')) {
  //     log("ROOTVM: Asset path found cached in local storage.showing asset from cache");
  //     svgSource = _journeyRepo.getAssetLocalFilePath('b1');
  //   } else {
  //     svgSource = "https://journey-assets-x.s3.ap-south-1.amazonaws.com/b1.svg";
  //     log("ROOTVM: Asset path not found in cache. Downloading and caching it now. also showing network Image for now");
  //     await Future.delayed(Duration(seconds: 5));
  //     final bool result = await _journeyRepo.downloadAndSaveFile(
  //         "https://journey-assets-x.s3.ap-south-1.amazonaws.com/b1.svg");
  //     if (result) {
  //       log("ROOTVM: Asset downlaoding & caching completed successfully. updating asset from local to network in widget tree");

  //       svgSource = _journeyRepo.getAssetLocalFilePath('b1');
  //     } else {
  //       log("ROOTVM: Asset downlaoding & caching failed. showing asset from network this time, will try again on next startup");
  //     }
  //   }
  // }

  Future<void> openJourneyView() async {
    AppState.delegate.appState.currentAction =
        PageAction(page: JourneyViewPageConfig, state: PageState.addPage);
  }

  void _showSecurityBottomSheet() {
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      isBarrierDismissable: false,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      backgroundColor: UiConstants.bottomNavBarColor,
      content: const SecurityModalSheet(),
    );
  }

  initialize() async {
    bool canExecuteStartupNotification = true;
    if (!_isInitialized) {
      // bool showSecurityPrompt = false;
      // if (_userService.showSecurityPrompt == null) {
      //   showSecurityPrompt = await _lModel.showSecurityPrompt();
      //   _userService.showSecurityPrompt = showSecurityPrompt;
      // }

      _isInitialized = true;
      _initAdhocNotifications();

      _baseUtil.getProfilePicture();
      // show security modal
      // if (showSecurityPrompt &&
      //     _userService.baseUser.isAugmontOnboarded &&
      //     _userService.userFundWallet.augGoldQuantity > 0 &&
      //     _userService.baseUser.userPreferences
      //             .getPreference(Preferences.APPLOCK) ==
      //         0) {
      //   canExecuteStartupNotification = false;
      //   WidgetsBinding.instance?.addPostFrameCallback((_) {
      //     _showSecurityBottomSheet();
      //     _localDBModel.updateSecurityPrompt(false);
      //   });
      // }

      if (canExecuteStartupNotification &&
          AppState.startupNotifMessage != null) {
        canExecuteStartupNotification = false;
        _logger.d(
          "terminated startup message: ${AppState.startupNotifMessage}",
        );
        _fcmListener.handleMessage(
          AppState.startupNotifMessage,
          MsgSource.Terminated,
        );
      }

      // if (canExecuteStartupNotification &&
      //     _userService.isAnyUnscratchedGTAvailable) {
      //   int lastWeekday;
      //   if (await CacheManager.exits(CacheManager.CACHE_LAST_UGT_CHECK_TIME))
      //     lastWeekday = await CacheManager.readCache(
      //         key: CacheManager.CACHE_LAST_UGT_CHECK_TIME, type: CacheType.int);
      //   // _logger.d("Unscratched Golden Ticket Show Count: $count");
      //   if (lastWeekday == null ||
      //       lastWeekday == 7 ||
      //       lastWeekday < DateTime.now().weekday)
      //     BaseUtil.openDialog(
      //       addToScreenStack: true,
      //       hapticVibrate: true,
      //       isBarrierDismissable: false,
      //       content: FelloInfoDialog(
      //         showCrossIcon: true,
      //         asset: Assets.goldenTicket,
      //         title: "Your Golden Tickets are waiting",
      //         subtitle:
      //             "You have unopened Golden Tickets available in your rewards wallet",
      //         action: FelloButtonLg(
      //           child: Text(
      //             "Open Rewards",
      //             style: TextStyles.body2.bold.colour(Colors.white),
      //           ),
      //           onPressed: () {
      //             AppState.backButtonDispatcher.didPopRoute();
      //             AppState.delegate.appState.currentAction = PageAction(
      //               widget: MyWinningsView(openFirst: true),
      //               page: MyWinnigsPageConfig,
      //               state: PageState.addWidget,
      //             );
      //           },
      //         ),
      //       ),
      //     );
      //   CacheManager.writeCache(
      //       key: CacheManager.CACHE_LAST_UGT_CHECK_TIME,
      //       value: DateTime.now().weekday,
      //       type: CacheType.int);
      // }
    }
  }

  Future<dynamic> _verifyReferral(BuildContext context) async {
    if (BaseUtil.referrerUserId != null) {
      // when referrer id is fetched from one-link
      if (PreferenceHelper.getBool(
        PreferenceHelper.REFERRAL_PROCESSED,
        def: false,
      )) return;

      await _httpModel.postUserReferral(
        _userService.baseUser.uid,
        BaseUtil.referrerUserId,
        _userService.myUserName,
      );

      _logger.d('referral processed from link');
      PreferenceHelper.setBool(PreferenceHelper.REFERRAL_PROCESSED, true);
    } else if (BaseUtil.manualReferralCode != null) {
      if (BaseUtil.manualReferralCode.length == 4) {
        _verifyFirebaseManualReferral(context);
      } else {
        _verifyOneLinkManualReferral();
      }
    }
  }

  Future<dynamic> _verifyOneLinkManualReferral() async {
    final referrerId = await _refRepo
        .getUserIdByRefCode(BaseUtil.manualReferralCode.toUpperCase());

    if (referrerId.code == 200) {
      await _httpModel.postUserReferral(
        _userService.baseUser.uid,
        referrerId.model,
        _userService.myUserName,
      );
    }
  }

  Future<dynamic> _verifyFirebaseManualReferral(BuildContext context) async {
    try {
      PendingDynamicLinkData dynamicLinkData =
          await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(
              '${FlavorConfig.instance.values.dynamicLinkPrefix}/app/referral/${BaseUtil.manualReferralCode}'));
      Uri deepLink = dynamicLinkData?.link;
      _logger.d(deepLink.toString());
      if (deepLink != null)
        return _processDynamicLink(
          _userService.baseUser.uid,
          deepLink,
          context,
        );
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  Future<dynamic> _initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink == null) return null;
      _logger.d('Received deep link. Process the referral');
      return _processDynamicLink(_userService.baseUser.uid, deepLink, context);
    }, onError: (OnLinkErrorException e) async {
      _logger.e('Error in fetching deeplink');
      _logger.e(e);
      return null;
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      _logger.d('Received deep link. Process the referral');
      return _processDynamicLink(_userService.baseUser.uid, deepLink, context);
    }
  }

  _processDynamicLink(String userId, Uri deepLink, BuildContext context) async {
    String _uri = deepLink.toString();

    if (_uri.startsWith(Constants.GOLDENTICKET_DYNAMICLINK_PREFIX)) {
      //Golden ticket dynamic link
      int flag = await _submitGoldenTicket(userId, _uri, context);
    } else if (_uri.startsWith(Constants.APP_DOWNLOAD_LINK)) {
      _submitTrack(_uri);
    } else if (_uri.startsWith(Constants.APP_NAVIGATION_LINK)) {
      try {
        final path =
            _uri.substring(Constants.APP_NAVIGATION_LINK.length, _uri.length);
        AppState.delegate.parseRoute(Uri.parse(path));
      } catch (error) {
        _logger.e(error);
      }
    } else {
      BaseUtil.manualReferralCode =
          null; //make manual Code null in case user used both link and code

      //Referral dynamic link
      bool _flag = await _submitReferral(
        _userService.baseUser.uid,
        _userService.myUserName,
        _uri,
      );

      if (_flag) {
        _logger.d('Rewards added');
        refresh();
      } else {
        // _logger.d('$addUserTicketCount tickets need to be added for the user');
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

  Future<bool> _submitReferral(
      String userId, String userName, String deepLink) async {
    try {
      String prefix = 'https://fello.in/';
      if (deepLink.startsWith(prefix)) {
        String referee = deepLink.replaceAll(prefix, '');
        _logger.d(referee);
        if (prefix.length > 0 && prefix != userId) {
          return _httpModel
              .postUserReferral(userId, referee, userName)
              .then((flag) {
            // _logger.d('User deserves $userTicketUpdateCount more tickets');
            return flag;
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

  Future<int> _submitGoldenTicket(
      String userId, String deepLink, BuildContext context) async {
    try {
      String prefix = "https://fello.in/goldenticketdynlnk/";
      if (!deepLink.startsWith(prefix)) return -1;
      String docId = deepLink.replaceAll(prefix, '');
      if (docId != null && docId.isNotEmpty) {
        return _httpModel
            .postGoldenTicketRedemption(userId, docId)
            .then((redemptionMap) {
          //_logger.d('Flag is ${tckCount.toString()}');
          if (redemptionMap != null &&
              redemptionMap['flag'] &&
              redemptionMap['count'] > 0) {
            _userCoinService.getUserCoinBalance();
            _userService.getUserFundWalletData();

            AppState.screenStack.add(ScreenItem.dialog);
            return showDialog(
              context: context,
              builder: (_) => GoldenTicketClaimDialog(
                ticketCount: redemptionMap['count'],
                cashPrize: redemptionMap['amt'],
              ),
            );
          } else {
            AppState.screenStack.add(ScreenItem.dialog);
            return showDialog(
              context: context,
              builder: (_) => GoldenTicketClaimDialog(
                ticketCount: 0,
                failMsg: redemptionMap['fail_msg'],
              ),
            );
          }
        });
      }
      return -1;
    } catch (e) {
      _logger.e('$e');
      return -1;
    }
  }

  // void earnMoreTokens() {
  //   _analyticsService.track(eventName: AnalyticsEvents.earnMoreTokens);
  //        BaseUtil.openModalBottomSheet(
  //                     addToScreenStack: true,
  //                     backgroundColor: UiConstants.gameCardColor,
  //                     content: WantMoreTicketsModalSheet(),
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(SizeConfig.roundness24),
  //                       topRight: Radius.circular(SizeConfig.roundness24),
  //                     ),
  //                     hapticVibrate: true,
  //                     isScrollControlled: true,
  //                     isBarrierDismissable: true,
  //                   );
  // }

  // addJourneyPage() async {
  //   isUploading = true;
  //   jourenyPages.forEach((page) async {
  //     await _dbModel.addJourneypage(page);
  //   });
  //   isUploading = false;
  // }

  void focusBuyField() {
    Haptic.vibrate();
    if (_userService.buyFieldFocusNode.hasPrimaryFocus ||
        _userService.buyFieldFocusNode.hasFocus) {
      _logger.d("field has focus");
      FocusManager.instance.primaryFocus.unfocus();
    }
    Future.delayed(Duration(milliseconds: 100), () {
      _userService.buyFieldFocusNode.requestFocus();
    });
  }

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }
}
