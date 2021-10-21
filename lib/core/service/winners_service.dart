import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/winners_repo.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class WinnerService extends PropertyChangeNotifier<WinnerServiceProperties> {
  final _logger = locator<Logger>();
  final _winnersRepo = locator<WinnersRepository>();
  WinnersModel _winners;
  get winners => this._winners;

  set winners(value) {
    this._winners = value;
    notifyListeners(WinnerServiceProperties.winLeaderboard);
    _logger.d("Win View leaderboard updated, property listeners notified");
  }

  fetchWinners() async {
    var temp = await _winnersRepo.getWinners("GM_CRIC2020", "weekly");
    if (temp != null) {
      winners = temp.model;
      _logger.d("Winners fetched");
    } else
      BaseUtil.showNegativeAlert(
          "Unable to fetch winners", "try again in sometime");
  }
}
