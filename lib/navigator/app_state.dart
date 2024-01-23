//Project imports
import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/router/back_dispatcher.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageAction {
  PageState state;
  PageConfiguration? page;
  List<PageConfiguration>? pages;
  Widget? widget;

  PageAction({this.state = PageState.none, this.page, this.pages, this.widget});
}

class AppState extends ChangeNotifier {
  // final WinnerService? _winnerService = locator<WinnerService>();
  // final LeaderboardService? _lbService = locator<LeaderboardService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final RootController _rootController = locator<RootController>();
  int _rootIndex = 0;
  PageController homeTabPageController = PageController(initialPage: 0);

  // Future _txnFunction;
  Timer? _txnTimer;
  Future? _txnFunction;

  static Map<String, dynamic>? startupNotifMessage;
  static ScrollController homeCardListController = ScrollController();
  static String? _fcmData;
  static bool showAutosaveBt = false;
  static bool autosaveMiddleFlow = false;
  static bool showAutoSaveSurveyBt = false;
  static bool isFirstTime = false;
  static bool isRootLoaded = false;
  static bool unsavedChanges = false;
  static bool isWebGameLInProgress = false;
  static bool isWebGamePInProgress = false;
  static bool isOnboardingInProgress = false;
  static bool isUpdateScreen = false;
  static bool isQuizInProgress = false;
  static bool isNetbankingInProgress = false;

  // static bool isDrawerOpened = false;
  static bool isUserSignedIn = false;

  // static bool isSaveOpened = false;
  // static bool isWinOpened = false;
  static bool isRootAvailableForIncomingTaskExecution = true;
  static bool isInstantGtViewInView = false;
  static int ticketCount = 0;
  static bool isFirstTimeJourneyOpened = false;
  static bool isFirstTimePlayOpened = false;
  static bool isFirstTimeSaveOpened = false;
  static bool isFirstTimeAccountsOpened = false;
  static bool isFirstTimeTambolaOpened = false;
  static bool isGoldProBuyInProgress = false;

  // static bool isJourneyFirstTab = false;
  static bool isAutosaveFlow = false;

  static List<ScreenItem> screenStack = [];
  static FelloRouterDelegate? delegate;
  static FelloBackButtonDispatcher? backButtonDispatcher;

  static void Function()? onTap;
  static InvestmentType? type;
  static double? amt;
  static bool isRepeated = false;
  static bool isTxnProcessing = false;
  PageAction _currentAction = PageAction();

  // BackButtonDispatcher backButtonDispatcher;

  int get rootIndex => _rootIndex;

  Timer? get txnTimer => _txnTimer;

  set txnTimer(Timer? timer) {
    _txnTimer = timer;
  }

  set rootIndex(value) {
    _rootIndex = value;
    notifyListeners();
  }

  set txnFunction(Future function) {
    _txnFunction = function;
    notifyListeners();
  }

  scrollHome(int cardNo) {
    double scrollDepth = SizeConfig.screenHeight! * 0.2 * cardNo;
    homeCardListController.animateTo(scrollDepth,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutSine);
    notifyListeners();
  }

  set setFcmData(String data) {
    _fcmData = data;
    routeDeepLink();
  }

  set setRootLoadValue(bool value) {
    isRootLoaded = value;
    routeDeepLink();
  }

  void routeDeepLink() {
    if (isRootLoaded && _fcmData != null) {
      delegate!.parseRoute(Uri.parse(_fcmData!));
    }
  }

  static void blockNavigation() {
    if (screenStack.last == ScreenItem.loader) return;
    screenStack.add(ScreenItem.loader);
  }

  static void unblockNavigation() {
    if (screenStack.last == ScreenItem.loader) screenStack.removeLast();
  }

  static void removeOverlay() {
    if (screenStack.last == ScreenItem.dialog ||
        screenStack.last == ScreenItem.modalsheet) screenStack.removeLast();
  }
// GETTERS AND SETTERS

  int get getCurrentTabIndex => _rootIndex;

  set setCurrentTabIndex(int index) {
    _rootIndex = index;
    debugPrint("$_rootIndex");
    notifyListeners();
  }

  void onItemTapped(int index) {
    if (_rootController.navItems.values.toList()[index].title == "Tickets") {
      if (locator<UserService>()
              .baseUser!
              .userPreferences
              .getPreference(Preferences.TAMBOLAONBOARDING) !=
          1) {
        AppState.delegate!.parseRoute(Uri.parse("ticketsIntro"));
        return;
      }
    }
    if (index == _rootIndex) {
      Haptic.vibrate();
      RootController.controller.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInCirc,
      );
      return;
    }
    _rootController.onChange(_rootController.navItems.values.toList()[index]);
    setCurrentTabIndex = index;

    trackEvent(index);
    Haptic.vibrate();
  }

  bool showTourStrip = false;

  void setTourStripValue() {
    showTourStrip = false;
    notifyListeners();
  }

  Future<void> setShowStripValue() async {
    final sharePreference = await SharedPreferences.getInstance();
    final value = sharePreference.getInt('showTour');
    final appSession = value ?? 0;
    if (appSession < 2) {
      if (appSession == 0) {
        showTourStrip = true;
        notifyListeners();
      }
      await sharePreference.setInt('showTour', appSession + 1);
    }
  }

  void returnHome() {
    _rootIndex = 0;
    log("$_rootIndex");

    notifyListeners();
  }

  PageAction get currentAction => _currentAction;

  set currentAction(PageAction action) {
    _currentAction = action;
    notifyListeners();
  }

  void resetCurrentAction() {
    _currentAction = PageAction();
  }

  void dump() {
    isRootAvailableForIncomingTaskExecution = true;
    isFirstTimeJourneyOpened = false;
    // isJourneyFirstTab = false;
    isFirstTime = false;
    _rootController.navItems.clear();

    if (homeTabPageController.hasClients) {
      homeTabPageController.dispose();
      return;
    }
  }

  void trackEvent(int index) {
    final ScratchCardService gtService = locator<ScratchCardService>();
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
            "Unscratched Ticket Count": gtService.unscratchedTicketsCount,
            "Scratched Ticket Count": (gtService.activeScratchCards.length) -
                gtService.unscratchedTicketsCount,
          }));
    } else if (_rootController.currentNavBarItemModel ==
        RootController.tambolaNavBar) {
      _analyticsService.track(eventName: "Tambola tab tapped", properties: {
        // "Ticket count": locator<TambolaService>().userWeeklyBoards?.length ?? 0,
        "index": index
      });
    }
  }

  static Future<bool> isFirstAppOpen() async {
    bool firstTime = PreferenceHelper.getBool(
        PreferenceHelper.CACHE_FIRST_TIME_APP_OPEN,
        def: true);
    if (firstTime) {
      await PreferenceHelper.setBool(
          PreferenceHelper.CACHE_FIRST_TIME_APP_OPEN, false);
    }
    return firstTime;
  }
}
