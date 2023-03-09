import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../ops/db_ops.dart';

class WinnerService extends ChangeNotifier {
  final CustomLogger? _logger = locator<CustomLogger>();
  final GameRepo _gamesRepo = locator<GameRepo>();
  final GetterRepository? _getterRepo = locator<GetterRepository>();
  final DBModel? _dbModel = locator<DBModel>();
  Map<String, List<Winners>> gameWinnersMap = {};
  // int? _cricketWinnersLength = 0;
  // int? _tambolaWinnersLength = 0;
  // int? _poolClubWinnersLength = 0;
  // int? _footBallWinnersLength = 0;
  // int? _candyFiestaWinnersLength = 0;
  Timestamp? _timestamp;

  List<Winners> _winners = [];
  // List<String> _topWinners = [];
  // List<String> _bugBountyWinners = [];
  // List<String> _newFelloWinners = [];
  // get bugBountyWinners => this._bugBountyWinners;
  // get newFelloWinners => this._newFelloWinners;
  List<Winners> get winners => this._winners;
  // List<String> get topWinners => this._topWinners;

  // get cricketWinnersLength => this._cricketWinnersLength;

  // get tambolaWinnersLength => this._tambolaWinnersLength;

  // get poolClubWinnersLength => this._poolClubWinnersLength;

  // get footBallWinnersLength => this._footBallWinnersLength;

  // get candyFiestaWinnersLength => this._candyFiestaWinnersLength;

  get timeStamp => _timestamp;

  setWinners() {
    notifyListeners();
    _logger!.d("Win View leaderboard updated, property listeners notified");
  }

  // setTopWinners() {
  //   notifyListeners(WinnerServiceProperties.topWinners);
  //   _logger!.d("Top Winners updated, property listeners notified");
  // }

  // setBugBountyWinners() {
  //   notifyListeners(WinnerServiceProperties.bugBounty);
  //   _logger!.d(
  //       "Top Winners of Bug Bounty Campaign updated, property listeners notified");
  // }

  // setNewFelloWinners() {
  //   notifyListeners(WinnerServiceProperties.newFello);
  //   _logger!.d(
  //       "Top Winners of New Fello App Campaign updated, property listeners notified");
  // }

  Future getProfileDpWithUid(String? uid) async {
    return await _dbModel!.getUserDP(uid);
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

  Future<WinnersModel?> fetchWinnersByGameCode(String code) async {
    return await getWinners(
      code,
      "weekly",
    );
  }

  Future<void> fetchWinnersForAllGames() async {
    _winners.clear();
    await Future.forEach(_gamesRepo.games!, (GameModel game) async {
      final gameWinners = await getWinners(game.gameCode!, "weekly");
      if (gameWinners.winners != null && gameWinners.winners!.isNotEmpty) {
        gameWinnersMap[game.gameCode!] = gameWinners.winners!;
        _winners.addAll(gameWinners.winners!);
      }
    });
    _winners.sort((a, b) => b.amount!.compareTo(a.amount!));
    setWinners();
  }

  Future<WinnersModel> getWinners(
    String gameType,
    String freq,
  ) async {
    _logger!.d("Winner Game Type : $gameType \n Frequency: $freq");

    final ApiResponse response = await _getterRepo!.getWinnerByFreqGameType(
      type: gameType,
      freq: freq,
    );

    if (response.code == 200) {
      return response.model;
    }
    return WinnersModel.base();
  }
}
