import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog_landscape.dart';
import 'package:felloapp/util/assets.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CricketGameViewModel extends BaseModel {
  // confirmExit() {
  //   BaseUtil.openDialog(
  //       addToScreenStack: true,
  //       isBarrierDismissable: false,
  //       hapticVibrate: true,
  //       content: FelloConfirmationLandScapeDialog(
  //         title: "Are you sure?",
  //         subtitle: "Game will end here if you exit now",
  //         accept: "Exit",
  //         acceptColor: Colors.red,
  //         rejectColor: Colors.grey.withOpacity(0.3),
  //         reject: "Stay",
  //         onAccept: () {
  //           AppState.backButtonDispatcher.didPopRoute();
  //           AppState.backButtonDispatcher.didPopRoute();
  //         },
  //         onReject: AppState.backButtonDispatcher.didPopRoute,
  //       ));
  // }
}
