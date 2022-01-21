import 'dart:async';
import 'package:device_unlock/device_unlock.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/tambola_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:package_info/package_info.dart';

class LauncherViewModel extends BaseModel {
  bool _isSlowConnection = false;
  Timer _timer3;
  DeviceUnlock deviceUnlock;
  final navigator = AppState.delegate.appState;

  // LOCATORS
  final _baseUtil = locator<BaseUtil>();
  final _fcmListener = locator<FcmListener>();
  final userService = locator<UserService>();
  final _httpModel = locator<HttpModel>();
  final _logger = locator<CustomLogger>();
  final _tambolaService = locator<TambolaService>();
  final _analyticsService = locator<AnalyticsService>();

  //GETTERS
  bool get isSlowConnection => _isSlowConnection;

  set isSlowConnection(bool val) {
    _isSlowConnection = val;
    notifyListeners();
  }

  init() {
    _analyticsService.trackInstall(null);
    initLogic();
    _timer3 = new Timer(const Duration(seconds: 6), () {
      //display slow internet message
      isSlowConnection = true;
    });
  }

  exit() {
    _timer3.cancel();
  }

  initLogic() async {
    await userService.init(); // PROCEED IF firebase != null
    await _baseUtil.init();
    _tambolaService.init();
    await _fcmListener.setupFcm();
    await _analyticsService.login(
        isOnboarded: userService.isUserOnborded,
        baseUser: userService.baseUser);
    _httpModel.init();
    _timer3.cancel();
    try {
      deviceUnlock = DeviceUnlock();
    } catch (e) {
      _logger.e(
        e.toString(),
      );
    }

    ///check if the account is blocked
    if (userService.baseUser != null && userService.baseUser.isBlocked) {
      AppState.isUpdateScreen = true;
      navigator.currentAction =
          PageAction(state: PageState.replaceAll, page: BlockedUserPageConfig);
      return;
    }

    ///check for breaking update (TESTING)
    if (await checkBreakingUpdateTest()) {
      AppState.isUpdateScreen = true;
      navigator.currentAction =
          PageAction(state: PageState.replaceAll, page: UpdateRequiredConfig);
      return;
    }

    ///check for breaking update
    if (await checkBreakingUpdate()) {
      AppState.isUpdateScreen = true;
      navigator.currentAction =
          PageAction(state: PageState.replaceAll, page: UpdateRequiredConfig);
      return;
    }

    ///check if user is onboarded
    if (!userService.isUserOnborded) {
      _logger.d("New user. Moving to Onboarding..");
      navigator.currentAction =
          PageAction(state: PageState.replaceAll, page: LoginPageConfig);
      return;
    }

    ///Ceck if app needs to be open securely
    bool _unlocked = true;
    if (_baseUtil.myUser.userPreferences.getPreference(Preferences.APPLOCK) ==
            1 &&
        deviceUnlock != null) {
      _unlocked = await authenticateDevice();
    }

    if (_unlocked) {
      navigator.currentAction =
          PageAction(state: PageState.replaceAll, page: RootPageConfig);
    } else {
      BaseUtil.showNegativeAlert(
          'Authentication Failed', 'Please reopen and try again');
    }
  }

  Future<bool> authenticateDevice() async {
    bool _res = false;
    try {
      _res = await deviceUnlock.request(
          localizedReason: 'Please authenticate in order to proceed');
    } on DeviceUnlockUnavailable {
      BaseUtil.showPositiveAlert('No Device Authentication Found',
          'Logging in, please enable device security to add lock');
      _res = true;
    } on RequestInProgress {
      _res = false;
      print('Request in progress');
    } catch (e) {
      _logger.e("error", [e]);
      BaseUtil.showNegativeAlert('Authentication Failed',
          'Please restart the application to try again.');
    }
    return _res;
  }

  Future<bool> checkBreakingUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentBuild = packageInfo.buildNumber;
    _logger.i('Current Build $currentBuild');
    String minBuild = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.FORCE_MIN_BUILD_NUMBER);
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

  Future<bool> checkBreakingUpdateTest() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentBuild = packageInfo.buildNumber;
    _logger.i('Current Build $currentBuild');
    String minBuild = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.FORCE_MIN_BUILD_NUMBER_2);
    _logger.v('Min Build Required $minBuild');
    //minBuild = "50";
    try {
      if (int.parse(currentBuild) < int.parse(minBuild)) {
        if (userService != null && userService.baseUser != null) {
          _logger.i("User mobile no: ${userService.baseUser.mobile}");
          if (userService.baseUser.mobile.startsWith('99999000') ||
              userService.baseUser.mobile.startsWith('88888000')) return true;
          return false;
        }
        return false;
      }
      return false;
    } catch (e) {
      _logger.e(e.toString());
      return false;
    }
  }
}
