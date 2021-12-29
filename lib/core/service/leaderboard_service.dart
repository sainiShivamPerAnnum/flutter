import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/model/referral_board_modal.dart';
import 'package:felloapp/core/repository/statistics_repo.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class LeaderboardService
    extends PropertyChangeNotifier<LeaderBoardServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _statsRepo = locator<StatisticsRepository>();
  final _userService = locator<UserService>();
  final ScrollController ownController = ScrollController();
  final ScrollController parentController = ScrollController();

  int _cricketLBLength = 0;
  int _referralLBLength = 0;

  LeaderBoardModal _crickLeaderboard;
  List<ReferralBoard> _referralLeaderBoard = [];

  LeaderBoardModal get cricketLeaderBoard => this._crickLeaderboard;
  List<ReferralBoard> get referralLeaderBoard => this._referralLeaderBoard;

  get cricketLBLength => this._cricketLBLength;

  get referralLBLength => this._referralLBLength;

  setCricketLeaderBoard() {
    notifyListeners(LeaderBoardServiceProperties.CricketLeaderboard);
    _logger.d("Cricket leaderboard updated, property listeners notified");
  }

  setReferralLeaderBoard() {
    notifyListeners(LeaderBoardServiceProperties.ReferralLeaderboard);
    _logger.d("Referral Leaderboard updated, property listeners notified");
  }

  Future fetchCricketLeaderBoard() async {
    ApiResponse<LeaderBoardModal> response =
        await _statsRepo.getLeaderBoard("GM_CRIC2020", "weekly");
    if (response.code == 200) {
      _crickLeaderboard = response.model;
      setCricketLeaderBoard();
      _logger.d("Cricket Leaderboard successfully fetched");
    }
  }

  fetchReferralLeaderBoard() async {
    ApiResponse<ReferralBoardModal> response =
        await _statsRepo.getReferralBoard("REF", "monthly");
    if (response.code == 200) {
      _referralLeaderBoard.clear();
      _referralLeaderBoard = response.model.scoreboard;
      setReferralLeaderBoard();
      _logger.d("Referral Leaderboard successfully fetched");
    }
  }

  scrollToUserIndexIfAvaiable() {
    _logger.d("Checking if user is in scoreboard or not");
    int index;
    for (int i = 0; i < _crickLeaderboard.scoreboard.length; i++) {
      if (_crickLeaderboard.scoreboard[i].username ==
          _userService.baseUser.username) index = i;
    }
    if (index != null) {
      _logger.i("user present in scoreboard at position ${index + 1}");
      parentController
          .animateTo(parentController.position.maxScrollExtent,
              duration: Duration(seconds: 1), curve: Curves.easeIn)
          .then((value) => ownController.animateTo(index * SizeConfig.padding54,
              duration: Duration(seconds: 1), curve: Curves.easeIn));
    }
  }
}
