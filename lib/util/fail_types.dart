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
  UserICICIDepositUpdateDiscrepancy,
  UserICICIWthdrwUpdateDiscrepancy,
  UserWithdrawalCheckIMPSFailed,
  UserWithdrawalGetRedeemFailed,
  UserWithdrawalExitLoadFailed,
  UserWithdrawalSubmitFailed,
  UserRedemptionOTPSendFailed,
  UserAugmontPurchaseFailed,
  UserAugmontSellFailed,
  UserRazorpayPurchaseFailed,
  UserAugmontDepositUpdateDiscrepancy,
  UserAugmontWthdrwUpdateDiscrepancy,
}

extension ParseToString on FailType {
  String value() {
    return this.toString().split('.').last;
  }
}