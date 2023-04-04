import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/power_play_models/match_winners_leaderboard_item_model.dart';
import 'package:felloapp/core/repository/power_play_repo.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class CompletedMatchDetailsVM extends BaseViewModel {
  final PowerPlayRepository _powerplayrepo = locator<PowerPlayRepository>();
  List<MatchWinnersLeaderboardItemModel> winners = [];
  List userPredictions = [];
  bool _isWinnersLoading = false;
  MatchData? matchData;

  bool get isWinnersLoading => _isWinnersLoading;

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

  Future<void> getUserPredictions() async {}
}
