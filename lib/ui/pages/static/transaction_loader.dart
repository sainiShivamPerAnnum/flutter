import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class TransactionLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Stack(
        children: [
          AnimatedPositioned(
            bottom: 0,
            duration: Duration(seconds: 1),
            curve: Curves.decelerate,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness24),
                  topRight: Radius.circular(SizeConfig.roundness24),
                ),
                color: Colors.white,
              ),
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: SizeConfig.padding20),
                  SpinKitWave(
                      size: SizeConfig.padding24,
                      color: UiConstants.primaryColor),
                  SizedBox(height: SizeConfig.padding20),
                  SizedBox(height: SizeConfig.padding6),
                  Text("Processing...", style: TextStyles.title4.bold),
                  SizedBox(height: SizeConfig.padding8),
                  Text(
                    "We are currently verifying you payment.",
                    style: TextStyles.body2.colour(Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.padding16),
                  Text(
                    "Please wait...",
                    style: TextStyles.body4.colour(Colors.grey).light,
                  ),
                  SizedBox(height: SizeConfig.padding24),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
