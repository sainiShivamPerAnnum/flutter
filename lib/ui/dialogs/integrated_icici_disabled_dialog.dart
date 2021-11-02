import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntegratedIciciDisabled extends StatefulWidget {
  @override
  State createState() => IntegratedIciciDisabledState();
}

class IntegratedIciciDisabledState extends State<IntegratedIciciDisabled> {
  final Log log = new Log('IntegratedIciciDisabled');
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
        backgroundColor: Colors.transparent,
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: SizeConfig.screenHeight * 0.34,
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 3),
        ),
        Transform.translate(
          offset: Offset(0, -SizeConfig.screenHeight * 0.1),
          child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(Assets.onboardingSlide[2]),
                    fit: BoxFit.contain,
                    width: SizeConfig.screenWidth * 0.6,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Currently Unavailable',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: UiConstants.primaryColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    Assets.integratedICICIUnavailable,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: SizeConfig.largeTextSize,
                        height: 1.5,
                        fontWeight: FontWeight.w300,
                        color: UiConstants.accentColor),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
