enum FailType{
  UserLoginOtpFailed,
  UserKYCFlagFetchFailed,
  UserICICAppCreationFailed,
  UserICICIBasicFieldUpdateFailed,
  UserICICIFatcaFieldUpdateFailed,
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
  UserTransactionVerifyTimeoutFailed,
  UserWithdrawalCheckIMPSFailed,
  UserWithdrawalGetRedeemFailed,
  UserWithdrawalExitLoadFailed,
  UserWithdrawalSubmitFailed
}

extension ParseToString on FailType {
  String value() {
    return this.toString().split('.').last;
  }
}