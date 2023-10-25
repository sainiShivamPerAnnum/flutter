import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/util/logger.dart';

class UserAugmontDetail {
  Log log = const Log('UserAugmontDetail');
  String? _hasIssue;
  String? _userId;
  String? _userName;
  String? _bankAccNo;
  String? _bankHolderName;
  String? _userStateId;
  String? _ifsc;
  bool? _firstInvMade;
  bool? _isDepLocked;
  bool? _isSellLocked;
  String? _sellNotice;
  String? _depNotice;
  TimestampModel? _createdTime;
  TimestampModel? _updatedTime;

  static const String fldUserId = 'aUid';
  static const String fldUserName = 'aUsrName';
  static const String fldBankAccNo = 'aAccNo';
  static const String fldBankHolderName = 'aBankHolderName';
  static const String fldStateId = 'aStateId';
  static const String fldIfsc = 'aIfsc';
  static const String fldFirstInvMade = 'aIsInvested';
  static const String fldHasIssue = 'aHasIssue';
  static const String fldCreatedTime = 'aCreatedTime';
  static const String fldUpdatedTime = 'aUpdatedTime';
  static const String fldIsSellLocked = 'aIsSellLocked';
  static const String fldIsDepLocked = 'aIsDepLocked';
  static const String fldSellNotice = 'aSellNotice';
  static const String fldDepNotice = 'aDepNotice';

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
    this._updatedTime,
    this._isSellLocked,
    this._isDepLocked,
    this._sellNotice,
    this._depNotice,
  );

  UserAugmontDetail.newUser(String uid, String uname, String stateId,
      String bankHolderName, String bankAccNo, String ifsc)
      : this(
          uid,
          uname,
          bankAccNo,
          bankHolderName,
          ifsc,
          stateId,
          false,
          '',
          TimestampModel.currentTimeStamp(),
          TimestampModel.currentTimeStamp(),
          false,
          false,
          '',
          '',
        );

  UserAugmontDetail.base() {
    _hasIssue = '';
    _userId = '';
    _userName = '';
    _bankAccNo = '';
    _bankHolderName = '';
    _userStateId = '';
    _ifsc = '';
    _firstInvMade = false;
    _isDepLocked = false;
    _isSellLocked = false;
    _sellNotice = '';
    _depNotice = '';
  }

  UserAugmontDetail.fromMap(Map<String, dynamic> data)
      : this(
          data[fldUserId] ?? '',
          data[fldUserName] ?? '',
          data[fldBankAccNo] ?? '',
          data[fldBankHolderName] ?? '',
          data[fldIfsc] ?? '',
          data[fldStateId] ?? '',
          data[fldFirstInvMade] ?? false,
          data[fldHasIssue] ?? '',
          TimestampModel.fromMap(data[fldCreatedTime]),
          TimestampModel.fromMap(data[fldUpdatedTime]),
          data[fldIsSellLocked] ?? false,
          data[fldIsDepLocked] ?? false,
          data[fldSellNotice] ?? '',
          data[fldDepNotice] ?? '',
        );

  toJson() {
    return {
      fldUserId: _userId,
      fldUserName: _userName,
      fldBankAccNo: _bankAccNo,
      fldBankHolderName: _bankHolderName,
      fldStateId: _userStateId,
      fldFirstInvMade: _firstInvMade,
      fldIfsc: _ifsc,
      fldCreatedTime: _createdTime!.toMap(),
      fldUpdatedTime: TimestampModel.currentTimeStamp().toMap(),
    };
  }

  TimestampModel get createdTime => _createdTime!;

  set createdTime(TimestampModel value) {
    _createdTime = value;
  }

  bool get firstInvMade => _firstInvMade!;

  set firstInvMade(bool value) {
    _firstInvMade = value;
  }

  String get userStateId => _userStateId!;

  set userStateId(String value) {
    _userStateId = value;
  }

  String get bankHolderName => _bankHolderName!;

  set bankHolderName(String value) {
    _bankHolderName = value;
  }

  String get bankAccNo => _bankAccNo!;

  set bankAccNo(String value) {
    _bankAccNo = value;
  }

  String get userName => _userName!;

  set userName(String value) {
    _userName = value;
  }

  String get userId => _userId!;

  set userId(String value) {
    _userId = value;
  }

  String get hasIssue => _hasIssue!;

  set hasIssue(String value) {
    _hasIssue = value;
  }

  String get ifsc => _ifsc!;

  set ifsc(String value) {
    _ifsc = value;
  }

  bool get isDepLocked => _isDepLocked!;

  bool get isSellLocked => _isSellLocked!;

  String get sellNotice => _sellNotice!;

  String get depNotice => _depNotice!;
}
