import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/util/logger.dart';

class UserMiniTransaction {
  static Log log = new Log('UserMiniTransaction');
  double _amount;
  int _closingBalance;
  String _type;
  String _subType;
  String _tranStatus;
  Timestamp _updatedTime;
  String _note;

  UserMiniTransaction(
      this._amount,
      this._closingBalance,
      this._type,
      this._subType,
      this._tranStatus,
      this._updatedTime,
      this._note);

  UserMiniTransaction.fromMap(Map<String, dynamic> data):this(
    data[UserTransaction.fldAmount],data[UserTransaction.fldClosingBalance],
    data[UserTransaction.fldType],data[UserTransaction.fldSubType],
    data[UserTransaction.fldTranStatus],data[UserTransaction.fldUpdatedTime],
    data[UserTransaction.fldNote],
  );

  String get note => _note;

  Timestamp get updatedTime => _updatedTime;

  String get tranStatus => _tranStatus;

  String get subType => _subType;

  String get type => _type;

  int get closingBalance => _closingBalance;

  double get amount => _amount;
}