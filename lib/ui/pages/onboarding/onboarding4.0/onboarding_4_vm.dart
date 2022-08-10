import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/onboarding/onboarding4.0/onboarding_4_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';

class OnboardingViewModel extends BaseModel {
  final _analyticsService = locator<AnalyticsService>();
  final _userService = locator<UserService>();
  final UserRepository _userRepository = locator<UserRepository>();
  final JourneyService _journeyService = locator<JourneyService>();
  PageController _pageController;
  int _currentPage;
  double dragStartPosition, dragUpdatePosition;
  List<List<String>> _onboardingData;
  bool _isWalkthroughRegistrationInProgress = false;

  get isWalkthroughRegistrationInProgress =>
      this._isWalkthroughRegistrationInProgress;

  set isWalkthroughRegistrationInProgress(value) {
    this._isWalkthroughRegistrationInProgress = value;
    notifyListeners();
  }

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

  registerWalkthroughCompletion(String comingFrom) async {
    if (_userService.firebaseUser == null) {
      PreferenceHelper.setBool(
          PreferenceHelper.CACHE_ONBOARDING_COMPLETION, true);
    } else {
      isWalkthroughRegistrationInProgress = true;
      if (_journeyService.avatarRemoteMlIndex == 1) {
        final ApiResponse<bool> res =
            await _userRepository.updateUserWalkthroughCompletion();
        if (res.isSuccess()) {
          BaseUtil.showPositiveAlert(
              "Walkthrough completed!", "You cleared milestone 1");
        } else {
          BaseUtil.showNegativeAlert(
              "Unable to registed walkthrough completion!", "Please try again");
        }
      }
      isWalkthroughRegistrationInProgress = false;
    }
    onBoardingCompleted(comingFrom);
  }

  onBoardingCompleted(String comingFrom) {
    if (comingFrom == COMING_FROM_SPLASH)
      AppState.delegate.appState.currentAction = PageAction(
        state: PageState.replaceAll,
        page: LoginPageConfig,
      );
    else
      AppState.backButtonDispatcher.didPopRoute();
  }
}
