import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/repository/prizes_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';

class PrizeService extends ChangeNotifier {
  final _prizeRepo = locator<PrizesRepository>();
  PrizesModel _tambolaPrizes;
  PrizesModel _cricketPrizes;
  PrizesModel _poolClubPrizes;
  PrizesModel _footballPrizes;
  PrizesModel _candyFiestaPrizes;

  get footballPrizes => this._footballPrizes;

  set footballPrizes(ApiResponse<PrizesModel> value) {
    this._footballPrizes = value.model;
    notifyListeners();
  }

  get candyFiestaPrizes => this._candyFiestaPrizes;

  set candyFiestaPrizes(ApiResponse<PrizesModel> value) {
    this._candyFiestaPrizes = value.model;
    notifyListeners();
  }

  get poolClubPrizes => this._poolClubPrizes;

  set poolClubPrizes(ApiResponse<PrizesModel> value) {
    this._poolClubPrizes = value.model;
    notifyListeners();
  }

  get tambolaPrizes => this._tambolaPrizes;

  set tambolaPrizes(ApiResponse<PrizesModel> value) {
    this._tambolaPrizes = value.model;
    notifyListeners();
  }

  get cricketPrizes => this._cricketPrizes;

  set cricketPrizes(ApiResponse<PrizesModel> value) {
    this._cricketPrizes = value.model;
    notifyListeners();
  }

  fetchFootballPrizes() async {
    footballPrizes = await _prizeRepo.getPrizesPerGamePerFreq(
        Constants.GAME_TYPE_FOOTBALL, "weekly");
  }

  fetchCandyFiestaPrizes() async {
    candyFiestaPrizes = await _prizeRepo.getPrizesPerGamePerFreq(
        Constants.GAME_TYPE_CANDYFIESTA, "weekly");
  }

  fetchTambolaPrizes() async {
    tambolaPrizes = await _prizeRepo.getPrizesPerGamePerFreq(
        Constants.GAME_TYPE_TAMBOLA, "weekly");
  }

  fetchCricketPrizes() async {
    cricketPrizes = await _prizeRepo.getPrizesPerGamePerFreq(
        Constants.GAME_TYPE_CRICKET, "weekly");
  }

  fetchPoolClubPrizes() async {
    poolClubPrizes = await _prizeRepo.getPrizesPerGamePerFreq(
        Constants.GAME_TYPE_POOLCLUB, "weekly");
  }
}
