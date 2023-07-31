import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class TambolaService extends ChangeNotifier {
  //LOCATORS
  final CustomLogger _logger = locator<CustomLogger>();
  final TambolaRepo _tambolaRepo = locator<TambolaRepo>();
  final ScratchCardRepository _scRepo = locator<ScratchCardRepository>();
  final WinnerService _winnerService = locator<WinnerService>();
  final GameRepo _gameRepo = locator<GameRepo>();
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
  TambolaBestTicketsModel? _bestTickets;
  int tambolaTicketCount = 0;
  int _matchedTicketCount = 0;
  int expiringTicketsCount = 0;
  Winners? winnerData;

  bool _isScreenLoading = true;
  bool _isLoading = false;
  bool isEligible = false;
  bool showWinScreen = false;
  bool noMoreTickets = false;

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

  List<int>? get todaysPicks => _todaysPicks;

  set todaysPicks(List<int>? value) {
    _todaysPicks = value;
    notifyListeners();
  }

  DailyPick? get weeklyPicks => this._weeklyPicks;

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
    if (winnersModel.timestamp!.toDate().weekday == DateTime.now().weekday) {
      if (pastWeekWinners!.indexWhere(
              (winner) => winner.userid == _userService.baseUser!.uid) !=
          -1) {
        winnerData = pastWeekWinners!.firstWhere(
            (winner) => winner.userid == _userService.baseUser!.uid);
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

  Future<void> getBestTambolaTickets() async {
    final ticketsResponse = await _tambolaRepo.getBestTickets();
    if (ticketsResponse.isSuccess()) {
      bestTickets = ticketsResponse.model;
    } else {
      //TODO: FAILED TO FETCH TAMBOLA TICKETS. HANDLE FAIL CASE
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
        }
        notifyListeners();
      } else {}
    } catch (e) {
      _logger.e('$e');
    }
  }

  // Future<void> examineTicketsForWins() async {
  //   if (bestTickets == null ||
  //       bestTickets?.data == null ||
  //       weeklyPicks == null ||
  //       weeklyPicks!.toList().length != 7 * 3 ||
  //       weeklyPicks!.toList().contains(-1) ||
  //       DateTime.now().weekday != 7) {
  //     _logger.i('Testing is not ready yet');
  //     return;
  //   }
  //   final tambolaTickets = bestTickets?.data?.allTickets();
  //   for (final boardObj in tambolaTickets!) {
  //     if (boardObj.assignedTime.toDate().weekday == 7 &&
  //         boardObj.assignedTime.toDate().hour > 18) continue;
  //     if (getCornerOdds(
  //             boardObj, weeklyPicks!.getPicksPostDate(DateTime.monday)) ==
  //         0) {
  //       if (boardObj.getTicketNumber() != 'NA') {
  //         ticketCodeWinIndex[boardObj.getTicketNumber()] =
  //             Constants.CORNERS_COMPLETED;
  //       }
  //     }
  //     if (getOneRowOdds(
  //             boardObj, weeklyPicks!.getPicksPostDate(DateTime.monday)) ==
  //         0) {
  //       if (boardObj.getTicketNumber() != 'NA') {
  //         ticketCodeWinIndex[boardObj.getTicketNumber()] =
  //             Constants.ONE_ROW_COMPLETED;
  //       }
  //     }
  //     if (getTwoRowOdds(
  //             boardObj, weeklyPicks!.getPicksPostDate(DateTime.monday)) ==
  //         0) {
  //       if (boardObj.getTicketNumber() != 'NA') {
  //         ticketCodeWinIndex[boardObj.getTicketNumber()] =
  //             Constants.TWO_ROWS_COMPLETED;
  //       }
  //     }
  //     if (getFullHouseOdds(
  //             boardObj, weeklyPicks!.getPicksPostDate(DateTime.monday)) ==
  //         0) {
  //       if (boardObj.getTicketNumber() != 'NA') {
  //         ticketCodeWinIndex[boardObj.getTicketNumber()] =
  //             Constants.FULL_HOUSE_COMPLETED;
  //       }
  //     }
  //   }
  //   showWinScreen = PreferenceHelper.getBool(
  //       PreferenceHelper.SHOW_TAMBOLA_PROCESSING,
  //       def: true);

  //   double totalInvestedPrinciple =
  //       locator<UserService>().userFundWallet!.augGoldPrinciple;
  // isEligible = totalInvestedPrinciple >=
  //     BaseUtil.toInt(
  //       AppConfig.getValue(AppConfigKey.unlock_referral_amt),
  //     );

  //   isEligible = true;
  //   _logger.i('Resultant wins: ${ticketCodeWinIndex.toString()}');
  //   await getPrizes();
  //   if (showWinScreen) {
  //     AppState.delegate!.appState.currentAction = PageAction(
  //       state: PageState.addWidget,
  //       page: TWeeklyResultPageConfig,
  //       widget: WeeklyResult(
  //         winningsMap: ticketCodeWinIndex,
  //         isEligible: isEligible,
  //       ),
  //     );
  //   }
  //   showWinScreen = false;
  //   unawaited(PreferenceHelper.setBool(
  //       PreferenceHelper.SHOW_TAMBOLA_PROCESSING, showWinScreen));
  //   S locale = locator<S>();
  //   if (ticketCodeWinIndex.isNotEmpty && showWinScreen) {
  //     BaseUtil.showPositiveAlert(
  //       locale.tambolaTicketWinAlert1,
  //       locale.tambolaTicketWinAlert2,
  //     );
  //   }

  //   if (DateTime.now().weekday == DateTime.sunday &&
  //       DateTime.now().hour >= 18) {
  //     notifyListeners();
  //   }
  // }
}
