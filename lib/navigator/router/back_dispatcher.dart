//Project Imports
import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/dialogs/default_dialog.dart';
import 'package:felloapp/ui/pages/others/games/web/web_game/web_game_vm.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog_landscape.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
//Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FelloBackButtonDispatcher extends RootBackButtonDispatcher {
  final FelloRouterDelegate _routerDelegate;
  final CustomLogger logger = locator<CustomLogger>();
  final _userRepo = locator<UserRepository>();
  BaseUtil _baseUtil = locator<BaseUtil>();
  final _userService = locator<UserService>();
  final _webGameViewModel = locator<WebGameViewModel>();
  final JourneyService _journeyService = locator<JourneyService>();

  FelloBackButtonDispatcher(this._routerDelegate) : super();

  Future<bool> _confirmExit(String title, String description,
      Function confirmAction, bool isInLandScape) {
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissable: false,
      hapticVibrate: true,
      content: RotatedBox(
        quarterTurns: 0,
        child: ConfirmationDialog(
          asset:
              SvgPicture.asset(Assets.noTickets, height: SizeConfig.padding54),
          title: title,
          description: description,
          cancelBtnText: "Exit",
          buttonText: "Stay",
          confirmAction: didPopRoute,
          cancelAction: confirmAction,
        ),
      ),
    );
  }

  bool isAnyDialogOpen() {
    if (AppState.screenStack.last == ScreenItem.dialog) return true;
    return false;
  }

  @override
  Future<bool> didPopRoute() {
    log("Back Request called");
    if (JourneyService.isAvatarAnimationInProgress) return null;
    if (AppState.delegate.appState.isTxnLoaderInView) return null;
    if (AppState.screenStack.last == ScreenItem.loader) return null;

    Future.delayed(Duration(milliseconds: 20), () {
      if (_userService.buyFieldFocusNode.hasPrimaryFocus ||
          _userService.buyFieldFocusNode.hasFocus) {
        logger.d("field has focus");
        FocusManager.instance.primaryFocus.unfocus();
      }
    });
    // If the top item is anything except a scaffold
    if (AppState.screenStack.last == ScreenItem.dialog ||
        AppState.screenStack.last == ScreenItem.modalsheet) {
      Navigator.pop(_routerDelegate.navigatorKey.currentContext);
      AppState.screenStack.removeLast();
      print("Current Stack: ${AppState.screenStack}");
      // if (GoldenTicketService.hasGoldenTicket)
      //   _gtService.showGoldenTicketFlushbar();
      return Future.value(true);
    }

    // If onboarding is in progress
    else if (AppState.isOnboardingInProgress) {
      showNegativeAlert("Exit Signup?", "Press back once more to exit");
      AppState.isOnboardingInProgress = false;
      return Future.value(true);
    }
    //If the cricket game is in progress
    else if (AppState.isWebGameLInProgress)
      return _confirmExit(
        "Exit Game",
        "Are you sure you want to leave?",
        () {
          logger.d("Closing landscape mode game view");
          AppState.isWebGameLInProgress = false;
          didPopRoute();
          didPopRoute();
          _webGameViewModel.handleGameSessionEnd();
        },
        true,
      );
    else if (AppState.isWebGamePInProgress)
      return _confirmExit(
        "Exit Game",
        "Are you sure you want to leave?",
        () {
          AppState.isWebGamePInProgress = false;
          didPopRoute();
          didPopRoute();
          _webGameViewModel.handleGameSessionEnd(
              duration: Duration(milliseconds: 500));
        },
        false,
      );
    else if (AppState.isUpdateScreen) {
      AppState.isUpdateScreen = false;
      return _routerDelegate.popRoute();
    }
    // If the root tab is not 0 at the time of exit

    else if (_baseUtil.isUserOnboarded &&
        AppState.screenStack.length == 1 &&
        AppState.delegate.appState.rootIndex != 0) {
      logger.w("Checking if app can be closed");
      // // if (RootViewModel.scaffoldKey.currentState.isDrawerOpen)
      // //   RootViewModel.scaffoldKey.currentState.openEndDrawer();
      // // else
      // if (AppState.delegate.appState.rootIndex != 0)
      AppState.delegate.appState.setCurrentTabIndex = 0;
      return Future.value(true);
    }

    return _routerDelegate.popRoute();
  }

  showNegativeAlert(String title, String message, {int seconds}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        Icons.assignment_late,
        size: 28.0,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(10),
      borderRadius: 8,
      title: title,
      message: message,
      duration: Duration(seconds: seconds ?? 3),
      backgroundColor: UiConstants.negativeAlertColor,
      boxShadows: [
        BoxShadow(
          color: UiConstants.negativeAlertColor,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    )..show(AppState.delegate.navigatorKey.currentContext);
  }
}
