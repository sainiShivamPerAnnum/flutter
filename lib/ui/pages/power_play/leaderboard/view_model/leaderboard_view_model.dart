import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/power_play_models/match_user_predicted_model.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

import '../widgets/make_prediction_sheet.dart';

class LeaderBoardViewModel extends BaseViewModel {
  final PowerPlayService _powerPlayService = locator<PowerPlayService>();

  PowerPlayService get powerPlayService => _powerPlayService;

  List<MatchUserPredictedData> _userPredictedData = [];

  List<MatchUserPredictedData> get userPredictedData => _userPredictedData;
  bool _isPredictionInProgress = false;

  bool get isPredictionInProgress => _isPredictionInProgress;

  set isPredictionInProgress(value) {
    _isPredictionInProgress = value;
    notifyListeners();
  }

  set userPredictedData(List<MatchUserPredictedData> value) {
    _userPredictedData = value;
  }

  List<MatchData?>? _liveMatchData = [];
  List<MatchData?>? _upcomingMatchData = [];
  List<MatchData?>? get liveMatchData => _liveMatchData;

  set liveMatchData(List<MatchData?>? value) {
    _liveMatchData = value;
  }

  List<MatchData?>? get upcomingMatchData => _upcomingMatchData;

  set upcomingMatchData(List<MatchData?>? value) {
    _upcomingMatchData = value;
  }

  Future<void> getUserPredictedData() async {
    state = ViewState.Busy;
    await _powerPlayService
        .getUserPredictedStats(powerPlayService.liveMatchData!.id!);

    log("userPredictedData: ${_powerPlayService.userPredictedData}");

    if (_powerPlayService.userPredictedData.isNotEmpty) {
      userPredictedData = _powerPlayService.userPredictedData;
    }

    state = ViewState.Idle;
    notifyListeners();
  }

  Future<void> getMatchesByStatus(String status, int limit, int offset) async {
    final res =
        await _powerPlayService.getMatchesByStatus(status, limit, offset);

    if (status == MatchStatus.active.name) {
      liveMatchData = res;
    } else if (status == MatchStatus.upcoming.name) {
      upcomingMatchData = res;
    }
  }

  Future<void> predict() async {
    isPredictionInProgress = true;
    await getMatchesByStatus(MatchStatus.active.name, 0, 0);

    await getMatchesByStatus(MatchStatus.upcoming.name, 0, 0);
    if (liveMatchData!.isEmpty) {
      BaseUtil.showNegativeAlert("No live matches at the moment",
          "come again tomorrow to make more predictions");
    } else if (liveMatchData!.isNotEmpty &&
        liveMatchData![0]!.status == MatchStatus.half_complete.name) {
      BaseUtil.showNegativeAlert("Predictions are over", "Try again tomorrow");
    } else {
      unawaited(
        BaseUtil.openModalBottomSheet(
          isBarrierDismissible: true,
          addToScreenStack: true,
          enableDrag: Platform.isIOS,
          backgroundColor: UiConstants.kGoldProBgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness32),
            topRight: Radius.circular(SizeConfig.roundness32),
          ),
          isScrollControlled: true,
          hapticVibrate: true,
          content: MakePredictionSheet(
            matchData: liveMatchData![0]!,
          ),
        ),
      );
    }
    isPredictionInProgress = false;
  }
}
