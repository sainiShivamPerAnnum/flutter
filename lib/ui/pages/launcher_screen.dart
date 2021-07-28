import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui show Image, instantiateImageCodec;

import 'package:device_unlock/device_unlock.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/breathing_text_widget.dart';
import 'package:felloapp/ui/elements/logo_canvas.dart';
import 'package:felloapp/ui/elements/logo_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:felloapp/util/size_config.dart';

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
    Timer(const Duration(milliseconds: 700), () {
      setState(() {
        _logoStyle = LogoStyle.stacked;
      });
    });
    Timer(const Duration(seconds: 1), () {
      initialize();
    });
    _timer3 = new Timer(const Duration(seconds: 6), () {
      //display slow internet message
      setState(() {
        _isSlowConnection = true;
      });
    });
    super.initState();
  }

  initialize() async {
    deviceUnlock = DeviceUnlock();
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    final fcmProvider = Provider.of<FcmListener>(context, listen: false);
    final stateProvider = Provider.of<AppState>(context, listen: false);
    await baseProvider.init();
    await fcmProvider.setupFcm();
    _timer3.cancel();
    if (!baseProvider.isUserOnboarded) {
      log.debug("New user. Moving to Onboarding..");
      stateProvider.currentAction =
          PageAction(state: PageState.replaceAll, page: OnboardPageConfig);
    } else {
      log.debug("Existing User. Moving to Home..");
      if (baseProvider.isSecurityEnabled) {
        bool _unlocked = await authenticateDevice();
        if (_unlocked) {
          stateProvider.currentAction =
              PageAction(state: PageState.replaceAll, page: RootPageConfig);
        } else {
          baseProvider.showNegativeAlert(
              'Authentication Failed', 'Please restart app', context);
        }
      } else {
        stateProvider.currentAction =
            PageAction(state: PageState.replaceAll, page: RootPageConfig);
      }
    } 
  }

  Future<bool> authenticateDevice() async {
    bool _res = false;
    try {
      _res = await deviceUnlock.request(
          localizedReason: 'Please authenticate in order to proceed');
    } on DeviceUnlockUnavailable {
      baseProvider.showPositiveAlert(
          'No Device Authentication Found',
          'Logging in, please enable device security to add lock',
          context);
      _res = true;
    } on RequestInProgress {
      _res = false;
      print('Request in progress');
    } catch(e) {
      baseProvider.showNegativeAlert(
          'Authentication Failed',
          'Please restart the application to try again.',
          context);
    }
    return _res;
  }

  @override
  Widget build(BuildContext context) {
    //if(!_timer.isActive)initialize();
    SizeConfig().init(context);
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: _isSlowConnection,
                    child: BreathingText(
                        alertText: 'Connection is taking longer than usual'))),
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
