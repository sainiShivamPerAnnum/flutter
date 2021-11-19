import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/repository/flc_actions_repo.dart';
import 'package:felloapp/core/repository/statistics_repo.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/core/service/prize_service.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_game/cricket_game_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/mixpanel_events.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CricketHomeViewModel extends BaseModel {
  final _userService = locator<UserService>();
  final _fclActionRepo = locator<FlcActionsRepo>();
  final _userCoinService = locator<UserCoinService>();
  final _logger = locator<Logger>();
  final _stats = locator<StatisticsRepository>();
  final _prizeService = locator<PrizeService>();
  final _mixpanelService = locator<MixpanelService>();

  PageController pageController = new PageController(initialPage: 0);

  int currentPage = 0;
  String _message;
  String _sessionId;
  LeaderBoardModal _cricLeaderboard;
  bool isLeaderboardLoading = false;
  bool isPrizesLoading = false;
  ScrollController scrollController = ScrollController();
  double cardOpacity = 1;

  udpateCardOpacity() {
    cardOpacity = (1 -
            (scrollController.offset /
                scrollController.position.maxScrollExtent))
        .clamp(0, 1)
        .toDouble();
    notifyListeners();
  }

  PrizesModel get cPrizes => _prizeService.cricketPrizes;

  String get message => _message;
  String get sessionID => _sessionId;
  LeaderBoardModal get clboard => _cricLeaderboard;

  viewpage(int index) {
    currentPage = index;
    print(currentPage);
    pageController.animateToPage(currentPage,
        duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    refresh();
  }

  init() {
    getLeaderboard();
    if (cPrizes == null) getPrizes();
  }

  startGame() {
    _mixpanelService.track(
        MixpanelEvents.playsCricket, {'userId': _userService.baseUser.uid});
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: CricketGamePageConfig,
        widget: CricketGameView(
          sessionId: _sessionId,
          userId: _userService.baseUser.uid,
          userName: _userService.baseUser.username,
          stage: FlavorConfig.getStage(),
        ));
  }

  Future<bool> openWebView() async {
    setState(ViewState.Busy);
    ApiResponse<FlcModel> _flcResponse = await _fclActionRepo.substractFlc(-10);
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

  getPrizes() async {
    isPrizesLoading = true;
    notifyListeners();
    await _prizeService.fetchCricketPrizes();
    if (cPrizes == null)
      BaseUtil.showNegativeAlert(
          "Prizes failed to update", "Please refresh again");
    isPrizesLoading = false;
    notifyListeners();
  }

  Future<void> getLeaderboard() async {
    isLeaderboardLoading = true;
    notifyListeners();
    var temp = await _stats.getLeaderBoard("GM_CRIC2020", "weekly");
    if (temp != null)
      _cricLeaderboard = temp.model;
    else
      BaseUtil.showNegativeAlert(
          "Leaderboard failed to update", temp.errorMessage);
    isLeaderboardLoading = false;
    notifyListeners();
  }
}
