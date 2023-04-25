import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_ticket_model.dart';
import 'package:felloapp/feature/tambola/src/repos/tambola_repo.dart';
import 'package:felloapp/feature/tambola/src/ui/weekly_results_views/weekly_result.dart';
import 'package:felloapp/feature/tambola/src/utils/ticket_odds_calculator.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class TambolaService extends ChangeNotifier {
  //LOCATORS
  final CustomLogger _logger = locator<CustomLogger>();
  final TambolaRepo _tambolaRepo = locator<TambolaRepo>();
  final ScratchCardRepository _scRepo = locator<ScratchCardRepository>();
  final WinnerService _winnerService = locator<WinnerService>();
  final GameRepo _gameRepo = locator<GameRepo>();

  //STATIC VARIABLES
  static int? ticketCount;
  static List<int>? _todaysPicks;

  //LOCAL VARIABLES
  DailyPick? _weeklyPicks;
  GameModel? tambolaGameData;
  PrizesModel? tambolaPrizes;
  List<Winners>? pastWeekWinners;
  List<TambolaTicketModel>? tambolaTickets;
  Map<String, int> ticketCodeWinIndex = {};
  int activeTambolaCardCount = 0;
  int _matchedTicketCount = 0;
  bool _isScreenLoading = true;
  bool _isLoading = false;
  bool isEligible = false;
  bool showWinScreen = false;

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

  //CORE METHODS

  void init() {}

  void dump() {
    _weeklyPicks = null;
    _todaysPicks = null;
    matchedTicketCount = 0;
    tambolaTickets = null;
    log("Tambola service Dispose called");
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
    await getTambolaTickets();
    return tambolaTickets?.length ?? 0;
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
    notifyListeners();
  }

  Future<void> getTambolaTickets() async {
    final ticketsResponse = await _tambolaRepo.getTickets();
    if (ticketsResponse.isSuccess()) {
      tambolaTickets = ticketsResponse.model;
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

  Future<void> examineTicketsForWins() async {
    if (tambolaTickets == null ||
        tambolaTickets!.isEmpty ||
        weeklyPicks == null ||
        weeklyPicks!.toList().length != 7 * 3 ||
        weeklyPicks!.toList().contains(-1) ||
        DateTime.now().weekday != 7) {
      _logger.i('Testing is not ready yet');
      return;
    }

    for (final boardObj in tambolaTickets!) {
      if (getCornerOdds(
              boardObj, weeklyPicks!.getPicksPostDate(DateTime.monday)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA') {
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.CORNERS_COMPLETED;
        }
      }
      if (getOneRowOdds(
              boardObj, weeklyPicks!.getPicksPostDate(DateTime.monday)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA') {
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.ONE_ROW_COMPLETED;
        }
      }
      if (getTwoRowOdds(
              boardObj, weeklyPicks!.getPicksPostDate(DateTime.monday)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA') {
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.TWO_ROWS_COMPLETED;
        }
      }
      if (getFullHouseOdds(
              boardObj, weeklyPicks!.getPicksPostDate(DateTime.monday)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA') {
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.FULL_HOUSE_COMPLETED;
        }
      }
    }
    showWinScreen = PreferenceHelper.getBool(
        PreferenceHelper.SHOW_TAMBOLA_PROCESSING,
        def: true);

    double totalInvestedPrinciple =
        locator<UserService>().userFundWallet!.augGoldPrinciple;
    isEligible = totalInvestedPrinciple >=
        BaseUtil.toInt(BaseRemoteConfig.remoteConfig
            .getString(BaseRemoteConfig.UNLOCK_REFERRAL_AMT));

    isEligible = true;
    _logger.i('Resultant wins: ${ticketCodeWinIndex.toString()}');

    if (showWinScreen) {
      AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: TWeeklyResultPageConfig,
        widget: WeeklyResult(
          winningsMap: ticketCodeWinIndex,
          isEligible: isEligible,
        ),
      );
    }
    showWinScreen = false;
    S locale = locator<S>();
    if (ticketCodeWinIndex.isNotEmpty) {
      BaseUtil.showPositiveAlert(
        locale.tambolaTicketWinAlert1,
        locale.tambolaTicketWinAlert2,
      );
    }

    if (DateTime.now().weekday == DateTime.sunday &&
        DateTime.now().hour >= 18) {
      notifyListeners();
    }
    unawaited(PreferenceHelper.setBool(
        PreferenceHelper.SHOW_TAMBOLA_PROCESSING, false));
  }
}
