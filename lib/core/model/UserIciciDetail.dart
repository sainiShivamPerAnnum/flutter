import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class UserIciciDetail{
  static Log log = new Log('UserIciciDetail');
  String _appId;
  String _panNumber;
  String _kycStatus;
  String _panName;
  String _hasIssue;
  Timestamp _createdTime;
  Timestamp _updatedTime;
  String _verifiedOtpId;
  String _unverifiedOtpId;
  String _email;
  String _folioNo;
  String _expDate;
  String _amcRefNo;
  String _payoutId;
  String _chkDigit;


  static final String fldAppId = 'iAppId';
  static final String fldPanNumber = 'iPanNumber';
  static final String fldKycStatus = 'iKycStatus';
  static final String fldHasIssue = 'iHasIssue';
  static final String fldPanName = 'iPanName';
  static final String fldVerifiedOtpId = 'iVeriOtpId';
  static final String fldCreatedTime = 'iCreatedTime';
  static final String fldUpdatedTime = 'iUpdatedTime';
  static final String fldFolioNo = 'iFolioNo';
  static final String fldExpDate = 'iExpDate';
  static final String fldAMCRefNo = 'iAMCRefNo';
  static final String fldPayoutId = 'iPayoutId';
  static final String fldChkDigit = 'iChkDigit';

  static const String NO_ISSUES = "NA";

  UserIciciDetail(this._appId, this._panNumber, this._kycStatus, this._panName
      , this._hasIssue, this._verifiedOtpId, this._folioNo, this._expDate,
      this._amcRefNo, this._payoutId, this._chkDigit, this._createdTime,
      this._updatedTime);

  UserIciciDetail.newApplication(String applicationId, String panNumber, String kycStatus):
      this(applicationId, panNumber, kycStatus, '', NO_ISSUES, null,
          null, null,null,null,null,Timestamp.now(), Timestamp.now());

  UserIciciDetail.fromMap(Map<String, dynamic> data):
      this(data[fldAppId], data[fldPanNumber], data[fldKycStatus],
          data[fldPanName], data[fldHasIssue], data[fldVerifiedOtpId],
          data[fldFolioNo], data[fldExpDate],data[fldAMCRefNo],
          data[fldPayoutId], data[fldCreatedTime], data[fldChkDigit],
          data[fldUpdatedTime]);

  toJson() {
    return {
      fldAppId: _appId,
      fldPanNumber: _panNumber,
      fldKycStatus: _kycStatus,
      fldPanName: _panName,
      fldHasIssue: _hasIssue,
      fldVerifiedOtpId: _verifiedOtpId,
      fldFolioNo: _folioNo,
      fldExpDate: _expDate,
      fldAMCRefNo: _amcRefNo,
      fldPayoutId: _payoutId,
      fldChkDigit: _chkDigit,
      fldCreatedTime: _createdTime,
      fldUpdatedTime: Timestamp.now()
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

  String get unverifiedOtpId => _unverifiedOtpId;

  set unverifiedOtpId(String value) {
    _unverifiedOtpId = value;
  }

  String get verifiedOtpId => _verifiedOtpId;

  set verifiedOtpId(String value) {
    _verifiedOtpId = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get expDate => _expDate;

  set expDate(String value) {
    _expDate = value;
  }

  String get folioNo => _folioNo;

  set folioNo(String value) {
    _folioNo = value;
  }

  String get chkDigit => _chkDigit;

  set chkDigit(String value) {
    _chkDigit = value;
  }

  String get payoutId => _payoutId;

  set payoutId(String value) {
    _payoutId = value;
  }

  String get amcRefNo => _amcRefNo;

  set amcRefNo(String value) {
    _amcRefNo = value;
  }
}