import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_unlock/device_unlock.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/repository/journey_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:package_info/package_info.dart';

import '../../../core/repository/user_repo.dart';

class LauncherViewModel extends BaseModel {
  bool _isSlowConnection = false;
  Timer _timer3;
  Stopwatch _logoWatch;
  DeviceUnlock deviceUnlock;
  bool _isPerformanceCollectionEnabled = false, _isFetchingData = false;
  String _performanceCollectionMessage =
      'Unknown status of performance collection.';
  final navigator = AppState.delegate.appState;

  // LOCATORS
  final _baseUtil = locator<BaseUtil>();
  final _fcmListener = locator<FcmListener>();
  final userService = locator<UserService>();
  final _httpModel = locator<HttpModel>();
  final _logger = locator<CustomLogger>();
  final _tambolaService = locator<TambolaService>();
  final _analyticsService = locator<AnalyticsService>();
  final _userRepo = locator<UserRepository>();
  final _paytmService = locator<PaytmService>();
  final _journeyService = locator<JourneyService>();
  final _journeyRepo = locator<JourneyRepository>();
  final _userCoinService = locator<UserCoinService>();
  final _internalOpsService = locator<InternalOpsService>();
  final _localDBModel = locator<LocalDBModel>();

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

  exit() {
    _timer3.cancel();
    _logoWatch.stop();
  }

  initLogic() async {
    // final Trace trace = _performance.newTrace('Splash trace start');
    // await trace.start();
    // trace.putAttribute('Spalsh', 'userservice init started');
    // trace.putAttribute('Spalsh', 'userservice init ended');
    try {
      await CacheService.initialize();
      await userService.init();
      await BaseRemoteConfig.init();

      if (userService.isUserOnborded) {
        await _journeyRepo.init();
        await _journeyService.init();
      }

      // check if cache invalidation required
      final now = DateTime.now().millisecondsSinceEpoch;
      _logger.d(
        'cache: invalidation time $now ${BaseRemoteConfig.invalidationBefore}',
      );
      if (now <= BaseRemoteConfig.invalidationBefore) {
        await new CacheService().invalidateAll();
      }
      // test
      // await new CacheService().invalidateAll();
      if (userService.isUserOnborded) await _userCoinService.init();
      // if (userService.isUserOnborded)
      await Future.wait(
        [
          // Note: BaseUtil Alredy in Sync
          _baseUtil.init(),
        ],
      );

      _fcmListener.setupFcm();

      if (userService.isUserOnborded)
        userService.firebaseUser?.getIdToken()?.then(
              (token) =>
                  _userRepo.updateUserAppFlyer(userService.baseUser, token),
            );
      if (userService.baseUser != null) {
        if (userService.isUserOnborded)
          await _analyticsService.login(
            isOnBoarded: userService?.isUserOnborded,
            baseUser: userService?.baseUser,
          );
      }
    } catch (e) {
      _logger.e("Splash Screen init : $e");
      _internalOpsService.logFailure(
        userService.baseUser?.uid ?? '',
        FailType.Splash,
        {'error': "Splash Screen init : $e"},
      );
    }
    _httpModel.init();
    if (userService.isUserOnborded) _tambolaService.init();
    _timer3.cancel();

    // await trace.stop();

    // log(_logoWatch.elapsed.inMilliseconds.toString());

    int delayedSecond = _logoWatch.elapsed.inMilliseconds % 2500;

    delayedSecond = 2500 - delayedSecond;
    log('Delayed seconds: $delayedSecond');
    await Future.delayed(
      new Duration(milliseconds: delayedSecond),
    );
    isFetchingData = false;

    // 21 FPS = 350 millisecods : Cal
    // = 1000 / 60 = 16.66
    // = 16.66 * 21 = 350

    await Future.delayed(
      new Duration(milliseconds: 1500),
    );

    try {
      deviceUnlock = DeviceUnlock();
    } catch (e) {
      _logger.e(e.toString());
      _internalOpsService.logFailure(
        userService.baseUser?.uid ?? '',
        FailType.Splash,
        {'error': "device unlock : $e"},
      );
    }

    ///check if the account is blocked
    if (userService.baseUser != null && userService.baseUser.isBlocked) {
      AppState.isUpdateScreen = true;
      navigator.currentAction = PageAction(
        state: PageState.replaceAll,
        page: BlockedUserPageConfig,
      );
      return;
    }

    ///check for breaking update
    if (await checkBreakingUpdate()) {
      AppState.isUpdateScreen = true;
      navigator.currentAction = PageAction(
        state: PageState.replaceAll,
        page: UpdateRequiredConfig,
      );
      return;
    }

    ///check for breaking update (TESTING)
    // if (await checkBreakingUpdateTest()) {
    //   AppState.isUpdateScreen = true;
    //   navigator.currentAction =
    //       PageAction(state: PageState.replaceAll, page: UpdateRequiredConfig);
    //   return;
    // }

    ///check if user is onboarded
    if (!userService.isUserOnborded) {
      _logger.d("New user. Moving to Onboarding..");
      bool showOnboarding = PreferenceHelper.getBool(
          PreferenceHelper.CACHE_ONBOARDING_COMPLETION);

      if (showOnboarding == null || showOnboarding == false) {
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

    ///Ceck if app needs to be open securely
    ///NOTE: CHECK APP LOCK
    bool _unlocked = false;
    // if (userService.baseUser.userPreferences != null &&
    //     userService.baseUser.userPreferences
    //             .getPreference(Preferences.APPLOCK) ==
    //         1 &&
    //     deviceUnlock != null) {
    _unlocked = await authenticateDevice();
    // }

    if (_unlocked) {
      return navigator.currentAction =
          PageAction(state: PageState.replaceAll, page: RootPageConfig);
    } else {
      BaseUtil.showNegativeAlert(
        'Authentication Failed',
        'Please reopen and try again',
      );
    }
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

  Future<bool> authenticateDevice() async {
    // bool _res = false;
    // try {
    //   _res = await deviceUnlock.request(
    //       localizedReason:
    //           'Confirm your phone screen lock pattern,PIN or password');
    // } on DeviceUnlockUnavailable {
    //   BaseUtil.showPositiveAlert('No Device Authentication Found',
    //       'Logging in, please enable device security to add lock');
    //   return true;
    // } on RequestInProgress {
    //   _res = false;
    //   print('Request in progress');
    // } catch (e) {
    //   _logger.e("error", [e]);
    //   BaseUtil.showNegativeAlert(
    //       'Authentication Failed', 'Please restart and try again');
    // }
    // return _res;
    return true;
  }

  Future<bool> checkBreakingUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentBuild = packageInfo.buildNumber;
    _logger.i('Current Build $currentBuild');
    String minBuild = BaseRemoteConfig.remoteConfig.getString(
      Platform.isAndroid
          ? BaseRemoteConfig.FORCE_MIN_BUILD_NUMBER_ANDROID
          : BaseRemoteConfig.FORCE_MIN_BUILD_NUMBER_IOS,
    );
    _logger.v('Min Build Required $minBuild');
    //minBuild = "50";
    try {
      if (int.parse(currentBuild) < int.parse(minBuild)) {
        return true;
      }
      return false;
    } catch (e) {
      _logger.e(e.toString());
      return false;
    }
  }

  // Future<bool> checkBreakingUpdateTest() async {
  // PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // String currentBuild = packageInfo.buildNumber;
  // _logger.i('Current Build $currentBuild');
  // String minBuild = BaseRemoteConfig.remoteConfig.getString(Platform.isAndroid
  //     ? BaseRemoteConfig.FORCE_MIN_BUILD_NUMBER_ANDROID_2
  //     : BaseRemoteConfig.FORCE_MIN_BUILD_NUMBER_IOS_2);
  // _logger.v('Min Build Required $minBuild');
  //minBuild = "50";
  // try {
  // if (int.parse(currentBuild) < int.parse(minBuild)) {
  // if (userService != null && userService.baseUser != null) {
  //   _logger.i("User mobile no: ${userService.baseUser.mobile}");
  //   if (userService.baseUser.mobile.startsWith('99999000') ||
  //       userService.baseUser.mobile.startsWith('88888000')) return true;
  //   return false;
  // }
  // return false;
  // }
  // return false;
  // } catch (e) {
  //   _logger.e(e.toString());
  //   return false;
  // }
  // }
}
