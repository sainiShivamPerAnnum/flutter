import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui show Image, instantiateImageCodec;

import 'package:felloapp/ui/elements/logo_canvas.dart';
import 'package:felloapp/ui/elements/logo_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import '../../base_util.dart';

class SplashScreen extends StatefulWidget {
  @override State<StatefulWidget> createState() => LogoFadeIn();
}

class LogoFadeIn extends State<SplashScreen> {
  Log log = new Log("SplashScreen");
  bool _isSlowConnection = false;
  bool _isAnimVisible = true;
  Timer _timer, _timer2, _timer3;
  LogoStyle _logoStyle = LogoStyle.markOnly;
  ui.Image logo;

  LogoFadeIn() {
    _loadImageAsset(Assets.logoMaxSize);
    _timer = new Timer(const Duration(seconds: 2), () {
      setState(() {
        _logoStyle = LogoStyle.stacked;
      });
    });
    _timer2 = new Timer(const Duration(seconds: 3), () {
      setState(() {
        initialize();
      });
    });
    _timer3 = new Timer(const Duration(seconds: 6), () {
      //display slow internet message
      setState(() {
        _isSlowConnection = true;
      });
    });
  }

  initialize() async{
    final baseProvider = Provider.of<BaseUtil>(context);
    // final fcmProvider = Provider.of<FcmListener>(context);
    await baseProvider.init();
    // await fcmProvider.setupFcm();
    _timer3.cancel();
    if(!baseProvider.isUserOnboarded) {
      log.debug("New user. Moving to Onboarding..");
      // Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
    else {
      log.debug("Existing User. Moving to Home..");
     // Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/approot');
    }
  }

  @override
  Widget build(BuildContext context) {
    //if(!_timer.isActive)initialize();
    return MaterialApp(
      home: Scaffold(
          body: Stack(
            children: <Widget>[
              (logo != null)?Center(
                child: Container(
                  child: new Logo(
                    size: 160.0,
                    style: _logoStyle,
                    img: logo,
                  ),
                ),
              ):Text('Loading..'),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //       padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              //       child: Visibility(
              //           maintainSize: true,
              //           maintainAnimation: true,
              //           maintainState: true,
              //           visible: _isSlowConnection,
              //           child:  BreathingText(alertText: 'Connection is taking longer than usual')
              //       )
              //   ),
              // )
            ],
          )
      ),
    );
  }

  void _loadImageAsset(String assetName) async{
    var bd = await rootBundle.load(assetName);
    Uint8List lst = new Uint8List.view(bd.buffer);
    var codec = await ui.instantiateImageCodec(lst);
    var frameInfo = await codec.getNextFrame();
    logo = frameInfo.image;
    print ("bkImage instantiated: $logo");
    setState(() {});
  }
}
