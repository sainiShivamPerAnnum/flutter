import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/modalsheets/security_modal_sheet.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/shared/spotlight_controller.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

enum NavBarItem { Journey, Save, Account, Play, Tambola }

class RootViewModel extends BaseViewModel {
  RootViewModel({S? l})
      : locale = l ?? locator<S>(),
        super();

  final BaseUtil? _baseUtil = locator<BaseUtil>();

  final FcmHandler? _fcmListener = locator<FcmHandler>();
  final UserService _userService = locator<UserService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final CustomLogger? _logger = locator<CustomLogger>();
  final JourneyRepository _journeyRepo = locator<JourneyRepository>();
  final JourneyService _journeyService = locator<JourneyService>();
  final UserRepository? _userRepo = locator<UserRepository>();
  final TambolaService? _tambolaService = locator<TambolaService>();
  final ScratchCardService? _gtService = locator<ScratchCardService>();
  final BankAndPanService? _bankAndKycService = locator<BankAndPanService>();
  final AppState appState = locator<AppState>();
  final S locale;
  int _bottomNavBarIndex = 0;
  static bool canExecuteStartupNotification = true;
  bool showHappyHourBanner = false;
  // final WinnerService? winnerService = locator<WinnerService>();
  final ReferralRepo _refRepo = locator<ReferralRepo>();
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final PaytmService _paytmService = locator<PaytmService>();
  final ReferralService _referralService = locator<ReferralService>();
  final MarketingEventHandlerService _marketingService =
      locator<MarketingEventHandlerService>();
  final RootController _rootController = locator<RootController>();
  Future<void> refresh() async {
    if (_rootController.currentNavBarItemModel == RootController.tambolaNavBar)
      return;
    await _userCoinService.getUserCoinBalance();
    await _userService.getUserFundWalletData();
    _txnHistoryService.signOut();
    _paytmService.getActiveSubscriptionDetails();
    await _journeyService.checkForMilestoneLevelChange();
    await _gtService?.updateUnscratchedGTCount();
    await _journeyService.getUnscratchedGT();
  }

  onInit() {
    AppState.isUserSignedIn = true;
    appState.setRootLoadValue = true;
    _referralService.verifyReferral();
    _referralService.initDynamicLinks();

    _rootController.currentNavBarItemModel =
        _rootController.navItems.values.first;

    _tambolaService!.init();
    initialize();
  }

  initialize() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await _userService.userBootUpEE();
        await verifyUserBootupDetails();
        await checkForBootUpAlerts();
        await _userService.getUserFundWalletData();
        if (AppState.isFirstTime)
          Future.delayed(Duration(seconds: 1), () {
            SpotLightController.instance.showTourDialog();
          });
        await handleStartUpNotificationData();

        _journeyService.getUnscratchedGT();

        _userService.checkForNewNotifications();
        _userService.getProfilePicture();
        _initAdhocNotifications();
        if (!AppState.isFirstTime) showMarketingCampings();
      },
    );
  }

  void showMarketingCampings() {
    Future.delayed(Duration(seconds: 2), () {
      _marketingService.getCampaigns();
    });
  }

  Map<Widget, NavBarItemModel> get navBarItems =>
      locator<RootController>().navItems;

  onDispose() {
    AppState.isUserSignedIn = false;
    appState.setRootLoadValue = false;
    _fcmListener!.addIncomingMessageListener(null);
  }

  _initAdhocNotifications() {
    if (_fcmListener != null && _baseUtil != null) {
      _fcmListener!.addIncomingMessageListener((valueMap) {
        if (valueMap['title'] != null && valueMap['body'] != null) {
          if (AppState.screenStack.last == ScreenItem.dialog ||
              AppState.screenStack.last == ScreenItem.modalsheet) return;
          BaseUtil.showPositiveAlert(valueMap['title'], valueMap['body'],
              seconds: 5);
        }
      });
    }
  }

  // uploadMilestone(){

  // }

  // downloadJourneyPage() {
  //   _journeyRepo!.fetchJourneyPages(1, JourneyRepository.PAGE_DIRECTION_UP);
  // }

  Future<void> openJourneyView() async {
    AppState.delegate!.appState.currentAction =
        PageAction(page: JourneyViewPageConfig, state: PageState.addPage);
  }

  void _showSecurityBottomSheet() {
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      isBarrierDismissible: false,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(SizeConfig.roundness12)),
      backgroundColor:
          UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
      content: SecurityModalSheet(),
    );
    _fcmListener?.addIncomingMessageListener((valueMap) {
      if (valueMap['title'] != null && valueMap['body'] != null) {
        BaseUtil.showPositiveAlert(valueMap['title'], valueMap['body'],
            seconds: 5);
      }
    });
  }

  checkForBootUpAlerts() async {
    bool updateAvailable =
        PreferenceHelper.getBool(Constants.IS_APP_UPDATE_AVAILABLE, def: false);
    bool isMsgNoticeAvailable =
        PreferenceHelper.getBool(Constants.IS_MSG_NOTICE_AVAILABLE, def: false);
    if (AppState.isRootAvailableForIncomingTaskExecution == false) return;
    if (updateAvailable) {
      AppState.isRootAvailableForIncomingTaskExecution = false;
      BaseUtil.openDialog(
        isBarrierDismissible: false,
        hapticVibrate: true,
        addToScreenStack: true,
        content: ConfirmationDialog(
          title: "App Update Available",
          description:
              "A new version of the app is available. Update now to enjoy the hassle free experience.",
          buttonText: "Update Now",
          cancelBtnText: "Not now",
          confirmAction: () {
            try {
              if (Platform.isIOS)
                BaseUtil.launchUrl(Constants.APPLE_STORE_APP_LINK);
              else if (Platform.isAndroid)
                BaseUtil.launchUrl(Constants.PLAY_STORE_APP_LINK);
            } catch (e) {
              _logger?.e(e.toString());
            }
            AppState.backButtonDispatcher!.didPopRoute();
          },
          cancelAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
            return false;
          },
        ),
      );
    } else if (isMsgNoticeAvailable) {
      AppState.isRootAvailableForIncomingTaskExecution = false;
      String msg = PreferenceHelper.getString(Constants.MSG_NOTICE);
      BaseUtil.openDialog(
        isBarrierDismissible: false,
        hapticVibrate: true,
        addToScreenStack: true,
        content: ConfirmationDialog(
          title: "Notice",
          description: msg,
          buttonText: "Ok",
          cancelBtnText: "Cancel",
          confirmAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
            return true;
          },
          cancelAction: () {
            AppState.backButtonDispatcher!.didPopRoute();
            return false;
          },
        ),
      );
    }
  }

  handleStartUpNotificationData() {
    if (AppState.isRootAvailableForIncomingTaskExecution == true &&
        AppState.startupNotifMessage != null) {
      AppState.isRootAvailableForIncomingTaskExecution = false;
      _fcmListener?.handleMessage(
        AppState.startupNotifMessage,
        MsgSource.Terminated,
      );
    }
  }

  checkIfAppLockModalSheetIsRequired() async {
    // show security modal
    if (!canExecuteStartupNotification) return;

    bool showSecurityPrompt = PreferenceHelper.getBool(
        PreferenceHelper.CACHE_SHOW_SECURITY_MODALSHEET,
        def: true);
    if (showSecurityPrompt &&
        _userService.baseUser!.isAugmontOnboarded! &&
        _userService.userFundWallet!.augGoldQuantity > 0 &&
        _userService.baseUser!.userPreferences
                .getPreference(Preferences.APPLOCK) ==
            0) {
      canExecuteStartupNotification = false;
      Future.delayed(Duration(seconds: 2), () {
        _showSecurityBottomSheet();
        PreferenceHelper.setBool(
            PreferenceHelper.CACHE_SHOW_SECURITY_MODALSHEET, false);
      });
    }
  }

  void setShowHappyHour(bool showHappyHour) {
    showHappyHourBanner = showHappyHour;
    notifyListeners();
  }

  Future<void> verifyUserBootupDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_userService.baseUser != null && _userService.userBootUp != null) {
        //1.check if the account is blocked
        if (_userService.userBootUp!.data != null &&
            _userService.userBootUp!.data!.isBlocked != null &&
            _userService.userBootUp!.data!.isBlocked == true) {
          AppState.isRootAvailableForIncomingTaskExecution = false;
          AppState.isUpdateScreen = true;
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.replaceAll,
            page: BlockedUserPageConfig,
          );
          return;
        }
        // //2.Checking for forced App Update
        if (_userService.userBootUp!.data!.isAppForcedUpdateRequired != null &&
            _userService.userBootUp!.data!.isAppForcedUpdateRequired == true) {
          AppState.isUpdateScreen = true;
          AppState.isRootAvailableForIncomingTaskExecution = false;
          AppState.delegate!.appState.currentAction = PageAction(
              state: PageState.replaceAll, page: UpdateRequiredConfig);
          return;
        }

        //3. Sign out the user automatically
        if (_userService.userBootUp!.data!.signOutUser != null &&
            _userService.userBootUp!.data!.signOutUser == true) {
          Haptic.vibrate();
          AppState.isRootAvailableForIncomingTaskExecution = false;
          _userService.signOut(() async {
            _analyticsService.track(eventName: AnalyticsEvents.signOut);
            _analyticsService.signOut();
            await _userRepo?.removeUserFCM(_userService.baseUser!.uid);
          }).then((flag) async {
            if (flag) {
              await BaseUtil().signOut();
              _tambolaService?.signOut();
              _analyticsService.signOut();
              _paytmService.signout();
              _bankAndKycService?.dump();
              AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.replaceAll, page: SplashPageConfig);
              BaseUtil.showPositiveAlert(
                'Session timed out ⚠️',
                'Please sign in again.',
              );
            }
          });
        }

        //4. App update present (Not forced)
        if (_userService.userBootUp!.data!.isAppUpdateRequired != null) {
          PreferenceHelper.setBool(Constants.IS_APP_UPDATE_AVAILABLE,
              _userService.userBootUp!.data!.isAppUpdateRequired!);
        } else
          PreferenceHelper.setBool(Constants.IS_APP_UPDATE_AVAILABLE, false);

        //5. Clear all the caches
        if (_userService.userBootUp!.data!.cache!.keys != null) {
          for (String id
              in _userService.userBootUp!.data!.cache!.keys as List<String>) {
            CacheService.invalidateByKey(id);
          }
        }

        //6. Notice
        if (_userService.userBootUp?.data?.notice != null) {
          if (_userService.userBootUp!.data!.notice!.message != null &&
              _userService.userBootUp!.data!.notice!.message != "") {
            PreferenceHelper.setBool(Constants.IS_MSG_NOTICE_AVAILABLE, true);
            PreferenceHelper.setString(Constants.MSG_NOTICE,
                _userService.userBootUp!.data!.notice!.message!);
          } else {
            PreferenceHelper.setBool(Constants.IS_MSG_NOTICE_AVAILABLE, false);
          }

          if (_userService.userBootUp!.data!.notice!.url != null &&
              _userService.userBootUp!.data!.notice!.url != "") {
            AppState.isRootAvailableForIncomingTaskExecution = false;
            try {
              if (Platform.isIOS)
                BaseUtil.launchUrl(_userService.userBootUp!.data!.notice!.url!);
              else if (Platform.isAndroid)
                BaseUtil.launchUrl(_userService.userBootUp!.data!.notice!.url!);
            } catch (e) {
              _logger?.d(e.toString());
            }
          } else {}
        }
      }
    });
  }
}
