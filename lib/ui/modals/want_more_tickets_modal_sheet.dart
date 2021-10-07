import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/widgets.dart';
import 'package:felloapp/util/styles/size_config.dart';
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
              child: Widgets()
                  .getTitle("Want more tickets?", UiConstants.primaryColor),
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Widgets().getHeadlineBold(text: "Save More Money"),
              subtitle: Widgets()
                  .getHeadlineLight("Get 1 ticket for every 100", Colors.black),
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Widgets().getHeadlineBold(text: "Refer your friends"),
              subtitle: Widgets().getHeadlineLight(
                  "Get 10 tickets per referral", Colors.black),
            ),
            ListTile(
              leading: Icon(Icons.repeat),
              title: Widgets().getHeadlineBold(text: "Set up SIP"),
              subtitle: Widgets()
                  .getHeadlineLight("Earn tickets on the go", Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
