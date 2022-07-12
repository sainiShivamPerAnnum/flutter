import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/winner_service_enum.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/winners_repo.dart';
import 'package:felloapp/core/service/api_cache_manager.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class WinnerService extends PropertyChangeNotifier<WinnerServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _winnersRepo = locator<WinnersRepository>();
  final _apiCacheManager = locator<ApiCacheManager>();
  final _getterRepo = locator<GetterRepository>();

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

  Future<WinnersModel> getWinners(
    String gameType,
    String freq,
  ) async {
    String cacheKey = "winners" + gameType + freq;
    _logger.d("Cachekey: $cacheKey");
    Map data;
    WinnersModel _responseModel;

    _logger.d("Winner Game Type : $gameType \n Frequency: $freq");
    //Caching Mechanism
    data = await _apiCacheManager.getApiCache(key: cacheKey);
    _logger.d("Cache with key $cacheKey data: $data");

    if (data != null) {
      _logger.d("Reading Api cache with key: $cacheKey");
      _responseModel = WinnersModel.fromMap(data);
    } else {
      _logger.d("Adding Api cache with key isCacheable: $cacheKey");

      final ApiResponse _response = await _getterRepo.getWinnerByFreqGameType(
        type: gameType,
        freq: freq,
      );
      if (_response.code == 200 && _response.model.isNotEmpty) {
        _responseModel = WinnersModel.fromMap(_response.model);
        await _apiCacheManager.writeApiCache(
          key: cacheKey,
          ttl: Duration(hours: 6),
          value: _responseModel.toMap(),
        );
      }
    }
    return _responseModel;
  }
}
