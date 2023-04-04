import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/power_play_models/match_user_predicted_model.dart';
import 'package:felloapp/core/model/power_play_models/match_winners_leaderboard_item_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/power_play_repo.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

enum MatchStatus { active, upcoming, completed }

class PowerPlayService extends ChangeNotifier {
  final CustomLogger _logger = locator<CustomLogger>();
  final PowerPlayRepository _powerPlayRepository =
      locator<PowerPlayRepository>();

  final TransactionHistoryRepository _transactionHistoryRepository =
      locator<TransactionHistoryRepository>();

  List<MatchData> matchData = [];

  List<UserTransaction>? transactions = [];
  List<Map<String, dynamic>>? cardCarousel;

  Map<String, int> currentScore = {};

  String matchId = "";

  List<MatchUserPredictedData> _userPredictedData = [];

  List<MatchUserPredictedData> get userPredictedData => _userPredictedData;

  set userPredictedData(List<MatchUserPredictedData> value) {
    _userPredictedData = value;
  }

  // List<MatchData> get completedMatchData => _completedMatchData;

  void init() {
    _logger.i("PowerPlayService init");
  }

  void dump() {
    matchData = [];
    _logger.i("PowerPlayService dump");
  }

  Future<List<MatchData>> getMatchesByStatus(
      String status, int limit, int offset) async {
    _logger.i("PowerPlayService -> getMatchesByStatus");
    final response =
        await _powerPlayRepository.getMatchesByStatus(status, limit, offset);
    log("SERVICE response => ${response.model?.data?.toList()}");

    try {
      if (response.isSuccess()) {
        matchId = response.model!.data![0].id!;
        currentScore = response.model!.data![0].currentScore!;
        return response.model!.data!;
      }
      return [];
    } catch (e) {
      _logger.d(e.toString());
      return [];
    }
  }

  Future<void> getUserPredictedStats() async {
    _logger.i("PowerPlayService -> getMatchStats");

    final response =
        await _powerPlayRepository.getUserPredictedStats('csk_rcb');

    log("SERVICE response => ${response.model?.data?.toList()}");

    if (response.isSuccess()) {
      userPredictedData = response.model!.data!;
    } else {
      BaseUtil.showNegativeAlert(response.errorMessage, "Please try again");
    }
  }

  Future<void> getUserTransactionHistory(
    MatchData matchData,
  ) async {
    _logger.i("PowerPlayService -> getTransactionHistory");
    var startTime;
    var endTime;

    if (matchData.status == MatchStatus.active.name) {
      startTime = matchData.startsAt;
      endTime = DateTime.now();
    } else if (matchData.status == MatchStatus.completed.name) {
      startTime = matchData.startsAt;
      endTime = matchData.endsAt;
    }

    final response =
        await _transactionHistoryRepository.getPowerPlayUserTransactions(
            startTime: startTime,
            endTime: endTime,
            type: 'DEPOSIT',
            status: 'COMPLETE');

    log("SERVICE response => ${response.model?.transactions?.toList()}");

    if (response.isSuccess()) {
      transactions = response.model!.transactions;

      log('transactions => ${transactions!.length}');
      // userPredictedData = response.model!.data!;
    } else {
      BaseUtil.showNegativeAlert(response.errorMessage, "Please try again");
    }
  }

  Future<List<MatchWinnersLeaderboardItemModel>?>
      getCompletedMatchWinnersLeaderboard(String matchId) async {
    final res = await _powerPlayRepository.getWinnersLeaderboard(matchId);
    if (res.isSuccess()) {
      return res.model!;
    } else {
      BaseUtil.showNegativeAlert(
          res.errorMessage, "Please try again after sometime");
      return [];
    }
  }
}
