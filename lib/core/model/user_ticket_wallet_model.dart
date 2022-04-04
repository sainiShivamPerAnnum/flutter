import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/logger.dart';

class UserTicketWallet {
  static Log log = new Log('UserTicketWallet');

  int _augGold99Tck;
  int _icici1565Tck;
  int _initTck;
  int _prizeTck; //recurring prize tickets
  int _refTck; //recurring referral tickets
  int _goldenRewTck; //tickets earned through golden ticket. recurring
  List<NonRecurringTicket> _activeNRTck;
  List<LockedTicket> _lockedTck;

  static final String fldAugmontGoldTckCount = 'gAUGGOLD99';
  static final String fldICICI1565TckCount = 'gICICI1565';
  static final String fldInitTckCount = 'gINIT';
  static final String fldPrizeRecurringTckCount = 'gPRIZE';
  static final String fldReferralRecurringTckCount = 'gREF';
  static final String fldGoldenRewardTckCount = 'gGOLDEN_TCK';

  static final String fldPrizeNonRecurringPrefix = 'gPRIZE';
  static final String fldReferralNonRecurringPrefix = 'gREF';

  static final String fldReferralLocked = 'gREF_LOCK';
  static final String fldPrizeLocked = 'gPRIZE_LOCK';

  static final String fldTicketGenerationCount = 'gGEN_LEFT_COUNT';
  static final String fldActiveTicketGenerationKey = 'gGEN_ACTIVE_KEY';

  UserTicketWallet(
      this._augGold99Tck,
      this._icici1565Tck,
      this._initTck,
      this._prizeTck,
      this._refTck,
      this._goldenRewTck,
      this._activeNRTck,
      this._lockedTck);

  UserTicketWallet.newTicketWallet() : this(0, 0, 0, 0, 0, 0, [], []);

  UserTicketWallet.fromMap(Map<String, dynamic> tMap) {
    _initTck =
        (_isValidField(tMap[fldInitTckCount])) ? tMap[fldInitTckCount] : 0;
    _augGold99Tck = (_isValidField(tMap[fldAugmontGoldTckCount]))
        ? tMap[fldAugmontGoldTckCount]
        : 0;
    _icici1565Tck = (_isValidField(tMap[fldICICI1565TckCount]))
        ? tMap[fldICICI1565TckCount]
        : 0;
    _prizeTck = (_isValidField(tMap[fldPrizeRecurringTckCount]))
        ? tMap[fldPrizeRecurringTckCount]
        : 0;
    _refTck = (_isValidField(tMap[fldReferralRecurringTckCount]))
        ? tMap[fldReferralRecurringTckCount]
        : 0;
    _goldenRewTck = (_isValidField(tMap[fldGoldenRewardTckCount]))
        ? tMap[fldGoldenRewardTckCount]
        : 0;
    _buildNonRecurringTicketBalance(tMap);
    _buildLockedTicketBalance(tMap);
  }

  ///all recurring tickets and all the non recurring tickets from this week
  ///this DOESNT include the locked tickets
  int getActiveTickets() {
    int _baseCount = _augGold99Tck +
        _icici1565Tck +
        _prizeTck +
        _initTck +
        _refTck +
        _goldenRewTck;
    if (_activeNRTck != null && _activeNRTck.length > 0) {
      for (NonRecurringTicket ticketCnt in _activeNRTck) {
        _baseCount = _baseCount + ticketCnt.tckCount;
      }
    }

    return _baseCount;
  }

  int getLockedTickets() {
    int _baseCount = 0;
    if (_lockedTck != null && _lockedTck.length > 0) {
      for (LockedTicket ticketCnt in _lockedTck) {
        _baseCount = _baseCount + ticketCnt.tckCount ?? 0;
      }
    }

    return _baseCount;
  }

  int getNRTicketBalance() {
    int _baseCount = 0;
    if (_activeNRTck != null && _activeNRTck.length > 0) {
      for (NonRecurringTicket ticketCnt in _activeNRTck) {
        _baseCount = _baseCount + ticketCnt.tckCount;
      }
    }
    return _baseCount;
  }

  ///NON RECURRING TICKET FIELD FORMAT
  /// gPREFIX_WEEKCODE_DAYCODE
  /// where PREFIX = {PRIZE, REF}
  /// WEEKCODE = weekcode for which ticket count is valid
  /// DAYCODE = the day of the week from when the ticket is valid
  _buildNonRecurringTicketBalance(Map<String, dynamic> tMap) {
    _activeNRTck = [];
    int _weekCde = CodeFromFreq.getYearWeekCode();
    for (String key in tMap.keys) {
      if (key.startsWith(fldReferralNonRecurringPrefix) ||
          key.startsWith(fldPrizeNonRecurringPrefix)) {
        //first break the parts
        List<String> _strList = key.split('_');
        if (_strList.length < 2) {
          log.error('Invalid format for entry');
          continue;
        }
        int _itemWeekCode, _itemDayCode;
        //find the weekcode
        try {
          _itemWeekCode = int.parse(_strList[1]);
        } catch (e) {
          log.error('Week code parse failed');
        }
        //check whether weekcode is more than todays weekcode
        if (_itemWeekCode == null || _itemWeekCode < _weekCde) {
          //these are irrelevant
          continue;
        }
        //see if the day code is available
        if (_strList.length == 3) {
          //this means the weekcode and daycode both are mentioned
          try {
            _itemDayCode = int.parse(_strList[2]);
          } catch (e) {
            log.error('Day code parse failed');
          }
        }
        if (_itemWeekCode != null && _isValidField(tMap[key])) {
          NonRecurringTicket _ticketCnt = NonRecurringTicket(
              _strList[0], _itemWeekCode, _itemDayCode, tMap[key]);
          _activeNRTck.add(_ticketCnt);
        }
      }
    }
  }

  ///LOCKED TICKET FIELD FORMAT
  /// gREF_LOCK
  /// gPRIZE_LOCK
  /// where SUFFIX = {REF}
  _buildLockedTicketBalance(Map<String, dynamic> tMap) {
    _lockedTck = [];
    int _refLockedTck =
        (_isValidField(tMap[fldReferralLocked])) ? tMap[fldReferralLocked] : 0;
    if (_refLockedTck > 0) _lockedTck.add(LockedTicket("REF", _refLockedTck));

    int _prizeLockedTck =
        (_isValidField(tMap[fldPrizeLocked])) ? tMap[fldPrizeLocked] : 0;
    if (_prizeLockedTck > 0)
      _lockedTck.add(LockedTicket("PRIZE", _prizeLockedTck));
  }

  bool _isValidField(dynamic fld) {
    if (fld == null) return false;
    try {
      int y = _cast<int>(fld);
      if (y != null) return true;
    } catch (e) {}

    return false;
  }

  ///pick the NR Ticket that is expiring most recently
  ///compose the date string for it and return
  String getNRExpiryDate() {
    if (_activeNRTck == null || _activeNRTck.isEmpty) return '';
    int _recentWeekNumber = 99;
    for (NonRecurringTicket tck in _activeNRTck) {
      int _wk = tck.weekCode;
      if (_wk == null || _wk == 0) continue;
      _wk = _wk % 100; //removing year from _wk
      if (_wk < _recentWeekNumber) _recentWeekNumber = _wk;
    }
    if (_recentWeekNumber == 99) return '';

    //now we have the most recent week code
    //construct date string
    try {
      var date = ((_recentWeekNumber - 1) * 7);
      var weekEnd =
          DateTime.utc(DateTime.now().year, 1, date).toLocal().weekday;
      var endDate = date + (7 - weekEnd);
      int endDay = DateTime.utc(DateTime.now().year, 1, endDate).toLocal().day;
      int endMon =
          DateTime.utc(DateTime.now().year, 1, endDate).toLocal().month;
      String endMonth = BaseUtil.getMonthName(monthNum: endMon);

      return '$endDay $endMonth';
    } catch (e) {
      return '';
    }
  }

  static T _cast<T>(x) => x is T ? x : null;

  List<LockedTicket> get lockedTck => _lockedTck;

  set lockedTck(List<LockedTicket> value) {
    _lockedTck = value;
  }

  List<NonRecurringTicket> get activeNRTck => _activeNRTck;

  set activeNRTck(List<NonRecurringTicket> value) {
    _activeNRTck = value;
  }

  int get refTck => _refTck;

  set refTck(int value) {
    _refTck = value;
  }

  int get prizeTck => _prizeTck;

  set prizeTck(int value) {
    _prizeTck = value;
  }

  int get initTck => _initTck;

  set initTck(int value) {
    _initTck = value;
  }

  int get icici1565Tck => _icici1565Tck;

  set icici1565Tck(int value) {
    _icici1565Tck = value;
  }

  int get augGold99Tck => _augGold99Tck;

  set augGold99Tck(int value) {
    _augGold99Tck = value;
  }

  int get goldenRewTck => _goldenRewTck;

  set goldenRewTck(int value) {
    _goldenRewTck = value;
  }
}

class NonRecurringTicket {
  final String type;
  final int weekCode;
  final int dayCode;
  final int tckCount;

  NonRecurringTicket(this.type, this.weekCode, this.dayCode, this.tckCount);
}

class LockedTicket {
  final String type;
  final int tckCount;

  LockedTicket(this.type, this.tckCount);
}
