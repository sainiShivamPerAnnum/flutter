import 'package:felloapp/core/enums/leaderboard_service_enum.dart';
import 'package:felloapp/core/model/leaderboard_model.dart';
import 'package:felloapp/core/model/scoreboard_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class LeaderboardService
    extends PropertyChangeNotifier<LeaderBoardServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _getterRepo = locator<GetterRepository>();
  final _userService = locator<UserService>();
  final _dbModel = locator<DBModel>();
  final ScrollController ownController = ScrollController();
  final ScrollController parentController = ScrollController();
  int _referralLBLength = 0;
  List<String> _userProfilePicUrl = [];
  bool isUserInTopThree = false;
  bool _isLeaderboardLoading = false;

  get isLeaderboardLoading => this._isLeaderboardLoading;

  set isLeaderboardLoading(value) {
    this._isLeaderboardLoading = value;
    notifyListeners(LeaderBoardServiceProperties.LeaderBoardState);
    _logger.d("Leaderboard state notifier updated");
  }

  int currentUserRank = 0;

  List<ScoreBoard> _referralLeaderBoard = [];

  LeaderboardModel _WebGameLeaderBoard;
  LeaderboardModel get WebGameLeaderBoard => this._WebGameLeaderBoard;

  List<ScoreBoard> get referralLeaderBoard => this._referralLeaderBoard;

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
    ApiResponse response = await _getterRepo.getStatisticsByFreqGameTypeAndCode(
      type: "REF-ACTIVE",
      freq: "monthly",
    );
    if (response.code == 200) {
      _referralLeaderBoard.clear();
      _referralLeaderBoard =
          LeaderboardModel.fromMap(response.model).scoreboard;
      setReferralLeaderBoard();
      _logger.d("Referral Leaderboard successfully fetched");
    }
  }

  fetchWebGameLeaderBoard({@required String game}) async {
    isLeaderboardLoading = true;
    ApiResponse response = await _getterRepo.getStatisticsByFreqGameTypeAndCode(
      type: game,
      freq: "weekly",
    );
    if (response.code == 200 && response.model.isNotEmpty) {
      _WebGameLeaderBoard = LeaderboardModel.fromMap(response.model);
      setCurrentPlayerRank();

      _userProfilePicUrl.clear();

      await fetchLeaderBoardProfileImage();

      setWebGameLeaderBoard();
      isLeaderboardLoading = false;
      _logger.d("$game Leaderboard successfully fetched");
    } else {
      _WebGameLeaderBoard = null;
    }
  }

  Future getProfileDpWithUid(String uid) async {
    return await _dbModel.getUserDP(uid) ?? "";
  }

  String getDateRange() {
    List<String> months = [
      'Jan',
      'Feb',
      'March',
      'April',
      'May',
      'June',
      'July',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    var today = DateTime.now();
    var beforeSevenDays = today.subtract(Duration(days: 7));

    int dayToday = today.day;
    int monthToday = today.month;
    String todayDateToShow = "$dayToday ${months[monthToday - 1]}";

    int dayOld = beforeSevenDays.day;
    int monthOld = beforeSevenDays.month;
    String oldDateToShow = "$dayOld ${months[monthOld - 1]}";

    return "$oldDateToShow - $todayDateToShow";
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
