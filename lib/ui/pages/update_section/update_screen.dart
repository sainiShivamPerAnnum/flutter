import 'dart:io';

import 'package:felloapp/main.dart';
import 'package:felloapp/ui/pages/tabs/profile/profile_screen.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SafeArea(
            child: GestureDetector(
          onTap: () {
            if (Platform.isIOS) {
              backButtonDispatcher.didPopRoute();
            } else if (Platform.isAndroid) {
              SystemNavigator.pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.close,
                  size: SizeConfig.blockSizeVertical * 4,
                )),
          ),
        )),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "images/update_alert.svg",
              height: SizeConfig.blockSizeVertical * 35,
            ),
          ],
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 8),
        Center(
            child: Text(
          'New Update !',
          style: TextStyle(
              color: UiConstants.primaryColor,
              fontSize: SizeConfig.cardTitleTextSize,
              fontWeight: FontWeight.bold),
        )),
        SizedBox(height: SizeConfig.blockSizeVertical * 2),
        Container(
          padding: EdgeInsets.all(8.0),
          width: SizeConfig.screenWidth * 0.9,
          child: Text(
            'We would like you to install the update to help you invest and play better. Click below to update.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: SizeConfig.cardTitleTextSize * 0.65,
                color: UiConstants.textColor),
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 5),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                gradient: new LinearGradient(colors: [
                  UiConstants.primaryColor,
                  UiConstants.primaryColor.withBlue(200),
                ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
              ),
              alignment: Alignment.bottomCenter,
              child: new Material(
                child: MaterialButton(
                  child: Center(
                    child: Text(
                      'Update',
                      style: Theme.of(context).textTheme.button.copyWith(
                          color: Colors.white,
                          fontSize: SizeConfig.largeTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  highlightColor: Colors.white30,
                  splashColor: Colors.white30,
                  onPressed: () {
                    if (Platform.isIOS) {
                      //TODO : Add ios Store link
                    } else if (Platform.isAndroid) {
                      launchUrl(
                          'https://play.google.com/store/apps/details?id=in.fello.felloapp');
                    }
                  },
                ),
                color: Colors.transparent,
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
