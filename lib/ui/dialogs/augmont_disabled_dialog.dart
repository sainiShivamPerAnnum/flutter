import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AugmontDisabled extends StatefulWidget {
  @override
  State createState() => AugmontDisabledState();
}

class AugmontDisabledState extends State<AugmontDisabled> {
  final Log log = new Log('AugmontDisabled');
  double _width;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        AppState.backButtonDispatcher.didPopRoute();
        return Future.value(true);
      },
      child: Dialog(
        insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
                padding:
                    EdgeInsets.only(top: 30, bottom: 40, left: 35, right: 35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Image(
                        image: AssetImage(Assets.onboardingSlide[2]),
                        fit: BoxFit.contain,
                      ),
                      width: 150,
                      height: 150,
                    ),
                    Text(
                      'Currently Unavailable',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: UiConstants.primaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      Assets.augmontUnavailable,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: UiConstants.accentColor),
                    ),
                  ],
                )),
          )
        ]);
  }
}
