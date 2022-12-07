import 'package:another_flushbar/flushbar.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppToasts {
  static Flushbar? flushbar;
  static bool isKeyboardOpen = false;
  static EdgeInsets? toastMargin;

  static showNegativeToast(
      {required String? title, required String? subtitle, int? seconds}) async {
    if (handleToastPreChecks(title, subtitle)) {
      if (flushbar != null) await flushbar!.dismiss();
      flushbar = Flushbar(
        flushbarPosition:
            isKeyboardOpen ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        icon: Icon(
          Icons.assignment_late,
          size: 28.0,
          color: UiConstants.tertiarySolid,
        ),
        margin: toastMargin!,
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        title: title!.isEmpty ? "Something went wrong" : title,
        message:
            subtitle!.isEmpty ? "Please try again after sometime" : subtitle,
        duration: Duration(seconds: seconds ?? 2),
        backgroundColor: Colors.black,
        boxShadows: [
          BoxShadow(
            color: UiConstants.negativeAlertColor,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
      );
      flushbar!.show(AppState.delegate!.navigatorKey.currentContext!);
      return true;
    }
    return false;
  }

  static showPositiveToast(
      {required String? title, required String? subtitle, int? seconds}) async {
    if (handleToastPreChecks(title, subtitle)) {
      if (AppState.screenStack.last == ScreenItem.dialog ||
          AppState.screenStack.last == ScreenItem.modalsheet) return;
      if (flushbar != null) await flushbar!.dismiss();
      flushbar = Flushbar(
        flushbarPosition:
            isKeyboardOpen ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        icon: Icon(
          Icons.flag,
          size: 28.0,
          color: UiConstants.primaryColor,
        ),
        margin: toastMargin!,
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        title: title,
        message: subtitle,
        duration: Duration(seconds: seconds ?? 2),
        backgroundColor: Colors.black,
        boxShadows: [
          BoxShadow(
            color: UiConstants.positiveAlertColor!,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
      );
      flushbar!.show(AppState.delegate!.navigatorKey.currentContext!);
      return true;
    }
    return false;
  }

  static showNoInternetToast() {
    ConnectivityStatus connectivityStatus = Provider.of<ConnectivityStatus>(
        AppState.delegate!.navigatorKey.currentContext!,
        listen: false);
    if (connectivityStatus == ConnectivityStatus.Offline) {
      flushbar = Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        icon: Icon(
          Icons.error,
          size: 28.0,
          color: Colors.white,
        ),
        margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        title: "No Internet",
        message: "Please check your network connection and try again",
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        boxShadows: [
          BoxShadow(
            color: Colors.red[800]!,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
      );
      flushbar!.show(AppState.delegate!.navigatorKey.currentContext!);
      return true;
    }
    return false;
  }

//HELPER
  static bool handleToastPreChecks(title, subtitle) {
    toastMargin = EdgeInsets.only(
        bottom: AppState.screenStack.length == 1 && AppState.isUserSignedIn
            ? SizeConfig.navBarHeight + SizeConfig.pageHorizontalMargins
            : SizeConfig.pageHorizontalMargins,
        left: SizeConfig.pageHorizontalMargins,
        right: SizeConfig.pageHorizontalMargins);
    isKeyboardOpen =
        MediaQuery.of(AppState.delegate!.navigatorKey.currentContext!)
                .viewInsets
                .bottom !=
            0;
    if (title == null || subtitle == null) return false;
    if (title.length > 100 || subtitle.length > 100) return false;
    return true;
  }
}
