//Project imports
import 'package:felloapp/core/service/leaderboard_service.dart';
import 'package:felloapp/core/service/winners_service.dart';
import 'package:felloapp/navigator/router/back_dispatcher.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';

//Flutter imports
import 'package:flutter/material.dart';

//Pub imports
import 'package:shared_preferences/shared_preferences.dart';

class PageAction {
  PageState state;
  PageConfiguration page;
  List<PageConfiguration> pages;
  Widget widget;

  PageAction({this.state = PageState.none, this.page, this.pages, this.widget});
}

class AppState extends ChangeNotifier {
  final _winnerService = locator<WinnerService>();
  final _lbService = locator<LeaderboardService>();
  int _rootIndex = 1;
  static ScrollController homeCardListController = ScrollController();
  static String _fcmData;
  static bool isFirstTime = true;
  static bool isRootLoaded = false;
  static bool unsavedChanges = false;
  static bool unsavedPrefs = false;
  static bool circGameInProgress = false;
  static bool isOnboardingInProgress = false;
  static bool isUpdateScreen = false;
  static bool isDrawerOpened = false;

  static bool isSaveOpened = false;
  static bool isWinOpened = false;

  static List<ScreenItem> screenStack = [];
  static FelloRouterDelegate delegate;
  static FelloBackButtonDispatcher backButtonDispatcher;

  PageAction _currentAction = PageAction();
  // BackButtonDispatcher backButtonDispatcher;

  get rootIndex => this._rootIndex;

  set rootIndex(value) {
    this._rootIndex = value;
    notifyListeners();
  }

  scrollHome(int cardNo) {
    double scrollDepth = SizeConfig.screenHeight * 0.2 * cardNo;
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
      delegate.parseRoute(Uri.parse(_fcmData));
    }
  }

// GETTERS AND SETTERS

  int get getCurrentTabIndex => _rootIndex ?? 1;

  set setCurrentTabIndex(int index) {
    _rootIndex = index;
    if (index == 2 && isWinOpened == false) {
      _winnerService.fetchWinners();
      _winnerService.fetchTopWinner();
      _lbService.fetchReferralLeaderBoard();
      isWinOpened = true;
    }
    print(_rootIndex);
    notifyListeners();
  }

  returnHome() {
    _rootIndex = 1;
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

  // setLastTapIndex() {
  //   SharedPreferences.getInstance().then((instance) {
  //     rootIndex = instance.getInt('lastTab');
  //   });
  // }
}
