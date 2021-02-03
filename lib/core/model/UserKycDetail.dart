import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class UserKycDetail{
  static Log log = new Log('UserKycDetail');
  String _userAccessToken;
  String _merchantId;
  String _tokenCreatedTime;
  String _username;
  String _password;
  int _tokenTtl;
  List<bool> _isStepComplete; //add bool flag for all steps here to keep track
  Timestamp _createdTime;
  Timestamp _updatedTime;

  static final String fldUsername = 'kUsername';
  static final String fldPassword = 'kPassword';
  static final String fldMerchantID = 'kMerchantId';
  static final String fldAccessToken = 'kUserAccessToken';
  static final String fldTokenCreatedTime = 'kTokenCreatedTime';
  static final String fldTokenTtl = 'kTokenTtl';
  static final String fldIsStepComplete = 'kStepsCompleteArr';
  static final String fldCreatedTime = 'kCreatedTime';
  static final String fldUpdatedTime = 'kUpdatedTime';


  UserKycDetail(this._username, this._password,  this._merchantId,
      this._userAccessToken, this._tokenCreatedTime, this._tokenTtl,
      this._isStepComplete, this._createdTime, this._updatedTime);

  UserKycDetail.newUser(String username, String password):
        this(username, password, null, null, null, null, null,
          Timestamp.now(), Timestamp.now());

  UserKycDetail.fromMap(Map<String, dynamic> data):
        this(data[fldUsername], data[fldPassword], data[fldMerchantID],
          data[fldAccessToken], data[fldCreatedTime], data[fldTokenTtl],
          (data[fldIsStepComplete]!=null)?List.from(data[fldIsStepComplete]):null,
          data[fldCreatedTime], data[fldUpdatedTime]);

  toJson() {
    return {
      fldUsername: _username,
      fldPassword: _password,
      fldMerchantID: _merchantId,
      fldAccessToken: _userAccessToken,
      fldCreatedTime: _tokenCreatedTime,
      fldTokenTtl: _tokenTtl,
      fldIsStepComplete: _isStepComplete,
      fldCreatedTime: _createdTime,
      fldUpdatedTime: Timestamp.now()
    };
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  int get tokenTtl => _tokenTtl;

  set tokenTtl(int value) {
    _tokenTtl = value;
  }

  String get tokenCreatedTime => _tokenCreatedTime;

  set tokenCreatedTime(String value) {
    _tokenCreatedTime = value;
  }

  String get merchantId => _merchantId;

  set merchantId(String value) {
    _merchantId = value;
  }

  String get userAccessToken => _userAccessToken;

  set userAccessToken(String value) {
    _userAccessToken = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  List<bool> get isStepComplete => _isStepComplete;

  set isStepComplete(List<bool> value) {
    _isStepComplete = value;
  }
}