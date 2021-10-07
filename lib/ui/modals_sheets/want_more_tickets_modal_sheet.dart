import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class WantMoreTicketsModalSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        AppState.backButtonDispatcher.didPopRoute();
        return Future.value(true);
      },
      child: Container(
        width: SizeConfig.screenWidth,
        child: Wrap(
          children: [
            Container(
              width: SizeConfig.screenWidth,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Want more tickets?",
                style: TextStyles.title2.bold.colour(UiConstants.primaryColor),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text(
                "Save More Money",
                style: TextStyles.body2.bold,
              ),
              subtitle:
                  Text("Get 1 ticket for every 100", style: TextStyles.body3),
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Refer your friends", style: TextStyles.body2.bold),
              subtitle:
                  Text("Get 10 tickets per referral", style: TextStyles.body3),
            ),
            ListTile(
              leading: Icon(Icons.repeat),
              title: Text("Set up SIP", style: TextStyles.body2.bold),
              subtitle: Text("Earn tickets on the go", style: TextStyles.body3),
            )
          ],
        ),
      ),
    );
  }
}
