import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/logger.dart';

class TambolaWinnersDetail {
  static Log log = new Log('TambolaWinnersDetail');
  static const String WIN_TYPE = 'tambola';

  String _winnerDocumentId;
  int _weeksAvgTicketCount;
  int _highestTicketCount;
  int _totalWinners;
  List<WeekWinner> _winnerList;

  TambolaWinnersDetail(this._winnerDocumentId, this._weeksAvgTicketCount,
      this._highestTicketCount, this._totalWinners, this._winnerList);

  TambolaWinnersDetail.fromMap(Map<String, dynamic> data, String id) {
    this._winnerDocumentId = id;
    //first compile stats
    Map<String, dynamic> _stats = data['stats'];
    if (_stats != null && _stats.isNotEmpty) {
      try {
        _weeksAvgTicketCount = BaseUtil.toInt(data['stats']['avg_tck_cnt']);
        _totalWinners = BaseUtil.toInt(data['stats']['tot_winners']);
        _highestTicketCount = BaseUtil.toInt(data['stats']['high_tck_cnt']);
      } catch (e) {}
    }
    //now compile winner list
    Map<String, dynamic> _winners = data['winners'];
    _winnerList = [];
    if (_winners != null && _winners.isNotEmpty) {
      for (String wKey in _winners.keys) {
        try {
          Map<String, dynamic> wValue = _winners[wKey];
          WeekWinner _weekWinner = new WeekWinner(
              wKey,
              wValue['name'],
              BaseUtil.toDouble(wValue['prize']),
              _getChoiceEnumValue(wValue['claim_type']));
          _winnerList.add(_weekWinner);
        } catch (error) {
          log.error('Failed to create WeekWinner object');
        }
      }
    }
    log.debug(_winnerList.toString());
  }

  bool isUserPrizeClaimComplete(String uid) {
    for (WeekWinner winner in _winnerList) {
      if (winner.uid == uid) return winner.claimChoice != PrizeClaimChoice.NA;
    }
    return false;
  }

  PrizeClaimChoice _getChoiceEnumValue(String value) {
    if (value == null || value.isEmpty)
      return PrizeClaimChoice.NA;
    else if (value == 'NA')
      return PrizeClaimChoice.NA;
    else if (value == 'AMZ_VOUCHER')
      return PrizeClaimChoice.AMZ_VOUCHER;
    else if (value == 'GOLD_CREDIT')
      return PrizeClaimChoice.GOLD_CREDIT;
    else
      return PrizeClaimChoice.NA;
  }

  bool get isWinnerListAvailable =>
      (_winnerList != null && _winnerList.length > 0);

  int get totalWinners => _totalWinners;

  int get highestTicketCount => _highestTicketCount;

  int get weeksAvgTicketCount => _weeksAvgTicketCount;

  String get winnerDocumentId => _winnerDocumentId;

  List<WeekWinner> get winnerList => (_winnerList == null) ? {} : _winnerList;

  set winnerList(List<WeekWinner> value) {
    _winnerList = value;
  }
}

class WeekWinner {
  final String _uid;
  final String _name;
  final double _prize;
  PrizeClaimChoice claimChoice;

  WeekWinner(this._uid, this._name, this._prize, this.claimChoice);

  double get prize => (_prize == null) ? 0.0 : _prize;

  String get name => (_name == null) ? 'Anonymous' : _name;

  String get uid => _uid;
}

enum PrizeClaimChoice { NA, AMZ_VOUCHER, GOLD_CREDIT, FELLO_PRIZE }

extension ParseToString on PrizeClaimChoice {
  String value() {
    return this.toString().split('.').last;
  }
}
