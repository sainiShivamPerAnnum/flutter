import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/internal_ops_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:felloapp/util/custom_logger.dart';

import '../../repository/ticket_repo.dart';

class TambolaService extends ChangeNotifier {
  CustomLogger _logger = locator<CustomLogger>();
  DBModel _dbModel = locator<DBModel>();
  UserService _userService = locator<UserService>();
  final _tambolaRepo = locator<TambolaRepo>();
  final internalOps = locator<InternalOpsRepository>();

  static int _ticketCount;
  static int _dailyPicksCount;
  static List<int> _todaysPicks;
  static DailyPick _weeklyDigits;
  static List<TambolaBoard> _userWeeklyBoards;
  static bool _weeklyDrawFetched = false;
  static bool _weeklyTicksFetched = false;
  static bool _winnerDialogCalled = false;
  int _atomicTicketGenerationLeftCount;
  int _atomicTicketDeletionLeftCount;
  int ticketGenerateCount;

  signOut() {
    _weeklyDrawFetched = false;
    _weeklyTicksFetched = false;
    _winnerDialogCalled = false;
    _weeklyDigits = null;
    _todaysPicks = null;
    _ticketCount = null;
    _userWeeklyBoards = null;
  }

  int get ticketCount => _ticketCount;

  get atomicTicketGenerationLeftCount => _atomicTicketGenerationLeftCount;

  get atomicTicketDeletionLeftCount => _atomicTicketDeletionLeftCount;

  get winnerDialogCalled => _winnerDialogCalled;

  get weeklyTicksFetched => _weeklyTicksFetched;

  get weeklyDrawFetched => _weeklyDrawFetched;

  get dailyPicksCount => _dailyPicksCount;

  set setTicketCount(int val) {
    _ticketCount = val;
    _logger.d("Ticket Wallet updated");
    notifyListeners();
  }

  set dailyPicksCount(value) {
    _dailyPicksCount = value;
    notifyListeners();
  }

  get todaysPicks => _todaysPicks;

  set todaysPicks(value) {
    _todaysPicks = value;
    notifyListeners();
  }

  get weeklyDigits => _weeklyDigits;

  set weeklyDigits(value) {
    _weeklyDigits = value;
    notifyListeners();
  }

  get userWeeklyBoards => _userWeeklyBoards;

  set userWeeklyBoards(value) {
    _userWeeklyBoards = value;
    notifyListeners();
  }

  set weeklyDrawFetched(value) {
    _weeklyDrawFetched = value;
  }

  set weeklyTicksFetched(value) {
    _weeklyTicksFetched = value;
  }

  set winnerDialogCalled(value) {
    _winnerDialogCalled = value;
  }

  set atomicTicketGenerationLeftCount(value) {
    _atomicTicketGenerationLeftCount = value;
    notifyListeners();
  }

  set atomicTicketDeletionLeftCount(val) {
    _atomicTicketDeletionLeftCount = val;
    notifyListeners();
  }

  init() {
    _atomicTicketGenerationLeftCount = 0;
    _atomicTicketDeletionLeftCount = 0;
    setUpDailyPicksCount();
  }

  Future<void> getTicketCount() async {
    final count = await _tambolaRepo.getTicketCount();
    if (count.code == 200) {
      setTicketCount = count.model;
    }
  }

  dump() {
    _dailyPicksCount = null;
    _todaysPicks = null;
    _weeklyDigits = null;
    _userWeeklyBoards = null;
    _weeklyDrawFetched = false;
    _weeklyTicksFetched = false;
    _winnerDialogCalled = false;
    _atomicTicketGenerationLeftCount = 0;
    _atomicTicketDeletionLeftCount = 0;
  }

  fetchWeeklyPicks({bool forcedRefresh = false}) async {
    if (forcedRefresh) weeklyDrawFetched = false;
    if (!weeklyDrawFetched) {
      try {
        _logger.i('Requesting for weekly picks');
        final DailyPick _picks = (await _tambolaRepo.getWeeklyPicks()).model;
        weeklyDrawFetched = true;
        if (_picks != null) {
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
        }
        if (todaysPicks == null) {
          _logger.i("Today's picks are not generated yet");
        }
        notifyListeners();
      } catch (e) {
        _logger.e('$e');
      }
    }
  }

  setUpDailyPicksCount() {
    String _dpc = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.TAMBOLA_DAILY_PICK_COUNT);
    if (_dpc == null || _dpc.isEmpty) _dpc = '3';
    dailyPicksCount = 3;
    try {
      dailyPicksCount = int.parse(_dpc);
    } catch (e) {
      _logger.e('key parsing failed: ' + e.toString());
      Map<String, String> errorDetails = {'error_msg': e.toString()};
      internalOps.logFailure(_userService.baseUser.uid,
          FailType.DailyPickParseFailed, errorDetails);
      dailyPicksCount = 3;
    }
    _logger.d("Daily picks count: $_dailyPicksCount");
  }
}
