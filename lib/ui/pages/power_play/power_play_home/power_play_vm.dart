import 'dart:async';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/live_match.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/power_play_matches.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

import '../leaderboard/widgets/make_prediction_sheet.dart';

// enum MatchStatus { active, upcoming, completed }

class PowerPlayHomeViewModel extends BaseViewModel {
  final PowerPlayService _powerPlayService = locator<PowerPlayService>();
  final TransactionHistoryRepository _txnRepo =
      locator<TransactionHistoryRepository>();

  TabController? tabController;
  ScrollController? scrollController;

  final List<String> _tabs = ["Live", "Upcoming", "Completed"];
  List<MatchData>? _liveMatchData = [];
  List<MatchData>? _upcomingMatchData = [];

  List<MatchData>? _completedMatchData;
  List<UserTransaction>? _predictions = [];
  bool _isPredictionInProgress = false;

  bool get isPredictionInProgress => _isPredictionInProgress;

  set isPredictionInProgress(value) {
    _isPredictionInProgress = value;
    notifyListeners();
  }

  List<UserTransaction>? get transactions => _powerPlayService.transactions;

  List<UserTransaction>? get predictions => _predictions;

  set predictions(List<UserTransaction>? value) {
    _predictions = value;
    notifyListeners();
  }

  bool _isLive = true;
  bool hasNoMoreCompletedMatches = false;
  List<dynamic>? cardCarousel;

  int _powerPlayReward = 0;

  int get powerPlayReward => _powerPlayReward;

  set powerPlayReward(int value) {
    _powerPlayReward = value;
    notifyListeners();
  }

  bool _isPredictionsLoading = false;

  bool get isPredictionsLoading => _isPredictionsLoading;

  set isPredictionsLoading(bool value) {
    _isPredictionsLoading = value;
    notifyListeners();
  }

  bool get isLive => _isLive;

  set isLive(bool value) {
    _isLive = value;
    notifyListeners();
  }

  bool _isLoadingMoreCompletedMatches = false;

  bool get isLoadingMoreCompletedMatches => _isLoadingMoreCompletedMatches;

  set isLoadingMoreCompletedMatches(bool value) {
    _isLoadingMoreCompletedMatches = value;
    notifyListeners();
  }

  List<MatchData>? get liveMatchData => _liveMatchData;

  set liveMatchData(List<MatchData>? value) {
    _liveMatchData = value;
  }

  List<MatchData>? get upcomingMatchData => _upcomingMatchData;

  set upcomingMatchData(List<MatchData>? value) {
    _upcomingMatchData = value;
  }

  List<MatchData>? get completedMatchData => _completedMatchData;

  set completedMatchData(List<MatchData>? value) {
    _completedMatchData = value;
  }

  List<String> get tabs => _tabs;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  MatchData? matchData;

  Future<void> init() async {
    setState(ViewState.Busy);
    _powerPlayService.init();
    getCardCarousle();
    scrollController = ScrollController();
    await getMatchesByStatus(MatchStatus.active.name, 0, 0);
    powerPlayReward = await _powerPlayService.getPowerPlayRewards();

    if (liveMatchData!.isNotEmpty) {
      liveMatchData = liveMatchData;
      matchData = liveMatchData![0];
      unawaited(
          _powerPlayService.getUserTransactionHistory(matchData: matchData!));
    }
    if ((liveMatchData == null || (liveMatchData?.isEmpty ?? true)) && isLive) {
      Future.delayed(const Duration(milliseconds: 200), () {
        tabController?.animateTo(1);
        handleTabSwitch(1);
        isLive = false;
      });
    }

    await getUserPredictionCount();
    setState(ViewState.Idle);
    scrollController!.addListener(() async {
      if (scrollController!.offset >=
          scrollController!.position.maxScrollExtent) {
        if (isLoadingMoreCompletedMatches ||
            hasNoMoreCompletedMatches ||
            tabController!.index != 2) return;
        isLoadingMoreCompletedMatches = true;
        await getMatchesByStatus(
            MatchStatus.completed.name, 3, completedMatchData?.length ?? 0);
        isLoadingMoreCompletedMatches = false;
      }
    });
  }

  Future<void> getAllMatched() async {
    setState(ViewState.Busy);
    completedMatchData = null;
    await getMatchesByStatus(MatchStatus.active.name, 0, 0);
    await getMatchesByStatus(MatchStatus.upcoming.name, 0, 0);
    await getMatchesByStatus(MatchStatus.completed.name, 0, 0);
    powerPlayReward = await _powerPlayService.getPowerPlayRewards();
    await getUserPredictionCount();
    setState(ViewState.Idle);
  }

  Future<void> getMatchesByStatus(String status, int limit, int offset) async {
    final res =
        await _powerPlayService.getMatchesByStatus(status, limit, offset);

    if (status == MatchStatus.active.name) {
      liveMatchData = res;
    } else if (status == MatchStatus.upcoming.name) {
      upcomingMatchData = res;
    } else if (status == MatchStatus.completed.name) {
      if (completedMatchData == null) {
        completedMatchData = res;
      } else {
        completedMatchData!.addAll(res);
        if (res.length <= limit) hasNoMoreCompletedMatches = true;
      }
    }
  }

  Future<void> handleTabSwitch(index) async {
    Haptic.vibrate();
    switch (index) {
      case 0:
        break;
      case 1:
        if (upcomingMatchData == null || upcomingMatchData!.isEmpty) {
          setState(ViewState.Busy);
          await getMatchesByStatus(MatchStatus.upcoming.name, 0, 0);
          setState(ViewState.Idle);
        }
        break;
      case 2:
        if (completedMatchData == null) {
          setState(ViewState.Busy);
          await getMatchesByStatus(MatchStatus.completed.name, 3, 0);
          setState(ViewState.Idle);
        }
        break;
    }
  }

  void getCardCarousle() {
    var appConfigData =
        AppConfig.getValue<Map<String, dynamic>>(AppConfigKey.powerplayConfig);

    cardCarousel = appConfigData['predictScreen']['cardCarousel'];
  }

  Future<void> getUserPredictionCount() async {
    if (liveMatchData == null || liveMatchData!.isEmpty) return;

    isPredictionsLoading = true;
    final response = await _txnRepo.getPowerPlayUserTransactions(
      startTime: liveMatchData![0].startsAt,
      endTime: liveMatchData![0].status == MatchStatus.active.name
          ? TimestampModel.currentTimeStamp()
          : (liveMatchData![0].predictionEndedAt ?? liveMatchData![0].endsAt),
      type: 'DEPOSIT',
      status: 'COMPLETE',
    );
    isPredictionsLoading = false;
    if (response.isSuccess()) {
      predictions = response.model!.transactions;
    } else {
      predictions = [];
    }
  }

  Future<void> predict() async {
    isPredictionInProgress = true;
    await getMatchesByStatus(MatchStatus.active.name, 0, 0);

    await getMatchesByStatus(MatchStatus.upcoming.name, 0, 0);
    print(liveMatchData![0].status);
    if (liveMatchData!.isEmpty) {
      BaseUtil.showNegativeAlert("No live matches at the moment",
          "come again tomorrow to make more predictions");
    } else if (liveMatchData!.isNotEmpty &&
        liveMatchData![0].status == MatchStatus.half_complete.name) {
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
            matchData: liveMatchData![0],
          ),
        ),
      );
    }
    isPredictionInProgress = false;
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.iplPredictNowTapped,
    );
  }

  Widget buildLiveTab() {
    if (state == ViewState.Busy) {
      return const Center(child: CircularProgressIndicator());
    }

    return liveMatchData?.isEmpty ?? true
        ? (upcomingMatchData!.isEmpty ||
                upcomingMatchData?[0] == null ||
                (upcomingMatchData?[0].startsAt == null))
            ? const SizedBox()
            : NoLiveMatch(
                timeStamp: upcomingMatchData?[0].startsAt,
                matchStatus: MatchStatus.active)
        : LiveMatch(model: this);
  }
}
