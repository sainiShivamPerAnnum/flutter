import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class UserAugmontDetail {
  Log log = new Log('UserAugmontDetail');
  String _hasIssue;
  String _userId;
  String _userName;
  String _bankAccNo;
  String _bankHolderName;
  String _userStateId;
  String _ifsc;
  bool _firstInvMade;
  Timestamp _createdTime;
  Timestamp _updatedTime;

  static final String fldUserId = 'aUid';
  static final String fldUserName = 'aUsrName';
  static final String fldBankAccNo = 'aAccNo';
  static final String fldBankHolderName = 'aBankHolderName';
  static final String fldStateId = 'aStateId';
  static final String fldIfsc = 'aIfsc';
  static final String fldFirstInvMade = 'aIsInvested';
  static final String fldHasIssue = 'aHasIssue';
  static final String fldCreatedTime = 'aCreatedTime';
  static final String fldUpdatedTime = 'aUpdatedTime';

  UserAugmontDetail(
      this._userId,
      this._userName,
      this._bankAccNo,
      this._bankHolderName,
      this._ifsc,
      this._userStateId,
      this._firstInvMade,
      this._hasIssue,
      this._createdTime,
      this._updatedTime);

  UserAugmontDetail.newUser(String uid, String uname, String stateId,
      String bankHolderName, String bankAccNo, String ifsc)
      : this(uid, uname, bankAccNo, bankHolderName, ifsc, stateId, false, null,
            Timestamp.now(), Timestamp.now());

  UserAugmontDetail.fromMap(Map<String, dynamic> data)
      : this(
            data[fldUserId],
            data[fldUserName],
            data[fldBankAccNo],
            data[fldBankHolderName],
            data[fldIfsc],
            data[fldStateId],
            data[fldFirstInvMade] ?? false,
            data[fldHasIssue],
            data[fldCreatedTime],
            data[fldUpdatedTime]);

  toJson() {
    return {
      fldUserId: _userId,
      fldUserName: _userName,
      fldBankAccNo: _bankAccNo,
      fldBankHolderName: _bankHolderName,
      fldStateId: _userStateId,
      fldFirstInvMade: _firstInvMade,
      fldIfsc: _ifsc,
      fldCreatedTime: _createdTime,
      fldUpdatedTime: Timestamp.now()
    };
  }

  Timestamp get createdTime => _createdTime;

  set createdTime(Timestamp value) {
    _createdTime = value;
  }

  bool get firstInvMade => _firstInvMade;

  set firstInvMade(bool value) {
    _firstInvMade = value;
  }

  String get userStateId => _userStateId;

  set userStateId(String value) {
    _userStateId = value;
  }

  String get bankHolderName => _bankHolderName;

  set bankHolderName(String value) {
    _bankHolderName = value;
  }

  String get bankAccNo => _bankAccNo;

  set bankAccNo(String value) {
    _bankAccNo = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get hasIssue => _hasIssue;

  set hasIssue(String value) {
    _hasIssue = value;
  }

  String get ifsc => _ifsc;

  set ifsc(String value) {
    _ifsc = value;
  }
}
