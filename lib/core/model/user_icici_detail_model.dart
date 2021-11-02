import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/util/logger.dart';

class UserIciciDetail {
  static Log log = new Log('UserIciciDetail');
  String _appId;
  String _panNumber;
  String _kycStatus;
  String _appMode;
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
  String _bankAccNo;
  String _bankCode;
  String _bankName;
  String _bankCity;
  String _vpa;
  String _fatcaFlag;
  bool _firstInvMade;

  static final String fldAppId = 'iAppId';
  static final String fldPanNumber = 'iPanNumber';
  static final String fldKycStatus = 'iKycStatus';
  static final String fldAppMode = 'iAppMode';
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
  static final String fldBankAccNo = 'iBankAccNo';
  static final String fldBankCode = 'iBankCode';
  static final String fldBankName = 'iBankName';
  static final String fldBankCity = 'iBankCity';
  static final String fldVpa = 'iVpa';
  static final String fldFatcaFlag = 'iFatcaFlag';
  static final String fldFirstInvMade = 'iIsInvested';

  static const String NO_ISSUES = "NA";

  UserIciciDetail(
      this._appId,
      this._panNumber,
      this._kycStatus,
      this._appMode,
      this._panName,
      this._hasIssue,
      this._verifiedOtpId,
      this._folioNo,
      this._expDate,
      this._amcRefNo,
      this._payoutId,
      this._chkDigit,
      this._bankAccNo,
      this._bankCode,
      this._bankName,
      this._bankCity,
      this._vpa,
      this._fatcaFlag,
      this._firstInvMade,
      this._createdTime,
      this._updatedTime);

  UserIciciDetail.newApplication(String applicationId, String panNumber,
      String kycStatus, String appMode, String fatcaFlag)
      : this(
            applicationId,
            panNumber,
            kycStatus,
            appMode,
            '',
            NO_ISSUES,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            fatcaFlag,
            false,
            Timestamp.now(),
            Timestamp.now());

  UserIciciDetail.fromMap(Map<String, dynamic> data)
      : this(
            data[fldAppId],
            data[fldPanNumber],
            data[fldKycStatus],
            data[fldAppMode],
            data[fldPanName],
            data[fldHasIssue],
            data[fldVerifiedOtpId],
            data[fldFolioNo],
            data[fldExpDate],
            data[fldAMCRefNo],
            data[fldPayoutId],
            data[fldChkDigit],
            data[fldBankAccNo],
            data[fldBankCode],
            data[fldBankName],
            data[fldBankCity],
            data[fldVpa],
            data[fldFatcaFlag],
            data[fldFirstInvMade],
            data[fldCreatedTime],
            data[fldUpdatedTime]);

  toJson() {
    return {
      fldAppId: _appId,
      fldPanNumber: _panNumber,
      fldKycStatus: _kycStatus,
      fldPanName: _panName,
      fldAppMode: _appMode,
      fldHasIssue: _hasIssue,
      fldVerifiedOtpId: _verifiedOtpId,
      fldFolioNo: _folioNo,
      fldExpDate: _expDate,
      fldAMCRefNo: _amcRefNo,
      fldPayoutId: _payoutId,
      fldChkDigit: _chkDigit,
      fldBankAccNo: _bankAccNo,
      fldBankCode: _bankCode,
      fldBankName: _bankName,
      fldBankCity: _bankCity,
      fldVpa: _vpa,
      fldFatcaFlag: _fatcaFlag,
      fldFirstInvMade: _firstInvMade,
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

  String get appMode => _appMode;

  set appMode(String value) {
    _appMode = value;
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

  String get bankAccNo => _bankAccNo;

  set bankAccNo(String value) {
    _bankAccNo = value;
  }

  String get bankCity => _bankCity;

  set bankCity(String value) {
    _bankCity = value;
  }

  String get bankName => _bankName;

  set bankName(String value) {
    _bankName = value;
  }

  String get bankCode => _bankCode;

  set bankCode(String value) {
    _bankCode = value;
  }

  String get fatcaFlag => _fatcaFlag;

  set fatcaFlag(String value) {
    _fatcaFlag = value;
  }

  bool get firstInvMade => _firstInvMade;

  set firstInvMade(bool value) {
    _firstInvMade = value;
  }

  String get vpa => _vpa;

  set vpa(String value) {
    _vpa = value;
  }
}
