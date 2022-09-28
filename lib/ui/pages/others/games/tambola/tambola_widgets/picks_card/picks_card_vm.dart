import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class PicksCardViewModel extends BaseViewModel {
  final TambolaService _tambolaService = locator<TambolaService>();
  int get dailyPicksCount => _tambolaService.dailyPicksCount ?? 3;

  bool _isShowingAllPicks;
  double _topCardHeight;
  double _expandedTopCardHeight;
  double _normalTopCardHeight;
  double _titleOpacity;
  List<int> _todaysPicks;
  DailyPick _weeklyDigits;
  List<int> get todaysPicks => _todaysPicks;
  DailyPick get weeklyDigits => _weeklyDigits;

  get normalTopCardHeight => this._normalTopCardHeight;

  get isShowingAllPicks => this._isShowingAllPicks;

  get topCardHeight => this._topCardHeight;

  get expandedTopCardHeight => this._expandedTopCardHeight;

  get titleOpacity => this._titleOpacity;

  set isShowingAllPicks(value) {
    this._isShowingAllPicks = value;
  }

  set topCardHeight(value) {
    this._topCardHeight = value;
  }

  set expandedTopCardHeight(value) {
    this._expandedTopCardHeight = value;
  }

  set titleOpacity(value) {
    this._titleOpacity = value;
  }

  set normalTopCardHeight(value) {
    this._normalTopCardHeight = value;
  }

  init() async {
    _normalTopCardHeight = SizeConfig.screenWidth * 0.5;
    _expandedTopCardHeight =
        (SizeConfig.smallTextSize + SizeConfig.screenWidth * 0.1) * 8 +
            SizeConfig.cardTitleTextSize * 2.4 +
            kToolbarHeight * 1.5;
    isShowingAllPicks = false;
    titleOpacity = 1.0;
    topCardHeight = normalTopCardHeight;
    await _tambolaService.fetchWeeklyPicks();

    fetchTodaysPicks();
  }

  fetchTodaysPicks() {
    _todaysPicks = _tambolaService.todaysPicks;
    _weeklyDigits = _tambolaService.weeklyDigits;
    notifyListeners();
  }

  void onTap(ValueChanged<bool> showBuyTicketModal) {
    if (!isShowingAllPicks) {
      showBuyTicketModal(false);
      topCardHeight = expandedTopCardHeight;
      titleOpacity = 0.0;
      isShowingAllPicks = true;
    } else {
      showBuyTicketModal(true);
      topCardHeight = normalTopCardHeight;
      isShowingAllPicks = false;
      Future.delayed(Duration(milliseconds: 500), () {
        titleOpacity = 1.0;
        notifyListeners();
      });
    }
    notifyListeners();
  }
}
