import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class UserKycDetail{
  static Log log = new Log('UserKycDetail');
  String _accessToken;
  String _signzyUserId;
  String _signzyPassword;

  UserKycDetail(this._signzyUserId, this._signzyPassword, this._accessToken);

  UserKycDetail.newApplication(String userId, String password, String accessToken):
        this(userId, password, accessToken);

  UserKycDetail.fromMap(Map<String, dynamic> data):
        this(data['user_id'], data['password'], data['access_token']);

  toJson() {
    return {
      'user_id': _signzyUserId,
      'password': _signzyPassword,
      'access_token': _accessToken
    };
  }

  String get signzyPassword => _signzyPassword;

  set signzyPassword(String value) {
    _signzyPassword = value;
  }

  String get signzyUserId => _signzyUserId;

  set signzyUserId(String value) {
    _signzyUserId = value;
  }

  String get accessToken => _accessToken;

  set accessToken(String value) {
    _accessToken = value;
  }
}