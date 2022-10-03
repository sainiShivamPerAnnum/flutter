import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/onboarding/onboarding4.0/onboarding_4_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingViewModel extends BaseViewModel {
  final _analyticsService = locator<AnalyticsService>();
  final _userService = locator<UserService>();
  final UserRepository _userRepository = locator<UserRepository>();
  final JourneyService _journeyService = locator<JourneyService>();
  PageController _pageController;
  int _currentPage = 0;
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

  List<Widget> assetWidgets = [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(Assets.assetList1OnBoarding.length, (index) {
        return SvgPicture.asset(
          Assets.assetList1OnBoarding[index],
          color: Colors.white,
          width: SizeConfig.screenWidth * 0.12,
        );
      }),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(Assets.assetList2OnBoarding.length, (index) {
        return SvgPicture.asset(
          Assets.assetList2OnBoarding[index],
          width: SizeConfig.screenWidth * 0.12,
        );
      }),
    ),
    SizedBox.shrink(),
  ];

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
        'In strong, low risk assets with steady growth secured by our partners',
      ],
      [
        'Play games',
        'Earn tambola tickets and Fello tokens for your savings and play weekly games'
      ],
      [
        'Win rewards',
        'Win the daily and weekly games and and earn rewards of upto 1 Crore!',
      ],
    ];
  }

  registerWalkthroughCompletion(String comingFrom) async {
    PreferenceHelper.setBool(
        PreferenceHelper.CACHE_ONBOARDING_COMPLETION, true);
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
