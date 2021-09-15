import 'package:felloapp/base_util.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SuccessDialog extends StatelessWidget {
  BaseUtil baseProvider;

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
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    return Container(
      height: SizeConfig.screenWidth * 0.75,
      width: SizeConfig.screenWidth * 0.75,
      // padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.016),
      child: Column(
        children: [
          Expanded(
            child: LottieBuilder.asset(
              "images/lottie/success.json",
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Investment Successful",
              style: TextStyle(
                fontSize: SizeConfig.largeTextSize,
                fontWeight: FontWeight.w700,
                color: UiConstants.primaryColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Your investment was successful. Also, we credited prize tickets to your account",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: SizeConfig.smallTextSize,
                  color: UiConstants.accentColor,
                  fontStyle: FontStyle.italic),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(
                      color: UiConstants.primaryColor,
                      gradient: new LinearGradient(
                        colors: [
                          UiConstants.primaryColor,
                          UiConstants.primaryColor.withGreen(200)
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(20))),
                  child: TextButton(
                    child: Text(
                      "Invest more",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.mediumTextSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      AppState.backButtonDispatcher.didPopRoute();
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      color: UiConstants.primaryColor,
                      gradient: new LinearGradient(
                        colors: [
                          UiConstants.primaryColor.withGreen(600),
                          UiConstants.primaryColor.withGreen(800),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(20))),
                  child: TextButton(
                    child: Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.mediumTextSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      AppState.backButtonDispatcher.didPopRoute();
                      AppState.backButtonDispatcher.didPopRoute();
                      // baseProvider.showRefreshIndicator(context);
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
