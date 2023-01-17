//Project imports
import 'dart:async';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/navigator/router/back_dispatcher.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
//Flutter imports
import 'package:flutter/material.dart';
//Pub imports
import 'package:shared_preferences/shared_preferences.dart';

class PageAction {
  PageState state;
  PageConfiguration? page;
  List<PageConfiguration>? pages;
  Widget? widget;

  PageAction({this.state = PageState.none, this.page, this.pages, this.widget});
}

class AppState extends ChangeNotifier {
  final WinnerService? _winnerService = locator<WinnerService>();
  // final LeaderboardService? _lbService = locator<LeaderboardService>();
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  final RootController _rootController = locator<RootController>();
  int _rootIndex = 0;
  static PageController homeTabPageController = PageController(initialPage: 0);
  // Future _txnFunction;
  Timer? _txnTimer;
  Future? _txnFunction;

  static Map<String, dynamic>? startupNotifMessage;
  static ScrollController homeCardListController = ScrollController();
  static String? _fcmData;
  static bool isFirstTime = false;
  static bool isRootLoaded = false;
  static bool unsavedChanges = false;
  static bool isWebGameLInProgress = false;
  static bool isWebGamePInProgress = false;
  static bool isOnboardingInProgress = false;
  static bool isUpdateScreen = false;
  static bool isDrawerOpened = false;
  static bool isUserSignedIn = false;
  static bool isSaveOpened = false;
  static bool isWinOpened = false;
  static bool isRootAvailableForIncomingTaskExecution = true;
  static bool isInstantGtViewInView = false;
  static int ticketCount = 0;
  static bool isFirstTimeJourneyOpened = false;
  static bool isJourneyFirstTab = false;

  static List<ScreenItem> screenStack = [];
  static FelloRouterDelegate? delegate;
  static FelloBackButtonDispatcher? backButtonDispatcher;

  PageAction _currentAction = PageAction();
  // BackButtonDispatcher backButtonDispatcher;

  get rootIndex => this._rootIndex;

  Timer? get txnTimer => this._txnTimer;

  set txnTimer(Timer? timer) {
    this._txnTimer = timer;
  }

  set rootIndex(value) {
    this._rootIndex = value;
    notifyListeners();
  }

  set txnFunction(Future function) {
    this._txnFunction = function;
    notifyListeners();
  }

  scrollHome(int cardNo) {
    double scrollDepth = SizeConfig.screenHeight! * 0.2 * cardNo;
    homeCardListController.animateTo(scrollDepth,
        duration: Duration(milliseconds: 600), curve: Curves.easeInOutSine);
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

  routeDeepLink() {
    if (isRootLoaded && _fcmData != null) {
      delegate!.parseRoute(Uri.parse(_fcmData!));
    }
  }

  static blockNavigation() {
    if (screenStack.last == ScreenItem.loader) return;
    screenStack.add(ScreenItem.loader);
  }

  static unblockNavigation() {
    if (screenStack.last == ScreenItem.loader) screenStack.removeLast();
  }

// GETTERS AND SETTERS

  int get getCurrentTabIndex => _rootIndex ?? 0;

  set setCurrentTabIndex(int index) {
    _rootIndex = index;
    switch (index) {
      case 0:
        _analyticsService!.trackScreen(screen: 'Journey', properties: {});
        break;
      case 1:
        _analyticsService!.trackScreen(screen: 'Save', properties: {});
        break;
      case 2:
        _analyticsService!.trackScreen(screen: 'Play', properties: {});
        break;
      case 3:
        _analyticsService!.trackScreen(screen: 'Win', properties: {});
        break;
      default:
    }
    //First Call check for journey
    executeForFirstJourneyTabClick(index);
    // if (index == 2 && isWinOpened == false) {
    //   _lbService!.fetchReferralLeaderBoard();
    //   isWinOpened = true;
    // }
    print(_rootIndex);
    notifyListeners();
  }

  returnHome() {
    _rootIndex = 0;
    print(_rootIndex);

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

  _saveLastTapIndex(int index) {
    SharedPreferences.getInstance().then((instance) {
      instance.setInt('lastTab', index);
    });
  }

  static dump() {
    isRootAvailableForIncomingTaskExecution = true;
    isFirstTimeJourneyOpened = false;
    isJourneyFirstTab = false;
    isFirstTime = false;
  }
  // setLastTapIndex() {
  //   SharedPreferences.getInstance().then((instance) {
  //     rootIndex = instance.getInt('lastTab');
  //   });
  // }

  executeForFirstJourneyTabClick(int index) {
    final JourneyService _journeyService = locator<JourneyService>();
    int journeyIndex = _rootController.navItems.values
        .toList()
        .indexWhere((item) => item.title == "Journey");
    if (journeyIndex == 0) {
      isFirstTimeJourneyOpened = true;
      isJourneyFirstTab = true;
    }
    if (!isFirstTimeJourneyOpened) {
      if (index == journeyIndex) {
        isFirstTimeJourneyOpened = true;
        _journeyService.buildJourney();
      }
    }
  }
}
