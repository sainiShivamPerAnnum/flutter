import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class GoldenTicketService {
  static bool hasGoldenTicket = false;

  void showGoldenTicketFlushbar() {
    hasGoldenTicket = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        mainButton: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_forward_ios_rounded),
          color: Colors.white,
        ),
        isDismissible: true,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        icon: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.padding16),
              image:
                  DecorationImage(image: AssetImage("assets/images/gtbg.png"))),
          height: SizeConfig.iconSize1,
        ),
        onTap: (data) {
          AppState.delegate.appState.currentAction = PageAction(
            page: MyWinnigsPageConfig,
            state: PageState.addPage,
          );
        },
        margin: EdgeInsets.all(10),
        borderRadius: SizeConfig.roundness16,
        // title: "You won a Golden Ticket",
        message: "Tap to find out what you won",
        duration: Duration(seconds: 3),
        shouldIconPulse: true,
        titleText: Text(
          "You won a Golden Ticket",
          style: TextStyles.body2.bold.colour(Colors.white),
        ),
        backgroundGradient: new LinearGradient(
          colors: [Color(0xffA267AC), Color(0xffCE7BB0)],
        ),
        boxShadows: [
          BoxShadow(
            color: Color(0xff750550).withOpacity(0.5),
            offset: Offset(0.0, 2.0),
            blurRadius: 8.0,
          )
        ],
      )..show(AppState.delegate.navigatorKey.currentContext);
    });
  }
}
