import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

// enum MatchStatus { active, upcoming, completed }

class PowerPlayHomeViewModel extends BaseViewModel {
  final PowerPlayService _powerPlayService = locator<PowerPlayService>();

  // PowerPlayHomeViewModel(){
  //   _powerPlayService.init();
  // }

  TabController? tabController;
  ScrollController? scrollController;

  final List<String> _tabs = ["Live", "Upcoming", "Completed"];
  List<MatchData?>? _liveMatchData = [];
  List<MatchData?>? _upcomingMatchData = [];
  List<MatchData>? _completedMatchData;

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

  Future<void> init() async {
    setState(ViewState.Busy);
    _powerPlayService.init();
    scrollController = ScrollController();
    await _powerPlayService.getMatchesByStatus(MatchStatus.active.name, 0, 0);
    if (_powerPlayService.liveMatchData.isNotEmpty) {
      liveMatchData = _powerPlayService.liveMatchData;
    }
    setState(ViewState.Idle);
    scrollController!.addListener(() async {
      if (scrollController!.offset >=
          scrollController!.position.maxScrollExtent) {
        if (isLoadingMoreCompletedMatches ||
            _powerPlayService.hasNoMoreCompletedMatches ||
            tabController!.index != 2) return;
        isLoadingMoreCompletedMatches = true;
        await getMatchesByStatus(
            MatchStatus.completed.name, 3, completedMatchData?.length ?? 0);
        isLoadingMoreCompletedMatches = false;
      }
    });
  }

  Future<void> getMatchesByStatus(String status, int limit, int offset) async {
    await _powerPlayService.getMatchesByStatus(status, limit, offset);

    if (_powerPlayService.liveMatchData.isNotEmpty &&
        status == MatchStatus.active.name) {
      liveMatchData = _powerPlayService.liveMatchData;
    } else if (_powerPlayService.upcomingMatchData.isNotEmpty &&
        status == MatchStatus.upcoming.name) {
      upcomingMatchData = _powerPlayService.upcomingMatchData;
    } else if (status == MatchStatus.completed.name) {
      completedMatchData = _powerPlayService.completedMatchData;
    }
  }

  Future<void> handleTabSwitch(index) async {
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
}
