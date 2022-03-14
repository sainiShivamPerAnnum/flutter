import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/model/referral_board_modal.dart';
import 'package:felloapp/core/repository/statistics_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
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

  int _referralLBLength = 0;

  List<ReferralBoard> _referralLeaderBoard = [];

  LeaderBoardModal _webGameLeaderBoard;
  LeaderBoardModal get webGameLeaderBoard => this._webGameLeaderBoard;

  List<ReferralBoard> get referralLeaderBoard => this._referralLeaderBoard;

  get referralLBLength => this._referralLBLength;

  setReferralLeaderBoard() {
    notifyListeners(LeaderBoardServiceProperties.ReferralLeaderboard);
    _logger.d("Referral Leaderboard updated, property listeners notified");
  }

  setWebGameLeaderBoard() {
    notifyListeners(LeaderBoardServiceProperties.WebGameLeaderBOard);
    _logger.d("Web Game leaderboard updated, property listeners notified");
  }

  fetchReferralLeaderBoard() async {
    ApiResponse<ReferralBoardModal> response =
        await _statsRepo.getReferralBoard("REF-ACTIVE", "monthly");
    if (response.code == 200) {
      _referralLeaderBoard.clear();
      _referralLeaderBoard = response.model.scoreboard;
      setReferralLeaderBoard();
      _logger.d("Referral Leaderboard successfully fetched");
    }
  }

  fetchWebGameLeaderBoard({@required String game}) async {
    ApiResponse<LeaderBoardModal> response =
        await _statsRepo.getLeaderBoard(game, "weekly");
    if (response.code == 200) {
      _webGameLeaderBoard = response.model;
      setWebGameLeaderBoard();
      _logger.d("$game Leaderboard successfully fetched");
    } else {
      _webGameLeaderBoard = null;
    }
  }

  scrollToUserIndexIfAvaiable() {
    _logger.d("Checking if user is in scoreboard or not");
    int index;
    for (int i = 0; i < _webGameLeaderBoard.scoreboard.length; i++) {
      if (_webGameLeaderBoard.scoreboard[i].username ==
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
