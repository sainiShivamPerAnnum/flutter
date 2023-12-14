import 'dart:developer';

import 'package:felloapp/core/model/leaderboard_model.dart';
import 'package:felloapp/core/model/scoreboard_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class LeaderboardService extends ChangeNotifier {
  final CustomLogger _logger = locator<CustomLogger>();
  final GetterRepository _getterRepo = locator<GetterRepository>();
  final UserService _userService = locator<UserService>();
  final DBModel _dbModel = locator<DBModel>();
  final ScrollController ownController = ScrollController();
  final ScrollController parentController = ScrollController();
  final int _referralLBLength = 0;
  final List<String?> _userProfilePicUrl = [];
  bool isUserInTopThree = false;
  bool _isLeaderboardLoading = false;

  get isLeaderboardLoading => _isLeaderboardLoading;

  set isLeaderboardLoading(value) {
    _isLeaderboardLoading = value;
    notifyListeners();
    _logger.d("Leaderboard state notifier updated");
  }

  int currentUserRank = 0;

  List<ScoreBoard>? _referralLeaderBoard = [];

  LeaderboardModel? _WebGameLeaderBoard;
  LeaderboardModel? get WebGameLeaderBoard => _WebGameLeaderBoard;

  List<ScoreBoard>? get referralLeaderBoard => _referralLeaderBoard;

  List<String?> get userProfilePicUrl => _userProfilePicUrl;

  get referralLBLength => _referralLBLength;

  setReferralLeaderBoard() {
    notifyListeners();
    _logger.d("Referral Leaderboard updated, property listeners notified");
  }

  setWebGameLeaderBoard() {
    notifyListeners();
    _logger.d("Web Game leaderboard updated, property listeners notified");
  }

  setUserProfilePicUrl() {
    notifyListeners();
    _logger.d("User profile pic url updated, property listeners notified");
  }

  fetchReferralLeaderBoard() async {
    ApiResponse response = await _getterRepo.getStatisticsByFreqGameTypeAndCode(
      type: "REF-ACTIVE",
      freq: "monthly",
    );

    if (response.code == 200) {
      _referralLeaderBoard!.clear();
      _referralLeaderBoard =
          LeaderboardModel.fromMap(response.model).scoreboard;
      setReferralLeaderBoard();
      _logger.d("Referral Leaderboard successfully fetched");
    }
  }

  // fetchWebGameLeaderBoard({required String? game}) async {
  //   isLeaderboardLoading = true;
  //   ApiResponse response =
  //       await _getterRepo!.getStatisticsByFreqGameTypeAndCode(
  //     type: game,
  //     freq: "weekly",
  //   );
  //   if (response.code == 200 && response.model.isNotEmpty) {
  //     _WebGameLeaderBoard = LeaderboardModel.fromMap(response.model);
  //     setCurrentPlayerRank();

  //     _userProfilePicUrl.clear();

  //     await fetchLeaderBoardProfileImage();

  //     setWebGameLeaderBoard();
  //     _logger!.d("$game Leaderboard successfully fetched");
  //   } else {
  //     _WebGameLeaderBoard = null;
  //   }
  //   isLeaderboardLoading = false;
  // }

  Future getProfileDpWithUid(String? uid) async {
    log("BUILD: get profile picture build called");
    return await _dbModel.getUserDP(uid);
  }

  String getDateRange({bool monthly = false}) {
    var today = DateTime.now();
    var beforeSevenDays = today.subtract(Duration(days: monthly ? 30 : 7));
    DateFormat formatter = DateFormat('MMM');

    int dayToday = today.day;
    String monthToday = formatter.format(today);
    String todayDateToShow = "$dayToday $monthToday";

    int dayOld = beforeSevenDays.day;
    String monthOld = formatter.format(beforeSevenDays);
    String oldDateToShow = "$dayOld $monthOld";

    return "$oldDateToShow - $todayDateToShow";
  }

  fetchLeaderBoardProfileImage() async {
    if (_WebGameLeaderBoard != null) {
      int length = _WebGameLeaderBoard!.scoreboard!.length <= 6
          ? _WebGameLeaderBoard!.scoreboard!.length
          : 6;
      _userProfilePicUrl.clear();
      for (var i = 0; i < length; i++) {
        String? url = await getPlayerProfileImageUrl(
          userId: _WebGameLeaderBoard!.scoreboard![i].userid,
        );
        _userProfilePicUrl.add(url);
      }
    }
  }

  // scrollToUserIndexIfAvaiable() {
  //   _logger!.d("Checking if user is in scoreboard or not");
  //   int? index;
  //   for (int i = 0; i < _WebGameLeaderBoard!.scoreboard!.length; i++) {
  //     if (_WebGameLeaderBoard!.scoreboard![i].username ==
  //         _userService!.baseUser!.username) index = i;
  //   }
  //   if (index != null) {
  //     _logger!.i("user present in scoreboard at position ${index + 1}");
  //     parentController
  //         .animateTo(parentController.position.maxScrollExtent,
  //             duration: Duration(seconds: 1), curve: Curves.easeIn)
  //         .then((value) => ownController.animateTo(
  //             index! * SizeConfig.padding54,
  //             duration: Duration(seconds: 1),
  //             curve: Curves.easeIn));
  //   }
  // }

  void setCurrentPlayerRank() {
    currentUserRank = 0;
    isUserInTopThree = false;
    for (var i = 0; i < WebGameLeaderBoard!.scoreboard!.length; i++) {
      if (WebGameLeaderBoard!.scoreboard![i].userid ==
          _userService.baseUser!.uid) {
        currentUserRank = i + 1;
        break;
      }
    }

    if (currentUserRank <= 3 && currentUserRank > 0) {
      isUserInTopThree = true;
    }
  }

  Future<String?> getPlayerProfileImageUrl({String? userId}) async {
    return await _dbModel.getUserDP(userId);
  }
}
