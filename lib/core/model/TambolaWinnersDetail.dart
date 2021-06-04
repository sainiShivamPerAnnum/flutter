import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/logger.dart';

class TambolaWinnersDetail {
  static Log log = new Log('TambolaWinnersDetail');
  static const String WIN_TYPE = 'tambola';

  int _weeksAvgTicketCount;
  int _highestTicketCount;
  int _totalWinners;
  List<WeekWinner> _winnerList;

  TambolaWinnersDetail(this._weeksAvgTicketCount, this._highestTicketCount,
      this._totalWinners, this._winnerList);

  TambolaWinnersDetail.fromMap(Map<String, dynamic> data) {
    //first compile stats
    try {
      _weeksAvgTicketCount = BaseUtil.toInt(data['avg_tck_cnt']);
      _totalWinners = BaseUtil.toInt(data['tot_winners']);
      _highestTicketCount = BaseUtil.toInt(data['high_tck_cnt']);
    } catch (e) {}
    //now compile winner list
    try {
      Map<String, dynamic> _winners = data['winners'];
      if (_winners != null && _winners.isNotEmpty) {
        for (String wKey in _winners.keys) {
          try {
            Map<String, dynamic> wValue = _winners[wKey];
            WeekWinner _weekWinner = new WeekWinner(uid: wKey,
                name: wValue['name'],
                prize: wValue['prize'],
                claimType: wValue['claim_type']);
            _winnerList.add(_weekWinner);
          }catch(error) {
            log.error('Failed to create WeekWinner object');
          }
        }
      }
    } catch (err) {

    }
  }

  isUserPrizeClaimComplete(String uid) {
    for(WeekWinner winner in _winnerList) {
      if(winner.uid == uid) return winner.claimType != 'NA';
    }
    return false;
  }

  getClaimTypeUpdateMap(String myUid, String type) {
    String key = 'winners.$myUid.claim_data';

    return {key: type};
  }

  int get totalWinners => _totalWinners;

  int get highestTicketCount => _highestTicketCount;

  int get weeksAvgTicketCount => _weeksAvgTicketCount;

  List<WeekWinner> get winnerList => _winnerList;

  set winnerList(List<WeekWinner> value) {
    _winnerList = value;
  }
}

class WeekWinner {
  final String uid;
  final String name;
  final int prize;
  String claimType;

  WeekWinner({this.uid, this.name, this.prize, this.claimType});
}