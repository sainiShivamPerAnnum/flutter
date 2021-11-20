import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/winners_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class WinnerService extends PropertyChangeNotifier<WinnerServiceProperties> {
  final _logger = locator<Logger>();
  final _winnersRepo = locator<WinnersRepository>();

  int _cricketWinnersLength = 0;
  int _tambolaWinnersLength = 0;
  Timestamp _timestamp;

  List<Winners> _winners = [];
  List<String> _topWinners = [];

  List<Winners> get winners => this._winners;
  List<String> get topWinners => this._topWinners;

  get cricketWinnersLength => this._cricketWinnersLength;

  get tambolaWinnersLength => this._tambolaWinnersLength;

  get timeStamp => _timestamp;

  setWinners() {
    notifyListeners(WinnerServiceProperties.winLeaderboard);
    _logger.d("Win View leaderboard updated, property listeners notified");
  }

  setTopWinners() {
    notifyListeners(WinnerServiceProperties.topWinners);
    _logger.d("Top Winners updated, property listeners notified");
  }

  fetchTopWinner() async {
    ApiResponse<List<String>> response = await _winnersRepo.getTopWinners();
    if (response.code == 200) {
      _topWinners.clear();
      _topWinners = response.model;
      setTopWinners();
      _logger.d("Top winners successfully fetched");
    }
  }

  fetchWinners() async {
    _winners.clear();
    ApiResponse<WinnersModel> _cricketWinners =
        await _winnersRepo.getWinners(Constants.GAME_TYPE_CRICKET, "weekly");

    ApiResponse<WinnersModel> _tambolaWinners =
        await _winnersRepo.getWinners(Constants.GAME_TYPE_TAMBOLA, "weekly");

    _winners.clear();

    if (_cricketWinners != null &&
        _cricketWinners.model != null &&
        _cricketWinners.model.winners != null &&
        _cricketWinners.model?.winners?.length != 0) {
      _timestamp = _cricketWinners.model?.timestamp;
      _cricketWinnersLength = _cricketWinners.model?.winners?.length;
      _winners.addAll(_cricketWinners.model.winners);
      _logger.d(_cricketWinners.model.winners.toString());
      _logger.d("Cricket Winners added to leaderboard");
    } else {
      _logger.i("Cricket Winners not added to leaderboard");
    }

    if (_tambolaWinners != null &&
        _tambolaWinners.model != null &&
        _tambolaWinners.model.winners != null &&
        _tambolaWinners.model?.winners?.length != 0) {
      _timestamp = _tambolaWinners.model.timestamp;
      _tambolaWinnersLength = _tambolaWinners.model?.winners?.length;
      _winners.addAll(_tambolaWinners.model.winners);
      _logger.d("Tambola Winners added to leaderboard");
    } else {
      _logger.i("Tambola Winners not added to leaderboard");
    }

    if (_tambolaWinners.model?.winners?.length == 0 &&
        _cricketWinners.model?.winners?.length == 0) {
      BaseUtil.showNegativeAlert(
          "Unable to fetch winners", "try again in sometime");
    }

    if (_winners != null)
      _winners.sort((a, b) => (a.amount == null || b.amount == null)
          ? -1
          : b.amount.compareTo(a.amount));
    else
      _winners = [];

    setWinners();
  }
}
