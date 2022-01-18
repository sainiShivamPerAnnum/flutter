import 'dart:developer';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class GoldenTicketService {
  // static bool hasGoldenTicket = false;
  void showGoldenTicketAvailableDialog() {
    // if (hasGoldenTicket) {
    // hasGoldenTicket = false;
    Future.delayed(Duration(milliseconds: 800), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          flushbarStyle: FlushbarStyle.FLOATING,
          icon: Icon(
            Icons.assignment_late,
            size: 28.0,
            color: Colors.white,
          ),
          onTap: (data) {
            log(data.message);
            Future.delayed(Duration(milliseconds: 00), () {
              AppState.backButtonDispatcher.didPopRoute();
              AppState.delegate.appState.currentAction = PageAction(
                page: MyWinnigsPageConfig,
                state: PageState.addPage,
              );
            });
          },
          margin: EdgeInsets.all(10),
          borderRadius: 8,
          title: "Luck Testament",
          message: "You won a Golden Ticket",
          duration: Duration(seconds: 5),
          // backgroundColor: UiConstants.negativeAlertColor,
          backgroundGradient: new LinearGradient(
            colors: [Color(0xffF88F01), Color(0xffF0A500)],
          ),
          boxShadows: [
            BoxShadow(
              color: UiConstants.negativeAlertColor,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
        )..show(AppState.delegate.navigatorKey.currentContext);
      });
      // BaseUtil.openDialog(
      //   addToScreenStack: true,
      //   isBarrierDismissable: false,
      //   hapticVibrate: false,
      //   content: FelloConfirmationDialog(
      //       title: 'Yayy!',
      //       subtitle: 'You won a golden ticket',
      //       accept: 'Open',
      //       acceptColor: UiConstants.primaryColor,
      //       asset: Assets.goldenTicket,
      //       reject: "Ok",
      //       rejectColor: UiConstants.tertiarySolid,
      //       showCrossIcon: false,
      // onAccept: () async {
      //   Future.delayed(Duration(milliseconds: 500), () {
      //     AppState.backButtonDispatcher.didPopRoute();
      //     AppState.delegate.appState.currentAction = PageAction(
      //       page: MyWinnigsPageConfig,
      //       state: PageState.addPage,
      //     );
      //   });
      // },
      //       onReject: () {
      //         AppState.backButtonDispatcher.didPopRoute();
      //       }),
      // );
    });
    // }
  }
}
