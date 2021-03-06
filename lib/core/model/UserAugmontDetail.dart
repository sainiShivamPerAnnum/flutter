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
  bool _firstInvMade;
  Timestamp _createdTime;
  Timestamp _updatedTime;

  static final String fldUserId = 'aUid';
  static final String fldUserName = 'aUsrName';
  static final String fldBankAccNo = 'aAccNo';
  static final String fldBankHolderName = 'aBankHolderName';
  static final String fldStateId = 'aStateId';
  static final String fldCreatedTime = 'aCreatedTime';
  static final String fldUpdatedTime = 'aUpdatedTime';

  UserAugmontDetail(
      this._userId,
      this._userName,
      this._bankAccNo,
      this._bankHolderName,
      this._userStateId,
      this._firstInvMade,
      this._hasIssue,
      this._createdTime,
      this._updatedTime);

  UserAugmontDetail.newUser(String uid, String uname, String stateId)
      : this(uid, uname, null, null, stateId, false, null, Timestamp.now(),
            Timestamp.now());

  toJson() {
    return {
      fldUserId: _userId,
      fldUserName: _userName,
      fldBankAccNo: _bankAccNo,
      fldBankHolderName: _bankHolderName,
      fldStateId: _userStateId,
      fldCreatedTime: _createdTime,
      fldUpdatedTime: Timestamp.now()
    };
  }
}
