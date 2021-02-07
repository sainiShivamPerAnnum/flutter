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
  UserTransactionInitiateFailed,
  UserTransactionDetailSaveFailed,
  UserTransactionVerifyTimeoutFailed
}

extension ParseToString on FailType {
  String value() {
    return this.toString().split('.').last;
  }
}