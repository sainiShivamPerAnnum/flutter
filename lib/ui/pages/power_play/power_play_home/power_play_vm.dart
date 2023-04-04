import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

// enum MatchStatus { active, upcoming, completed }

class PowerPlayHomeViewModel extends BaseViewModel {
  final PowerPlayService _powerPlayService = locator<PowerPlayService>();
  final TransactionHistoryRepository _txnRepo =
      locator<TransactionHistoryRepository>();
  // PowerPlayHomeViewModel(){
  //   _powerPlayService.init();
  // }

  TabController? tabController;
  ScrollController? scrollController;

  final List<String> _tabs = ["Live", "Upcoming", "Completed"];
  List<MatchData?>? _liveMatchData = [];
  List<MatchData?>? _upcomingMatchData = [];
  List<MatchData>? _completedMatchData;
  List<UserTransaction>? predictions = [];

  bool _isLive = true;
  bool hasNoMoreCompletedMatches = false;
  List<dynamic>? cardCarousel;

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

  List<MatchData?>? get liveMatchData => _liveMatchData;

  set liveMatchData(List<MatchData?>? value) {
    _liveMatchData = value;
  }

  List<MatchData?>? get upcomingMatchData => _upcomingMatchData;

  set upcomingMatchData(List<MatchData?>? value) {
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
    if (liveMatchData!.isNotEmpty) {
      liveMatchData = liveMatchData;
      matchData = liveMatchData![0]!;
    }
    getUserPredictionCount();
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

  Future<void> getMatchesByStatus(String status, int limit, int offset) async {
    final res =
        await _powerPlayService.getMatchesByStatus(status, limit, offset);

    if (liveMatchData!.isEmpty && status == MatchStatus.active.name) {
      liveMatchData = res;
    } else if (upcomingMatchData!.isEmpty &&
        status == MatchStatus.upcoming.name) {
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
    if (liveMatchData == null) return;
    isPredictionsLoading = true;
    final response = await _txnRepo.getPowerPlayUserTransactions(
        startTime: liveMatchData![0]!.startsAt.toString(),
        endTime: TimestampModel.currentTimeStamp().toString(),
        type: 'DEPOSIT',
        status: 'COMPLETE');
    isPredictionsLoading = false;
    if (response.isSuccess()) {
      predictions = response.model!.transactions;
    } else {
      predictions = [];
    }
  }
}
