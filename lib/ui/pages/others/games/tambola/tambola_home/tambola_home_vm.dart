import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/repository/statistics_repo.dart';
import 'package:felloapp/core/service/prize_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/custom_logger.dart';

class TambolaHomeViewModel extends BaseModel {
  final _stats = locator<StatisticsRepository>();
  final _prizeService = locator<PrizeService>();
  final _logger = locator<CustomLogger>();

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
        (scrollController.offset / scrollController.position.maxScrollExtent)
            .clamp(0, 1)
            .toDouble();
    notifyListeners();
  }

  LeaderBoardModal get tlboard => _tLeaderBoard;
  PrizesModel get tPrizes => _prizeService.tambolaPrizes;

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
    if (temp.model != null) _tLeaderBoard = temp.model;
    // else
    //   BaseUtil.showNegativeAlert(
    //       "Leaderboard failed to update", temp.errorMessage);
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
