import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui show Image, instantiateImageCodec;

import 'package:device_unlock/device_unlock.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/core/service/tambola_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/elements/logo/logo_canvas.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/services.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:package_info/package_info.dart';

class LauncherViewModel extends BaseModel {
  ui.Image _logo;
  LogoStyle _logoStyle = LogoStyle.markOnly;
  bool _isSlowConnection = false;
  Timer _timer3;
  DeviceUnlock deviceUnlock;
  AppState navigator = AppState.delegate.appState;

  // LOCATORS
  final _baseUtil = locator<BaseUtil>();
  final _fcmListener = locator<FcmListener>();
  final userService = locator<UserService>();
  final _httpModel = locator<HttpModel>();
  final _logger = locator<CustomLogger>();
  final _tambolaService = locator<TambolaService>();
  final _mixpanelService = locator<MixpanelService>();

  //GETTERS
  ui.Image get logo => _logo;
  LogoStyle get logoStyle => _logoStyle;
  bool get isSlowConnection => _isSlowConnection;

  //SETTERS
  set logo(ui.Image value) {
    _logo = value;
    refresh();
  }

  set logoStyle(LogoStyle value) {
    _logoStyle = value;
    refresh();
  }

  init() {
    _loadImageAsset(Assets.logoMaxSize);
    initLogic();
    Timer(const Duration(milliseconds: 300), () {
      _logoStyle = LogoStyle.stacked;
      refresh();
    });
    _timer3 = new Timer(const Duration(seconds: 6), () {
      //display slow internet message
      _isSlowConnection = true;
      refresh();
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
    await _mixpanelService.init(
        isOnboarded: userService.isUserOnborded,
        baseUser: userService.baseUser);
    _httpModel.init();
    _timer3.cancel();
    // try {
    //   deviceUnlock = DeviceUnlock();
    // } catch (e) {
    //   _logger.e(
    //     e.toString(),
    //   );
    // }

    ///check if the account is blocked
    if (userService.baseUser != null && userService.baseUser.isBlocked) {
      AppState.isUpdateScreen = true;
      navigator.currentAction =
          PageAction(state: PageState.replaceAll, page: BlockedUserPageConfig);
      return;
    }
    bool isThereBreakingUpdateTest = await checkBreakingUpdateTest();
    if (isThereBreakingUpdateTest) {
      AppState.isUpdateScreen = true;
      navigator.currentAction =
          PageAction(state: PageState.replaceAll, page: UpdateRequiredConfig);
      return;
    }

    bool isThereBreakingUpdate = await checkBreakingUpdate();
    if (isThereBreakingUpdate) {
      AppState.isUpdateScreen = true;
      navigator.currentAction =
          PageAction(state: PageState.replaceAll, page: UpdateRequiredConfig);
      return;
    }

    ///check if user is onboarded
    if (!userService.isUserOnborded) {
      _logger.d2("New user. Moving to Onboarding..");
      navigator.currentAction =
          PageAction(state: PageState.replaceAll, page: LoginPageConfig);
      return;
    }
    //
    // ///now check if app needs to be open securely
    bool _unlocked = true;
    // if (_baseUtil.myUser.userPreferences.getPreference(Preferences.APPLOCK) ==
    //         1 &&
    //     deviceUnlock != null) {
    //   try {
    //     _unlocked = await deviceUnlock.request(localizedReason: 'Unlock Fello');
    //   } on DeviceUnlockUnavailable {
    //     BaseUtil.showPositiveAlert('No Device Authentication Found',
    //         'Logging in, please enable device security to add lock');
    //     _unlocked = true;
    //   } on RequestInProgress {
    //     _unlocked = false;
    //     print('Request in progress');
    //   }
    // }

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

  void _loadImageAsset(String assetName) async {
    var bd = await rootBundle.load(assetName);
    Uint8List lst = new Uint8List.view(bd.buffer);
    var codec = await ui.instantiateImageCodec(lst);
    var frameInfo = await codec.getNextFrame();
    logo = frameInfo.image;
    print("bkImage instantiated: $logo");
    refresh();
  }
}
