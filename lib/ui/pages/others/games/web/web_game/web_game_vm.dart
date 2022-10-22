import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/constants/fcm_commands_constants.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/score_reject_dialog.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class WebGameViewModel extends BaseViewModel {
  final _gtService = locator<GoldenTicketService>();
  final _logger = locator<CustomLogger>();
  final _lbService = locator<LeaderboardService>();
  final _userRepo = locator<UserRepository>();
  final _userCoinService = locator<UserCoinService>();
  final _analyticsService = locator<AnalyticsService>();
  final _journeyService = locator<JourneyService>();

  String _currentGame;

  get currentGame => this._currentGame;

  set currentGame(value) => this._currentGame = value;
  init(String game, bool inLandscapeMode) async {
    currentGame = game;
    if (inLandscapeMode) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom]);
      SystemChrome.setPreferredOrientations([
        Platform.isIOS
            ? DeviceOrientation.landscapeRight
            : DeviceOrientation.landscapeLeft
      ]);
      AppState.isWebGameLInProgress = true;
    } else {
      AppState.isWebGamePInProgress = true;
    }
    print("In Landscape mode: $inLandscapeMode");
    if (!await CacheManager.exits(CacheManager.CACHE_IS_FIRST_TIME_FOOTBALL) &&
        currentGame == Constants.GAME_TYPE_FOOTBALL) {
      CacheManager.writeCache(
          key: CacheManager.CACHE_IS_FIRST_TIME_FOOTBALL,
          value: true,
          type: CacheType.bool);

      Future.delayed(Duration(seconds: 1), () {
        BaseUtil.showNegativeAlert(
          'Game Loading',
          'This game might take longer than usual to load',
        );
      });
    }

    // setUpWebGameView(game);
  }

  handleCricketHeroRoundEnd(Map<String, dynamic> data, String game) async {
    _analyticsService.track(eventName: AnalyticsEvents.cricketHeroGameEnds);
    if (data['gt_id'] != null && data['gt_id'].toString().isNotEmpty) {
      _logger.d("Recived a Golden ticket with id: ${data['gt_id']}");
      GoldenTicketService.goldenTicketId = data['gt_id'];
    }
    handleGameEndRound(data, game);
  }

  handlePoolClubRoundEnd(Map<String, dynamic> data, String game) async {
    _analyticsService.track(eventName: AnalyticsEvents.poolClubEnds);
    if (data['gt_id'] != null && data['gt_id'].toString().isNotEmpty) {
      _logger.d("Recived a Golden ticket with id: ${data['gt_id']}");
      GoldenTicketService.goldenTicketId = data['gt_id'];
    }
    handleGameEndRound(data, game);
  }

  handleFootBallRoundEnd(Map<String, dynamic> data, String game) async {
    _analyticsService.track(eventName: AnalyticsEvents.footBallEnds);
    if (data['gt_id'] != null && data['gt_id'].toString().isNotEmpty) {
      _logger.d("Recived a Golden ticket with id: ${data['gt_id']}");
      GoldenTicketService.goldenTicketId = data['gt_id'];
    }
    handleGameEndRound(data, game);
  }

  handleCandyFiestaRoundEnd(Map<String, dynamic> data, String game) async {
    _analyticsService.track(eventName: AnalyticsEvents.candyFiestaEnds);
    if (data['gt_id'] != null && data['gt_id'].toString().isNotEmpty) {
      _logger.d("Recived a Golden ticket with id: ${data['gt_id']}");
      GoldenTicketService.goldenTicketId = data['gt_id'];
    }
    handleGameEndRound(data, game);
  }

  handleLowBalanceAlert() {
    if (AppState.isWebGameLInProgress || AppState.isWebGamePInProgress) {
      AppState.isWebGameLInProgress = false;
      AppState.isWebGamePInProgress = false;
      AppState.backButtonDispatcher.didPopRoute();
      Future.delayed(Duration(milliseconds: 700), () async {
        BaseUtil.openModalBottomSheet(
          addToScreenStack: true,
          backgroundColor: UiConstants.gameCardColor,
          content: WantMoreTicketsModalSheet(isInsufficientBalance: true),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness24),
            topRight: Radius.circular(SizeConfig.roundness24),
          ),
          hapticVibrate: true,
          isScrollControlled: true,
          isBarrierDismissable: true,
        );
      });
    }
  }

  handleGameEndRound(Map<String, dynamic> data, String game) {
    _logger.d(
        "$game round end at  ${DateFormat('yyyy-MM-dd - hh:mm a').format(DateTime.now())}");
    if (data['mlIndex'] != null)
      _journeyService.avatarRemoteMlIndex = data["mlIndex"];
    _logger.d("MLIndex found: ${data['mlIndex']}");
    if (data[FcmCommands.GAME_END_MESSAGE_KEY] != null &&
        data[FcmCommands.GAME_END_MESSAGE_KEY].toString().isNotEmpty) {
      _logger.d("Game end message: ${data[FcmCommands.GAME_END_MESSAGE_KEY]}");
      GoldenTicketService.gameEndMsgText =
          data[FcmCommands.GAME_END_MESSAGE_KEY].toString();
    }
    updateFlcBalance();
    _lbService.fetchWebGameLeaderBoard(game: game);
  }

  handleGameSessionEnd({Duration duration}) {
    updateFlcBalance();
    _logger.d("Checking for golden tickets");
    if (GoldenTicketService.gameEndMsgText != null &&
        GoldenTicketService.gameEndMsgText.isNotEmpty) {
      _logger.d("Showing game end message");
      Future.delayed(duration ?? Duration(milliseconds: 500), () {
        BaseUtil.openDialog(
          addToScreenStack: true,
          isBarrierDismissable: false,
          hapticVibrate: true,
          content: ScoreRejectedDialog(
              contentText: GoldenTicketService.gameEndMsgText),
        );
        GoldenTicketService.gameEndMsgText = null;
      });
      return;
    }
    _gtService.fetchAndVerifyGoldenTicketByID();
  }

  //helper
  updateFlcBalance() async {
    ApiResponse<FlcModel> _flcResponse = await _userRepo.getCoinBalance();
    if (_flcResponse.model.flcBalance != null) {
      _userCoinService.setFlcBalance(_flcResponse.model.flcBalance);
    } else {
      _logger.d("Flc balance is null");
    }
  }
}
