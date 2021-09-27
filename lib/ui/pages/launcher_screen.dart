//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/Texts/breathing_text_widget.dart';
import 'package:felloapp/ui/elements/logo/logo_canvas.dart';
import 'package:felloapp/ui/elements/logo/logo_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';

//Dart and Flutter Imports
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui show Image, instantiateImageCodec;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

//Pub Imports
import 'package:device_unlock/device_unlock.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LogoFadeIn();
}

class LogoFadeIn extends State<SplashScreen> {
  Log log = new Log("SplashScreen");
  bool _isSlowConnection = false;
  bool _isAnimVisible = true;
  Timer _timer3;
  LogoStyle _logoStyle = LogoStyle.markOnly;
  ui.Image logo;
  DeviceUnlock deviceUnlock;
  BaseUtil baseProvider;

  @override
  void initState() {
    _loadImageAsset(Assets.logoMaxSize);
    initialize();
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _logoStyle = LogoStyle.stacked;
      });
    });
    // Timer(const Duration(milliseconds: 500), () {
    // });
    _timer3 = new Timer(const Duration(seconds: 6), () {
      //display slow internet message
      setState(() {
        _isSlowConnection = true;
      });
    });
    super.initState();
  }

  initialize() async {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    final fcmProvider = Provider.of<FcmListener>(context, listen: false);
    final stateProvider = Provider.of<AppState>(context, listen: false);
    stateProvider.setLastTapIndex();
    await baseProvider.init();
    await fcmProvider.setupFcm();
    _timer3.cancel();
    try {
      deviceUnlock = DeviceUnlock();
    } catch (e) {
      log.error(e.toString());
    }

    bool isThereBreakingUpdate = await checkBreakingUpdate();
    if (isThereBreakingUpdate) {
      stateProvider.currentAction =
          PageAction(state: PageState.replaceAll, page: UpdateRequiredConfig);
      return;
    }

    ///check if user is onboarded
    if (!baseProvider.isUserOnboarded) {
      log.debug("New user. Moving to Onboarding..");
      stateProvider.currentAction =
          PageAction(state: PageState.replaceAll, page: OnboardPageConfig);
      return;
    }

    ///now check if app needs to be open securely
    bool _unlocked = true;
    if (baseProvider.myUser.userPreferences
                .getPreference(Preferences.APPLOCK) ==
            1 &&
        deviceUnlock != null) {
      try {
        _unlocked = await deviceUnlock.request(localizedReason: 'Unlock Fello');
      } on DeviceUnlockUnavailable {
        baseProvider.showPositiveAlert('No Device Authentication Found',
            'Logging in, please enable device security to add lock', context);
        _unlocked = true;
      } on RequestInProgress {
        _unlocked = false;
        print('Request in progress');
      }
    }

    if (_unlocked) {
      stateProvider.currentAction =
          PageAction(state: PageState.replaceAll, page: RootPageConfig);
    } else {
      baseProvider.showNegativeAlert(
          'Authentication Failed', 'Please reopen and try again', context);
    }
  }

  Future<bool> authenticateDevice() async {
    bool _res = false;
    try {
      _res = await deviceUnlock.request(
          localizedReason: 'Please authenticate in order to proceed');
    } on DeviceUnlockUnavailable {
      baseProvider.showPositiveAlert('No Device Authentication Found',
          'Logging in, please enable device security to add lock', context);
      _res = true;
    } on RequestInProgress {
      _res = false;
      print('Request in progress');
    } catch (e) {
      baseProvider.showNegativeAlert('Authentication Failed',
          'Please restart the application to try again.', context);
    }
    return _res;
  }

  Future<bool> checkBreakingUpdate() async {
    String currentBuild = BaseUtil.packageInfo.buildNumber;
    print('Current Build $currentBuild');
    String minBuild = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.FORCE_MIN_BUILD_NUMBER);
    print('Min Build Required $minBuild');
    // minBuild = "0";
    try {
      if (int.parse(currentBuild) < int.parse(minBuild)) {
        return true;
      }
      return false;
    } catch (e) {
      log.error(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //if(!_timer.isActive)initialize();
    SizeConfig().init(context);
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context, listen: true);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Stack(
        children: <Widget>[
          (logo != null)
              ? Center(
                  child: Container(
                    child: new Logo(
                      size: 160.0,
                      style: _logoStyle,
                      img: logo,
                    ),
                  ),
                )
              : Text('Loading..'),
          Positioned(
            bottom: 0,
            child: Container(
              width: SizeConfig.screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: _isSlowConnection,
                      child: connectivityStatus == ConnectivityStatus.Offline
                          ? Text('No active internet connection',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: SizeConfig.mediumTextSize))
                          : BreathingText(
                              alertText:
                                  'Connection is taking longer than usual',
                              textStyle: GoogleFonts.montserrat(
                                fontSize: SizeConfig.mediumTextSize * 1.3,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  void _loadImageAsset(String assetName) async {
    var bd = await rootBundle.load(assetName);
    Uint8List lst = new Uint8List.view(bd.buffer);
    var codec = await ui.instantiateImageCodec(lst);
    var frameInfo = await codec.getNextFrame();
    logo = frameInfo.image;
    print("bkImage instantiated: $logo");
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _timer3.cancel();
  }
}
