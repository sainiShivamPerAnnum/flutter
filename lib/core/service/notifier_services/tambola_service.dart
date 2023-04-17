import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../repository/ticket_repo.dart';

class TambolaService extends ChangeNotifier {
  final CustomLogger _logger = locator<CustomLogger>();
  final UserService _userService = locator<UserService>();
  final TambolaRepo _tambolaRepo = locator<TambolaRepo>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();

  static int? ticketCount;
  static int? _dailyPicksCount = 3;
  static List<int>? _todaysPicks;
  static DailyPick? _weeklyDigits;
  static List<TambolaBoard?>? _userWeeklyBoards;
  static bool _weeklyDrawFetched = false;
  static bool _weeklyTicksFetched = false;
  static bool _winnerDialogCalled = false;
  int? _atomicTicketGenerationLeftCount;
  int? _atomicTicketDeletionLeftCount;
  int? ticketGenerateCount;
  int? initialTicketCount;
  int matchedTicketCount = 0;
  List<List<int>> _ticketsNumbers = [];

  late Completer<List<TambolaBoard?>?> completer;

  void signOut() {
    _weeklyDrawFetched = false;
    _weeklyTicksFetched = false;
    _winnerDialogCalled = false;
    _weeklyDigits = null;
    _todaysPicks = null;
    // _ticketCount = null;
    _userWeeklyBoards = null;
    matchedTicketCount = 0;
    _ticketsNumbers = [];
  }

  List<List<int>> get ticketsNumbers => _ticketsNumbers;

  set ticketsNumbers(List<List<int>> value) {
    _ticketsNumbers = value;
    notifyListeners();
  }

  get atomicTicketGenerationLeftCount => _atomicTicketGenerationLeftCount;

  get atomicTicketDeletionLeftCount => _atomicTicketDeletionLeftCount;

  get winnerDialogCalled => _winnerDialogCalled;

  get weeklyTicksFetched => _weeklyTicksFetched;

  get weeklyDrawFetched => _weeklyDrawFetched;

  get dailyPicksCount => _dailyPicksCount;

  // set setTicketCount(int? val) {
  //   _ticketCount = val;
  //   _logger!.d("Ticket Wallet updated");
  //   notifyListeners();
  // }

  set dailyPicksCount(value) {
    _dailyPicksCount = value;
    notifyListeners();
  }

  List<int>? get todaysPicks => _todaysPicks;

  set todaysPicks(value) {
    _todaysPicks = value;
    notifyListeners();
  }

  get weeklyDigits => _weeklyDigits;

  set weeklyDigits(value) {
    _weeklyDigits = value;
    notifyListeners();
  }

  List<TambolaBoard?>? get userWeeklyBoards => _userWeeklyBoards;

  set userWeeklyBoards(List<TambolaBoard?>? value) {
    _userWeeklyBoards = value;
    notifyListeners();
  }

  bool isTambolaBoardUpdated = false;

  set weeklyDrawFetched(value) {
    _weeklyDrawFetched = value;
  }

  set weeklyTicksFetched(value) {
    _weeklyTicksFetched = value;
  }

  set winnerDialogCalled(value) {
    _winnerDialogCalled = value;
    notifyListeners();
  }

  set atomicTicketGenerationLeftCount(value) {
    _atomicTicketGenerationLeftCount = value;
    notifyListeners();
  }

  set atomicTicketDeletionLeftCount(val) {
    _atomicTicketDeletionLeftCount = val;
    notifyListeners();
  }

  Future<void> init() async {
    _atomicTicketGenerationLeftCount = 0;
    _atomicTicketDeletionLeftCount = 0;

    setUpDailyPicksCount();
    if (locator<RootController>()
        .navItems
        .containsValue(RootController.tambolaNavBar)) {
      await fetchTambolaBoard();

      await completer.future.then((value) {
        initialTicketCount = value?.length;
        highlightDailyPicks(_ticketsNumbers);
      });
    }
  }

  Future<void> fetchTambolaBoard() async {
    completer = Completer();
    if (_weeklyTicksFetched) {
      completer.complete(null);
      return;
    }

    _weeklyTicksFetched = true;
    _logger.d("Fetching Tambola tickets ${DateTime.now().second}");

    final tickets = await _tambolaRepo.getTickets();

    if (tickets.code != 200) {
      _logger.d(tickets.errorMessage);
      return;
    }

    List<TambolaBoard?> boards = tickets.model!.map((e) => e.board).toList();

    if (userWeeklyBoards != null && userWeeklyBoards!.length != boards.length) {
      isTambolaBoardUpdated = true;
      notifyListeners();
      isTambolaBoardUpdated = false;
    }

    _ticketsNumbers.clear();

    await Future.forEach(boards, (board) async {
      ticketsNumbers
          .add(board!.tambolaBoard!.expand((numbers) => numbers).toList());
    });
    // log('ticketsNumbers $ticketsNumbers');
    notifyListeners();

    _logger!.d("Fetched Tambola tickets ${DateTime.now().second}");
    userWeeklyBoards = boards;
    ticketCount = boards.length;
    completer.complete(boards);
  }

  Future<void> highlightDailyPicks(List<List<int>> ticketNumbersList) async {
    matchedTicketCount = 0;

    if (ticketNumbersList.isEmpty || (_todaysPicks?.isEmpty ?? true)) return;

    await Future.forEach(ticketNumbersList, (numsList) async {
      log('numsList $numsList --  todaysPicks $todaysPicks');

      if (_todaysPicks != null) {
        for (final int pick in _todaysPicks!) {
          if (numsList.contains(pick)) {
            matchedTicketCount++;
            break;
          }
        }
      }
    });

    notifyListeners();
  }

  void dump() {
    _dailyPicksCount = null;
    _todaysPicks = null;
    _weeklyDigits = null;
    _userWeeklyBoards = null;
    _weeklyDrawFetched = false;
    _weeklyTicksFetched = false;
    _winnerDialogCalled = false;
    _atomicTicketGenerationLeftCount = 0;
    _atomicTicketDeletionLeftCount = 0;
    _ticketsNumbers = [];
    matchedTicketCount = 0;
  }

  Future<void> fetchWeeklyPicks({bool forcedRefresh = false}) async {
    if (forcedRefresh) weeklyDrawFetched = false;
    if (!weeklyDrawFetched) {
      try {
        _logger!.i('Requesting for weekly picks');
        final ApiResponse picksResponse = await _tambolaRepo!.getWeeklyPicks();
        if (picksResponse.isSuccess()) {
          final DailyPick _picks = picksResponse.model!;
          weeklyDrawFetched = true;
          _logger!.d("Weekly pickst: ${_picks.toList().toString()}");
          weeklyDigits = _picks;
          switch (DateTime.now().weekday) {
            case 1:
              todaysPicks = weeklyDigits.mon;
              break;
            case 2:
              todaysPicks = weeklyDigits.tue;
              break;
            case 3:
              todaysPicks = weeklyDigits.wed;
              break;
            case 4:
              todaysPicks = weeklyDigits.thu;
              break;
            case 5:
              todaysPicks = weeklyDigits.fri;
              break;
            case 6:
              todaysPicks = weeklyDigits.sat;
              break;
            case 7:
              todaysPicks = weeklyDigits.sun;
              break;
          }
          if (todaysPicks == null) {
            _logger!.i("Today's picks are not generated yet");
          }
          notifyListeners();
        } else {
          //BaseUtil.showNegativeAlert(picksResponse.errorMessage, '');
        }
      } catch (e) {
        _logger!.e('$e');
      }
    }
  }

  void setUpDailyPicksCount() {
    String _dpc = (AppConfig.getValue(AppConfigKey.tambola_daily_pick_count)
            .toString()) ??
        '';
    if (_dpc.isEmpty) _dpc = '3';
    dailyPicksCount = 3;
    try {
      dailyPicksCount = int.parse(_dpc);
    } catch (e) {
      _logger!.e('key parsing failed: $e');
      Map<String, String> errorDetails = {'error_msg': e.toString()};
      _internalOpsService!.logFailure(_userService!.baseUser!.uid,
          FailType.DailyPickParseFailed, errorDetails);
      dailyPicksCount = 3;
    }
    _logger!.d("Daily picks count: $_dailyPicksCount");
  }
}
