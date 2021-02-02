import 'package:felloapp/util/logger.dart';

class UserKycDetail{
  static Log log = new Log('UserKycDetail');
  String _userAccessToken;
  String _merchantId;
  String _createdTime;
  String _username;
  String _password;
  int _tokenTtl;

  static final String fldUsername = 'kUsername';
  static final String fldPassword = 'kPassword';
  static final String fldMerchantID = 'kMerchantId';
  static final String fldAccessToken = 'kUserAccessToken';
  static final String fldCreatedTime = 'kCreatedTime';
  static final String fldTokenTtl = 'kTokenTtl';

  UserKycDetail(this._username, this._password,  this._merchantId,
      this._userAccessToken, this._createdTime, this._tokenTtl);

  UserKycDetail.newUser(String username, String password):
        this(username, password, null, null, null, null);

  UserKycDetail.fromMap(Map<String, dynamic> data):
        this(data[fldUsername], data[fldPassword], data[fldMerchantID],
          data[fldAccessToken], data[fldCreatedTime], data[fldTokenTtl]);

  toJson() {
    return {
      fldUsername: _username,
      fldPassword: _password,
      fldMerchantID: _merchantId,
      fldAccessToken: _userAccessToken,
      fldCreatedTime: _createdTime,
      fldTokenTtl: _tokenTtl
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

  String get createdTime => _createdTime;

  set createdTime(String value) {
    _createdTime = value;
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
}