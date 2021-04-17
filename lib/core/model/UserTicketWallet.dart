import 'package:felloapp/util/logger.dart';

class UserTicketWallet{
  static Log log = new Log('UserTicketWallet');

  int _augGold99Tck;
  int _icici1565Tck;
  int _initTck;
  int _prizeTck;
  int _refTck;
  List<NonRecurringTicket> _activeNRTck;
  List<LockedTicket> _lockedTck;

  static final String fldAugmontGoldTckCount = 'gAUGGOLD99';
  static final String fldAugmontICICI1565TckCount = 'gICICI1565';
  static final String fldInitTckCount = 'gINIT';
  static final String fldPrizeRecurringTckCount = 'gPRIZE';

  static final String fldPrizeNonRecurringPrefix = 'gPRIZE';
  static final String fldReferralNonRecurringPrefix = 'gREF';

  static final String fldReferralLockedTckCount = 'gREF_LOCK';


  UserTicketWallet(this._augGold99Tck, this._icici1565Tck, this._initTck,
      this._prizeTck, this._refTck, this._activeNRTck, this._lockedTck);

  UserTicketWallet.fromMap(Map<String, dynamic> tMap) {
    // if(tMap.is)
  }
}

class NonRecurringTicket{
  final String type;
  final int weekCode;
  final int dayCode;
  final int tckCount;

  NonRecurringTicket(this.type, this.weekCode, this.dayCode, this.tckCount);
}

class LockedTicket{
  final String type;
  final String tckCount;

  LockedTicket(this.type, this.tckCount);
}