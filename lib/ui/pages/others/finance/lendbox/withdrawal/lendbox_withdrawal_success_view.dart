import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LendboxWithdrawalSuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    AppState.backButtonDispatcher.didPopRoute();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Lottie.asset(
              Assets.floSellCompleteLottie,
            ),
          ),
          Text(
            "Congratulations!",
            style: TextStyles.rajdhaniB.title2,
          ),
          SizedBox(height: SizeConfig.padding12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding28),
            child: Text(
              "Your withdrawal request has been placed and the money will be credited to your account in the next 1-2 business working days",
              style: TextStyles.sourceSans.body2.setOpecity(0.7),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          SizedBox(height: SizeConfig.padding24),
          TextButton(
            onPressed: () {
              AppState.backButtonDispatcher.didPopRoute();
            },
            child: Text(
              "Done",
              style:
                  TextStyles.rajdhaniSB.body0.colour(UiConstants.primaryColor),
            ),
          )
        ],
      ),
    );
  }
}
