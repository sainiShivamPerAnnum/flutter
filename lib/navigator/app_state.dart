//Project imports
import 'dart:async';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/navigator/router/back_dispatcher.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_instant_view.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/haptic.dart';
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
  // final WinnerService? _winnerService = locator<WinnerService>();
  // final LeaderboardService? _lbService = locator<LeaderboardService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
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

  static void Function()? onTap;
  static InvestmentType? type;
  static double? amt;
  static bool isRepeated = false;
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

  int get getCurrentTabIndex => _rootIndex;

  set setCurrentTabIndex(int index) {
    _rootIndex = index;
    //First Call check for journey
    executeForFirstJourneyTabClick(index);
    executeNavBarItemFirstClick(index);
    _rootController.onChange(_rootController.navItems.values.toList()[index]);
    print(_rootIndex);
    notifyListeners();
  }

  void onItemTapped(int index) {
    final JourneyService _journeyService = locator<JourneyService>();
    if (JourneyService.isAvatarAnimationInProgress) return;
  _rootController.onChange(_rootController.navItems.values.toList()[index]);
    AppState.delegate!.appState.setCurrentTabIndex = index;
    trackEvent(index);
    Haptic.vibrate();
    if (_rootController.currentNavBarItemModel ==
        RootController.journeyNavBarItem)
      _journeyService.checkForMilestoneLevelChange();
    executeNavBarItemFirstClick(index);
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

  dump() {
    isRootAvailableForIncomingTaskExecution = true;
    isFirstTimeJourneyOpened = false;
    isJourneyFirstTab = false;
    isFirstTime = false;
    _rootController.navItems.clear();
  }
  // setLastTapIndex() {
  //   SharedPreferences.getInstance().then((instance) {
  //     rootIndex = instance.getInt('lastTab');
  //   });
  // }

  executeNavBarItemFirstClick(index) {
    switch (_rootController.currentNavBarItemModel.title) {
      case "Journey":
        executeForFirstJourneyTabClick(index);
        break;
      case "Save":
        executeForFirstSaveTabClick(index);
        break;
      case "Play":
        executeForFirstPlayTabClick(index);
        break;
      case "Tambola":
        executeForFirstTambolaClick(index);
        break;
      case "Accounts":
        executeForFirstAccountsTabClick(index);
        break;
      default:
        break;
    }
  }

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

  executeForFirstSaveTabClick(index) {}
  executeForFirstPlayTabClick(index) {}
  executeForFirstAccountsTabClick(index) {}

  executeForFirstTambolaClick(index) {
    final TambolaService _tambolaService = locator<TambolaService>();
    _tambolaService.completer.future.then(
      (value) {
        if ((_tambolaService.initialTicketCount ?? -1) == 0) {
          if (_tambolaService.userWeeklyBoards!.length > 0) {
            _tambolaService.initialTicketCount =
                _tambolaService.userWeeklyBoards!.length;
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                AppState.screenStack.add(ScreenItem.dialog);
                Navigator.of(AppState.delegate!.navigatorKey.currentContext!)
                    .push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) =>
                        TambolaInstantView(
                      ticketCount: _tambolaService.userWeeklyBoards!.length,
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }

  void trackEvent(int index) {
    final ScratchCardService _gtService = locator<ScratchCardService>();
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
            "Unscratched Ticket Count": _gtService.unscratchedTicketsCount,
            "Scratched Ticket Count": (_gtService.activeScratchCards.length) -
                _gtService.unscratchedTicketsCount,
          }));
    } else if (_rootController.currentNavBarItemModel ==
        RootController.tambolaNavBar) {
      _analyticsService.track(eventName: "Tambola tab tapped", properties: {
        "Ticket count": locator<TambolaService>().userWeeklyBoards?.length ?? 0,
        "index": index
      });
    }
  }
}
