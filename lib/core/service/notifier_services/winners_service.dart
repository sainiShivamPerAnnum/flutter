import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/api_cache_manager.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

import '../../ops/db_ops.dart';

class WinnerService extends PropertyChangeNotifier<WinnerServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _apiCacheManager = locator<ApiCacheManager>();
  final _getterRepo = locator<GetterRepository>();
  final _dbModel = locator<DBModel>();

  int _cricketWinnersLength = 0;
  int _tambolaWinnersLength = 0;
  int _poolClubWinnersLength = 0;
  int _footBallWinnersLength = 0;
  int _candyFiestaWinnersLength = 0;
  Timestamp _timestamp;

  List<Winners> _winners = [];
  List<String> _topWinners = [];
  List<String> _bugBountyWinners = [];
  List<String> _newFelloWinners = [];
  get bugBountyWinners => this._bugBountyWinners;
  get newFelloWinners => this._newFelloWinners;
  List<Winners> get winners => this._winners;
  List<String> get topWinners => this._topWinners;

  get cricketWinnersLength => this._cricketWinnersLength;

  get tambolaWinnersLength => this._tambolaWinnersLength;

  get poolClubWinnersLength => this._poolClubWinnersLength;

  get footBallWinnersLength => this._footBallWinnersLength;

  get candyFiestaWinnersLength => this._candyFiestaWinnersLength;

  get timeStamp => _timestamp;

  setWinners() {
    notifyListeners(WinnerServiceProperties.winLeaderboard);
    _logger.d("Win View leaderboard updated, property listeners notified");
  }

  setTopWinners() {
    notifyListeners(WinnerServiceProperties.topWinners);
    _logger.d("Top Winners updated, property listeners notified");
  }

  setBugBountyWinners() {
    notifyListeners(WinnerServiceProperties.bugBounty);
    _logger.d(
        "Top Winners of Bug Bounty Campaign updated, property listeners notified");
  }

  setNewFelloWinners() {
    notifyListeners(WinnerServiceProperties.newFello);
    _logger.d(
        "Top Winners of New Fello App Campaign updated, property listeners notified");
  }

  Future getProfileDpWithUid(String uid) async {
    return await _dbModel.getUserDP(uid);
  }

  String getDateRange() {
    var today = DateTime.now();
    var beforeSevenDays = today.subtract(Duration(days: 7));
    DateFormat formatter = DateFormat('MMM');

    int dayToday = today.day;
    String monthToday = formatter.format(today);
    String todayDateToShow = "$dayToday $monthToday";

    int dayOld = beforeSevenDays.day;
    String monthOld = formatter.format(beforeSevenDays);
    String oldDateToShow = "$dayOld $monthOld";

    return "$oldDateToShow - $todayDateToShow";
  }

  fetchBugBountyWinners() async {
    _bugBountyWinners = [
      "madmaen won ₹5000 for Pool bug",
      "kaiser won ₹5000 for Cricket Bug"
    ];
    setBugBountyWinners();
    _logger.d("Bug Bounty Winners successfully fetched");
  }

  fetchNewFelloWinners() async {
    _newFelloWinners = [
      "Godon won ₹5000 for reviewing new Fello",
      "buckminister won ₹5000 for reviewing Save Screen"
    ];
    setNewFelloWinners();
    _logger.d("New Fello winners successfully fetched");
  }

  fetchtambolaWinners() async {
    _winners.clear();
    WinnersModel _tambolaWinners = await getWinners(
      Constants.GAME_TYPE_TAMBOLA,
      "weekly",
    );

    if (_tambolaWinners != null &&
        _tambolaWinners.winners != null &&
        _tambolaWinners?.winners?.length != 0) {
      _timestamp = _tambolaWinners.timestamp;
      _tambolaWinnersLength = _tambolaWinners?.winners?.length;
      _winners.addAll(_tambolaWinners.winners);
      _logger.d("Only Tambola Winners added to leaderboard");
    } else {
      _logger.i("Tambola Winners not added to leaderboard");
    }

    if (_winners != null)
      _winners.sort((a, b) => (a.amount == null || b.amount == null)
          ? -1
          : b.amount.compareTo(a.amount));
    else
      _winners = [];

    setWinners();
  }

  fetchWinners() async {
    _winners.clear();
    WinnersModel _cricketWinners = await getWinners(
      Constants.GAME_TYPE_CRICKET,
      "weekly",
    );

    WinnersModel _tambolaWinners = await getWinners(
      Constants.GAME_TYPE_TAMBOLA,
      "weekly",
    );

    WinnersModel _poolClubWinners = await getWinners(
      Constants.GAME_TYPE_POOLCLUB,
      "weekly",
    );

    WinnersModel _footBallWinners = await getWinners(
      Constants.GAME_TYPE_FOOTBALL,
      "weekly",
    );

    WinnersModel _candyFiestaWinners = await getWinners(
      Constants.GAME_TYPE_CANDYFIESTA,
      "weekly",
    );

    _winners.clear();

    if (_cricketWinners != null &&
        _cricketWinners.winners != null &&
        _cricketWinners?.winners?.length != 0) {
      _timestamp = _cricketWinners?.timestamp;
      _cricketWinnersLength = _cricketWinners?.winners?.length;
      _winners.addAll(_cricketWinners.winners);
      _logger.d(_cricketWinners.winners.toString());
      _logger.d("Cricket Winners added to leaderboard");
    } else {
      _logger.i("Cricket Winners not added to leaderboard");
    }

    if (_tambolaWinners != null &&
        _tambolaWinners.winners != null &&
        _tambolaWinners?.winners?.length != 0) {
      _timestamp = _tambolaWinners.timestamp;
      _tambolaWinnersLength = _tambolaWinners?.winners?.length;
      _winners.addAll(_tambolaWinners.winners);
      _logger.d("Tambola Winners added to leaderboard");
    } else {
      _logger.i("Tambola Winners not added to leaderboard");
    }

    if (_poolClubWinners != null &&
        _poolClubWinners.winners != null &&
        _poolClubWinners?.winners?.length != 0) {
      _timestamp = _poolClubWinners?.timestamp;
      _poolClubWinnersLength = _poolClubWinners?.winners?.length;
      _winners.addAll(_poolClubWinners.winners);
      _logger.d(_poolClubWinners.winners.toString());
      _logger.d("PoolClub Winners added to leaderboard");
    } else {
      _logger.i("PoolClub Winners not added to leaderboard");
    }

    if (_footBallWinners != null &&
        _footBallWinners.winners != null &&
        _footBallWinners?.winners?.length != 0) {
      _timestamp = _footBallWinners?.timestamp;
      _footBallWinnersLength = _footBallWinners?.winners?.length;
      _winners.addAll(_footBallWinners.winners);
      _logger.d(_footBallWinners.winners.toString());
      _logger.d("FootBall Winners added to leaderboard");
    } else {
      _logger.i("FootBall Winners not added to leaderboard");
    }

    if (_candyFiestaWinners != null &&
        _candyFiestaWinners.winners != null &&
        _candyFiestaWinners?.winners?.length != 0) {
      _timestamp = _candyFiestaWinners?.timestamp;
      _candyFiestaWinnersLength = _candyFiestaWinners?.winners?.length;
      _winners.addAll(_candyFiestaWinners.winners);
      _logger.d(_candyFiestaWinners.winners.toString());
      _logger.d("CandyFiesta Winners added to leaderboard");
    } else {
      _logger.i("CandyFiesta Winners not added to leaderboard");
    }

    if (_tambolaWinners?.winners?.length == 0 &&
        _cricketWinners?.winners?.length == 0 &&
        _poolClubWinners?.winners?.length == 0 &&
        _footBallWinners?.winners?.length == 0) {
      // BaseUtil.showNegativeAlert(
      //     "Unable to fetch winners", "try again in sometime");
    }

    if (_winners != null)
      _winners.sort((a, b) => (a.amount == null || b.amount == null)
          ? -1
          : b.amount.compareTo(a.amount));
    else
      _winners = [];

    setWinners();
  }

  Future<WinnersModel> getWinners(
    String gameType,
    String freq,
  ) async {
    _logger.d("Winner Game Type : $gameType \n Frequency: $freq");

    final ApiResponse response = await _getterRepo.getWinnerByFreqGameType(
      type: gameType,
      freq: freq,
    );

    if (response.code == 200) {
      return response.model;
    }
    return null;
  }
}
