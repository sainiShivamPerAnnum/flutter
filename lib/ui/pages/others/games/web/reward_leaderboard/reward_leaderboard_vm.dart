import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/prize_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class RewardLeaderboardViewModel extends BaseViewModel {
  String? _currentGame;
  bool _isPrizesLoading = false;
  PageController? _pageController;
  double _tabPosWidthFactor = SizeConfig.pageHorizontalMargins;
  PrizesModel? _prizes;
  int _tabNo = 0;

  //Getters
  final PrizeService _prizeService = locator<PrizeService>();
  final LeaderboardService? _lbService = locator<LeaderboardService>();
  String? get currentGame => this._currentGame;
  bool get isPrizesLoading => this._isPrizesLoading;
  PrizesModel? get prizes => _prizes;
  PageController? get pageController => _pageController;
  double get tabPosWidthFactor => _tabPosWidthFactor;
  int get tabNo => _tabNo;

  //Setters
  set currentGame(value) {
    this._currentGame = value;
    notifyListeners();
  }

  set isPrizesLoading(value) {
    this._isPrizesLoading = value;
    notifyListeners();
  }

  set prizes(PrizesModel? value) {
    this._prizes = value;
    notifyListeners();
  }

  set tabPosWidthFactor(value) {
    this._tabPosWidthFactor = value;
    notifyListeners();
  }

  set tabNo(value) {
    this._tabNo = value;
    notifyListeners();
  }

  //Super Methods
  init(String game) async {
    currentGame = game;
    print('Opened game: $currentGame');
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      refreshPrizes();
      refreshLeaderboard();
    });
  }

  clear() {
    // _pageController.dispose();
  }

  switchTab(int tab) {
    if (tab == tabNo) return;

    tabPosWidthFactor = tabNo == 0
        ? SizeConfig.screenWidth! / 2 + SizeConfig.pageHorizontalMargins
        : SizeConfig.pageHorizontalMargins;

    _pageController!.animateToPage(
      tab,
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    tabNo = tab;
  }

  refreshPrizes() async {
    isPrizesLoading = true;
    if (!_prizeService.gamePrizeMap.containsKey(currentGame))
      await _prizeService.fetchPrizeByGameType(currentGame!);
    prizes = _prizeService.gamePrizeMap[currentGame];
    isPrizesLoading = false;
    if (prizes == null)
      BaseUtil.showNegativeAlert(
        "Unable to fetch prizes at the moment",
        "Please try again after sometime",
      );
  }

  refreshLeaderboard() async {
    await _lbService!.fetchWebGameLeaderBoard(game: currentGame);
  }
}
