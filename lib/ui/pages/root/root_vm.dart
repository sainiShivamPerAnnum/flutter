import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/material.dart';

class RootViewModel extends BaseViewModel {
  final FcmHandler _fcmListener = locator<FcmHandler>();
  final UserService _userService = locator<UserService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final JourneyService _journeyService = locator<JourneyService>();
  final UserRepository _userRepo = locator<UserRepository>();
  final TambolaService _tambolaService = locator<TambolaService>();
  final GoldenTicketService _gtService = locator<GoldenTicketService>();
  final BankAndPanService _bankAndKycService = locator<BankAndPanService>();
  final WinnerService winnerService = locator<WinnerService>();
  final TransactionHistoryService _txnHistoryService =
      locator<TransactionHistoryService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final PaytmService _paytmService = locator<PaytmService>();
  final ReferralService _referralService = locator<ReferralService>();
  final MarketingEventHandlerService _marketingService =
      locator<MarketingEventHandlerService>();

  Future<void> refresh() async {
    await _userCoinService.getUserCoinBalance();
    await _userService.getUserFundWalletData();
    _txnHistoryService.signOut();
    _paytmService.getActiveSubscriptionDetails();
    await _txnHistoryService.fetchTransactions(
        subtype: InvestmentType.AUGGOLD99);
    await _journeyService.checkForMilestoneLevelChange();
    await _gtService.updateUnscratchedGTCount();
    await _journeyService.getUnscratchedGT();
  }

  onInit() {
    AppState.isUserSignedIn = true;
    AppState().setRootLoadValue = true;
    _referralService.verifyReferral();
    initialize();
  }

  initialize() async {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await verifyUserBootupDetails();
      await checkForBootUpAlerts();
      await _referralService.initDynamicLinks();
      await handleStartUpNotificationData();
      _userService.getUserFundWalletData();
      _userService.checkForNewNotifications();
      _userService.getProfilePicture();
      _initAdhocNotifications();
      _marketingService.checkUserDailyAppCheckInStatus();
    });
  }

  onDispose() {
    AppState.isUserSignedIn = false;
    _fcmListener.addIncomingMessageListener(null);
  }

  void onItemTapped(int index) {
    if (JourneyService.isAvatarAnimationInProgress) return;
    switch (index) {
      case 0:
        _analyticsService.track(
            eventName: AnalyticsEvents.journeySection,
            properties: AnalyticsProperties.getDefaultPropertiesMap());
        break;
      case 1:
        _analyticsService.track(
            eventName: AnalyticsEvents.saveSection,
            properties: AnalyticsProperties.getDefaultPropertiesMap());
        break;
      case 2:
        {
          _analyticsService.track(
              eventName: AnalyticsEvents.playSection,
              properties:
                  AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
                "Time left for draw Tambola (mins)":
                    AnalyticsProperties.getTimeLeftForTambolaDraw(),
                "Tambola Tickets Owned":
                    AnalyticsProperties.getTambolaTicketCount(),
              }));
        }
        break;
      case 3:
        {
          _analyticsService.track(
              eventName: AnalyticsEvents.winSection,
              properties:
                  AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
                "Winnings Amount": AnalyticsProperties.getUserCurrentWinnings(),
                "Unscratched Ticket Count": _gtService.unscratchedTicketsCount,
                "Scratched Ticket Count":
                    (_gtService.activeGoldenTickets.length) -
                        _gtService.unscratchedTicketsCount,
              }));
        }
        break;

      default:
    }
    AppState.delegate!.appState.setCurrentTabIndex = index;
    Haptic.vibrate();
    if (AppState.delegate!.appState.getCurrentTabIndex == 0)
      _journeyService.checkForMilestoneLevelChange();
  }

  _initAdhocNotifications() {
    _fcmListener.addIncomingMessageListener((valueMap) {
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
              _logger.e(e.toString());
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
      _fcmListener.handleMessage(
        AppState.startupNotifMessage,
        MsgSource.Terminated,
      );
    }
  }

  Future<void> verifyUserBootupDetails() async {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
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
            await _userRepo.removeUserFCM(_userService.baseUser!.uid);
          }).then((flag) async {
            if (flag) {
              await BaseUtil().signOut();
              _tambolaService.signOut();
              _analyticsService.signOut();
              _paytmService.signout();
              _bankAndKycService.dump();
              AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.replaceAll, page: SplashPageConfig);
              BaseUtil.showPositiveAlert(
                'Signed out automatically.',
                'Seems like some internal issues. Please sign in again.',
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
            CacheService().invalidateByKey(id);
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
              _logger.d(e.toString());
            }
          } else {}
        }
      }
    });
  }
}
