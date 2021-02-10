import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class UserTransaction{
  static Log log = new Log('UserTransaction');
  String _docKey;
  int _amount;
  int _closingBalance;
  String _note;
  String _subType;
  int _ticketUpCount;
  String _type;
  String _userId;
  String _tranId;
  String _multipleId;
  String _sessionId;
  String _tranStatus;
  String _upiTime;
  Timestamp _timestamp;
  Timestamp _updatedTime;


  static final String fldAmount = 'tAmount';
  static final String fldClosingBalance = 'tClosingBalance';
  static final String fldNote = 'tNote';
  static final String fldSubType = 'tSubtype';
  static final String fldType = 'tType';
  static final String fldTicketUpCount = 'tTicketUpCount';
  static final String fldUserId = 'tUserId';
  static final String fldTimestamp = 'timestamp';
  static final String fldUpdatedTime = 'tUpdateTime';
  static final String fldTranId = 'tTranId';
  static final String fldMultipleId = 'tMultipleId';
  static final String fldSessionId = 'tSessionId';
  static final String fldTranStatus = 'tTranStatus';
  static final String fldUpiTime = 'tUpiDateTime';

  static const String TRAN_STATUS_PENDING = 'PENDING';
  static const String TRAN_STATUS_COMPLETE = 'COMPLETE';
  static const String TRAN_STATUS_CANCELLED = 'CANCELLED';

  static const String TRAN_TYPE_DEPOSIT = 'DEPOSIT';
  static const String TRAN_TYPE_WITHDRAW = 'WITHDRAWAL';
  static const String TRAN_SUBTYPE_ICICI_DEPOSIT = 'ICICI1565';

  UserTransaction(this._amount,this._closingBalance,this._note,this._subType,
      this._type,this._ticketUpCount,this._userId,this._tranId,this._multipleId,this._sessionId, this._upiTime,
      this._tranStatus, this._timestamp,this._updatedTime);
  
  UserTransaction.fromMap(Map<String, dynamic> data, String documentID):
        this(data[fldAmount], data[fldClosingBalance], data[fldNote], data[fldSubType],
        data[fldType], data[fldTicketUpCount], data[fldUserId], data[fldTranId], data[fldMultipleId],
        data[fldUpiTime], data[fldSessionId], data[fldTranStatus], data[fldTimestamp], data[fldUpdatedTime]);

  //investment by new investor
  UserTransaction.newMFDeposit(String tranId, String multipleId, String upiTimestamp, int amount, String userId):
      this(amount,0,'NA',TRAN_SUBTYPE_ICICI_DEPOSIT,TRAN_TYPE_DEPOSIT,0,userId,tranId,multipleId,null,
      upiTimestamp, TRAN_STATUS_PENDING,Timestamp.now(),Timestamp.now());

  //investment by existing investor
  UserTransaction.extMFDeposit(String tranId, String sesionId, int amount, String userId):
        this(amount,0,'NA',TRAN_SUBTYPE_ICICI_DEPOSIT,TRAN_TYPE_DEPOSIT,0,userId,tranId,
          null,sesionId,null, TRAN_STATUS_PENDING,Timestamp.now(),Timestamp.now());

  toJson() {
    return {
      fldAmount: _amount,
      fldClosingBalance: _closingBalance,
      fldNote: _note,
      fldSubType: _subType,
      fldType: _type,
      fldTicketUpCount: _ticketUpCount,
      fldUserId: _userId,
      fldTimestamp: _timestamp,
      fldUpdatedTime: Timestamp.now(),
      fldTranId: _tranId,
      fldMultipleId: _multipleId,
      fldSessionId: _sessionId,
      fldTranStatus: _tranStatus,
      fldUpiTime: _upiTime
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

  String get sessionId => _sessionId;

  set sessionId(String value) {
    _sessionId = value;
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

  int get ticketUpCount => _ticketUpCount;

  set ticketUpCount(int value) {
    _ticketUpCount = value;
  }

  String get subType => _subType;

  set subType(String value) {
    _subType = value;
  }

  String get note => _note;

  set note(String value) {
    _note = value;
  }

  int get closingBalance => _closingBalance;

  set closingBalance(int value) {
    _closingBalance = value;
  }

  int get amount => _amount;

  set amount(int value) {
    _amount = value;
  }

  String get upiTime => _upiTime;

  set upiTime(String value) {
    _upiTime = value;
  }

  String get docKey => _docKey;

  set docKey(String value) {
    _docKey = value;
  }
}