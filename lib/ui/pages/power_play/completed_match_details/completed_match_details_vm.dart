import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/power_play_models/match_winners_leaderboard_item_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/power_play_repo.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class CompletedMatchDetailsVM extends BaseViewModel {
  final PowerPlayRepository _powerplayrepo = locator<PowerPlayRepository>();
  final TransactionHistoryRepository _txnRepo =
      locator<TransactionHistoryRepository>();
  List<MatchWinnersLeaderboardItemModel> winners = [];
  List userPredictions = [];
  bool _isWinnersLoading = false;
  bool _isPredictionsLoading = false;
  MatchData? matchData;
  String winString = "";
  List<UserTransaction>? predictions = [];

  bool get isWinnersLoading => _isWinnersLoading;

  bool get isPredictionsLoading => _isPredictionsLoading;

  set isPredictionsLoading(bool value) {
    _isPredictionsLoading = value;
    notifyListeners();
  }

  set isWinnersLoading(bool value) {
    _isWinnersLoading = value;
    notifyListeners();
  }

  void init(MatchData md) {
    matchData = md;
    getWinnersLeaderboard(md.id!);
    getUserPredictions();
  }

  void dump() {
    winners = [];
    userPredictions = [];
  }

  Future<void> getWinnersLeaderboard(String matchId) async {
    _isWinnersLoading = true;
    final res = await _powerplayrepo.getWinnersLeaderboard(matchId);
    if (res.isSuccess()) {
      winners = res.model!;
    } else {
      winners = [];
    }
    final userIndex = winners.indexWhere(
        (winner) => winner.uid == locator<UserService>().baseUser!.uid);
    if (userIndex != -1) {
      winString = "You ${getWinningString(winners[userIndex])}";
    }
    isWinnersLoading = false;
  }

  String getWinningString(MatchWinnersLeaderboardItemModel item) {
    String wText = "won";
    if (item.amt! > 0) {
      wText += " gold worth ₹${item.amt} ";
    }
    if (item.flc! > 0) {
      wText += " | ${item.flc} tokens ";
    }
    if (item.tt! > 0) {
      wText += " | ${item.tt} tickets";
    }
    return wText;
  }

  Future<void> getUserPredictions() async {
    isPredictionsLoading = true;
    final response = await _txnRepo.getPowerPlayUserTransactions(
        startTime: matchData!.startsAt,
        endTime: matchData!.predictionEndedAt ?? matchData!.endsAt,
        type: 'DEPOSIT',
        status: 'COMPLETE');
    isPredictionsLoading = false;
    if (response.isSuccess()) {
      predictions = response.model!.transactions;
    } else {
      predictions = [];
    }
  }
}
