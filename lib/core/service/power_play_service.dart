import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/repository/power_play_repo.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

enum MatchStatus { active, upcoming, completed }

extension MatchStatusExtension on MatchStatus {
  String get getValue {
    switch (this) {
      case MatchStatus.active:
        return "active";
      case MatchStatus.upcoming:
        return "upcoming";
      case MatchStatus.completed:
        return "completed";
      default:
        return "live";
    }
  }
}

class PowerPlayService extends ChangeNotifier {
  final CustomLogger _logger = locator<CustomLogger>();
  final PowerPlayRepository _powerPlayRepository =
      locator<PowerPlayRepository>();

  List<MatchData> _matchData = [];

  List<MatchData> _liveMatchData = [];
  List<MatchData> _upcomingMatchData = [];
  List<MatchData> _completedMatchData = [];

  List<MatchData> get liveMatchData => _liveMatchData;

  List<MatchData> get upcomingMatchData => _upcomingMatchData;

  List<MatchData> get completedMatchData => _completedMatchData;

  List<MatchData> get matchData => _matchData;

  set matchData(List<MatchData> value) {
    _matchData = value;
  }

  void init() {
    _logger.i("PowerPlayService init");
  }

  void dump() {
    matchData = [];
    _logger.i("PowerPlayService dump");
  }

  Future<void> getMatchesByStatus(String status, int limit, int offset) async {
    _logger.i("PowerPlayService -> getMatchesByStatus");

    final response =
        await _powerPlayRepository.getMatchesByStatus(status, limit, offset);

    log("SERVICE response => ${response.model?.data?.toList()}");

    try {
      if (response.isSuccess()) {
        if (status == 'active') {
          log("hello");
          _liveMatchData = response.model!.data!;
          log('liveMatchData => ${_liveMatchData[0].toJson()}');
        } else if (status == MatchStatus.upcoming.getValue) {
          _upcomingMatchData = response.model!.data!;
        } else if (status == MatchStatus.completed.getValue) {
          _completedMatchData = response.model!.data!;
        }

        // matchData = response.model!.data!;
      } else {
        BaseUtil.showNegativeAlert(response.errorMessage, "Please try again");
      }
    } catch (e) {
      // BaseUtil.showNegativeAlert("Something went wrong", "Please try again");
    }
  }
}
