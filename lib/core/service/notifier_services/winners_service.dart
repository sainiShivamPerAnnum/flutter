import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/winners_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class WinnerService extends PropertyChangeNotifier<WinnerServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _winnersRepo = locator<WinnersRepository>();

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

  fetchTopWinner() async {
    ApiResponse<List<String>> response = await _winnersRepo.getTopWinners();
    if (response.code == 200) {
      _topWinners.clear();
      _topWinners = response.model;
      setTopWinners();
      _logger.d("Top winners successfully fetched");
    }
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

  fetchWinners() async {
    _winners.clear();
    ApiResponse<WinnersModel> _cricketWinners =
        await _winnersRepo.getWinners(Constants.GAME_TYPE_CRICKET, "weekly");

    ApiResponse<WinnersModel> _tambolaWinners =
        await _winnersRepo.getWinners(Constants.GAME_TYPE_TAMBOLA, "weekly");

    ApiResponse<WinnersModel> _poolClubWinners =
        await _winnersRepo.getWinners(Constants.GAME_TYPE_POOLCLUB, "weekly");

    ApiResponse<WinnersModel> _footBallWinners =
        await _winnersRepo.getWinners(Constants.GAME_TYPE_FOOTBALL, "weekly");

    ApiResponse<WinnersModel> _candyFiestaWinners = await _winnersRepo
        .getWinners(Constants.GAME_TYPE_CANDYFIESTA, "weekly");

    _winners.clear();

    if (_cricketWinners != null &&
        _cricketWinners.model != null &&
        _cricketWinners.model.winners != null &&
        _cricketWinners.model?.winners?.length != 0) {
      _timestamp = _cricketWinners.model?.timestamp;
      _cricketWinnersLength = _cricketWinners.model?.winners?.length;
      _winners.addAll(_cricketWinners.model.winners);
      _logger.d(_cricketWinners.model.winners.toString());
      _logger.d("Cricket Winners added to leaderboard");
    } else {
      _logger.i("Cricket Winners not added to leaderboard");
    }

    if (_tambolaWinners != null &&
        _tambolaWinners.model != null &&
        _tambolaWinners.model.winners != null &&
        _tambolaWinners.model?.winners?.length != 0) {
      _timestamp = _tambolaWinners.model.timestamp;
      _tambolaWinnersLength = _tambolaWinners.model?.winners?.length;
      _winners.addAll(_tambolaWinners.model.winners);
      _logger.d("Tambola Winners added to leaderboard");
    } else {
      _logger.i("Tambola Winners not added to leaderboard");
    }

    if (_poolClubWinners != null &&
        _poolClubWinners.model != null &&
        _poolClubWinners.model.winners != null &&
        _poolClubWinners.model?.winners?.length != 0) {
      _timestamp = _poolClubWinners.model?.timestamp;
      _poolClubWinnersLength = _poolClubWinners.model?.winners?.length;
      _winners.addAll(_poolClubWinners.model.winners);
      _logger.d(_poolClubWinners.model.winners.toString());
      _logger.d("PoolClub Winners added to leaderboard");
    } else {
      _logger.i("PoolClub Winners not added to leaderboard");
    }

    if (_footBallWinners != null &&
        _footBallWinners.model != null &&
        _footBallWinners.model.winners != null &&
        _footBallWinners.model?.winners?.length != 0) {
      _timestamp = _footBallWinners.model?.timestamp;
      _footBallWinnersLength = _footBallWinners.model?.winners?.length;
      _winners.addAll(_footBallWinners.model.winners);
      _logger.d(_footBallWinners.model.winners.toString());
      _logger.d("FootBall Winners added to leaderboard");
    } else {
      _logger.i("FootBall Winners not added to leaderboard");
    }

    if (_candyFiestaWinners != null &&
        _candyFiestaWinners.model != null &&
        _candyFiestaWinners.model.winners != null &&
        _candyFiestaWinners.model?.winners?.length != 0) {
      _timestamp = _candyFiestaWinners.model?.timestamp;
      _candyFiestaWinnersLength = _candyFiestaWinners.model?.winners?.length;
      _winners.addAll(_candyFiestaWinners.model.winners);
      _logger.d(_candyFiestaWinners.model.winners.toString());
      _logger.d("CandyFiesta Winners added to leaderboard");
    } else {
      _logger.i("CandyFiesta Winners not added to leaderboard");
    }

    if (_tambolaWinners.model?.winners?.length == 0 &&
        _cricketWinners.model?.winners?.length == 0 &&
        _poolClubWinners.model?.winners?.length == 0 &&
        _footBallWinners.model?.winners?.length == 0) {
      BaseUtil.showNegativeAlert(
          "Unable to fetch winners", "try again in sometime");
    }

    if (_winners != null)
      _winners.sort((a, b) => (a.amount == null || b.amount == null)
          ? -1
          : b.amount.compareTo(a.amount));
    else
      _winners = [];

    setWinners();
  }
}
