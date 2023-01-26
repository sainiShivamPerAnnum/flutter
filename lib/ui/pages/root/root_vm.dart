import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/repository/referral_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
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
import 'package:felloapp/ui/pages/games/tambola/tambola_instant_view.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _rootController.currentNavBarItemModel =
        _rootController.navItems.values.first;

    AppState.isUserSignedIn = true;
    AppState().setRootLoadValue = true;
    _referralService.verifyReferral();
    _referralService.initDynamicLinks();
    initialize();
  }

  initialize() async {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await verifyUserBootupDetails();
      await checkForBootUpAlerts();

      await handleStartUpNotificationData();
      _userService.getUserFundWalletData();
      _userService.checkForNewNotifications();
      _userService.getProfilePicture();
      _tambolaService!.init();
      _initAdhocNotifications();
      Future.delayed(Duration(seconds: 3), () {
        _marketingService.checkUserDailyAppCheckInStatus().then((value) {
          getHappyHourCampaign();
        });
      });
    });
  }

  Map<Widget, NavBarItemModel> get navBarItems =>
      locator<RootController>().navItems;

  onDispose() {
    _rootController.navItems.clear();
    AppState.isUserSignedIn = false;
    _fcmListener!.addIncomingMessageListener(null);
  }

  void onItemTapped(int index) {
    if (JourneyService.isAvatarAnimationInProgress) return;
    _rootController.onChange(_rootController.navItems.values.toList()[index]);

    AppState.delegate!.appState.setCurrentTabIndex = index;
    trackEvent(index);
    Haptic.vibrate();
    if (_rootController.currentNavBarItemModel ==
        RootController.journeyNavBarItem)
      _journeyService.checkForMilestoneLevelChange();

    if (_rootController.currentNavBarItemModel ==
        RootController.tambolaNavBar) {
      _tambolaService!.completer.future.then((value) {
        if ((_tambolaService!.initialTicketCount ?? -1) == 0) {
          if (_tambolaService!.userWeeklyBoards!.length > 0) {
            _tambolaService!.initialTicketCount =
                _tambolaService!.userWeeklyBoards!.length;
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                _showTambolaTicketDialog(
                    _tambolaService!.userWeeklyBoards!.length);
              },
            );
          }
        }
      });
    }
  }

  _showTambolaTicketDialog(int ticketCount) {
    AppState.screenStack.add(ScreenItem.dialog);
    Navigator.of(AppState.delegate!.navigatorKey.currentContext!).push(
      PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => TambolaInstantView(
                ticketCount: ticketCount,
              )),
    );
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

  downloadJourneyPage() {
    _journeyRepo!.fetchJourneyPages(1, JourneyRepository.PAGE_DIRECTION_UP);
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

  void trackEvent(int index) {
    if (_rootController.currentNavBarItemModel ==
        RootController.journeyNavBarItem) {
      _analyticsService.track(
          eventName: AnalyticsEvents.journeySection,
          properties: AnalyticsProperties.getDefaultPropertiesMap());
    } else if (_rootController.currentNavBarItemModel ==
        RootController.saveNavBarItem) {
      _analyticsService.track(
          eventName: AnalyticsEvents.saveSection,
          properties: AnalyticsProperties.getDefaultPropertiesMap());
    } else if (_rootController.currentNavBarItemModel ==
        RootController.playNavBarItem) {
      _analyticsService.track(
          eventName: AnalyticsEvents.playSection,
          properties:
              AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
            "Time left for draw Tambola (mins)":
                AnalyticsProperties.getTimeLeftForTambolaDraw(),
            "Tambola Tickets Owned":
                AnalyticsProperties.getTambolaTicketCount(),
          }));
    } else if (_rootController.currentNavBarItemModel ==
        RootController.winNavBarItem) {
      _analyticsService.track(
          eventName: "Account section tapped",
          properties:
              AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
            "Winnings Amount": AnalyticsProperties.getUserCurrentWinnings(),
            "Unscratched Ticket Count": _gtService?.unscratchedTicketsCount,
            "Scratched Ticket Count": (_gtService!.activeScratchCards.length) -
                _gtService!.unscratchedTicketsCount,
          }));
    } else if (_rootController.currentNavBarItemModel ==
        RootController.tambolaNavBar) {
      _analyticsService.track(eventName: "Tambola tab tapped", properties: {
        "Ticket count": locator<TambolaService>().userWeeklyBoards?.length ?? 0,
        "index": index
      });
    }
  }

  late HappyHourCampign happyHourCampaign;

  Future getHappyHourCampaign() async {
    final campaign = await locator<CampaignRepo>().getHappyHourCampaign();
    if (campaign.code == 200 && campaign.model != null) {
      if (locator.isRegistered<HappyHourCampign>()) {
        locator.unregister<HappyHourCampign>();
      }
      locator.registerSingleton<HappyHourCampign>(campaign.model!);
      final _isDuringHappyHourVisited =
          locator<SharedPreferences>().getBool("duringHappyHourVisited") ??
              false;
      if (_isDuringHappyHourVisited) {
        final date =
            locator<SharedPreferences>().getString("timStampOfHappyHour") ??
                DateTime.now().toString();

        final shouldClearCache = DateTime.now().day != DateTime.parse(date).day;

        if (shouldClearCache) {
          locator<SharedPreferences>().remove('timStampOfHappyHour');
          locator<SharedPreferences>().remove('duringHappyHourVisited');
          locator<SharedPreferences>().remove('showedAfterHappyHourDialog');
        }
      }

      if (campaign.model!.data!.showHappyHour) {
        if (!_isDuringHappyHourVisited && !AppState.isFirstTime) {
          locator<BaseUtil>().showHappyHourDialog(campaign.model!);
          locator<SharedPreferences>().setBool("duringHappyHourVisited", true);
          locator<SharedPreferences>()
              .setString('timStampOfHappyHour', DateTime.now().toString());
        }

        happyHourCampaign = campaign.model!;
        showHappyHourBanner = true;
        notifyListeners();
        return;
      }

      final endTime = DateTime.parse(campaign.model!.data!.endTime!);

      if (endTime.day != DateTime.now().day) {
        return;
      }
      final isVistedDuringHappyHour =
          locator<SharedPreferences>().getBool('duringHappyHourVisited') ??
              false;
      final isalreadyShowed =
          locator<SharedPreferences>().getBool("showedAfterHappyHourDialog") ??
              false;
      if (DateTime.now().isAfter(endTime) &&
          !isVistedDuringHappyHour &&
          !isalreadyShowed) {
        locator<BaseUtil>()
            .showHappyHourDialog(campaign.model!, afterHappyHour: true);
        locator<SharedPreferences>()
            .setBool("showedAfterHappyHourDialog", true);
      }
      ;
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
        _userService!.baseUser!.isAugmontOnboarded! &&
        _userService!.userFundWallet!.augGoldQuantity > 0 &&
        _userService!.baseUser!.userPreferences
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

  Future<dynamic> _verifyReferral(BuildContext? context) async {
    if (BaseUtil.referrerUserId != null) {
      // when referrer id is fetched from one-link
      if (PreferenceHelper.getBool(
        PreferenceHelper.REFERRAL_PROCESSED,
        def: false,
      )) return;

      await _refRepo!.createReferral(
        _userService!.baseUser!.uid,
        BaseUtil.referrerUserId,
      );

      _logger!.d('referral processed from link');
      PreferenceHelper.setBool(PreferenceHelper.REFERRAL_PROCESSED, true);
    } else if (BaseUtil.manualReferralCode != null) {
      if (BaseUtil.manualReferralCode!.length == 4) {
        _verifyFirebaseManualReferral(context);
      } else {
        _verifyOneLinkManualReferral();
      }
    }
  }

  Future<dynamic> _verifyOneLinkManualReferral() async {
    final referrerId = await _refRepo!
        .getUserIdByRefCode(BaseUtil.manualReferralCode!.toUpperCase());

    if (referrerId.code == 200) {
      await _refRepo!.createReferral(
        _userService!.baseUser!.uid,
        referrerId.model,
      );
    } else {
      BaseUtil.showNegativeAlert(referrerId.errorMessage, '');
    }
  }

  Future<dynamic> _verifyFirebaseManualReferral(BuildContext? context) async {
    try {
      PendingDynamicLinkData? dynamicLinkData =
          await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(
              '${FlavorConfig.instance!.values.dynamicLinkPrefix}/app/referral/${BaseUtil.manualReferralCode}'));
      Uri? deepLink = dynamicLinkData?.link;
      _logger!.d(deepLink.toString());
      if (deepLink != null)
        return _processDynamicLink(
          _userService!.baseUser!.uid,
          deepLink,
          context,
        );
    } catch (e) {
      _logger!.e(e.toString());
    }
  }

  Future<dynamic> _initDynamicLinks(BuildContext? context) async {
    FirebaseDynamicLinks.instance.onLink.distinct().listen((event) {
      final Uri? deepLink = event.link;
      if (deepLink == null) return null;
      _logger!.d('Received deep link. Process the referral');
      return _processDynamicLink(
          _userService!.baseUser!.uid, deepLink, context);
    }).onError((e) {
      _logger!.d('Error');
      _logger!.d(e.toString());
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      _logger!.d('Received deep link. Process the referral');
      return _processDynamicLink(
          _userService!.baseUser!.uid, deepLink, context);
    }
  }

  void setShowHappyHour(bool showHappyHour) {
    showHappyHourBanner = showHappyHour;
    notifyListeners();
  }

  _processDynamicLink(
      String? userId, Uri deepLink, BuildContext? context) async {
    String _uri = deepLink.toString();

    if (_uri.startsWith(Constants.APP_DOWNLOAD_LINK)) {
      _submitTrack(_uri);
    } else if (_uri.startsWith(Constants.APP_NAVIGATION_LINK)) {
      try {
        final path =
            _uri.substring(Constants.APP_NAVIGATION_LINK.length, _uri.length);
        AppState.delegate!.parseRoute(Uri.parse(path));
      } catch (error) {
        _logger!.e(error);
      }
    } else {
      BaseUtil.manualReferralCode =
          null; //make manual Code null in case user used both link and code

      //Referral dynamic link
      bool _flag = await _submitReferral(
        _userService!.baseUser!.uid,
        _userService!.myUserName,
        _uri,
      );

      if (_flag) {
        _logger!.d('Rewards added');
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
          _logger!.d(campaignId);
          _analyticsService!.trackInstall(campaignId);
          return true;
        }
      }
      return false;
    } catch (e) {
      _logger!.e(e);
      return false;
    }
  }

  Future<bool> _submitReferral(
      String? userId, String? userName, String deepLink) async {
    try {
      String prefix = 'https://fello.in/';
      if (deepLink.startsWith(prefix)) {
        String referee = deepLink.replaceAll(prefix, '');
        _logger!.d(referee);
        if (prefix.length > 0 && prefix != userId) {
          return _refRepo!.createReferral(userId, referee).then((res) {
            // _logger.d('User deserves $userTicketUpdateCount more tickets');
            return res.model!;
          });
        } else
          return false;
      } else
        return false;
    } catch (e) {
      _logger!.e(e);
      return false;
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
