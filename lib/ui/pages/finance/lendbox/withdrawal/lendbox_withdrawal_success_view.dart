import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LendboxWithdrawalSuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Lottie.asset(
              Assets.floSellCompleteLottie,
            ),
          ),
          Text(
           locale.btnCongratulations,
            style: TextStyles.rajdhaniB.title2,
          ),
          SizedBox(height: SizeConfig.padding12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding28),
            child: Text( locale.txnWithDrawReq,
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
              AppState.backButtonDispatcher!.didPopRoute();
            },
            child: Text(
             locale.obDone,
              style:
                  TextStyles.rajdhaniSB.body0.colour(UiConstants.primaryColor),
            ),
          )
        ],
      ),
    );
  }
}
