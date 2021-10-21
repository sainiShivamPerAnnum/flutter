import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/repository/prizes_repo.dart';
import 'package:felloapp/core/repository/statistics_repo.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';

class PrizeService extends ChangeNotifier {
  final _stats = locator<StatisticsRepository>();
  final _prizeRepo = locator<PrizesRepository>();
  PrizesModel _tambolaPrizes;
  PrizesModel _cricketPrizes;
  get tambolaPrizes => this._tambolaPrizes;

  set tambolaPrizes(value) {
    this._tambolaPrizes = value;
    notifyListeners();
  }

  get cricketPrizes => this._cricketPrizes;

  set cricketPrizes(value) {
    this._cricketPrizes = value;
    notifyListeners();
  }

  fetchTambolaPrizes() async {
    tambolaPrizes =
        await _prizeRepo.getPrizesPerGamePerFreq("GM_TAMBOLA2020", "weekly");
  }

  fetchCricketPrizes() async {
    cricketPrizes =
        await _prizeRepo.getPrizesPerGamePerFreq("GM_CRIC2020", "daily");
  }
}
