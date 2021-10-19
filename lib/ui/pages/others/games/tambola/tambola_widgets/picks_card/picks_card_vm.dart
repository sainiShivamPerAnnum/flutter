import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/service/tambola_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class PicksCardViewModel extends BaseModel {
  final TambolaService _tambolaService = locator<TambolaService>();
  int get dailyPicksCount => _tambolaService.dailyPicksCount;
  List<int> get todaysPicks => _tambolaService.todaysPicks;
  DailyPick get weeklyDigits => _tambolaService.weeklyDigits;
  bool _isShowingAllPicks;
  double _topCardHeight;
  double _expandedTopCardHeight;
  double _normalTopCardHeight;
  double _titleOpacity;

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

  init() {
    _normalTopCardHeight = SizeConfig.screenWidth * 0.5;
    _expandedTopCardHeight =
        (SizeConfig.smallTextSize + SizeConfig.screenWidth * 0.1) * 8 +
            SizeConfig.cardTitleTextSize * 2.4 +
            kToolbarHeight * 1.5;
    isShowingAllPicks = false;
    titleOpacity = 1.0;
    topCardHeight = normalTopCardHeight;
    _tambolaService.fetchWeeklyPicks();
  }

  void onTap() {
    if (!isShowingAllPicks) {
      topCardHeight = expandedTopCardHeight;
      titleOpacity = 0.0;
      isShowingAllPicks = true;
    } else {
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
