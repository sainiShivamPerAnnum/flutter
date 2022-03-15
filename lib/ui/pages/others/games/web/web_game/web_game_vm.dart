import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class WebGameViewModel extends BaseModel {
  final _gtService = locator<GoldenTicketService>();
  final _logger = locator<CustomLogger>();
  final _lbService = locator<LeaderboardService>();
  String _currentGame;

  get currentGame => this._currentGame;

  set currentGame(value) => this._currentGame = value;
  init(String game) {
    currentGame = game;
    // setUpWebGameView(game);
  }

  // setUpWebGameView(String game) {
  //   switch (game) {
  //     case Constants.GAME_TYPE_POOLCLUB:
  //       break;
  //     case Constants.GAME_TYPE_CRICKET:
  //       break;
  //     default:
  //       return;
  //   }
  // }

  // cleanUpWebGameView(String game) {
  //   switch (game) {
  //     case Constants.GAME_TYPE_POOLCLUB:
  //       break;
  //     case Constants.GAME_TYPE_CRICKET:
  //       break;
  //     default:
  //       return;
  //   }
  // }

  endWebGame(data, game) {
    _logger.i("FCM Command received to end Cricket game");
    //  check if payload has a golden ticket
    if (data['gt_id'] != null && data['gt_id'].toString().isNotEmpty) {
      _logger.d(data.toString());
      GoldenTicketService.goldenTicketId = data['gt_id'];
    }
    //Navigate back to CricketView
    if (AppState.webGameInProgress) {
      AppState.webGameInProgress = false;
      AppState.backButtonDispatcher.didPopRoute();
      Future.delayed(Duration(milliseconds: 100), () async {
        if (await _gtService.fetchAndVerifyGoldenTicketByID()) {
          _gtService.showInstantGoldenTicketView(
              title: 'Game milestone achieved', source: GTSOURCE.cricket);
        } else
          BaseUtil.openDialog(
            addToScreenStack: true,
            isBarrierDismissable: true,
            hapticVibrate: false,
            content: FelloInfoDialog(
              showCrossIcon: false,
              title: "Game Over",
              subtitle: (data['game_score'] != null)
                  ? "You score was ${data['game_score']}"
                  : "Game Over",
              action: Container(
                width: SizeConfig.screenWidth,
                child: FelloButtonLg(
                    child: Text(
                      "OK",
                      style: TextStyles.body2.bold.colour(Colors.white),
                    ),
                    onPressed: () {
                      AppState.backButtonDispatcher.didPopRoute();
                      // _gtService.showGoldenTicketAvailableDialog();
                    }),
              ),
            ),
          );
      });
    }
    // update cricket scoreboard
    Future.delayed(Duration(milliseconds: 2500), () {
      _lbService
          .fetchWebGameLeaderBoard(game: game)
          .then((value) => _lbService.scrollToUserIndexIfAvaiable());
    });
  }
}
