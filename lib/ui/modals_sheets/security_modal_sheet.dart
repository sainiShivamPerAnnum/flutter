import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecurityModalSheet extends StatelessWidget {
  const SecurityModalSheet();

  @override
  Widget build(BuildContext context) {
    final baseProvider = Provider.of<BaseUtil>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(
          top: 25.0, bottom: 25.0, left: 45.0, right: 45.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical * 1.5,
          ),
          Image.asset(
            "images/safe-small.png",
            width: SizeConfig.screenHeight * 0.2,
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 1.5,
          ),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Secure Fello',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: UiConstants.primaryColor,
                        fontSize: SizeConfig.largeTextSize * 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2.5,
          ),
          Text(
              'Protect your Fello account by using your phone\'s default security.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: UiConstants.textColor,
                  fontSize: SizeConfig.mediumTextSize * 1.4)),
          SizedBox(height: SizeConfig.blockSizeVertical * 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.35,
                height: SizeConfig.blockSizeVertical * 5,
                decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(100.0),
                    color: UiConstants.primaryColor),
                child: new Material(
                  child: MaterialButton(
                    child: Text(
                      'Enable',
                      style: Theme.of(context).textTheme.button.copyWith(
                          color: Colors.white,
                          fontSize: SizeConfig.largeTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    highlightColor: Colors.white30,
                    splashColor: Colors.white30,
                    onPressed: () {
                      baseProvider.flipSecurityValue(true);
                      Navigator.of(context).pop();
                    },
                  ),
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.circular(100.0),
                ),
              ),
              Container(
                width: SizeConfig.screenWidth * 0.35,
                height: SizeConfig.blockSizeVertical * 5,
                // decoration: BoxDecoration(
                //   borderRadius: new BorderRadius.circular(100.0),
                //   border: Border.all(color : UiConstants.accentColor)
                // ),
                child: new Material(
                  child: MaterialButton(
                    child: Text(
                      'Not now',
                      style: Theme.of(context).textTheme.button.copyWith(
                          color: UiConstants.accentColor,
                          fontSize: SizeConfig.largeTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    highlightColor: Colors.grey[300],
                    splashColor: Colors.grey[300],
                    onPressed: () {
                      Navigator.of(context).pop();
                      // if (baseProvider.show_finance_tutorial) {
                      //   _walkthroughBottomSheet();
                      // }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        side: BorderSide(color: UiConstants.accentColor)),
                  ),
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 5,
          ),
        ],
      ),
    );
  }
}
