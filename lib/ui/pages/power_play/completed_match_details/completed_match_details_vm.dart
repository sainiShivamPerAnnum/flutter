import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/power_play_models/match_winners_leaderboard_item_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/power_play_repo.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
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
    isWinnersLoading = false;
  }

  Future<void> getUserPredictions() async {
    isPredictionsLoading = true;
    final response = await _txnRepo.getPowerPlayUserTransactions(
        startTime: matchData!.startsAt,
        endTime: matchData!.endsAt,
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
