import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/repository/statistics_repo.dart';
import 'package:felloapp/core/service/prize_service.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class TambolaHomeViewModel extends BaseModel {
  final _stats = locator<StatisticsRepository>();
  final _prizeService = locator<PrizeService>();
  final _logger = locator<Logger>();

  bool isLeaderboardLoading = false;
  bool isPrizesLoading = false;
  int currentPage = 0;
  PageController pageController = new PageController(initialPage: 0);
  LeaderBoardModal _tLeaderBoard;
  ScrollController scrollController;
  double cardOpacity = 1;

  Map<String, IconData> tambolaOdds = {
    "Full House": Icons.apps,
    "Top Row": Icons.border_top,
    "Middle Row": Icons.border_horizontal,
    "Bottom Row": Icons.border_bottom,
    "Corners": Icons.border_outer
  };

  udpateCardOpacity() {
    cardOpacity = 1 -
        (scrollController.offset / scrollController.position.maxScrollExtent);
    notifyListeners();
  }

  LeaderBoardModal get tlboard => _tLeaderBoard;
  PrizesModel get tPrizes => _prizeService.tambolaPrizes;

  GameModel gameData = GameModel(
      gameName: "Tambola",
      pageConfig: THomePageConfig,
      tag: 'tambola',
      thumbnailImage:
          "https://store-images.s-microsoft.com/image/apps.7421.14526104391731353.3efa198c-600d-47e2-a495-171846e34e31.74622fdc-08ff-434d-9cec-a4b5266dc24c?mode=scale&q=90&h=1080&w=1920");
  viewpage(int index) {
    currentPage = index;
    print(currentPage);
    pageController.animateToPage(currentPage,
        duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    refresh();
  }

  init() {
    getLeaderboard();
    if (tPrizes == null) getPrizes();
  }

  Future<void> getLeaderboard() async {
    isLeaderboardLoading = true;
    notifyListeners();
    ApiResponse temp = await _stats.getLeaderBoard("GM_TAMBOLA2020", "weekly");
    _logger.d(temp.code);
    if (temp.model != null)
      _tLeaderBoard = temp.model;
    else
      BaseUtil.showNegativeAlert(
          "Leaderboard failed to update", temp.errorMessage);
    isLeaderboardLoading = false;
    notifyListeners();
  }

  Future<void> getPrizes() async {
    isPrizesLoading = true;
    notifyListeners();
    await _prizeService.fetchTambolaPrizes();
    if (tPrizes == null)
      BaseUtil.showNegativeAlert(
          "Prizesd failed to update", "Please refresh again");
    isPrizesLoading = false;
    notifyListeners();
  }

  openGame() {
    BaseUtil().openTambolaHome();
  }
}
