import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'router/ui_pages.dart';

const String LoggedInKey = 'LoggedIn';

enum PageState { none, addPage, addAll, addWidget, pop, replace, replaceAll }

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
  int _selectedNavIndex = 0;
  static bool _dialogOpen = false;
  PageAction _currentAction = PageAction();

  bool get getDialogOpenStatus => _dialogOpen;
  set setDialogOpenStatus(bool val) {
    _dialogOpen = val;
  }

  int get getCurrentTabIndex => _selectedNavIndex;
  set setCurrentTabIndex(int index) {
    _selectedNavIndex = index;
    print(_selectedNavIndex);
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
}
