import 'package:felloapp/util/logger.dart';

class PrizeLeader {
  static Log log = new Log('PrizeLeader');
  String _id;
  String _name;
  double _totalWin;

  PrizeLeader(this._id, this._name, this._totalWin);

  double get totalWin => _totalWin;

  String get name => _name;

  String get id => _id;
}
