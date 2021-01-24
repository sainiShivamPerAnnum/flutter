import 'package:felloapp/util/logger.dart';

class UserIciciDetail{
  static Log log = new Log('UserIciciDetail');
  String _appId;
  String _panNumber;
  int _kycStatus;
  String _hasIssue;

  static final String fldAppId = 'iAppId';
  static final String fldPanNumber = 'iPanNumber';
  static final String fldKycStatus = 'iKycStatus';
  static final String fldHasIssue = 'iHasIssue';

  static const String NO_ISSUES = "NA";

  UserIciciDetail(this._appId, this._panNumber, this._kycStatus, this._hasIssue);

  UserIciciDetail.newApplication(String applicationId, String panNumber, int kycStatus):
      this(applicationId, panNumber, kycStatus, NO_ISSUES);

  UserIciciDetail.fromMap(Map<String, dynamic> data):
      this(data[fldAppId], data[fldPanNumber], data[fldKycStatus], data[fldHasIssue]);

  toJson() {
    return {
      fldAppId: _appId,
      fldPanNumber: _panNumber,
      fldKycStatus: _kycStatus,
      fldHasIssue: _hasIssue
    };
  }

  String get hasIssue => _hasIssue;

  set hasIssue(String value) {
    _hasIssue = value;
  }

  int get kycStatus => _kycStatus;

  set kycStatus(int value) {
    _kycStatus = value;
  }

  String get panNumber => _panNumber;

  set panNumber(String value) {
    _panNumber = value;
  }

  String get appId => _appId;

  set appId(String value) {
    _appId = value;
  }
}