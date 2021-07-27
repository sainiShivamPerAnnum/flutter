import 'package:felloapp/main.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'router/ui_pages.dart';

const String LoggedInKey = 'LoggedIn';

enum PageState { none, addPage, addAll, addWidget, pop, replace, replaceAll }
enum ScreenItem { page, dialog }
enum Homeviews { dashboard, games, finance, profile }

var scr = new GlobalKey();

class PageAction {
  PageState state;
  PageConfiguration page;
  List<PageConfiguration> pages;
  Widget widget;

  PageAction(
      {this.state = PageState.none,
      this.page = null,
      this.pages = null,
      this.widget = null});
}

class AppState extends ChangeNotifier {
  int _rootIndex = 0;
  int _gameTabIndex = 0;
  int _gameIndex = 0;
  static ScrollController homeCardListController = ScrollController();
  static String _fcmData;
  static bool isRootLoaded = false;
  static bool unsavedChanges = false;
  static bool isOnboardingInProgress = false;
  static List<ScreenItem> screenStack = [];

  PageAction _currentAction = PageAction();

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

  int get getCurrentTabIndex => _rootIndex;

  set setCurrentTabIndex(int index) {
    _rootIndex = index;
    _saveLastTapIndex(index);
    print(_rootIndex);
    notifyListeners();
  }

  returnHome() {
    _rootIndex = 0;
    notifyListeners();
  }

  int get getCurrentGameTabIndex => _gameTabIndex;

  set setCurrentGameTabIndex(int index) {
    _gameTabIndex = index;
    print(_gameTabIndex);
    notifyListeners();
  }

  int get getCurrentGameIndex => _gameIndex;

  set setCurrentGameIndex(int index) {
    _gameIndex = index;
    print(_gameIndex);
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

  setLastTapIndex() {
    SharedPreferences.getInstance().then((instance) {
      _rootIndex = instance.getInt('lastTab') ?? 0;
    });
  }
}
