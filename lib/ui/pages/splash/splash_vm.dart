import 'dart:async';
import 'dart:developer';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/connectivity_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
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
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

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
  final TambolaService _tambolaService = locator<TambolaService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final UserRepository _userRepo = locator<UserRepository>();
  final PaytmService _paytmService = locator<PaytmService>();
  final JourneyService _journeyService = locator<JourneyService>();
  final JourneyRepository _journeyRepo = locator<JourneyRepository>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  final LocalDBModel _localDBModel = locator<LocalDBModel>();
  final UserService _userService = locator<UserService>();

  FirebasePerformance _performance = FirebasePerformance.instance;
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
      //display slow internet message
      isSlowConnection = true;
    });
  }

  fetchUserBootUpDetails() async {
    await _userService!.userBootUpEE();
  }

  exit() {
    _timer3.cancel();
    _logoWatch.stop();
  }

  initLogic() async {
    // final Trace trace = _performance.newTrace('Splash trace start');
    // await trace.start();
    // trace.putAttribute('Splash', 'userService init started');
    // trace.putAttribute('Splash', 'userService init ended');

    try {
      await CacheService.initialize();
      await userService.init();
      fetchUserBootUpDetails();

      // await BaseRemoteConfig.init();

      final _appConfig = await locator<GetterRepository>().getAppConfig();

      if (_appConfig.code != 200) {
        AppConfig.instance({
          "message": "Default Values",
          "data": BaseRemoteConfig.DEFAULTS,
        });
      }

      if (userService.isUserOnboarded) {
        await _journeyRepo.init();
        await _journeyService.init();
      }

      // check if cache invalidation required
      final now = DateTime.now().millisecondsSinceEpoch;

      final _invalidate =
          AppConfig.getValue(AppConfigKey.invalidateBefore) as int;
      if (now <= _invalidate) {
        await new CacheService().invalidateAll();
      }
      // test
      // await new CacheService().invalidateAll();
      if (userService.isUserOnboarded) _userCoinService.init();

      _baseUtil.init();

      _fcmListener.setupFcm();

      if (userService.isUserOnboarded)
        userService.firebaseUser?.getIdToken().then(
              (token) =>
                  _userRepo.updateUserAppFlyer(userService!.baseUser!, token),
            );

      if (userService.baseUser != null) {
        if (userService.isUserOnboarded)
          await _analyticsService.login(
            isOnBoarded: userService.isUserOnboarded,
            baseUser: userService.baseUser,
          );

        //To fetch the properties required to pass for the analytics
        await AnalyticsProperties().init();
      }
    } catch (e) {
      _logger.e("Splash Screen init : $e");
      _internalOpsService.logFailure(
        userService.baseUser?.uid ?? '',
        FailType.Splash,
        {'error': "Splash Screen init : $e"},
      );
    }
    if (userService.isUserOnboarded) _tambolaService.init();
    _timer3.cancel();
    log("Splash init http: ${DateFormat('yyyy-MM-dd – hh:mm:ss').format(DateTime.now())}");

    // await trace.stop();

    // log(_logoWatch.elapsed.inMilliseconds.toString());

    int delayedSecond = _logoWatch.elapsed.inMilliseconds % loopLottieDuration;

    delayedSecond = loopLottieDuration - delayedSecond;
    log('Delayed seconds: $delayedSecond');
    await Future.delayed(
      new Duration(milliseconds: delayedSecond),
    );
    isFetchingData = false;
    loopOutlottieAnimationController!.forward();

    // 21 FPS = 350 millisecods : Cal
    // = 1000 / 60 = 16.66
    // = 16.66 * 21 = 350

    await Future.delayed(
      new Duration(milliseconds: 820),
    );

    ///check if user is onboarded

    if (!userService.isUserOnboarded) {
      _logger.d("New user. Moving to Onboarding..");
      bool showOnboarding = PreferenceHelper.getBool(
          PreferenceHelper.CACHE_ONBOARDING_COMPLETION);

      if (showOnboarding == false) {
        //show tutorial
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
      // });
    }

    ///Check if app needs to be open securely
    userService.authenticateDevice();
  }

  Future<void> _togglePerformanceCollection() async {
    // No-op for web.
    await _performance
        .setPerformanceCollectionEnabled(!_isPerformanceCollectionEnabled);

    // Always true for web.
    final bool isEnabled = await _performance.isPerformanceCollectionEnabled();

    _isPerformanceCollectionEnabled = isEnabled;
    _performanceCollectionMessage = _isPerformanceCollectionEnabled
        ? 'Performance collection is enabled.'
        : 'Performance collection is disabled.';
  }
}

/// Indicates that the user has not yet configured a passcode (iOS) or
/// PIN/pattern/password (Android) on the device.
const String passcodeNotSet = 'PasscodeNotSet';

/// Indicates the user has not enrolled any biometrics on the device.
const String notEnrolled = 'NotEnrolled';

/// Indicates the device does not have hardware support for biometrics.
const String notAvailable = 'NotAvailable';

/// Indicates the device operating system is unsupported.
const String otherOperatingSystem = 'OtherOperatingSystem';

/// Indicates the API is temporarily locked out due to too many attempts.
const String lockedOut = 'LockedOut';

/// Indicates the API is locked out more persistently than [lockedOut].
/// Strong authentication like PIN/Pattern/Password is required to unlock.
const String permanentlyLockedOut = 'PermanentlyLockedOut';

/// Indicates that the biometricOnly parameter can't be true on Windows
const String biometricOnlyNotSupported = 'biometricOnlyNotSupported';
