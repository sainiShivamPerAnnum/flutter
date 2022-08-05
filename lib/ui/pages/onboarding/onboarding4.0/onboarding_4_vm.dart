import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class OnboardingViewModel extends BaseModel {
  PageController _pageController;
  int _currentPage;
  double dragStartPosition, dragUpdatePosition;
  List<List<String>> _onboardingData;

  PageController get pageController => _pageController;

  int get currentPage => _currentPage;

  List<List<String>> get onboardingData => _onboardingData;

  set pageController(PageController val) {
    _pageController = val;
    notifyListeners();
  }

  set currentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }

  set onboardingData(List<List<String>> val) {
    _onboardingData = val;
    notifyListeners();
  }

  init() {
    pageController = PageController();
    currentPage = 0;
    onboardingData = [
      [
        'Save and Invest',
        'Strong, low risk assets with steady\ngrowth',
      ],
      [
        'Play games',
        'Get Fello tokens and tambola tickets for\nyour savings and play weekly games'
      ],
      [
        'Win rewards',
        'Win the daily and weekly games and get\nrewards and prizes!',
      ],
    ];
  }

  onBoardingCompleted() {
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.replaceAll,
      page: LoginPageConfig,
    );
  }
}
