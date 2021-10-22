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

  get winners => this._winners;
  get cricketWinnersLength => this._cricketWinnersLength;
  get tambolaWinnersLength => this._tambolaWinnersLength;
  get timeStamp => _timestamp;

  setWinners() {
    notifyListeners(WinnerServiceProperties.winLeaderboard);
    _logger.d("Win View leaderboard updated, property listeners notified");
  }

  fetchWinners() async {
    _winners.clear();
    ApiResponse<WinnersModel> _cricketWinners =
        await _winnersRepo.getWinners(Constants.GAME_TYPE_CRICKET, "weekly");

    ApiResponse<WinnersModel> _tambolaWinners =
        await _winnersRepo.getWinners(Constants.GAME_TYPE_TAMBOLA, "weekly");

    _winners.clear();

    if (_cricketWinners.model?.winners?.length != 0) {
      _timestamp = _cricketWinners.model?.timestamp;
      _cricketWinnersLength = _cricketWinners.model?.winners?.length;
      _winners.addAll(_cricketWinners.model.winners);
      _logger.d(_cricketWinners.model.winners.toString());
      _logger.d("Cricket Winners added to leaderboard");
    }

    if (_tambolaWinners.model?.winners?.length != 0) {
      _timestamp = _cricketWinners.model.timestamp;
      _tambolaWinnersLength = _tambolaWinners.model?.winners?.length;
      _winners.addAll(_tambolaWinners.model.winners);
      _logger.d("Tambola Winners added to leaderboard");
    }

    if (_tambolaWinners.model?.winners?.length == 0 &&
        _cricketWinners.model?.winners?.length == 0) {
      BaseUtil.showNegativeAlert(
          "Unable to fetch winners", "try again in sometime");
    }

    if (_winners != null) {
      _winners.sort((a, b) => a.score.compareTo(b.score));
      setWinners();
    }
  }
}
