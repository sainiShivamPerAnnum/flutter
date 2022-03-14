import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/repository/flc_actions_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
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
import 'package:flutter/material.dart';

class WebHomeViewModel extends BaseModel {
  //Dependency Injection
  final _userService = locator<UserService>();
  final _lbService = locator<LeaderboardService>();
  final _analyticsService = locator<AnalyticsService>();
  final _prizeService = locator<PrizeService>();
  final _fclActionRepo = locator<FlcActionsRepo>();
  final _userCoinService = locator<UserCoinService>();
  final _logger = locator<CustomLogger>();

  //Local Variables

  int currentPage = 0;
  int gameIndex = 0;
  double cardOpacity = 1;
  bool _isPrizesLoading = false;
  String _currentGame;
  PageController pageController;
  ScrollController scrollController;
  PrizesModel _prizes;
  String _message;
  String _sessionId;

  //Getters
  String get currentGame => this._currentGame;
  PrizesModel get prizes => _prizes;
  bool get isPrizesLoading => this._isPrizesLoading;
  int get getGameIndex => this.gameIndex;
  String get message => _message;
  String get sessionID => _sessionId;

  //Setters
  set currentGame(value) {
    this._currentGame = value;
    notifyListeners();
  }

  set prizes(PrizesModel value) {
    this._prizes = value;
    notifyListeners();
  }

  set isPrizesLoading(value) {
    this._isPrizesLoading = value;
    notifyListeners();
  }

  //Super Methods
  init(String game) async {
    currentGame = game;
    scrollController = _lbService.parentController;
    pageController = new PageController(initialPage: 0);
    setGameIndex();
    refreshPrizes();
    refreshLeaderboard();
  }

  clear() {
    cleanUpWebHomeView();
  }

  //Conditional Main Methods

  setGameIndex() {
    switch (currentGame) {
      case Constants.GAME_TYPE_CRICKET:
        gameIndex = 0;
        break;
      case Constants.GAME_TYPE_POOLCLUB:
        gameIndex = 1;
        break;
      case Constants.GAME_TYPE_TAMBOLA:
        gameIndex = 2;
        break;
    }
    this.gameIndex = gameIndex;
    notifyListeners();
  }

  setUpWebHomeView() {
    switch (currentGame) {
      case Constants.GAME_TYPE_POOLCLUB:
        break;
      case Constants.GAME_TYPE_CRICKET:
        break;
      default:
        return;
    }
  }

  cleanUpWebHomeView() {
    switch (currentGame) {
      case Constants.GAME_TYPE_POOLCLUB:
        break;
      case Constants.GAME_TYPE_CRICKET:
        break;
      default:
        return;
    }
  }

  refreshPrizes() async {
    isPrizesLoading = true;
    switch (currentGame) {
      case Constants.GAME_TYPE_POOLCLUB:
        if (_prizeService.poolClubPrizes == null)
          await _prizeService.fetchPoolClubPrizes();
        prizes = _prizeService.poolClubPrizes;

        break;
      case Constants.GAME_TYPE_CRICKET:
        if (_prizeService.cricketPrizes == null)
          await _prizeService.fetchCricketPrizes();
        prizes = _prizeService.cricketPrizes;

        break;
      case Constants.GAME_TYPE_TAMBOLA:
        if (_prizeService.tambolaPrizes == null)
          await _prizeService.fetchTambolaPrizes();
        prizes = _prizeService.tambolaPrizes;

        break;
    }
    isPrizesLoading = false;
    if (prizes == null)
      BaseUtil.showNegativeAlert("Unable to fetch prizes at the moment",
          "Please try again after sometime");
  }

  Future<bool> setupGame() async {
    switch (currentGame) {
      case Constants.GAME_TYPE_POOLCLUB:
        return _setupPoolClubGame();
        break;
      case Constants.GAME_TYPE_CRICKET:
        return _setupCricketGame();
        break;
      default:
        return false;
    }
  }

  launchGame() async {
    _analyticsService.track(eventName: AnalyticsEvents.startPlayingCricket);
    String initialUrl;
    viewpage(1);
    switch (currentGame) {
      case Constants.GAME_TYPE_POOLCLUB:
        initialUrl = _generatePoolClubGameUrl();
        break;
      case Constants.GAME_TYPE_CRICKET:
        initialUrl = _generateCricketGameUrl();
        break;
    }
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: WebGameViewPageConfig,
      widget: WebGameView(
        initialUrl: initialUrl,
        game: currentGame,
      ),
    );
  }

  //Cricket Methods -------------------------------------START----------------//
  Future<bool> _setupCricketGame() async {
    setState(ViewState.Busy);
    String _cricPlayCost = BaseRemoteConfig.remoteConfig
            .getString(BaseRemoteConfig.CRICKET_PLAY_COST) ??
        "10";
    int _cost = -1 * int.tryParse(_cricPlayCost) ?? 10;
    ApiResponse<FlcModel> _flcResponse =
        await _fclActionRepo.substractFlc(_cost);
    _message = _flcResponse.model.message;
    if (_flcResponse.model.flcBalance != null) {
      _userCoinService.setFlcBalance(_flcResponse.model.flcBalance);
    } else {
      _logger.d("Flc balance is null");
    }

    if (_flcResponse.model.sessionId != null) {
      _sessionId = _flcResponse.model.sessionId;
    } else {
      _logger.d("sessionId null");
    }

    if (_flcResponse.model.canUserPlay) {
      setState(ViewState.Idle);
      return true;
    } else {
      setState(ViewState.Idle);
      return false;
    }
  }

  String _generateCricketGameUrl() {
    return '${Constants.GAME_CRICKET_URI}?userId=${_userService.baseUser.uid}&userName=${_userService.baseUser.username}&sessionId=$_sessionId&stage=${FlavorConfig.getStage()}&gameId=cric2020';
  }

  //Cricket Methods -----------------------------------END--------------------//

  //PoolClub Methods --------------------------------START--------------------//
  Future<bool> _setupPoolClubGame() async {
    return true;
  }

  String _generatePoolClubGameUrl() {
    return "https://d2qfyj2eqvh06a.cloudfront.net/pool-club/index.html?user=${_userService.baseUser.uid}&name=${_userService.baseUser.username}";
  }

  //PoolClub Methods -----------------------------------END-------------------//

  //Main Methods
  udpateCardOpacity() {
    cardOpacity = (1 -
            (scrollController.offset /
                scrollController.position.maxScrollExtent))
        .clamp(0, 1)
        .toDouble();
    notifyListeners();
  }

  void earnMoreTokens() {
    _analyticsService.track(eventName: AnalyticsEvents.earnMoreTokens);
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      content: WantMoreTicketsModalSheet(
        isInsufficientBalance: true,
      ),
      hapticVibrate: true,
      backgroundColor: Colors.transparent,
      isBarrierDismissable: true,
    );
  }

  void viewpage(int index) {
    currentPage = index;
    print(currentPage);
    pageController.animateToPage(currentPage,
        duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    refresh();
  }

  refreshLeaderboard() async {
    await _lbService.fetchWebGameLeaderBoard(game: currentGame);
  }
}
