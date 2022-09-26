import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/prize_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/games/web/web_game/web_game_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RechargeOption {
  final Color color;
  final int amount;
  final bool isCustom;

  RechargeOption({this.color, this.amount, this.isCustom = false});
}

class WebHomeViewModel extends BaseViewModel {
  //Dependency Injection
  final _userService = locator<UserService>();
  final _lbService = locator<LeaderboardService>();
  final _analyticsService = locator<AnalyticsService>();
  final _prizeService = locator<PrizeService>();
  final _userRepo = locator<UserRepository>();
  final _logger = locator<CustomLogger>();
  final _coinService = locator<UserCoinService>();
  final GameRepo _gamesRepo = locator<GameRepo>();

  //Local Variables

  int currentPage = 0;
  int gameIndex = 0;
  double cardOpacity = 1;
  bool _isPrizesLoading = false;
  bool _isGameLoading = false;
  String _currentGame;
  PageController pageController;
  ScrollController scrollController;
  PrizesModel _prizes;
  String _message;
  String _sessionId;
  String _gameEndpoint;
  String token = "";
  bool _isLoading;
  String gameCode;
  GameModel _currentGameModel;
  List<RechargeOption> rechargeOptions = [
    RechargeOption(
      color: Color(0xff5948B2),
      amount: 100,
    ),
    RechargeOption(
      color: Color(0xff9A3538),
      amount: 200,
    ),
    RechargeOption(
      color: Color(0xff9A3538),
      amount: 500,
    ),
    RechargeOption(
      isCustom: true,
      color: Color(0xff39393C),
      amount: 0,
    )
  ];
  String gameToken;
  int _currentCoinValue;

  //Getters
  String get currentGame => this._currentGame;
  PrizesModel get prizes => _prizes;
  bool get isPrizesLoading => this._isPrizesLoading;
  int get getGameIndex => this.gameIndex;
  String get message => _message;
  String get sessionID => _sessionId;
  get isLoading => this._isLoading;
  GameModel get currentGameModel => _currentGameModel;
  int get currentCoinValue => _currentCoinValue;

  set isLoading(value) {
    this._isLoading = value;
    notifyListeners();
  }

  //Setters
  set currentGame(value) {
    this._currentGame = value;
    notifyListeners();
  }

  set prizes(PrizesModel value) {
    this._prizes = value;
    notifyListeners();
  }

  set currentGameModel(GameModel value) {
    this._currentGameModel = value;
    notifyListeners();
  }

  set isPrizesLoading(value) {
    this._isPrizesLoading = value;
    notifyListeners();
  }

  set isGameLoading(value) {
    this._isGameLoading = value;
    notifyListeners();
  }

  //Super Methods
  init(String game) async {
    currentGame = game;
    isLoading = true;
    // await loadGameLists();
    await fetchGame(game);
    // scrollController = _lbService.parentController;
    // pageController = new PageController(initialPage: 0);
    // refreshPrizes();
    fetchUsersCurrentCoins();
    isLoading = false;
  }

  newInit(String game) async {
    currentGame = game;
  }

  clear() {}

  // refreshPrizes() async {
  //   isPrizesLoading = true;
  //   switch (currentGame) {
  //     case Constants.GAME_TYPE_POOLCLUB:
  //       if (_prizeService.poolClubPrizes == null)
  //         await _prizeService.fetchPoolClubPrizes();
  //       prizes = _prizeService.poolClubPrizes;
  //       gameCode = "PO";

  //       break;
  //     case Constants.GAME_TYPE_CRICKET:
  //       if (_prizeService.cricketPrizes == null)
  //         await _prizeService.fetchCricketPrizes();
  //       prizes = _prizeService.cricketPrizes;
  //       gameCode = "CR";

  //       break;
  //     case Constants.GAME_TYPE_TAMBOLA:
  //       if (_prizeService.tambolaPrizes == null)
  //         await _prizeService.fetchTambolaPrizes();
  //       prizes = _prizeService.tambolaPrizes;
  //       gameCode = "TA";
  //       break;
  //     case Constants.GAME_TYPE_FOOTBALL:
  //       if (_prizeService.footballPrizes == null)
  //         await _prizeService.fetchFootballPrizes();
  //       prizes = _prizeService.footballPrizes;
  //       gameCode = "FO";
  //       break;
  //     case Constants.GAME_TYPE_CANDYFIESTA:
  //       if (_prizeService.candyFiestaPrizes == null)
  //         await _prizeService.fetchCandyFiestaPrizes();
  //       prizes = _prizeService.candyFiestaPrizes;
  //       gameCode = "CA";
  //       break;
  //   }
  //   isPrizesLoading = false;
  //   if (prizes == null)
  //     BaseUtil.showNegativeAlert("Unable to fetch prizes at the moment",
  //         "Please try again after sometime");
  // }

  Future<bool> setupGame() async {
    if (checkIfUserIsBannedFromThisGame()) {
      await getBearerToken();
      return _setupCurrentGame();
    }
    return false;
  }

  Stream<DatabaseEvent> getRealTimePlayingStream(String game) {
    return Api().fetchRealTimePlayingStats(game);
  }

  fetchUsersCurrentCoins() {
    _currentCoinValue = _coinService.flcBalance;
    notifyListeners();
  }

  bool checkIfUserIsBannedFromThisGame() {
    bool isUserBannedForThisGame;
    String userBannedNotice;
    switch (currentGame) {
      case Constants.GAME_TYPE_CRICKET:
        isUserBannedForThisGame =
            _userService.userBootUp.data.banMap.games.cricketMap.isBanned;
        userBannedNotice =
            _userService.userBootUp.data.banMap.games.cricketMap.reason;
        break;
      case Constants.GAME_TYPE_CANDYFIESTA:
        isUserBannedForThisGame =
            _userService.userBootUp.data.banMap.games.candyFiestaMap.isBanned;
        userBannedNotice =
            _userService.userBootUp.data.banMap.games.candyFiestaMap.reason;
        break;
      case Constants.GAME_TYPE_FOOTBALL:
        isUserBannedForThisGame =
            _userService.userBootUp.data.banMap.games.footballMap.isBanned;
        userBannedNotice =
            _userService.userBootUp.data.banMap.games.footballMap.reason;
        break;
      case Constants.GAME_TYPE_POOLCLUB:
        isUserBannedForThisGame =
            _userService.userBootUp.data.banMap.games.poolClubMap.isBanned;
        userBannedNotice =
            _userService.userBootUp.data.banMap.games.poolClubMap.reason;
        break;
    }
    if (isUserBannedForThisGame != null && isUserBannedForThisGame) {
      BaseUtil.showNegativeAlert(
          userBannedNotice ?? "Game locked for security reasons",
          "Please contact us for more details");
      return false;
    }
    return true;
  }

  launchGame() {
    String initialUrl;
    viewpage(1);
    _analyticsService.track(eventName: AnalyticsEvents.gamePlayStarted);
    switch (currentGame) {
      case Constants.GAME_TYPE_POOLCLUB:
        _analyticsService.track(eventName: AnalyticsEvents.poolClubStarts);

        break;
      case Constants.GAME_TYPE_CRICKET:
        _analyticsService.track(
            eventName: AnalyticsEvents.cricketHeroGameStarts);
        break;
      case Constants.GAME_TYPE_FOOTBALL:
        _analyticsService.track(
            eventName: AnalyticsEvents.startPlayingFootball);
        break;
      case Constants.GAME_TYPE_CANDYFIESTA:
        _analyticsService.track(
            eventName: AnalyticsEvents.startPlayingCandyFiesta);
        break;
    }
    initialUrl = generateGameUrl();
    _logger.d("Game Url: $initialUrl");
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: WebGameViewPageConfig,
      widget: WebGameView(
        initialUrl: initialUrl,
        game: currentGame,
        inLandscapeMode:
            currentGame == Constants.GAME_TYPE_POOLCLUB ? true : false,
      ),
    );
  }

  Future<bool> _setupCurrentGame() async {
    setState(ViewState.Busy);
    int _playCost = _currentGameModel.playCost;
    ApiResponse<FlcModel> _flcResponse = await _userRepo.getCoinBalance();
    final response =
        _gamesRepo.getGameToken(gameName: currentGameModel.gameCode);
    if (response.isSuccess()) gameToken = response.model;
    setState(ViewState.Idle);
    if (_flcResponse.model.flcBalance != null &&
        _flcResponse.model.flcBalance >= _playCost)
      return true;
    else {
      return false;
    }
  }

  generateGameUrl() {
    String _uri = currentGameModel.gameUri;
    String _loadUri =
        "$_uri?user=${_userService.baseUser.uid}&name=${_userService.baseUser.username}&token=$gameToken";
    if (FlavorConfig.isDevelopment()) _loadUri = "$_loadUri&dev=true";
    return _loadUri;
  }

  getPromo() {
    switch (currentGame) {
      case Constants.GAME_TYPE_POOLCLUB:
        return null;
      case Constants.GAME_TYPE_CRICKET:
        return BaseRemoteConfig.remoteConfig
            .getString(BaseRemoteConfig.GAME_CRICKET_FPL_ANNOUNCEMENT);
      case Constants.GAME_TYPE_FOOTBALL:
        return null;
      default:
        return null;
    }
  }

  getSubtitle() {
    switch (currentGame) {
      case Constants.GAME_TYPE_POOLCLUB:
        return 'The highest scorers of the week win prizes every Sunday at midnight';
      case Constants.GAME_TYPE_CRICKET:
        return 'The highest scorers of the week win prizes every Sunday at midnight';
      case Constants.GAME_TYPE_FOOTBALL:
        return 'The highest scorers of the week win prizes every Sunday at midnight';
      default:
        return null;
    }
  }

  //Main Methods
  udpateCardOpacity() {
    cardOpacity = (1 -
            (scrollController.offset /
                scrollController.position.maxScrollExtent))
        .clamp(0, 1)
        .toDouble();
    notifyListeners();
  }

  Future<void> getBearerToken() async {
    token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);
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
      isBarrierDismissable: true,
    );
  }

  void viewpage(int index) {
    currentPage = index;
    print(currentPage);
    // pageController.animateToPage(currentPage,
    //     duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    refresh();
  }

  refreshLeaderboard() async {
    await _lbService.fetchWebGameLeaderBoard(game: currentGame);
  }

  fetchGame(String game) async {
    isGameLoading = true;
    final GameModel gameData =
        _gamesRepo.allgames.firstWhere((g) => g.gameCode == game, orElse: null);
    if (gameData != null) {
      currentGameModel = gameData;
      return;
    }
    final response = await _gamesRepo.getGameByCode(gameCode: game);
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
