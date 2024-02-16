import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/fcm/fcm_handler_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/lendbox_maturity_service.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/elements/bottom_nav_bar/default_quick_save_modal_sheet.dart';
import 'package:felloapp/ui/elements/bottom_nav_bar/quick_save_modal_sheet.dart';
import 'package:felloapp/ui/modalsheets/security_modal_sheet.dart';
import 'package:felloapp/ui/pages/onboarding/blocked_user.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/service_elements/last_week/last_week_view.dart';
import 'package:felloapp/ui/service_elements/last_week/last_week_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:firebase_instance_id/firebase_instance_id.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

enum NavBarItem { Journey, Save, Account, Play, Tambola }

class RootViewModel extends BaseViewModel {
  RootViewModel({S? l}) : locale = l ?? locator<S>();

  final FcmListener _fcmListener = locator<FcmListener>();
  final FcmHandler _fcmHandler = locator<FcmHandler>();
  final UserService _userService = locator<UserService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final UserRepository _userRepo = locator<UserRepository>();
  final TambolaService _tambolaService = locator<TambolaService>();
  final ScratchCardService _gtService = locator<ScratchCardService>();
  final BankAndPanService _bankAndKycService = locator<BankAndPanService>();
  final PowerPlayService _powerPlayService = locator<PowerPlayService>();
  final AppState appState = locator<AppState>();
  final SubService _subscriptionService = locator<SubService>();
  final S locale;
  static bool canExecuteStartupNotification = true;
  bool showHappyHourBanner = false;
  bool fetchCampaign = true;
  bool _isWelcomeAnimationInProgress = true;

  bool get isWelcomeAnimationInProgress => _isWelcomeAnimationInProgress;

  set isWelcomeAnimationInProgress(bool value) {
    _isWelcomeAnimationInProgress = value;
    notifyListeners();
  }

  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final ReferralService _referralService = locator<ReferralService>();
  final MarketingEventHandlerService _marketingService =
      locator<MarketingEventHandlerService>();
  final RootController _rootController = locator<RootController>();

  Future<void> pullToRefresh() async {
    if (_rootController.currentNavBarItemModel ==
        RootController.tambolaNavBar) {
      await Future.wait([
        // _tambolaService.getTambolaTickets(limit: 1),
        _tambolaService.getBestTambolaTickets(forced: true)
      ]);
      return;
    }

    await Future.wait([
      _userCoinService.getUserCoinBalance(),
      _userService.getUserFundWalletData(),
      _gtService.updateUnscratchedGTCount(),
    ]);

    _txnHistoryService.signOut();
  }

  Future<void> onInit() async {
    log("onInit called");

    AppState.isUserSignedIn = true;
    appState.setRootLoadValue = true;

    _rootController.currentNavBarItemModel =
        _rootController.navItems.values.first;

    await initialize();
  }

  Future<void> initialize() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await _userService.userBootUpEE();
        _checkForAppUpdates();
        if (!await verifyUserBootupDetails()) return;
        await showLastWeekOverview();
        await locator<LendboxMaturityService>().init();
        showMarketingCampings();
        await Future.wait([
          _referralService.verifyReferral(),
          _referralService.initDynamicLinks(),
        ]);
        unawaited(getFirebaseAppInstanceId());
        unawaited(handleStartUpNotificationData());
        await locator<ReferralService>().fetchReferralCode();
        await Future.wait([
          // _userService.checkForNewNotifications(),
          _gtService.updateUnscratchedGTCount(),
          // _tambolaService.refreshTickets(),
          _userService.getProfilePicture(),
          _fcmListener.refreshTopics(),
        ]);

        _initAdhocNotifications();
      },
    );
  }

  Future<void> getFirebaseAppInstanceId() async {
    var instanceId =
        await FirebaseInstanceId.appInstanceId ?? 'Unknown installation id';
    _logger.i("Firebase app instance id: $instanceId");
  }

  void _checkForAppUpdates() {
    if (Platform.isAndroid) {
      InAppUpdate.checkForUpdate().then((info) {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          InAppUpdate.startFlexibleUpdate().then((result) {
            if (result == AppUpdateResult.success) {
              InAppUpdate.completeFlexibleUpdate()
                  .catchError((e) => _logger.e(e.toString()));
            }
          }).catchError((e) {
            _logger.e(e.toString());
          });
        }
      }).catchError((e) {
        _logger.e(e.toString());
      });
    }
  }

  void showMarketingCampings() {
    final isComplete = PreferenceHelper.getBool(
      PreferenceHelper.isUserOnboardingComplete,
      def: false,
    );

    if (AppState.isRootAvailableForIncomingTaskExecution && isComplete) {
      Future.delayed(
        const Duration(seconds: 2),
        _marketingService.getCampaigns,
      );
    }
  }

  Map<Widget, NavBarItemModel> get navBarItems =>
      locator<RootController>().navItems;

  void onDispose() {
    AppState.isUserSignedIn = false;
    appState.setRootLoadValue = false;
    _fcmHandler.addIncomingMessageListener(null);
  }

  void _initAdhocNotifications() {
    _fcmHandler.addIncomingMessageListener((valueMap) {
      if (valueMap['title'] != null && valueMap['body'] != null) {
        if (AppState.screenStack.last == ScreenItem.dialog ||
            AppState.screenStack.last == ScreenItem.modalsheet) return;
        BaseUtil.showPositiveAlert(valueMap['title'], valueMap['body'],
            seconds: 5);
      }
    });
  }

  FileType getFileType(String fileUrl) {
    String extension = fileUrl.toLowerCase().split('.').last;

    switch (extension) {
      case "svg":
        return FileType.svg;
      case "json":
      case "lottie":
        return FileType.lottie;
      case "png":
      case "jpeg":
      case "webp":
      case "jpg":
        return FileType.png;
      default:
        return FileType.unknown;
    }
  }

  Widget centerTab(
    BuildContext context,
  ) {
    Widget childWidget;
    final quickSaveData = _userService.quickSaveModel?.data;

    if (quickSaveData == null || quickSaveData.isEmpty) {
      return defaultCenterButton();
    }

    if (quickSaveData[0].outerAssetUrl != null &&
        quickSaveData[0].outerAssetUrl!.isNotEmpty) {
      String fileUrl = quickSaveData[0].outerAssetUrl!;
      childWidget = BaseUtil.getWidgetBasedOnUrl(fileUrl);
    } else if (quickSaveData.length == 1) {
      String fileUrl = quickSaveData[0].icon!;
      childWidget = BaseUtil.getWidgetBasedOnUrl(fileUrl);
    } else {
      childWidget = const Icon(
        Icons.add,
        color: Colors.white,
      );
    }

    void onTap() {
      if (quickSaveData.length == 1) {
        if (quickSaveData[0].action == null ||
            (quickSaveData[0].action?.isEmpty ?? false)) {
          BaseUtil().openRechargeModalSheet(
            investmentType: InvestmentType.AUGGOLD99,
          );
        } else {
          AppState.delegate!.parseRoute(Uri.parse(quickSaveData[0].action!));
        }
      } else {
        BaseUtil.openModalBottomSheet(
          addToScreenStack: true,
          enableDrag: false,
          hapticVibrate: true,
          isBarrierDismissible: true,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          content: QuickSaveModalSheet(
            quickSaveData: quickSaveData,
          ),
        );
      }

      locator<AnalyticsService>().track(
        eventName: AnalyticsEvents.quickCheckoutTapped,
      );
    }

    return FloatingActionButton(
      elevation: 10,
      onPressed: onTap,
      backgroundColor: Colors.black,
      child: childWidget,
    );
  }

  Widget defaultCenterButton() {
    return FloatingActionButton(
      elevation: 10,
      backgroundColor: Colors.black,
      onPressed: () {
        BaseUtil.openModalBottomSheet(
          addToScreenStack: true,
          enableDrag: false,
          hapticVibrate: true,
          isBarrierDismissible: true,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          content: const DefaultQuickSaveModalSheet(),
        );
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Future<void> openJourneyView() async {
    AppState.delegate!.appState.currentAction =
        PageAction(page: JourneyViewPageConfig, state: PageState.addPage);
  }

  void _showSecurityBottomSheet() {
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      isBarrierDismissible: false,
      borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(30.0),
          topRight: Radius.circular(SizeConfig.roundness12)),
      backgroundColor:
          UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
      content: SecurityModalSheet(),
    );
    _fcmHandler.addIncomingMessageListener((valueMap) {
      if (valueMap['title'] != null && valueMap['body'] != null) {
        BaseUtil.showPositiveAlert(valueMap['title'], valueMap['body'],
            seconds: 5);
      }
    });
  }

  Future<void> checkForBootUpAlerts() async {
    bool updateAvailable =
        PreferenceHelper.getBool(Constants.IS_APP_UPDATE_AVAILABLE, def: false);
    bool isMsgNoticeAvailable =
        PreferenceHelper.getBool(Constants.IS_MSG_NOTICE_AVAILABLE, def: false);
    if (AppState.isRootAvailableForIncomingTaskExecution == false) return;
    if (updateAvailable) {
      AppState.isRootAvailableForIncomingTaskExecution = false;
      await BaseUtil.openDialog(
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
              if (Platform.isIOS) {
                BaseUtil.launchUrl(Constants.APPLE_STORE_APP_LINK);
              } else if (Platform.isAndroid) {
                BaseUtil.launchUrl(Constants.PLAY_STORE_APP_LINK);
              }
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
      AppState.isRootAvailableForIncomingTaskExecution = true;
    } else if (isMsgNoticeAvailable) {
      AppState.isRootAvailableForIncomingTaskExecution = false;
      String msg = PreferenceHelper.getString(Constants.MSG_NOTICE);
      await BaseUtil.openDialog(
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
      AppState.isRootAvailableForIncomingTaskExecution = true;
    }
  }

  Future<void> handleStartUpNotificationData() async {
    if (AppState.isRootAvailableForIncomingTaskExecution == true &&
        AppState.startupNotifMessage != null) {
      AppState.isRootAvailableForIncomingTaskExecution = false;
      await _fcmHandler.handleMessage(
        AppState.startupNotifMessage,
        MsgSource.Terminated,
      );
      AppState.isRootAvailableForIncomingTaskExecution = true;
    }
    await _userService.checkForNewNotifications();
  }

  Future<void> checkIfAppLockModalSheetIsRequired() async {
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
      Future.delayed(const Duration(seconds: 2), () {
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

  Future<bool> verifyUserBootupDetails() async {
    bool flag = true;
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

          flag = false;
          return;
        }

        //2. Check if the user is from restricted state
        if (_userService.userBootUp != null &&
            (_userService.userBootUp!.data?.stateRestricted ?? false)) {
          log("User is from restricted state", name: "UserBootUp");
          AppState.isRootAvailableForIncomingTaskExecution = false;
          AppState.delegate!.appState.currentAction = PageAction(
              state: PageState.replaceWidget,
              page: BlockedUserPageConfig,
              widget: BlockedUserView(
                isStateRestricted: true,
                blockTitle: _userService.userBootUp!.data?.blockTitle ?? '',
                blockSubtitle:
                    _userService.userBootUp!.data?.blockSubtitle ?? '',
              ));
          return;
        }

        //2. Check if app is in maintenance mode
        if (_userService.userBootUp != null &&
            (_userService.userBootUp!.data?.isAppInMaintenance ?? false)) {
          log("User is from restricted state", name: "UserBootUp");
          AppState.isRootAvailableForIncomingTaskExecution = false;
          AppState.delegate!.appState.currentAction = PageAction(
              state: PageState.replaceWidget,
              page: BlockedUserPageConfig,
              widget: BlockedUserView(
                isMaintenanceMode: true,
                blockTitle: _userService.userBootUp!.data?.blockTitle ?? '',
                blockSubtitle:
                    _userService.userBootUp!.data?.blockSubtitle ?? '',
              ));
          return;
        }

        // 3.Checking for forced App Update
        if (_userService.userBootUp!.data!.isAppForcedUpdateRequired != null &&
            _userService.userBootUp!.data!.isAppForcedUpdateRequired == true) {
          AppState.isUpdateScreen = true;
          AppState.isRootAvailableForIncomingTaskExecution = false;
          AppState.delegate!.appState.currentAction = PageAction(
              state: PageState.replaceAll, page: UpdateRequiredConfig);
          flag = false;
          return;
        }

        //4. Sign out the user automatically
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
              _tambolaService.dispose();
              _analyticsService.signOut();
              _bankAndKycService.dump();
              _subscriptionService.dispose();
              _powerPlayService.dump();
              AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.replaceAll, page: SplashPageConfig);
              BaseUtil.showPositiveAlert(
                'Session timed out ⚠️',
                'Please sign in again.',
              );
            }
          });
          flag = false;
          return;
        }

        //5. App update present (Not forced)
        if (_userService.userBootUp!.data!.isAppUpdateRequired) {
          AppState.isRootAvailableForIncomingTaskExecution = false;
          unawaited(
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
                    if (Platform.isIOS) {
                      BaseUtil.launchUrl(Constants.APPLE_STORE_APP_LINK);
                    } else if (Platform.isAndroid) {
                      BaseUtil.launchUrl(Constants.PLAY_STORE_APP_LINK);
                    }
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
            ),
          );
          return;
        }

        //6. Clear all the caches
        final keys = _userService.userBootUp?.data?.cache?.keys;
        if (keys != null) {
          keys.forEach(CacheService.invalidateByKey);
        }

        //7. Notice
        if (_userService.userBootUp?.data?.notice != null) {
          if (_userService.userBootUp!.data!.notice!.message != null &&
              _userService.userBootUp!.data!.notice!.message != "") {
            AppState.isRootAvailableForIncomingTaskExecution = false;
            String msg = PreferenceHelper.getString(Constants.MSG_NOTICE);
            unawaited(
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
              ),
            );
            return;
          }

          if (_userService.userBootUp!.data!.notice!.url != null &&
              _userService.userBootUp!.data!.notice!.url != "") {
            AppState.isRootAvailableForIncomingTaskExecution = false;
            try {
              if (Platform.isIOS) {
                BaseUtil.launchUrl(_userService.userBootUp!.data!.notice!.url!);
              } else if (Platform.isAndroid) {
                BaseUtil.launchUrl(_userService.userBootUp!.data!.notice!.url!);
              }
            } catch (e) {
              _logger.d(e.toString());
            }
          }
        }
      }
    });
    return flag;
  }

  Future<void> showLastWeekOverview() async {
    if (isWelcomeAnimationInProgress &&
        AppState.isFirstTime == false &&
        !_userService.isUserInFirstWeekOfSignUp() &&
        await BaseUtil.isFirstTimeThisWeek()) {
      log('showLastWeekOverview condition ok', name: 'HomeVM');

      final response = await locator<CampaignRepo>().getLastWeekData();

      log('last_week => ${response.model?.toJson()}', name: 'HomeVM');

      try {
        if (response.isSuccess() &&
            response.model != null &&
            response.model?.data != null) {
          if (AppState.screenStack.length == 1 &&
              (AppState.screenStack.last != ScreenItem.dialog ||
                  AppState.screenStack.last != ScreenItem.modalsheet)) {
            AppState.isRootAvailableForIncomingTaskExecution = false;
            unawaited(BaseUtil.openModalBottomSheet(
              addToScreenStack: true,
              backgroundColor: UiConstants.gameCardColor,
              content: LastWeekUi(
                model: response.model!.data!,
                fromRoot: true,
                callCampaign: true,
                lastWeekViewModel: locator<LastWeekViewModel>(),
              ),
              hapticVibrate: true,
              isScrollControlled: true,
              isBarrierDismissible: false,
            ));

            fetchCampaign = false;
          } else {
            await PreferenceHelper.setInt(PreferenceHelper.LAST_WEEK_NUMBER, 0);
          }
        } else {
          await PreferenceHelper.setInt(PreferenceHelper.LAST_WEEK_NUMBER, 0);
        }
      } catch (e) {
        await PreferenceHelper.setInt(PreferenceHelper.LAST_WEEK_NUMBER, 0);
        debugPrint(e.toString());
      }
    }
  }
}
