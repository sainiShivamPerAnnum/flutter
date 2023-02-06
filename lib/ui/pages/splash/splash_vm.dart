import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/repository/user_repo.dart';

class LauncherViewModel extends BaseViewModel {
  bool _isSlowConnection = false;
  late Timer _timer3;
  late Stopwatch _logoWatch;
  bool _isPerformanceCollectionEnabled = false, _isFetchingData = false;
  String _performanceCollectionMessage =
      'Unknown status of performance collection.';
  final navigator = AppState.delegate!.appState;

  AnimationController? loopOutlottieAnimationController;
  int loopLottieDuration = 2500;
  // LOCATORS
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final FcmListener _fcmListener = locator<FcmListener>();
  final UserService userService = locator<UserService>();
  final CustomLogger _logger = locator<CustomLogger>();
  // final TambolaService _tambolaService = locator<TambolaService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final UserRepository _userRepo = locator<UserRepository>();
  final PaytmService _paytmService = locator<PaytmService>();
  final JourneyService _journeyService = locator<JourneyService>();
  final JourneyRepository _journeyRepo = locator<JourneyRepository>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  // final LocalDBModel _localDBModel = locator<LocalDBModel>();
  final ReferralService _referralService = locator<ReferralService>();
  final UserService _userService = locator<UserService>();
  FirebasePerformance _performance = FirebasePerformance.instance;
  final GetterRepository _getterRepo = locator<GetterRepository>();
  final AnalyticsProperties _analyticsProperties =
      locator<AnalyticsProperties>();
  //GETTERS
  bool get isSlowConnection => _isSlowConnection;

  set isSlowConnection(bool val) {
    _isSlowConnection = val;
    notifyListeners();
  }

  bool get isFetchingData => _isFetchingData;

  set isFetchingData(bool val) {
    _isFetchingData = val;
    notifyListeners();
  }

  init() {
    isFetchingData = true;
    _logoWatch = Stopwatch()..start();
    // _togglePerformanceCollection();

    initLogic();
    _timer3 = new Timer(const Duration(seconds: 6), () {
      isSlowConnection = true;
    });
  }

  exit() {
    _timer3.cancel();
    _logoWatch.stop();
  }

  initLogic() async {
    try {
      //Initialize every time
      await Future.wait([
        CacheService.initialize(),
        userService.init(),
        _getterRepo.setUpAppConfigs()
      ]);

      //Initialize only if user is onboarded
      if (userService.isUserOnboarded) {
        await Future.wait([
          _journeyRepo.init(),
          _journeyService.init(),
          CacheService.checkIfInvalidationRequired(),
          _analyticsService.login(
              isOnBoarded: true, baseUser: userService.baseUser),
          userService.firebaseUser!.getIdToken().then(
                (token) =>
                    _userRepo.updateUserAppFlyer(userService.baseUser!, token),
              ),
        ]);
        _userCoinService.init();
        _referralService.init();
        _baseUtil.init();
        _fcmListener.setupFcm();
        _analyticsProperties.init();
      }
    } catch (e) {
      _logger.e("Splash Screen init : $e");
      _internalOpsService.logFailure(
        userService.baseUser?.uid ?? '',
        FailType.Splash,
        {'error': "Splash Screen init : $e"},
      );
    }

    _timer3.cancel();
    int delayedSecond = _logoWatch.elapsed.inMilliseconds % loopLottieDuration;
    delayedSecond = loopLottieDuration - delayedSecond;
    await Future.delayed(Duration(milliseconds: delayedSecond));
    isFetchingData = false;
    loopOutlottieAnimationController!.forward();
    await Future.delayed(new Duration(milliseconds: 900));

    if (!userService.isUserOnboarded) {
      _logger.d("New user. Moving to Onboarding..");
      bool showOnboarding = PreferenceHelper.getBool(
          PreferenceHelper.CACHE_ONBOARDING_COMPLETION);

      if (showOnboarding == false) {
        return navigator.currentAction = PageAction(
          state: PageState.replaceAll,
          page: OnBoardingViewPageConfig,
        );
      } else {
        return navigator.currentAction = PageAction(
          state: PageState.replaceAll,
          page: LoginPageConfig,
        );
      }
    }

    ///Check if app needs to be open securely
    userService.authenticateDevice();
  }

  // Future<void> _togglePerformanceCollection() async {
  //   // No-op for web.
  //   await _performance
  //       .setPerformanceCollectionEnabled(!_isPerformanceCollectionEnabled);

  //   // Always true for web.
  //   final bool isEnabled = await _performance.isPerformanceCollectionEnabled();

  //   _isPerformanceCollectionEnabled = isEnabled;
  //   _performanceCollectionMessage = _isPerformanceCollectionEnabled
  //       ? 'Performance collection is enabled.'
  //       : 'Performance collection is disabled.';
  // }
}
