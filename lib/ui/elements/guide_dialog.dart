import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class GuideDialog extends StatelessWidget {
  final Log log = new Log('GuideDialog');

  GuideDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left:20, top:50, bottom: 80, right:20),
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
                padding: EdgeInsets.only(top: 30, bottom: 30, left: 30, right: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Image(
                        image: AssetImage(Assets.winnersGraphic),
                        fit: BoxFit.contain,
                      ),
                      width: 180,
                      height: 180,
                    ),
                    Text(
                      Assets.guideText,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          color: UiConstants.accentColor
                      ),
                    ),

                  ],
                )
            ),
          )
          ]);


  }
}
