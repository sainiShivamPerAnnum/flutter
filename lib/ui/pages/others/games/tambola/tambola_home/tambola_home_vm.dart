import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/leaderboard_model.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/prize_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/custom_logger.dart';

class TambolaHomeViewModel extends BaseModel {
  final _getterRepo = locator<GetterRepository>();
  final _prizeService = locator<PrizeService>();
  final _baseUtil = locator<BaseUtil>();
  final _logger = locator<CustomLogger>();
  final _analyticsService = locator<AnalyticsService>();
  final GameRepo _gamesRepo = locator<GameRepo>();
  final WinnerService _winnerService = locator<WinnerService>();
  final _dbModel = locator<DBModel>();

  bool isLeaderboardLoading = false;
  bool isPrizesLoading = false;
  int currentPage = 0;
  PageController pageController = new PageController(initialPage: 0);
  LeaderboardModel _tLeaderBoard;
  ScrollController scrollController;
  double cardOpacity = 1;
  GameModel game;
  List<Winners> _winners = [];
  bool _showBuyModal = true;

  //Constant values
  Map<String, IconData> tambolaOdds = {
    "Full House": Icons.apps,
    "Top Row": Icons.border_top,
    "Middle Row": Icons.border_horizontal,
    "Bottom Row": Icons.border_bottom,
    "Corners": Icons.border_outer
  };

  List<IconData> leadingIconList = [
    Icons.apps,
    Icons.border_top,
    Icons.border_horizontal,
    Icons.border_bottom,
    Icons.border_outer
  ];
  String boxHeading = "How to Play";

  List<String> boxTitlles = [
    "Your ticket comprises of 15 randomly placed numbers, refreshed every Monday",
    "3 random numbers are picked everyday from 1 to 90 at 6 pm.",
    "Numbers that match your ticket gets automatically crossed out.",
  ];
  List<String> boxAssets = [
    Assets.howToPlayAsset1Tambola,
    Assets.howToPlayAsset2Tambola,
    Assets.howToPlayAsset3Tambola,
  ];

  udpateCardOpacity() {
    cardOpacity = 1 -
        (scrollController.offset / scrollController.position.maxScrollExtent)
            .clamp(0, 1)
            .toDouble();
    notifyListeners();
  }

  LeaderboardModel get tlboard => _tLeaderBoard;
  PrizesModel get tPrizes => _prizeService.tambolaPrizes;
  List<Winners> get winners => _winners;
  get showBuyModal => _showBuyModal;

  set showBuyModal(value) {
    _showBuyModal = value;
    notifyListeners();
  }

  viewpage(int index) {
    currentPage = index;
    print(currentPage);
    pageController.animateToPage(currentPage,
        duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    refresh();
  }

  init() async {
    setState(ViewState.Busy);
    await getGameDetails();
    getLeaderboard();

    fetchWinners();
    if (tPrizes == null) getPrizes();
    setState(ViewState.Idle);
  }

  fetchWinners() async {
    _winnerService.fetchtambolaWinners();
    _winners = _winnerService.winners;

    notifyListeners();
  }

  Future getProfileDpWithUid(String uid) async {
    return await _dbModel.getUserDP(uid) ?? "";
  }

  Future<void> getLeaderboard() async {
    isLeaderboardLoading = true;
    notifyListeners();

    log("GM_TAMBOLA2020");
    ApiResponse temp = await _getterRepo.getStatisticsByFreqGameTypeAndCode(
      type: "GM_TAMBOLA2020",
      freq: "weekly",
    );
    _logger.d(temp.code);
    if (temp.model != null && temp.model.isNotEmpty) _tLeaderBoard = temp.model;
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
      BaseUtil.showNegativeAlert("This week's prizes could not be fetched",
          "Please try again in sometime");
    isPrizesLoading = false;
    notifyListeners();
  }

  void openGame() {
    _analyticsService.track(eventName: AnalyticsEvents.startPlayingTambola);
    // _baseUtil.cacheGameorder('TA');
    BaseUtil().openTambolaGame();
  }

  getGameDetails() async {
    final response =
        await _gamesRepo.getGameByCode(gameCode: Constants.GAME_TYPE_TAMBOLA);
    if (response.isSuccess()) {
      game = response.model;
    }
  }
}
