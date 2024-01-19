import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingViewModel extends BaseViewModel {
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  PageController? _pageController;
  int _currentPage = 0;
  double dragStartPosition = 0, dragUpdatePosition = 0;
  List<List<String>>? _onboardingData;
  bool _isWalkthroughRegistrationInProgress = false;

  get isWalkthroughRegistrationInProgress =>
      _isWalkthroughRegistrationInProgress;

  set isWalkthroughRegistrationInProgress(value) {
    _isWalkthroughRegistrationInProgress = value;
    notifyListeners();
  }

  PageController? get pageController => _pageController;
  S locale = locator<S>();

  int get currentPage => _currentPage;

  List<Widget> assetWidgets = [
    SvgPicture.asset(
      "assets/svg/partner_assets_frame.svg",
      width: SizeConfig.screenWidth! * 0.9,
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(Assets.assetList2OnBoarding.length, (index) {
        return SvgPicture.asset(
          Assets.assetList2OnBoarding[index],
          height: SizeConfig.screenWidth! * 0.1,
          width: SizeConfig.screenWidth! * 0.1,
          fit: BoxFit.cover,
        );
      }),
    ),
    const SizedBox.shrink(),
  ];

  List<List<String>>? get onboardingData => _onboardingData;

  set pageController(PageController? val) {
    _pageController = val;
    notifyListeners();
  }

  set currentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }

  set onboardingData(List<List<String>>? val) {
    _onboardingData = val;
    notifyListeners();
  }

  void init() {
    pageController = PageController();
    currentPage = 0;
    onboardingData = [
      [
        "Grow your savings by 12% p.a.",
        "By saving in safe and secure assets like Digital Gold and Fello Flo "
      ],
      [
        "Get rewarded for Saving",
        "Save and get free tickets and participate in the weekly draws",
      ],
      [
        "Become a Crorepati",
        "Grab ₹1 crore and a Mahindra Thar by participating in weekly draws",
      ],
    ];
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
