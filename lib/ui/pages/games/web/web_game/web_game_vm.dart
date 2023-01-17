import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/fcm_commands_constants.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/repository/user_stats_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/score_reject_dialog.dart';
import 'package:felloapp/ui/modalsheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class WebGameViewModel extends BaseViewModel {
  final ScratchCardService? _gtService = locator<ScratchCardService>();
  final CustomLogger? _logger = locator<CustomLogger>();
  final LeaderboardService? _lbService = locator<LeaderboardService>();
  final UserRepository? _userRepo = locator<UserRepository>();
  final UserCoinService? _userCoinService = locator<UserCoinService>();
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  final JourneyService? _journeyService = locator<JourneyService>();
  S locale = locator<S>();
  String? _currentGame;

  get currentGame => this._currentGame;

  set currentGame(value) => this._currentGame = value;
  init(String? game, bool inLandscapeMode) async {
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
          locale.gameLoading,
          locale.gameLoadingSubTitle,
        );
      });
    }

    // setUpWebGameView(game);
  }

  handleLowBalanceAlert() {
    if (AppState.isWebGameLInProgress || AppState.isWebGamePInProgress) {
      AppState.isWebGameLInProgress = false;
      AppState.isWebGamePInProgress = false;
      AppState.backButtonDispatcher!.didPopRoute();
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
          isBarrierDismissible: true,
        );
      });
    }
  }

  handleGameRoundEnd(Map<String, dynamic> data) {
    _logger!.d(
        "round end at  ${DateFormat('yyyy-MM-dd - hh:mm a').format(DateTime.now())}");

    if (data['gt_id'] != null && data['gt_id'].toString().isNotEmpty) {
      _logger!.d("Recived a Golden ticket with id: ${data['gt_id']}");

      BaseUtil.showPositiveAlert(
          "Scratch Card Won!", "You can claim it in the Win section");

      ScratchCardService.scratchCardId = data['gt_id'];
    }
    if (data['mlIndex'] != null)
      _journeyService!.avatarRemoteMlIndex = data["mlIndex"];
    _logger!.d("MLIndex found: ${data['mlIndex']}");
    if (data[FcmCommands.GAME_END_MESSAGE_KEY] != null &&
        data[FcmCommands.GAME_END_MESSAGE_KEY].toString().isNotEmpty) {
      _logger!.d("Game end message: ${data[FcmCommands.GAME_END_MESSAGE_KEY]}");
      ScratchCardService.gameEndMsgText =
          data[FcmCommands.GAME_END_MESSAGE_KEY].toString();
    }
    updateFlcBalance();
    if (data["game_type"] != null)
      _lbService!.fetchWebGameLeaderBoard(game: data["game_type"]);
  }

  handleGameSessionEnd({Duration? duration}) {
    updateFlcBalance();

    locator<UserStatsRepo>().getGameStats();

    _logger!.d("Checking for golden tickets");
    if (ScratchCardService.gameEndMsgText != null &&
        ScratchCardService.gameEndMsgText!.isNotEmpty) {
      _logger!.d("Showing game end message");
      Future.delayed(duration ?? Duration(milliseconds: 500), () {
        BaseUtil.openDialog(
          addToScreenStack: true,
          isBarrierDismissible: false,
          hapticVibrate: true,
          content: ScoreRejectedDialog(
              contentText: ScratchCardService.gameEndMsgText),
        );
        ScratchCardService.gameEndMsgText = null;
      });
      return;
    }
    _gtService!.fetchAndVerifyScratchCardByID();
  }

  //helper
  updateFlcBalance() async {
    ApiResponse<FlcModel> _flcResponse = await _userRepo!.getCoinBalance();
    if (_flcResponse.model!.flcBalance != null) {
      _userCoinService!.setFlcBalance(_flcResponse.model!.flcBalance);
    } else {
      _logger!.d("Flc balance is null");
    }
  }
}
