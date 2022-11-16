import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/repository/golden_ticket_repo.dart';

import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';

class PrizeService extends ChangeNotifier {
  final GoldenTicketRepository? _gtRepo = locator<GoldenTicketRepository>();
  PrizesModel? _tambolaPrizes;
  PrizesModel? _cricketPrizes;
  PrizesModel? _poolClubPrizes;
  PrizesModel? _footballPrizes;
  PrizesModel? _candyFiestaPrizes;

  PrizesModel? get footballPrizes => this._footballPrizes;

  set footballPrizes(PrizesModel? value) {
    this._footballPrizes = value;
    notifyListeners();
  }

  PrizesModel? get candyFiestaPrizes => this._candyFiestaPrizes;

  set candyFiestaPrizes(PrizesModel? value) {
    this._candyFiestaPrizes = value;
    notifyListeners();
  }

PrizesModel?  get poolClubPrizes => this._poolClubPrizes;

  set poolClubPrizes(PrizesModel?  value) {
    this._poolClubPrizes = value;
    notifyListeners();
  }

 PrizesModel? get tambolaPrizes => this._tambolaPrizes;

  set tambolaPrizes(PrizesModel?  value) {
    this._tambolaPrizes = value;
    notifyListeners();
  }

PrizesModel?  get cricketPrizes => this._cricketPrizes;

  set cricketPrizes( PrizesModel? value) {
    this._cricketPrizes = value;
    notifyListeners();
  }

  fetchFootballPrizes() async {
    await _gtRepo!
        .getPrizesPerGamePerFreq(
      Constants.GAME_TYPE_FOOTBALL,
      "weekly",
    )
        .then((value) {
      footballPrizes = value.model;
    });
  }

  fetchCandyFiestaPrizes() async {
    await _gtRepo!
        .getPrizesPerGamePerFreq(
      Constants.GAME_TYPE_CANDYFIESTA,
      "weekly",
    )
        .then((value) {
      candyFiestaPrizes = value.model;
    });
  }

  fetchTambolaPrizes() async {
    await _gtRepo!
        .getPrizesPerGamePerFreq(
      Constants.GAME_TYPE_TAMBOLA,
      "weekly",
    )
        .then((value) {
      tambolaPrizes = value.model;
    });
  }

  fetchCricketPrizes() async {
    await _gtRepo!
        .getPrizesPerGamePerFreq(
      Constants.GAME_TYPE_CRICKET,
      "weekly",
    )
        .then((value) {
      cricketPrizes = value.model;
    });
  }

  fetchPoolClubPrizes() async {
     await _gtRepo!
        .getPrizesPerGamePerFreq(
      Constants.GAME_TYPE_POOLCLUB,
      "weekly",
    )  .then((value){
      poolClubPrizes = value.model;
    });
  }
}
