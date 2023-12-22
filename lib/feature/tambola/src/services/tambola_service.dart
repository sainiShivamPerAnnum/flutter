import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/model/tambola_offers_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_best_tickets_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_ticket_model.dart';
import 'package:felloapp/feature/tambola/src/repos/tambola_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/cupertino.dart';

enum SlotMachineState { toBeSpinned, Spinnned }

class TambolaService extends ChangeNotifier {
  //LOCATORS
  final CustomLogger _logger = locator<CustomLogger>();
  final TambolaRepo _tambolaRepo = locator<TambolaRepo>();
  final ScratchCardRepository _scRepo = locator<ScratchCardRepository>();
  final WinnerService _winnerService = locator<WinnerService>();
  final GameRepo _gameRepo = locator<GameRepo>();
  final GetterRepository _getterRepo = locator<GetterRepository>();
  final UserService _userService = locator<UserService>();

  //STATIC VARIABLES
  static int? ticketCount;
  static List<int>? _todaysPicks;

  //LOCAL VARIABLES
  DailyPick? _weeklyPicks;
  GameModel? tambolaGameData;
  PrizesModel? tambolaPrizes;
  List<Winners>? pastWeekWinners;
  List<TambolaTicketModel> allTickets = [];
  List<TambolaTicketModel>? allBestTickets = [];
  TambolaBestTicketsModel? _bestTickets;
  int _tambolaTicketCount = 0;
  bool hasUserSpinedForToday = false;
  bool _showPastWeekWinStrip = false;
  String _slotMachineTitle = "Reveal today's picks";

  String get slotMachineTitle => _slotMachineTitle;

  set slotMachineTitle(String value) {
    _slotMachineTitle = value;
    notifyListeners();
  }

  bool get showPastWeekWinStrip => _showPastWeekWinStrip;

  set showPastWeekWinStrip(bool value) {
    _showPastWeekWinStrip = value;
    notifyListeners();
  }

  int _matchedTicketCount = 0;
  int expiringTicketsCount = 0;
  Winners? winnerData;
  Winners? pastWinnerData;

  int get tambolaTicketCount => _tambolaTicketCount;

  set tambolaTicketCount(int value) {
    _tambolaTicketCount = value;
    notifyListeners();
  }

  List<TicketsOffers> _ticketsOffers = [];

  get ticketsOffers => _ticketsOffers;

  set ticketsOffers(value) {
    _ticketsOffers = value;
    notifyListeners();
  }

  bool _isScreenLoading = true;
  bool _isLoading = false;
  bool _isEligible = false;

  bool get isEligible => _isEligible;

  set isEligible(value) {
    _isEligible = value;
    notifyListeners();
  }

  bool showWinScreen = false;
  bool noMoreTickets = false;
  bool _showSpinButton = false;
  bool _isCollapsed = false;

  bool get isCollapsed => _isCollapsed;

  set isCollapsed(bool value) {
    _isCollapsed = value;
    notifyListeners();
  }

  bool get showSpinButton => _showSpinButton;

  set showSpinButton(bool value) {
    _showSpinButton = value;
    notifyListeners();
  }

  AnimationController? ticketsDotLightsController;
  SlotMachineState _slotMachinState = SlotMachineState.toBeSpinned;

  get slotMachinState => _slotMachinState;

  set slotMachinState(value) {
    _slotMachinState = value;
    notifyListeners();
  }

  //GETTERS SETTERS
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isScreenLoading => _isScreenLoading;

  set isScreenLoading(bool value) {
    _isScreenLoading = value;
    notifyListeners();
  }

  List<int> _weeklyPicksList = [];

  List<int> get weeklyPicksList => _weeklyPicksList;

  set weeklyPicksList(List<int> value) => _weeklyPicksList = value;

  List<int>? get todaysPicks => _todaysPicks;

  set todaysPicks(List<int>? value) {
    _todaysPicks = value;
    notifyListeners();
  }

  DailyPick? get weeklyPicks => _weeklyPicks;

  set weeklyPicks(DailyPick? value) {
    _weeklyPicks = value;
    notifyListeners();
  }

  int get matchedTicketCount => _matchedTicketCount;

  set matchedTicketCount(int value) {
    _matchedTicketCount = value;
    notifyListeners();
  }

  TambolaBestTicketsModel? get bestTickets => _bestTickets;

  set bestTickets(TambolaBestTicketsModel? value) {
    _bestTickets = value;
    notifyListeners();
  }

  //CORE METHODS

  void init() {}

  void dump() {
    tambolaTicketCount = 0;
    _matchedTicketCount = 0;
    noMoreTickets = false;
    _isScreenLoading = true;
    _isLoading = false;
    isEligible = false;
    showWinScreen = false;
    _weeklyPicks = null;
    _todaysPicks = null;
    bestTickets = null;
    allTickets = [];
  }

  //CORE METHODS -- END

  //MAIN METHODS

  Future<void> refreshTickets() async {
    await fetchWeeklyPicks();
    await getBestTambolaTickets(forced: true);
    unawaited(getTambolaTickets(limit: 1));
  }

  Future<bool> getGameDetails() async {
    final gameRes =
        await _gameRepo.getGameByCode(gameCode: Constants.GAME_TYPE_TAMBOLA);
    if (gameRes.isSuccess()) {
      tambolaGameData = gameRes.model;
      return true;
    } else {
      return false;
    }
  }

  Future<int> getTambolaTicketsCount() async {
    await getBestTambolaTickets();
    tambolaTicketCount = bestTickets?.data?.totalTicketCount ?? 0;
    allBestTickets = bestTickets?.data?.allTickets();
    return tambolaTicketCount;
  }

  Future<void> getPrizes({bool refresh = false}) async {
    if (tambolaPrizes != null && !refresh) return;
    final res = await _scRepo.getPrizesPerGamePerFreq(
        Constants.GAME_TYPE_TAMBOLA, "weekly");
    if (res.isSuccess()) {
      tambolaPrizes = res.model;
    }
    notifyListeners();
  }

  Future<void> getPastWeekWinners({bool refresh = false}) async {
    if (pastWeekWinners != null && !refresh) return;
    final winnersModel = await _winnerService
        .fetchWinnersByGameCode(Constants.GAME_TYPE_TAMBOLA);
    pastWeekWinners = winnersModel!.winners!;
    //Check if its the winners day
    if (winnersModel.createdOn!.toDate().weekday == DateTime.now().weekday) {
      if (pastWeekWinners!.indexWhere(
              (winner) => winner.userid == _userService.baseUser!.uid) !=
          -1) {
        winnerData = pastWeekWinners!.firstWhere(
            (winner) => winner.userid == _userService.baseUser!.uid);
      }
    }
    if (DateTime.now().weekday < 4) {
      if (pastWeekWinners!.indexWhere(
              (winner) => winner.userid == _userService.baseUser!.uid) !=
          -1) {
        pastWinnerData = pastWeekWinners!.firstWhere(
            (winner) => winner.userid == _userService.baseUser!.uid);
        showPastWeekWinStrip = true;
      }
    }

    notifyListeners();
  }

  Future<void> getTambolaTickets({int limit = 10}) async {
    final ticketsResponse = await _tambolaRepo.getTickets(
        allTickets.isEmpty ? 0 : allTickets.length + 1, limit);
    if (ticketsResponse.isSuccess()) {
      if (ticketsResponse.model!.isEmpty) {
        noMoreTickets = true;
        return;
      }
      if (allTickets.isEmpty) {
        allTickets = ticketsResponse.model!;
      } else {
        allTickets.addAll(ticketsResponse.model!);
      }
      expiringTicketsCount = TambolaRepo.expiringTicketCount;

      notifyListeners();
    } else {
      //TODO: FAILED TO FETCH TAMBOLA TICKETS. HANDLE FAIL CASE
    }
  }

  Future<void> getBestTambolaTickets({bool forced = false}) async {
    if (forced) {
      await CacheService.invalidateByKey(CacheKeys.TAMBOLA_TICKETS);
    }
    bool postSpin = false;
    if (DateTime.now().hour > 18 && hasUserSpinedForToday) {
      postSpin = true;
    }
    final ticketsResponse =
        await _tambolaRepo.getBestTickets(postSpinStats: postSpin);
    if (ticketsResponse.isSuccess()) {
      bestTickets = ticketsResponse.model;
      allBestTickets = bestTickets?.data?.allTickets();
      if (allBestTickets?.isNotEmpty ?? false) {
        isCollapsed = true;
        if (todaysPicks != null &&
            todaysPicks!.isNotEmpty &&
            !todaysPicks!.contains(-1) &&
            !hasUserSpinedForToday) {
          slotMachineTitle = "Reveal Numbers to match with Tickets";
        }
      }
    } else {
      //TODO: FAILED TO FETCH TAMBOLA TICKETS. HANDLE FAIL CASE
    }
  }

  Future<void> getOffers() async {
    final res = await _getterRepo.getTambolaOffers();
    if (res.isSuccess()) {
      ticketsOffers = res.model;
    }
  }

  Future<void> highlightDailyPicks(List<List<int>> ticketNumbersList) async {
    matchedTicketCount = 0;

    if (ticketNumbersList.isEmpty) return;

    await Future.wait(ticketNumbersList.map((numsList) async {
      log('numsList $numsList --  todaysPicks $todaysPicks');

      if (_todaysPicks != null) {
        for (final int pick in _todaysPicks!) {
          if (numsList.contains(pick)) {
            matchedTicketCount++;
            break;
          }
        }
      }
    }).toList());

    notifyListeners();
  }

  Future<void> fetchWeeklyPicks({bool forcedRefresh = false}) async {
    try {
      _logger.i('Requesting for weekly picks');
      final ApiResponse picksResponse = await _tambolaRepo.getWeeklyPicks();
      if (picksResponse.isSuccess()) {
        weeklyPicks = picksResponse.model!;
        weeklyPicksList = weeklyPicks?.toList() ?? [];
        // weeklyDrawFetched = true;
        switch (DateTime.now().weekday) {
          case 1:
            todaysPicks = weeklyPicks!.mon;
            break;
          case 2:
            todaysPicks = weeklyPicks!.tue;
            break;
          case 3:
            todaysPicks = weeklyPicks!.wed;
            break;
          case 4:
            todaysPicks = weeklyPicks!.thu;
            break;
          case 5:
            todaysPicks = weeklyPicks!.fri;
            break;
          case 6:
            todaysPicks = weeklyPicks!.sat;
            break;
          case 7:
            todaysPicks = weeklyPicks!.sun;
            break;
        }
        if (todaysPicks == null) {
          _logger.i("Today's picks are not generated yet");
          todaysPicks = [-1, -1, -1];
          slotMachineTitle = "Numbers will be revealed at 6pm";
        } else {
          String lastSpinTimeInIsoString = PreferenceHelper.getString(
              PreferenceHelper.CACHE_TICKETS_LAST_SPIN_TIMESTAMP);
          if (lastSpinTimeInIsoString.isNotEmpty) {
            TimestampModel lastSpinTime =
                TimestampModel.fromIsoString(lastSpinTimeInIsoString);

            if (lastSpinTime.toDate().day == DateTime.now().day &&
                lastSpinTime.toDate().month == DateTime.now().month) {
              //user has already spinned the slot machine
              hasUserSpinedForToday = true;
              isEligible = true;
              slotMachineTitle = "Today's Picks";
            } else {
              handleSlotPreSpin();
            }
          } else {
            handleSlotPreSpin();
          }
        }

        notifyListeners();
      } else {}
    } catch (e) {
      _logger.e('$e');
    }
  }

  void handleSlotPreSpin() {
    //remove today's picks from weeklyPicksList
    for (final tp in todaysPicks!) {
      weeklyPicksList.removeWhere((wp) => wp == tp);
    }
    switch (DateTime.now().weekday) {
      case 1:
        weeklyPicks!.mon = [-1, -1, -1];
        break;
      case 2:
        weeklyPicks!.tue = [-1, -1, -1];
        break;
      case 3:
        weeklyPicks!.wed = [-1, -1, -1];
        break;
      case 4:
        weeklyPicks!.thu = [-1, -1, -1];
        break;
      case 5:
        weeklyPicks!.fri = [-1, -1, -1];
        break;
      case 6:
        weeklyPicks!.sat = [-1, -1, -1];
        break;
      case 7:
        weeklyPicks!.sun = [-1, -1, -1];
        break;
    }
    showSpinButton = true;
    notifyListeners();
  }

  void postSlotSpin() {
    weeklyPicksList.addAll(todaysPicks!);
    switch (DateTime.now().weekday) {
      case 1:
        weeklyPicks!.mon = todaysPicks;
        break;
      case 2:
        weeklyPicks!.tue = todaysPicks;
        break;
      case 3:
        weeklyPicks!.wed = todaysPicks;
        break;
      case 4:
        weeklyPicks!.thu = todaysPicks;
        break;
      case 5:
        weeklyPicks!.fri = todaysPicks;
        break;
      case 6:
        weeklyPicks!.sat = todaysPicks;
        break;
      case 7:
        weeklyPicks!.sun = todaysPicks;
        break;
    }
    showSpinButton = false;
    weeklyPicks = weeklyPicks;
    slotMachineTitle = "Today's Picks";
    PreferenceHelper.setString(
        PreferenceHelper.CACHE_TICKETS_LAST_SPIN_TIMESTAMP,
        DateTime.now().toIso8601String());
    hasUserSpinedForToday = true;
    getBestTambolaTickets(forced: true);
    getPastWeekWinners(refresh: true).then((value) => isEligible = true);
  }

  String getTicketCategoryFromPrizes(String category) {
    if (tambolaPrizes == null) {
      return "";
    } else {
      if (category == 'category_1') {
        return tambolaPrizes!.prizes![0].displayName ?? "";
      }
      if (category == 'category_2') {
        return tambolaPrizes!.prizes![1].displayName ?? "";
      }
      if (category == 'category_3') {
        return tambolaPrizes!.prizes![2].displayName ?? "";
      }
      if (category == 'category_4') {
        return tambolaPrizes!.prizes![3].displayName ?? "";
      }
    }
    return "";
  }

  void setSlotMachineTitle() {
    _slotMachineTitle = "Today's Picks";
  }
}
