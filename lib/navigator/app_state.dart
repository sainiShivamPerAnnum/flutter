//Project imports
import 'package:felloapp/navigator/router/back_dispatcher.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
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
  static int _rootIndex = 0;
  static ScrollController homeCardListController = ScrollController();
  static String _fcmData;
  static bool isFirstTime = true;
  static bool isRootLoaded = false;
  static bool unsavedChanges = false;
  static bool unsavedPrefs = false;
  static bool isOnboardingInProgress = false;
  static List<ScreenItem> screenStack = [];
  static FelloRouterDelegate delegate;
  static FelloBackButtonDispatcher backButtonDispatcher;

  PageAction _currentAction = PageAction();
  // BackButtonDispatcher backButtonDispatcher;

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

  static int get getCurrentTabIndex => _rootIndex ?? 0;

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

  static setLastTapIndex() {
    SharedPreferences.getInstance().then((instance) {
      _rootIndex = instance.getInt('lastTab');
    });
  }
}
