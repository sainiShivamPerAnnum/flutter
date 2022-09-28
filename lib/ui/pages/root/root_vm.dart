import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/dialogs/default_dialog.dart';
import 'package:felloapp/ui/modals_sheets/security_modal_sheet.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootViewModel extends BaseViewModel {
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
  final UserRepository _userRepo = locator<UserRepository>();
  final _tambolaService = locator<TambolaService>();
  int _bottomNavBarIndex = 1;

  final winnerService = locator<WinnerService>();

  final _txnHistoryService = locator<TransactionHistoryService>();
  final _analyticsService = locator<AnalyticsService>();
  final _paytmService = locator<PaytmService>();

  final _refRepo = locator<ReferralRepo>();

  BuildContext rootContext;
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
    _txnHistoryService.signOut();
    _paytmService.getActiveSubscriptionDetails();
    await _txnHistoryService.fetchTransactions();
    await _journeyService.checkForMilestoneLevelChange();
  }

  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  // List<Widget> pages;

  onInit() {
    // pages = <Widget>[Save(), Play(), Win()];
    // AppState.delegate.appState.setCurrentTabIndex = 1;
    AppState.isUserSignedIn = true;
    AppState().setRootLoadValue = true;
    _initDynamicLinks(AppState.delegate.navigatorKey.currentContext);
    _verifyReferral(AppState.delegate.navigatorKey.currentContext);
    initialize();
    verifyUserBootupDetails();
  }

  onDispose() {
    // if (_baseUtil != null) _baseUtil.cancelIncomingNotifications();
    AppState.isUserSignedIn = false;
    _fcmListener.addIncomingMessageListener(null);
  }

  openAlertsScreen() {
    Haptic.vibrate();
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: NotificationsConfig);
  }

  void onItemTapped(int index) {
    if (JourneyService.isAvatarAnimationInProgress) return;
    switch (index) {
      case 0:
        _analyticsService.track(eventName: AnalyticsEvents.journeySection);
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
    AppState.delegate.appState.setCurrentTabIndex = index;
    Haptic.vibrate();
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

  checkForBootUpAlerts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool updateAvilable =
        prefs.getBool(Constants.IS_APP_UPDATE_AVILABLE) ?? false;
    bool isMsgNoticeAvilable =
        prefs.getBool(Constants.IS_MSG_NOTICE_AVILABLE) ?? false;

    if (updateAvilable) {
      BaseUtil.openDialog(
        isBarrierDismissable: false,
        hapticVibrate: true,
        addToScreenStack: true,
        content: ConfirmationDialog(
          title: "App Update Avilable",
          description:
              "A new version of the app is avilable. Update now to enjoy the hastle free experience.",
          buttonText: "Update Now",
          cancelBtnText: "Not now",
          confirmAction: () {
            try {
              if (Platform.isIOS)
                BaseUtil.launchUrl(Constants.APPLE_STORE_APP_LINK);
              else if (Platform.isAndroid)
                BaseUtil.launchUrl(Constants.PLAY_STORE_APP_LINK);
            } catch (e) {
              Log(e.toString());
              BaseUtil.showNegativeAlert(
                  "Something went wrong", "Please try again");
            }
            AppState.backButtonDispatcher.didPopRoute();
          },
          cancelAction: () {
            AppState.backButtonDispatcher.didPopRoute();
            return false;
          },
        ),
      );
    } else if (isMsgNoticeAvilable) {
      String msg = prefs.getString(Constants.MSG_NOTICE) ?? " ";
      BaseUtil.openDialog(
        isBarrierDismissable: false,
        hapticVibrate: true,
        addToScreenStack: true,
        content: ConfirmationDialog(
          title: "Notice",
          description: msg,
          buttonText: "Ok",
          cancelBtnText: "Cancel",
          confirmAction: () {
            AppState.backButtonDispatcher.didPopRoute();
            return true;
          },
          cancelAction: () {
            AppState.backButtonDispatcher.didPopRoute();
            return false;
          },
        ),
      );
    }
  }

  initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bool canExecuteStartupNotification = true;

      // bool showSecurityPrompt = false;
      // if (_userService.showSecurityPrompt == null) {
      //   showSecurityPrompt = await _lModel.showSecurityPrompt();
      //   _userService.showSecurityPrompt = showSecurityPrompt;
      // }

      _userService.getUserFundWalletData();
      _userService.checkForNewNotifications();
      _userService.checkForUnscratchedGTStatus();
      _baseUtil.getProfilePicture();
      // await _baseUtil.getProfilePicture();

      _initAdhocNotifications();

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

      checkForBootUpAlerts();

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
    });
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
    } else {
      BaseUtil.showNegativeAlert(referrerId.errorMessage, '');
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

    if (_uri.startsWith(Constants.APP_DOWNLOAD_LINK)) {
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

  Future<void> verifyUserBootupDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_userService.baseUser != null && _userService.userBootUp != null) {
        //1.check if the account is blocked
        if (_userService.userBootUp.data != null &&
            _userService.userBootUp.data.isBlocked != null &&
            _userService.userBootUp.data.isBlocked == true) {
          AppState.isUpdateScreen = true;
          AppState.delegate.appState.currentAction = PageAction(
            state: PageState.replaceAll,
            page: BlockedUserPageConfig,
          );
          return;
        }
        // //2.Checking for forced App Update
        if (_userService.userBootUp.data.isAppForcedUpdateRequired != null &&
            _userService.userBootUp.data.isAppForcedUpdateRequired == true) {
          AppState.isUpdateScreen = true;
          AppState.delegate.appState.currentAction = PageAction(
              state: PageState.replaceAll, page: UpdateRequiredConfig);
          return;
        }

        //3. Sign out the user automatically
        if (_userService.userBootUp.data.signOutUser != null &&
            _userService.userBootUp.data.signOutUser == true) {
          Haptic.vibrate();

          _userService.signOut(() async {
            _analyticsService.track(eventName: AnalyticsEvents.signOut);
            _analyticsService.signOut();
            await _userRepo.removeUserFCM(_userService.baseUser.uid);
          }).then((flag) async {
            if (flag) {
              //log.debug('Sign out process complete');
              await BaseUtil().signOut();
              // _journeyService.dump();
              _tambolaService.signOut();
              _analyticsService.signOut();
              _paytmService.signout();
              AppState.backButtonDispatcher.didPopRoute();
              AppState.delegate.appState.currentAction = PageAction(
                  state: PageState.replaceAll, page: SplashPageConfig);
              BaseUtil.showPositiveAlert(
                'Signed out automatically.',
                'Seems like some internal issues. Please sign in again.',
              );
            } else {
              BaseUtil.showNegativeAlert(
                'Sign out failed',
                'Couldn\'t signout. Please try again',
              );
              //log.error('Sign out process failed');
            }
          });
        }

        //4. App update present (Not forced)
        if (_userService.userBootUp.data.isAppUpdateRequired != null) {
          PreferenceHelper.setBool(Constants.IS_APP_UPDATE_AVILABLE,
              _userService.userBootUp.data.isAppUpdateRequired);
        } else {
          PreferenceHelper.setBool(Constants.IS_APP_UPDATE_AVILABLE, false);
        }

        //5. Clear all the caches
        if (_userService.userBootUp.data.cache.keys != null) {
          for (String id in _userService.userBootUp.data.cache.keys) {
            CacheService().invalidateByKey(id);
          }
        }

        //6. Notice
        if (_userService.userBootUp.data.notice != null) {
          if (_userService.userBootUp.data.notice.message != null &&
              _userService.userBootUp.data.notice.message != "") {
            PreferenceHelper.setBool(Constants.IS_MSG_NOTICE_AVILABLE, true);
            PreferenceHelper.setString(Constants.MSG_NOTICE,
                _userService.userBootUp.data.notice.message);
          } else {
            PreferenceHelper.setBool(Constants.IS_MSG_NOTICE_AVILABLE, false);
          }

          if (_userService.userBootUp.data.notice.url != null &&
              _userService.userBootUp.data.notice.url != "") {
            try {
              if (Platform.isIOS)
                BaseUtil.launchUrl(_userService.userBootUp.data.notice.url);
              else if (Platform.isAndroid)
                BaseUtil.launchUrl(_userService.userBootUp.data.notice.url);
            } catch (e) {
              _logger.d(e.toString());
              BaseUtil.showNegativeAlert(
                  "Something went wrong", "Please try again");
            }
          } else {}
        }
      }
    });
  }
}
