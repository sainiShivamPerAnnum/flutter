import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/referral_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/repository/user_repo.dart';

class LauncherViewModel extends BaseViewModel {
  bool _isSlowConnection = false;
  Timer? _timer3;
  Stopwatch? _logoWatch;
  bool _isPerformanceCollectionEnabled = false, _isFetchingData = true;
  final String _performanceCollectionMessage =
      'Unknown status of performance collection.';
  final navigator = AppState.delegate!.appState;

  AnimationController? loopOutlottieAnimationController,
      loopingLottieAnimationController;
  int loopLottieDuration = 2500;

  // LOCATORS
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final FcmListener _fcmListener = locator<FcmListener>();
  final UserService userService = locator<UserService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final UserRepository _userRepo = locator<UserRepository>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  final ReferralService _referralService = locator<ReferralService>();
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

  bool isStillLooping = false;
  bool isPreExecuted = false;
  bool isHalfLottieExecuted = false;

  Future<void> init() async {
    isFetchingData = true;
    unawaited(initLogic());
    loopingLottieAnimationController!.addListener(() {
      if (loopingLottieAnimationController!.status == AnimationStatus.forward) {
        debugPrint("Looping lottie completed");
        if (!isFetchingData) {
          notifyListeners();
          loopingLottieAnimationController!.stop();
          unawaited(loopOutlottieAnimationController!.forward());
          Future.delayed(const Duration(milliseconds: 900)).then((_) {
            exitSplash();
          });
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        loopingLottieAnimationController!.forward(from: 0.6).then((_) {
          loopingLottieAnimationController!.repeat();
        }),
      );
    });
    _timer3 = Timer(const Duration(seconds: 6), () {
      isSlowConnection = true;
    });
  }

  void exit() {
    _timer3?.cancel();
    _logoWatch?.stop();
  }

  Future<void> initLogic() async {
    try {
      await CacheService.initialize();
      //Initialize every time
      await _getterRepo.setUpAppConfigs();
      await userService.init();
      //Initialize only if user is onboarded
      if (userService.isUserOnboarded) {
        await Future.wait([
          CacheService.checkIfInvalidationRequired(),
          _analyticsService.login(
              isOnBoarded: true, baseUser: userService.baseUser),
        ]);

        unawaited(locator<GameRepo>().getGameTiers());
        _referralService.init();
        _baseUtil.init();
        unawaited(_fcmListener.setupFcm());
      }
    } catch (e) {
      _logger.e("Splash Screen init : $e");
      unawaited(_internalOpsService.logFailure(
        userService.baseUser?.uid ?? '',
        FailType.Splash,
        {'error': "Splash Screen init : $e"},
      ));
    }

    _timer3?.cancel();
    _isFetchingData = false;

    // if (isStillLooping && !isPreExecuted) {
    //   int delayedSecond =
    //       _logoWatch.elapsed.inMilliseconds % loopLottieDuration;
    //   delayedSecond = loopLottieDuration - delayedSecond;
    //   await Future.delayed(Duration(milliseconds: delayedSecond));
    //   unawaited(loopOutlottieAnimationController!.forward());
    //   await Future.delayed(const Duration(milliseconds: 900));
    //   exitSplash();
    // }
  }

  void exitSplash() {
    _logger.i("Splash: Exiting splash");
    if (!userService.isUserOnboarded) {
      _logger.d("New user. Moving to Onboarding..");
      bool showOnboarding = PreferenceHelper.getBool(
          PreferenceHelper.CACHE_ONBOARDING_COMPLETION);

      if (showOnboarding == false) {
        navigator.currentAction = PageAction(
          state: PageState.replaceAll,
          page: OnBoardingViewPageConfig,
        );
        return;
      } else {
        navigator.currentAction = PageAction(
          state: PageState.replaceAll,
          page: SipPageConfig,
        );
        return;
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
