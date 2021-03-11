import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class UserTransaction{
  static Log log = new Log('UserTransaction');
  String _docKey;
  double _amount;
  int _closingBalance;
  String _note;
  String _subType;
  int _ticketUpCount;
  String _type;
  String _userId;
  String _tranId;
  String _multipleId;
  String _bankRnn;
  String _tranStatus;
  String _upiTime;
  Map<String, dynamic> _rzp;
  Map<String, dynamic> _augmnt;
  Timestamp _timestamp;
  Timestamp _updatedTime;

  static final String fldAmount = 'tAmount';
  static final String fldClosingBalance = 'tClosingBalance';
  static final String fldNote = 'tNote';
  static final String fldSubType = 'tSubtype';
  static final String fldType = 'tType';
  static final String fldTicketUpCount = 'tTicketUpdCount';
  static final String fldUserId = 'tUserId';
  static final String fldTimestamp = 'timestamp';
  static final String fldUpdatedTime = 'tUpdateTime';
  static final String fldTranId = 'tTranId';
  static final String fldMultipleId = 'tMultipleId';
  static final String fldBankRnn = 'tBankRnn';
  static final String fldRzpMap = 'tRzpMap';
  static final String fldAugmontMap = 'tAugmontMap';
  static final String fldTranStatus = 'tTranStatus';
  static final String fldUpiTime = 'tUpiDateTime';

  //razorpay submap fields
  static final String subFldRzpOrderId = 'rOrderId';
  static final String subFldRzpPaymentId = 'rPaymentId';
  static final String subFldRzpStatus = 'rStatus';

  //augmont submap fields
  static final String subFldAugBlockId = 'aBlockId';
  static final String subFldAugLockPrice = 'aLockPrice';
  static final String subFldAugPaymode = 'aPaymode';
  static final String subFldMerchantTranId = 'aTranId';
  static final String subFldAugTranId = 'aAugTranId';

  static const String TRAN_STATUS_PENDING = 'PENDING';
  static const String TRAN_STATUS_COMPLETE = 'COMPLETE';
  static const String TRAN_STATUS_CANCELLED = 'CANCELLED';

  static const String RZP_TRAN_STATUS_NEW = 'NEW';
  static const String RZP_TRAN_STATUS_FAILED = 'FAILED';
  static const String RZP_TRAN_STATUS_COMPLETE = 'COMPLETE';

  static const String TRAN_TYPE_DEPOSIT = 'DEPOSIT';
  static const String TRAN_TYPE_WITHDRAW = 'WITHDRAWAL';

  static const String TRAN_SUBTYPE_ICICI_DEPOSIT = 'ICICI1565';
  static const String TRAN_SUBTYPE_AUGMONT_GOLD = 'AUGGOLD99';

  UserTransaction(this._amount,this._closingBalance,this._note,this._subType,
      this._type,this._ticketUpCount,this._userId,this._tranId,this._multipleId,
      this._bankRnn, this._upiTime, this._tranStatus, this._rzp, this._augmnt, this._timestamp,this._updatedTime);

  UserTransaction.fromMap(Map<String, dynamic> data, String documentID):
        this(data[fldAmount], data[fldClosingBalance], data[fldNote], data[fldSubType],
        data[fldType], data[fldTicketUpCount], data[fldUserId], data[fldTranId], data[fldMultipleId],
        data[fldBankRnn], data[fldUpiTime], data[fldTranStatus], data[fldRzpMap],data[fldAugmontMap],data[fldTimestamp],
        data[fldUpdatedTime]);

  //ICICI investment initiated by new investor
  UserTransaction.newMFDeposit(String tranId, String multipleId, String upiTimestamp, double amount, String userId):
      this(amount,0,'NA',TRAN_SUBTYPE_ICICI_DEPOSIT,TRAN_TYPE_DEPOSIT,0,userId,tranId,multipleId,
      null, upiTimestamp, TRAN_STATUS_PENDING, null,null,Timestamp.now(),Timestamp.now());

  //ICICI investment initiated by existing investor
  UserTransaction.extMFDeposit(String tranId, String multipleId, double amount, String upiTimestamp, String userId):
        this(amount,0,'NA',TRAN_SUBTYPE_ICICI_DEPOSIT,TRAN_TYPE_DEPOSIT,0,userId,tranId,
          multipleId, null,upiTimestamp, TRAN_STATUS_PENDING, null,null,Timestamp.now(),Timestamp.now());

  //ICICI withdrawal initiated and completed by active investor
  UserTransaction.extMFWithdrawal(String tranId, String bankRnn, String note, String upiTimestamp,
      double amount, String userId):
        this(amount,0,note??'NA',TRAN_SUBTYPE_ICICI_DEPOSIT,TRAN_TYPE_WITHDRAW,0,userId,tranId,
          null, bankRnn, upiTimestamp, TRAN_STATUS_COMPLETE, null,null,Timestamp.now(),Timestamp.now());

  //Augmont gold investment initiated by investor
  UserTransaction.newGoldDeposit(double amount, String blockId, double lockPrice, String paymode, String userId):
        this(amount, 0, 'NA', TRAN_SUBTYPE_AUGMONT_GOLD, TRAN_TYPE_DEPOSIT, 0, userId,null,null,null,null,TRAN_STATUS_PENDING,null,
          {subFldAugBlockId: blockId, subFldAugLockPrice: lockPrice, subFldAugPaymode: paymode}, Timestamp.now(),Timestamp.now());

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
      fldBankRnn: _bankRnn,
      fldRzpMap: _rzp,
      fldAugmontMap: _augmnt,
      fldTranStatus: _tranStatus,
      fldUpiTime: _upiTime
    };
  }

  bool isExpired() {
    DateTime txnTime = _updatedTime.toDate();
    DateTime nowTime = DateTime.now();
    DateTime txnExpireTime = txnTime.add(new Duration(hours: 1));

    return nowTime.isAfter(txnExpireTime);
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

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  String get bankRnn => _bankRnn;

  set bankRnn(String value) {
    _bankRnn = value;
  }

  String get upiTime => _upiTime;

  set upiTime(String value) {
    _upiTime = value;
  }

  Map<String, dynamic> get rzp => _rzp;

  set rzp(Map<String, dynamic> value) {
    _rzp = value;
  }

  Map<String, dynamic> get augmnt => _augmnt;

  set augmnt(Map<String, dynamic> value) {
    _augmnt = value;
  }

  String get docKey => _docKey;

  set docKey(String value) {
    _docKey = value;
  }
}