import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class UserTransaction{
  static Log log = new Log('UserTransaction');
  String _docKey;
  double _amount;
  double _closingBalance;
  String _note;
  String _subType;
  String _type;
  String _userId;
  String _tranId;
  String _multipleId;
  String _tranStatus;
  Timestamp _timestamp;
  Timestamp _updatedTime;

  static final String fldAmount = 'tAmount';
  static final String fldClosingBalance = 'tClosingBalance';
  static final String fldNote = 'tNote';
  static final String fldSubType = 'tSubtype';
  static final String fldType = 'tType';
  static final String fldUserId = 'tUserId';
  static final String fldTimestamp = 'timestamp';
  static final String fldUpdatedTime = 'tUpdateTime';
  static final String fldTranId = 'tTranId';
  static final String fldMultipleId = 'tMultipleId';
  static final String fldTranStatus = 'tTranStatus';

  static const String TRAN_STATUS_PENDING = 'PENDING';
  static const String TRAN_STATUS_COMPLETE = 'COMPLETE';
  static const String TRAN_STATUS_CANCELLED = 'CANCELLED';

  static const String TRAN_TYPE_DEPOSIT = 'DEPOSIT';
  static const String TRAN_TYPE_WITHDRAW = 'WITHDRAWAL';
  static const String TRAN_SUBTYPE_ICICI_DEPOSIT = 'ICICI1565';

  UserTransaction(this._amount,this._closingBalance,this._note,this._subType,
      this._type,this._userId,this._tranId,this._multipleId,this._tranStatus,
      this._timestamp,this._updatedTime);
  
  UserTransaction.fromMap(Map<String, dynamic> data, String documentID):
        this(data[fldAmount], data[fldClosingBalance], data[fldNote], data[fldSubType],
        data[fldType], data[fldUserId], data[fldTranId], data[fldMultipleId],
        data[fldTranStatus], data[fldTimestamp], data[fldUpdatedTime]);
  
  UserTransaction.newMFDeposit(String tranId, String multipleId, double amount, String userId):
      this(amount,0,'NA',TRAN_SUBTYPE_ICICI_DEPOSIT,TRAN_TYPE_DEPOSIT,userId,tranId,multipleId,
      TRAN_STATUS_PENDING,Timestamp.now(),Timestamp.now());

  toJson() {
    return {
      fldAmount: _amount,
      fldClosingBalance: _closingBalance,
      fldNote: _note,
      fldSubType: _subType,
      fldType: _type,
      fldUserId: _userId,
      fldTimestamp: _timestamp,
      fldUpdatedTime: Timestamp.now(),
      fldTranId: _tranId,
      fldMultipleId: _multipleId,
      fldTranStatus: _tranStatus
    };
  }

  String get tranStatus => _tranStatus;

  set tranStatus(String value) {
    _tranStatus = value;
  }

  String get multipleId => _multipleId;

  set multipleId(String value) {
    _multipleId = value;
  }

  String get tranId => _tranId;

  set tranId(String value) {
    _tranId = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get subType => _subType;

  set subType(String value) {
    _subType = value;
  }

  String get note => _note;

  set note(String value) {
    _note = value;
  }

  double get closingBalance => _closingBalance;

  set closingBalance(double value) {
    _closingBalance = value;
  }

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  String get docKey => _docKey;

  set docKey(String value) {
    _docKey = value;
  }
}