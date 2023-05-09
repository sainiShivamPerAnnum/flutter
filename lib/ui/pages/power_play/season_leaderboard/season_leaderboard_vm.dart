// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/core/model/power_play_models/season_leaderboard_model.dart';
import 'package:felloapp/core/repository/power_play_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class SeasonLeaderboardViewModel extends BaseViewModel {
  final PowerPlayRepository _powerPlayRepo = locator<PowerPlayRepository>();
  final UserService _userService = locator<UserService>();
  bool _isLeaderboardLoading = false;
  bool get isLeaderboardLoading => _isLeaderboardLoading;

  List<SeasonLeaderboardItemModel>? leaderboard;

  set isLeaderboardLoading(bool value) {
    _isLeaderboardLoading = value;
    notifyListeners();
  }

  int currentUserRank = -1;
  bool get isUserInTopThree => currentUserRank < 3;

  void init() {
    getSeasonLeaderboard();
  }

  void dump() {}

  Future<void> getSeasonLeaderboard() async {
    isLeaderboardLoading = true;
    final res = await _powerPlayRepo.getSeasonLeaderboard();
    if (res.isSuccess()) {
      leaderboard = res.model;
      currentUserRank = leaderboard!
          .indexWhere((item) => item.uid == _userService.baseUser!.uid);
    } else {
      leaderboard = [];
    }
    isLeaderboardLoading = false;
  }
}
