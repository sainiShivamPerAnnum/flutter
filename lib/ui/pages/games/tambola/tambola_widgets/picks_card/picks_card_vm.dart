import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class PicksCardViewModel extends BaseViewModel {
  final TambolaService _tambolaService = locator<TambolaService>();

  int get dailyPicksCount => _tambolaService!.dailyPicksCount ?? 3;
  PageController? _pageController;

  bool? _isShowingAllPicks;
  double? _topCardHeight;
  double? _expandedTopCardHeight;
  double? _normalTopCardHeight;
  double? _titleOpacity;
  List<int>? _todaysPicks;
  DailyPick? _weeklyDigits;
  int? _totalTicketMatched;

  int get totalTicketMatched => _tambolaService.matchedTicketCount ?? 0;

  set totalTicketMatched(int value) {
    _totalTicketMatched = value;
  }

  List<int>? get todaysPicks => _todaysPicks;

  DailyPick? get weeklyDigits => _weeklyDigits;
  int _tabNo = 0;

  get tabNo => _tabNo;
  double _tabPosWidthFactor = SizeConfig.pageHorizontalMargins;

  get tabPosWidthFactor => _tabPosWidthFactor;

  set tabNo(value) {
    _tabNo = value;
    notifyListeners();
  }

  set tabPosWidthFactor(value) {
    _tabPosWidthFactor = value;
    notifyListeners();
  }

  double? get normalTopCardHeight => _normalTopCardHeight;

  get isShowingAllPicks => _isShowingAllPicks;

  get topCardHeight => _topCardHeight;

  get expandedTopCardHeight => _expandedTopCardHeight;

  get titleOpacity => _titleOpacity;

  set isShowingAllPicks(value) {
    _isShowingAllPicks = value;
  }

  set topCardHeight(value) {
    _topCardHeight = value;
  }

  set expandedTopCardHeight(value) {
    _expandedTopCardHeight = value;
  }

  set titleOpacity(value) {
    _titleOpacity = value;
  }

  set normalTopCardHeight(value) {
    _normalTopCardHeight = value;
  }

  PageController? get pageController => _pageController;

  Future<void> init() async {
    _pageController = PageController(initialPage: 0);

    isShowingAllPicks = false;
    titleOpacity = 1.0;
    topCardHeight = normalTopCardHeight;
    await _tambolaService!.fetchWeeklyPicks();

    fetchTodaysPicks();
  }

  void fetchTodaysPicks() {
    _todaysPicks = _tambolaService!.todaysPicks;
    _weeklyDigits = _tambolaService!.weeklyDigits;

    notifyListeners();
  }

  void onTap() {
    if (!isShowingAllPicks) {
      topCardHeight = expandedTopCardHeight;
      titleOpacity = 0.0;
      isShowingAllPicks = true;
    } else {
      topCardHeight = normalTopCardHeight;
      isShowingAllPicks = false;
      Future.delayed(const Duration(milliseconds: 500), () {
        titleOpacity = 1.0;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void switchTab(int tab) {
    if (tab == tabNo) return;

    tabPosWidthFactor = tabNo == 0
        ? SizeConfig.screenWidth! / 2 - SizeConfig.pageHorizontalMargins
        : SizeConfig.pageHorizontalMargins;

    _pageController!.animateToPage(
      tab,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    tabNo = tab;
  }

  bool isNumberPresent(String dailyNumber) {
    var data = _tambolaService.ticketsNumbers;
    bool exist = false;
    if (dailyNumber != '-') {
      for (final element in data) {
        exist = element.contains(int.tryParse(dailyNumber));
        if (exist) break;
      }
    }

    return exist;
  }
}
