import 'package:felloapp/util/logger.dart';

class ReferralLeader {
  static Log log = new Log('ReferralLeader');
  String _id;
  String _name;
  int _refCount;

  ReferralLeader(this._id, this._name, this._refCount);

  int get refCount => _refCount;

  String get name => _name;

  String get id => _id;
}
