enum FailType{
  UserLoginOtpFailed,
  UserKYCFlagFetchFailed,
  UserICICAppCreationFailed,
  UserICICIBasicFieldUpdateFailed,
  UserICICIIncomeFieldUpdateFailed,
  UserInsufficientBankDetailFailed,
  UserICICIBankFieldUpdateFailed,
  UserIFSCNotFound,
  UserICICIOTPSendFailed,
  UserICICIOTPResendFailed,
  UserICICIPfCreationFailed,
  UserPfCreatedButFolioFailed,
}

extension ParseToString on FailType {
  String value() {
    return this.toString().split('.').last;
  }
}