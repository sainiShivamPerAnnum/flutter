import 'dart:io';

import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launch_review/launch_review.dart';

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: SizeConfig.blockSizeVertical*15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("images/update_alert.svg", height: SizeConfig.blockSizeVertical*35,),
              ],
            ),
            SizedBox(height : SizeConfig.blockSizeVertical*8),
            Text('New Update !', style: TextStyle(color: UiConstants.primaryColor, fontSize: SizeConfig.cardTitleTextSize, fontWeight: FontWeight.bold),),
            SizedBox(height : SizeConfig.blockSizeVertical*2),
            Container(
              padding: EdgeInsets.all(8.0),
              width: SizeConfig.screenWidth*0.9,
              child: Text('We would like you to install the update to help you invest and play better. Click below to update.', style: TextStyle(fontSize: SizeConfig.cardTitleTextSize*0.65, color: UiConstants.textColor),),
            ),
            SizedBox(height : SizeConfig.blockSizeVertical*5),
            Container(
              width: SizeConfig.screenWidth*0.65,
              height: SizeConfig.blockSizeVertical*8,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(100.0),
                color: UiConstants.primaryColor
              ),
              child: new Material(
                child: MaterialButton(
                  child: Text(
                          'Update',
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.white, fontSize: SizeConfig.largeTextSize, fontWeight: FontWeight.bold),),
                  highlightColor: Colors.white30,
                  splashColor: Colors.white30,
                  onPressed: () {
                    // TODO: implement update logic
                    if(Platform.isIOS) {
                      LaunchReview.launch();
                    }
                    else if(Platform.isAndroid) {
                      //in-app update
                    }
                  },
                ),
                color: Colors.transparent,
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
          ]
        ),
      )
    );
  }
}