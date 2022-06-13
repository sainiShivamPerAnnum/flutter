import 'dart:developer';

import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/model/referral_board_modal.dart';
import 'package:felloapp/core/ops/db_ops.dart';
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
  final _dbModel = locator<DBModel>();
  final ScrollController ownController = ScrollController();
  final ScrollController parentController = ScrollController();
  int _referralLBLength = 0;
  List<ReferralBoard> _referralLeaderBoard = [];
  List<String> _userProfilePicUrl = [];
  LeaderBoardModal _WebGameLeaderBoard;
  bool isUserInTopThree = false;
  int currentUserRank = 0;

  LeaderBoardModal get WebGameLeaderBoard => this._WebGameLeaderBoard;

  List<ReferralBoard> get referralLeaderBoard => this._referralLeaderBoard;

  List<String> get userProfilePicUrl => this._userProfilePicUrl;

  get referralLBLength => this._referralLBLength;

  setReferralLeaderBoard() {
    notifyListeners(LeaderBoardServiceProperties.ReferralLeaderboard);
    _logger.d("Referral Leaderboard updated, property listeners notified");
  }

  setWebGameLeaderBoard() {
    notifyListeners(LeaderBoardServiceProperties.WebGameLeaderBoard);
    _logger.d("Web Game leaderboard updated, property listeners notified");
  }

  setUserProfilePicUrl() {
    notifyListeners(LeaderBoardServiceProperties.WebGameLeaderBoard);
    _logger.d("User profile pic url updated, property listeners notified");
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
      _WebGameLeaderBoard = response.model;
      setCurrentPlayerRank();
      setWebGameLeaderBoard();
      _logger.d("$game Leaderboard successfully fetched");
    } else {
      _WebGameLeaderBoard = null;
    }
  }

  fetchLeaderBoardProfileImage() async {
    if (_WebGameLeaderBoard != null) {
      int length = _WebGameLeaderBoard.scoreboard.length <= 6
          ? _WebGameLeaderBoard.scoreboard.length
          : 6;
      _userProfilePicUrl.clear();
      for (var i = 0; i < length; i++) {
        String url = await getPlayerProfileImageUrl(
          userId: _WebGameLeaderBoard.scoreboard[i].userid,
        );
        _userProfilePicUrl.add(url);
      }
    }
  }

  scrollToUserIndexIfAvaiable() {
    _logger.d("Checking if user is in scoreboard or not");
    int index;
    for (int i = 0; i < _WebGameLeaderBoard.scoreboard.length; i++) {
      if (_WebGameLeaderBoard.scoreboard[i].username ==
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

  void setCurrentPlayerRank() {
    currentUserRank = 0;
    isUserInTopThree = false;
    for (var i = 0; i < WebGameLeaderBoard.scoreboard.length; i++) {
      if (WebGameLeaderBoard.scoreboard[i].userid ==
          _userService.baseUser.uid) {
        currentUserRank = i + 1;
        break;
      }
    }

    if (currentUserRank <= 3 && currentUserRank > 0) {
      isUserInTopThree = true;
    }
  }

  Future<String> getPlayerProfileImageUrl({String userId}) async {
    return await _dbModel.getUserDP(userId);
  }
}
