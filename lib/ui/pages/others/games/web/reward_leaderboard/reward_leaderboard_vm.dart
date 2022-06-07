import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/service/notifier_services/leaderboard_service.dart';
import 'package:felloapp/core/service/notifier_services/prize_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class RewardLeaderboardViewModel extends BaseModel {
  String _currentGame;
  bool _isPrizesLoading = false, _isLeaderboardLoading = false;

  PrizesModel _prizes;

  final _prizeService = locator<PrizeService>();
  final _lbService = locator<LeaderboardService>();
  String get currentGame => this._currentGame;
  bool get isPrizesLoading => this._isPrizesLoading;
  bool get isLeaderboardLoading => this._isLeaderboardLoading;

  PrizesModel get prizes => _prizes;

  //Setters
  set currentGame(value) {
    this._currentGame = value;
    notifyListeners();
  }

  set isPrizesLoading(value) {
    this._isPrizesLoading = value;
    notifyListeners();
  }

  set isLeaderboardLoading(value) {
    this._isLeaderboardLoading = value;
    notifyListeners();
  }

  set prizes(PrizesModel value) {
    this._prizes = value;
    notifyListeners();
  }

  //Super Methods
  init(String game) async {
    currentGame = game;
    print(currentGame);
    refreshPrizes();
    refreshLeaderboard();
  }

  clear() {}

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
      case Constants.GAME_TYPE_FOOTBALL:
        if (_prizeService.footballPrizes == null)
          await _prizeService.fetchFootballPrizes();
        prizes = _prizeService.footballPrizes;

        break;
      case Constants.GAME_TYPE_CANDYFIESTA:
        if (_prizeService.candyFiestaPrizes == null)
          await _prizeService.fetchCandyFiestaPrizes();
        prizes = _prizeService.candyFiestaPrizes;

        break;
    }
    isPrizesLoading = false;
    if (prizes == null)
      BaseUtil.showNegativeAlert(
        "Unable to fetch prizes at the moment",
        "Please try again after sometime",
      );
  }

  refreshLeaderboard() async {
    isLeaderboardLoading = true;
    await _lbService.fetchWebGameLeaderBoard(game: currentGame);
    await _lbService.fetchLeaderBoardProfileImage();
    isLeaderboardLoading = false;
  }
}
