import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/leaderboard_model.dart';
import 'package:felloapp/core/model/scoreboard_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modalsheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/games/web/web_game/web_game_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RechargeOption {
  final Color? color;
  final int? amount;
  final bool isCustom;

  RechargeOption({this.color, this.amount, this.isCustom = false});
}

class WebHomeViewModel extends BaseViewModel {
  //Dependency Injection
  final UserService _userService = locator<UserService>();
  final LeaderboardService _lbService = locator<LeaderboardService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final UserRepository _userRepo = locator<UserRepository>();
  final CustomLogger _logger = locator<CustomLogger>();
  final UserCoinService _coinService = locator<UserCoinService>();
  final GameRepo _gamesRepo = locator<GameRepo>();
  final GetterRepository _getterRepo = locator<GetterRepository>();
  final DBModel _dbModel = locator<DBModel>();
  final InternalOpsService _internalOps = locator<InternalOpsService>();
  S locale = locator<S>();
  //Local Variables
  bool _isGameLoading = false;
  String? _currentGame;
  String? _sessionId;
  String? _gameEndpoint;
  bool? _isLoading;
  String? gameCode;
  GameModel? _currentGameModel;
  List<RechargeOption> rechargeOptions = [
    RechargeOption(
      color: const Color(0xff5948B2),
      amount: 100,
    ),
    RechargeOption(
      color: const Color(0xff9A3538),
      amount: 200,
    ),
    RechargeOption(
      color: const Color(0xff9A3538),
      amount: 500,
    ),
    RechargeOption(
      isCustom: true,
      color: const Color(0xff39393C),
      amount: 0,
    )
  ];
  String? gameToken;
  int? _currentCoinValue;
  List<ScoreBoard>? _pastWeekParticipants;

  //Getters
  List<ScoreBoard>? get pastWeekParticipants => _pastWeekParticipants;
  String? get currentGame => _currentGame;

  String? get sessionID => _sessionId;
  get isLoading => _isLoading;
  GameModel? get currentGameModel => _currentGameModel;
  int? get currentCoinValue => _currentCoinValue;

  //Setters
  set currentGame(value) {
    _currentGame = value;
    notifyListeners();
  }

  set currentGameModel(GameModel? value) {
    _currentGameModel = value;
    notifyListeners();
  }

  set isGameLoading(value) {
    _isGameLoading = value;
    notifyListeners();
  }

  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  set currentCoinValue(int? val) {
    _currentCoinValue = val;
    notifyListeners();
  }

  //Super Methods
  init(String game) async {
    currentGame = game;
    isLoading = true;
    currentCoinValue = _coinService!.flcBalance;
    await setGameDetails(game);
    // fetchTopSaversPastWeek(game);
    isLoading = false;
  }

  trackGameStart(int lastScore, int bestScore) {
    _analyticsService.track(
        eventName: AnalyticsEvents.playGameTapped,
        properties:
            AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
          //TODO : add location [Trending, gow,others, etc]
          'Game name': _currentGameModel!.gameName,
          "Entry fee": _currentGameModel!.playCost,
          "Last Score": lastScore,
          "best score": bestScore,
          "Time left for draw Tambola (mins)":
              AnalyticsProperties.getTimeLeftForTambolaDraw(),
          "Tambola Tickets Owned": AnalyticsProperties.getTambolaTicketCount(),
        }));
  }

  clear() {
    if (AppState.screenStack.last == ScreenItem.modalsheet) {
      AppState.screenStack.removeLast();
    }
  }

  Future<bool> setupGame() async {
    if (_userService.baseUser!.username!.isEmpty) {
      BaseUtil.showUsernameInputModalSheet();
      return false;
    }
    if (checkIfUserIsBannedFromThisGame() &&
        await checkIfDeviceIsNotAnEmulator()) {
      return _checkIfUserHasEnoughTokens();
    }
    return false;
  }

  Future<bool> checkIfDeviceIsNotAnEmulator() async {
    final bool isReal = await _internalOps!.checkIfDeviceIsReal();
    if (!isReal) {
      BaseUtil.showNegativeAlert(
          locale.simulatorsNotAllowed, locale.tryOnRealDevice);
      return false;
    }
    return true;
  }

  Stream<DatabaseEvent>? getRealTimePlayingStream(String game) {
    return Api().fetchRealTimePlayingStats(game);
  }

//MOVE THIS TO AN ISOLATED WIDGET --START
  Future getProfileDpWithUid(String? uid) async {
    return await _dbModel!.getUserDP(uid);
  }

  fetchTopSaversPastWeek(String game) async {
    ApiResponse response =
        await _getterRepo!.getStatisticsByFreqGameTypeAndCode(
      freq: "weekly",
      type: game,
      isForPast: true,
    );
    if (response.code == 200) {
      _pastWeekParticipants =
          LeaderboardModel.fromMap(response.model).scoreboard;
    } else {
      _pastWeekParticipants = [];
    }
    notifyListeners();
  }

//MOVE THIS TO AN ISOLATED WIDGET --END
  bool checkIfUserIsBannedFromThisGame() {
    bool isUserBannedForThisGame = false;
    String userBannedNotice = '';
    switch (currentGame) {
      case Constants.GAME_TYPE_CRICKET:
        isUserBannedForThisGame = _userService
                .userBootUp?.data?.banMap?.games?.cricketMap?.isBanned ??
            false;
        userBannedNotice =
            _userService.userBootUp?.data?.banMap?.games?.cricketMap?.reason ??
                '';
        break;
      case Constants.GAME_TYPE_CANDYFIESTA:
        isUserBannedForThisGame = _userService
                .userBootUp?.data?.banMap?.games?.candyFiestaMap?.isBanned ??
            false;
        userBannedNotice = _userService
                .userBootUp?.data?.banMap?.games?.candyFiestaMap?.reason ??
            '';
        break;
      case Constants.GAME_TYPE_FOOTBALL:
        isUserBannedForThisGame = _userService
                .userBootUp?.data?.banMap?.games?.footballMap?.isBanned ??
            false;
        userBannedNotice =
            _userService.userBootUp?.data?.banMap?.games?.footballMap?.reason ??
                '';
        break;
      case Constants.GAME_TYPE_POOLCLUB:
        isUserBannedForThisGame = _userService
                .userBootUp?.data?.banMap?.games?.poolClubMap?.isBanned ??
            false;
        userBannedNotice =
            _userService.userBootUp?.data?.banMap?.games?.poolClubMap?.reason ??
                '';
        break;
      case Constants.GAME_TYPE_BOWLING:
        isUserBannedForThisGame = _userService
                .userBootUp?.data?.banMap?.games?.bowlingMap?.isBanned ??
            false;
        userBannedNotice =
            _userService.userBootUp?.data?.banMap?.games?.bowlingMap?.reason ??
                '';
        break;
      case Constants.GAME_TYPE_BOTTLEFLIP:
        isUserBannedForThisGame = _userService
                .userBootUp?.data?.banMap?.games?.bottleFlipMap?.isBanned ??
            false;
        userBannedNotice = _userService
                .userBootUp?.data?.banMap?.games?.bottleFlipMap?.reason ??
            '';
        break;
      case Constants.GAME_TYPE_ROLLYVORTEX:
        isUserBannedForThisGame = _userService
                .userBootUp?.data?.banMap?.games?.rollyVortex?.isBanned ??
            false;
        userBannedNotice =
            _userService.userBootUp?.data?.banMap?.games?.rollyVortex?.reason ??
                '';
        break;
      case Constants.GAME_TYPE_KNIFEHIT:
        isUserBannedForThisGame =
            _userService.userBootUp?.data?.banMap?.games?.knifeHit?.isBanned ??
                false;
        userBannedNotice =
            _userService.userBootUp?.data?.banMap?.games?.knifeHit?.reason ??
                '';
        break;
      case Constants.GAME_TYPE_FRUITMAINA:
        isUserBannedForThisGame = _userService
                .userBootUp?.data?.banMap?.games?.fruitMania?.isBanned ??
            false;
        userBannedNotice =
            _userService.userBootUp?.data?.banMap?.games?.fruitMania?.reason ??
                '';
        break;
      case Constants.GAME_TYPE_TWODOTS:
        isUserBannedForThisGame =
            _userService.userBootUp?.data?.banMap?.games?.twoDots?.isBanned ??
                false;
        userBannedNotice =
            _userService.userBootUp?.data?.banMap?.games?.twoDots?.reason ?? '';
        break;
    }
    if (isUserBannedForThisGame) {
      BaseUtil.showNegativeAlert(
          userBannedNotice ?? locale.gameLocked, locale.contactUs);
      return false;
    }
    return true;
  }

  launchGame(int lastScore, int bestScore) {
    trackGameStart(lastScore, bestScore);
    String initialUrl = generateGameUrl();
    _logger!.d("Game Url: $initialUrl");

    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: WebGameViewPageConfig,
      widget: WebGameView(
          initialUrl: initialUrl,
          game: currentGame,
          inLandscapeMode:
              currentGame == Constants.GAME_TYPE_POOLCLUB ? true : false),
    );
    AppState.backButtonDispatcher!.didPopRoute();
  }

  Future<bool> _checkIfUserHasEnoughTokens() async {
    setState(ViewState.Busy);
    int? _playCost = _currentGameModel!.playCost;
    ApiResponse<FlcModel> _flcResponse = await _userRepo!.getCoinBalance();
    final response =
        _gamesRepo!.getGameToken(gameName: currentGameModel!.gameCode);
    if (response.isSuccess()) gameToken = response.model;
    setState(ViewState.Idle);
    if (_flcResponse.model!.flcBalance != null &&
        _flcResponse.model!.flcBalance! >= _playCost!) {
      return true;
    } else {
      earnMoreTokens();
      return false;
    }
  }

  String generateGameUrl() {
    String? _uri = currentGameModel!.gameUri;
    String _loadUri =
        "$_uri?user=${_userService.baseUser!.uid}&name=${_userService.baseUser!.username}&token=$gameToken";
    if (FlavorConfig.isDevelopment()) _loadUri = "$_loadUri&dev=true";
    log("FULL GAME URI: $_loadUri");
    return _loadUri;
  }

  void earnMoreTokens() {
    _analyticsService.track(eventName: AnalyticsEvents.earnMoreTokens);
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
  }

  // refreshLeaderboard() async {
  //   await _lbService!.fetchWebGameLeaderBoard(game: currentGame);
  // }

  setGameDetails(String game) async {
    isGameLoading = true;
    GameModel? gameData = _gamesRepo!.allgames!.firstWhereOrNull(
      (g) => g.gameCode == game,
    );
    if (gameData != null) {
      currentGameModel = gameData;
      return;
    }
    final response = await _gamesRepo!.getGameByCode(gameCode: game);
    if (response.isSuccess()) {
      currentGameModel = response.model;
      isGameLoading = false;
    } else {
      BaseUtil.showNegativeAlert("", response.errorMessage);
    }
  }

  String sortPlayerNumbers(String number) {
    double num = double.parse(number);

    if (num < 1000) {
      return num.toStringAsFixed(0);
    } else {
      num = num / 1000;
      return "${num.toStringAsFixed(1)}K";
    }
  }
}
