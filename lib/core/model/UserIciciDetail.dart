import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class UserIciciDetail{
  static Log log = new Log('UserIciciDetail');
  String _appId;
  String _panNumber;
  String _kycStatus;
  String _panName;
  String _hasIssue;
  FieldValue _createdTime;
  FieldValue _updatedTime;

  static final String fldAppId = 'iAppId';
  static final String fldPanNumber = 'iPanNumber';
  static final String fldKycStatus = 'iKycStatus';
  static final String fldHasIssue = 'iHasIssue';
  static final String fldPanName = 'iPanName';
  static final String fldCreatedTime = 'iCreatedTime';
  static final String fldUpdatedTime = 'iUpdatedTime';

  static const String NO_ISSUES = "NA";

  UserIciciDetail(this._appId, this._panNumber, this._kycStatus, this._panName
      , this._hasIssue, this._createdTime, this._updatedTime);

  UserIciciDetail.newApplication(String applicationId, String panNumber, String kycStatus):
      this(applicationId, panNumber, kycStatus, '', NO_ISSUES,
          FieldValue.serverTimestamp(), FieldValue.serverTimestamp());

  UserIciciDetail.fromMap(Map<String, dynamic> data):
      this(data[fldAppId], data[fldPanNumber], data[fldKycStatus],
          data[fldPanName], data[fldHasIssue], data[fldCreatedTime],
          data[fldUpdatedTime]);

  toJson() {
    return {
      fldAppId: _appId,
      fldPanNumber: _panNumber,
      fldKycStatus: _kycStatus,
      fldPanName: _panName,
      fldHasIssue: _hasIssue,
      fldCreatedTime: _createdTime,
      fldUpdatedTime: FieldValue.serverTimestamp()
    };
  }

  String get hasIssue => _hasIssue;

  set hasIssue(String value) {
    _hasIssue = value;
  }

  String get kycStatus => _kycStatus;

  set kycStatus(String value) {
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

  String get panName => _panName;

  set panName(String value) {
    _panName = value;
  }
}