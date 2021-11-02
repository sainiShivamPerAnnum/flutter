import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AboutUsDialog extends StatelessWidget {
  final Log log = const Log('AboutUsDialog');

  const AboutUsDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
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
                      image: AssetImage(Assets.logoMaxSize),
                      fit: BoxFit.contain,
                    ),
                    width: 120,
                    height: 120,
                  ),
                  Text(
                    'ABOUT US',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: UiConstants.primaryColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    Assets.aboutUsDesc,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        color: UiConstants.accentColor),
                  ),
                ],
              )),
        )
      ],
    );
  }
}
