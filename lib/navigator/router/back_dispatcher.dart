//Project Imports
import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/navigator/router/router_delegate.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/modalsheets/autosave_confirm_exit_modalsheet.dart';
import 'package:felloapp/ui/modalsheets/autosave_survey_modalsheet.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_components/gold_pro_buy_exit_modalsheet.dart';
import 'package:felloapp/ui/pages/games/web/web_game/web_game_vm.dart';
import 'package:felloapp/ui/pages/hometabs/home/card_actions_notifier.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/app_toasts_utils.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
//Flutter Imports
import 'package:flutter/material.dart';

class FelloBackButtonDispatcher extends RootBackButtonDispatcher {
  final FelloRouterDelegate? _routerDelegate;
  final CustomLogger? logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  final WebGameViewModel _webGameViewModel = locator<WebGameViewModel>();
  final AugmontTransactionService _augTxnService =
      locator<AugmontTransactionService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  FelloBackButtonDispatcher(this._routerDelegate) : super();

  Future<bool> _confirmExit(String title, String description,
      Function confirmAction, bool isInLandScape) {
    BaseUtil.openDialog(
      addToScreenStack: true,
      isBarrierDismissible: false,
      hapticVibrate: true,
      content: RotatedBox(
        quarterTurns: 0,
        child: ConfirmationDialog(
          title: title,
          description: description,
          cancelBtnText: "Exit",
          buttonText: "Stay",
          confirmAction: didPopRoute,
          cancelAction: confirmAction,
        ),
      ),
    );
    return Future.value(true);
  }

  bool isAnyDialogOpen() {
    if (AppState.screenStack.last == ScreenItem.dialog) return true;
    return false;
  }

  @override
  Future<bool> didPopRoute() {
    AppToasts.flushbar?.dismiss();
    if (AppState.screenStack.last == ScreenItem.loader) {
      return Future.value(true);
    }
    // _journeyService.checkForMilestoneLevelChange();
    if (locator<BackButtonActions>().isTransactionCancelled) {
      if (AppState.onTap != null &&
          AppState.type != null &&
          AppState.amt != null) {
        if (AppState.delegate!.currentConfiguration!.key ==
                'LendboxBuyViewPath' &&
            AppState.screenStack.last != ScreenItem.dialog &&
            !AppState.isRepeated &&
            AppState.type == InvestmentType.LENDBOXP2P) {
          locator<BackButtonActions>().showWantToCloseTransactionBottomSheet(
            AppState.amt!.round(),
            AppState.type!,
            () {
              AppState.onTap?.call();
            },
          );
          AppState.isRepeated = true;
          return Future.value(true);
        } else if (AppState.screenStack[AppState.screenStack.length - 2] !=
                ScreenItem.dialog &&
            AppState.screenStack.last == ScreenItem.dialog &&
            !AppState.isRepeated &&
            !AppState.isTxnProcessing &&
            AppState.type == InvestmentType.AUGGOLD99) {
          locator<BackButtonActions>().showWantToCloseTransactionBottomSheet(
            AppState.amt!.round(),
            AppState.type!,
            () {
              AppState.onTap?.call();
            },
          );
          AppState.isRepeated = true;
          return Future.value(true);
        }
      }
    }
    if (AppState.isInstantGtViewInView) return Future.value(true);

    // If the top item is anything except a scaffold
    if (AppState.screenStack.last == ScreenItem.dialog ||
        AppState.screenStack.last == ScreenItem.modalsheet) {
      log("AppState.screenStack.last ${AppState.screenStack.last.name}");

      Navigator.pop(_routerDelegate!.navigatorKey.currentContext!);
      AppState.screenStack.removeLast();
      print("Current Stack: ${AppState.screenStack}");
      return Future.value(true);
    }

    if (_augTxnService.currentTransactionState == TransactionState.overView) {
      Haptic.vibrate();
      if (AppState.isGoldProBuyInProgress) {
        AppState.isGoldProBuyInProgress = false;
        BaseUtil.openModalBottomSheet(
          isBarrierDismissible: true,
          addToScreenStack: true,
          backgroundColor: UiConstants.kArrowButtonBackgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.roundness24),
              topRight: Radius.circular(SizeConfig.roundness24)),
          hapticVibrate: true,
          isScrollControlled: true,
          content: const GoldProBuyExitModalSheet(),
        );
      } else {
        _augTxnService.currentTransactionState = TransactionState.idle;
      }
      return Future.value(true);
    }

    if (AppState.showAutoSaveSurveyBt) {
      final PageController apgController =
          locator<SubService>().pageController!;
      if (apgController.hasClients) {
        if (apgController.page!.toInt() > 0) {
          AppState.showAutoSaveSurveyBt = false;
          BaseUtil.openModalBottomSheet(
              isBarrierDismissible: true,
              addToScreenStack: true,
              backgroundColor: UiConstants.kBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.roundness32),
                topRight: Radius.circular(SizeConfig.roundness32),
              ),
              isScrollControlled: true,
              hapticVibrate: true,
              content: const AutoSaveSurvey());
          return Future.value(true);
        }
      }
    }

    if (AppState.showAutosaveBt) {
      if (AppState.autosaveMiddleFlow) {
        AppState.showAutoSaveSurveyBt = false;
        AppState.autosaveMiddleFlow = false;
        return _routerDelegate!.popRoute();
      }
      if (locator<SubService>().pageController?.hasClients ?? false) {
        final PageController apgController =
            locator<SubService>().pageController!;
        if (apgController.page!.toInt() > 0) {
          apgController.animateToPage(apgController.page!.toInt() - 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.decelerate);
          return Future.value(true);
        } else {
          AppState.showAutosaveBt = false;
          _analyticsService.track(eventName: AnalyticsEvents.asHardBackTapped);
          BaseUtil.openModalBottomSheet(
              isBarrierDismissible: true,
              addToScreenStack: true,
              backgroundColor: UiConstants.kBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.roundness32),
                topRight: Radius.circular(SizeConfig.roundness32),
              ),
              isScrollControlled: true,
              hapticVibrate: true,
              content: const AutosaveConfirmExitModalSheet());
          return Future.value(true);
        }
      }
    }

    // If onboarding is in progress
    else if (AppState.isOnboardingInProgress) {
      BaseUtil().showConfirmExit();
      AppState.isOnboardingInProgress = false;
      return Future.value(true);
    }
    //If the cricket game is in progress
    else if (AppState.isWebGameLInProgress) {
      return _confirmExit(
        "Exit Game",
        "Are you sure you want to leave?",
        () {
          logger!.d("Closing landscape mode game view");
          AppState.isWebGameLInProgress = false;
          didPopRoute();
          didPopRoute();
          _webGameViewModel.handleGameSessionEnd();
        },
        true,
      );
    } else if (AppState.isWebGamePInProgress) {
      return _confirmExit(
        "Exit Game",
        "Are you sure you want to leave?",
        () {
          AppState.isWebGamePInProgress = false;
          didPopRoute();
          didPopRoute();
          _webGameViewModel.handleGameSessionEnd(
              duration: const Duration(milliseconds: 500));
        },
        false,
      );
    } else if (AppState.isQuizInProgress) {
      return _confirmExit(
        "Exit Quiz",
        "Are you sure you want to leave?",
        () async {
          AppState.isQuizInProgress = false;

          final superFelloIndex = AppState.delegate!.pages.indexWhere(
            (element) => element.name == FelloBadgeHomeViewPageConfig.path,
          );

          if (superFelloIndex != -1) {
            while (AppState.delegate!.pages.last.name !=
                FelloBadgeHomeViewPageConfig.path) {
              await didPopRoute();
            }

            await didPopRoute();

            await Future.delayed(const Duration(milliseconds: 100));

            AppState.delegate!.appState.currentAction = PageAction(
              state: PageState.addPage,
              page: FelloBadgeHomeViewPageConfig,
            );
          } else {
            await didPopRoute();
            await didPopRoute();
          }
        },
        false,
      );
    } else if (AppState.isUpdateScreen) {
      AppState.isUpdateScreen = false;
      return _routerDelegate!.popRoute();
    }

    //If device authentication failed
    else if (AppState.screenStack.length == 1 &&
        AppState.delegate!.pages[0].name == SplashPath) {
      return _routerDelegate!.popRoute();
    }
    // If the root tab is not 0 at the time of exit

    else if (_userService.isUserOnboarded && AppState.screenStack.length == 1) {
      logger!.w("Checking if app can be closed");

      if (AppState.delegate!.appState.rootIndex != 0) {
        AppState.delegate!.appState.setCurrentTabIndex = 0;
        locator<RootController>()
            .onChange(locator<RootController>().navItems.values.toList()[0]);
        return Future.value(true);
      } else if (AppState.delegate!.appState.rootIndex ==
              locator<RootController>()
                  .navItems
                  .values
                  .toList()
                  .indexWhere((element) => element.title == "Save") &&
          locator<CardActionsNotifier>().isVerticalView) {
        locator<CardActionsNotifier>().isVerticalView = false;
        return Future.value(true);
      }
    }
    Haptic.vibrate();
    return _routerDelegate!.popRoute();
  }
}
