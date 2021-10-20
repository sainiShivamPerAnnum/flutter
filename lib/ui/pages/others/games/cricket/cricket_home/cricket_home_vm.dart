import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/repository/flc_actions_repo.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_game/cricket_game_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CricketHomeViewModel extends BaseModel {
  final _userService = locator<UserService>();
  final _fclActionRepo = locator<FlcActionsRepo>();
  final _userCoinService = locator<UserCoinService>();
  final _logger = locator<Logger>();

  PageController pageController = new PageController(initialPage: 0);

  int currentPage = 0;
  String _message;
  String _sessionId;

  String get message => _message;
  String get sessionID => _sessionId;

  GameModel gameData = GameModel(
      gameName: "Cricket",
      pageConfig: CricketHomePageConfig,
      tag: 'cricket',
      thumbnailImage:
          "https://www.mpl.live/blog/wp-content/uploads/2020/09/WCC2-mobile-game-becomes-the-worlds-No.1-cricket-game-silently-1.png");
  viewpage(int index) {
    currentPage = index;
    print(currentPage);
    pageController.animateToPage(currentPage,
        duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    refresh();
  }

  init() {
    fetchScoreboard();
  }

  fetchScoreboard() async {}

  startGame() {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: CricketGamePageConfig,
        widget: CricketGameView(
          sessionId: _sessionId,
          userId: _userService.baseUser.uid,
          userName: _userService.baseUser.username,
          stage: FlavorConfig.isDevelopment() ? 'dev' : 'prod',
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
}
