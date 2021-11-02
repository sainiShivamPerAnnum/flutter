import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/util/logger.dart';

class UserMiniTransaction {
  static Log log = new Log('UserMiniTransaction');
  double _amount;
  int _closingBalance;
  String _type;
  String _subType;
  String _tranStatus;
  Timestamp _timestamp;
  String _note;

  UserMiniTransaction(this._amount, this._closingBalance, this._type,
      this._subType, this._tranStatus, this._timestamp, this._note);

  UserMiniTransaction.fromMap(Map<String, dynamic> data)
      : this(
          toDouble(data[UserTransaction.fldAmount]),
          data[UserTransaction.fldClosingBalance],
          data[UserTransaction.fldType],
          data[UserTransaction.fldSubType],
          data[UserTransaction.fldTranStatus],
          data[UserTransaction.fldTimestamp],
          data[UserTransaction.fldNote],
        );

  static double toDouble(dynamic fld) {
    double res = 0;
    try {
      res = fld;
      return res;
    } catch (e) {}

    try {
      int p = fld;
      return p + .0;
    } catch (err) {}

    return res;
  }

  String get note => _note;

  Timestamp get timestamp => _timestamp;

  String get tranStatus => _tranStatus;

  String get subType => _subType;

  String get type => _type;

  int get closingBalance => _closingBalance;

  double get amount => _amount;
}
