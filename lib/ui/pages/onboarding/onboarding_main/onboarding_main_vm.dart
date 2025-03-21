import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/material.dart';

class OnboardingViewModel extends BaseViewModel {
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  PageController? _pageController;
  int _currentPage = 0;
  // To sync indicator with lottie animation.
  int _indicatorPosition = 0;

  double dragStartPosition = 0, dragUpdatePosition = 0;
  List<Onboarding>? _onboardingData;
  bool _isWalkthroughRegistrationInProgress = false;

  bool get isWalkthroughRegistrationInProgress =>
      _isWalkthroughRegistrationInProgress;

  set isWalkthroughRegistrationInProgress(bool value) {
    _isWalkthroughRegistrationInProgress = value;
    notifyListeners();
  }

  PageController? get pageController => _pageController;
  S locale = locator<S>();

  int get currentPage => _currentPage;

  int get indicatorPosition => _indicatorPosition;

  set indicatorPosition(int value) {
    _indicatorPosition = value;
    notifyListeners();
  }

  List<Onboarding>? get onboardingData => _onboardingData;

  set pageController(PageController? val) {
    _pageController = val;
    notifyListeners();
  }

  set currentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }

  set onboardingData(List<Onboarding>? val) {
    _onboardingData = val;
    notifyListeners();
  }

  void init() {
    pageController = PageController();
    currentPage = 0;
    final onboardingInformation = AppConfigV2.instance.onboarding;
    onboardingData = onboardingInformation;
  }

  Future<void> registerWalkthroughCompletion() async {
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.replaceAll,
      page: LoginPageConfig,
    );

    _analyticsService.track(
      eventName: AnalyticsEvents.splashScrenProceed,
    );

    await PreferenceHelper.setBool(
      PreferenceHelper.CACHE_ONBOARDING_COMPLETION,
      true,
    );
  }
}
