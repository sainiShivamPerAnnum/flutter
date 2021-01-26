const int QUERY_FAILED = 500;
const int QUERY_PASSED = 200;
const String QUERY_SUCCESS_FLAG = "flag";
const String QUERY_FAIL_REASON = "reason";
const String INTERNAL_FAIL_FLAG = "fello_flag";
const String PAYMODE = "UPI";
const int ICICI_OTP_LEN = 5;

class GetTaxStatus{
  static final String path = 'api/getTaxStatus';
  static final String resTaxCode = 'TAX_CODE';
  static final String resTaxDescription = 'TAX_DESC';
}

// ignore: slash_for_doc_comments
/**
 * YY – Show Fatca Popup with message as
    “Is any of the applicant's/guardian/Power of Attorney holder's country
    of birth/citizenship/nationality/tax residency status other than India?”

    NN – Don’t show Fatca Popup

    YN –Show Fatca Popup with message as “FATCA Status as per our records is
    'Unable to confirm'.Do you wish to update the FATCA Confirmation?”

    UC – Show Fatca Popup with message as “US/Canada Person(s) are not
    allowed to do the subscription/Switch In transaction.”

    PC -  Show Fatca Popup with message as “Dear Investor,
    Your Additional KYC, FATCA and CRS Self declaration complete
    information is not available, Kindly submit the same.”

    Sample Output:
    {"STATUS":"1","F_PAN_NAME":"SHOURYADITYA RAY
    LALA","F_PAN_STATUS":"OK","S_PAN_NAME":"","S_PAN_STATUS":"","T_PAN_NAME":"",
    "T_PAN_STATUS":"","APP_KYC_MODE":"0","APP_UPDT_STATUS":"","FATCA_FLAG_1":"NN"}
 * */

class GetKycStatus{
  static final String path = 'api/getKycStatus';
  static final String fldPan = 'firstpan';
  static final String resName = 'F_PAN_NAME';
  static final String resStatus = 'STATUS';
  static final String resFatcaStatus = 'FATCA_FLAG_1';
  static final String resPanStatus = 'F_PAN_STATUS';//should be 'OK'

  static const String KYC_STATUS_INVALID = '0';
  static const String KYC_STATUS_VALID = '1';
  static const String KYC_STATUS_FETCH_FAILED = '2';
  static const String KYC_STATUS_SERVICE_DOWN = '3';
  static const String KYC_STATUS_ALLOW_VIDEO = '4';
}

/**
 * Sample output: {"STATUS":"Y","ID":"752828","A_STATUS":"N"}
 * */
class SubmitPanDetail{
  static final String path = 'api/submitPanDetails';
  static final String fldPan = 'firstpan';
  static final String fldName = 'panname';

  static final String resStatus = 'STATUS'; //should be 'Y'
  static final String resId = 'ID'; //should be saved
}

/**
 * Sample output: {"STATUS":"Y"}
 * */
class SubmitInvoiceDetail{
  static final String path = 'api/submitInvoiceDetails';
  static final String fldId = 'appid';
  static final String fldDob = 'dob'; //format= '29-Aug-1996'
  static final String fldEmail = 'email'; //encoded
  static final String fldMobile = 'mobile'; //919986643444
  static final String fldPan = 'firstpan';

  static final String resStatus = 'STATUS';
}

/**
 * Sample output: {"STATUS":"Y"}
 * */
class SubmitInvKYCDetail{
  static final String path = 'api/submitInvoiceKycDetails';
  static final String fldId = 'appid';
  static final String fldOccpCde = 'occpcde';
  static final String fldIncome = 'income';
  static final String fldPolOp = 'polopt';
  static final String fldPan = 'firstpan';
  static final String fldSrcWealth = 'srcwealth';

  static final String resStatus = 'STATUS';
}


/**
 * Sample Output:
 * {"BANK_CODE":"14","BANK_NAME":"INDUSIND BANK LTD","STATUS":"Y","LIQUID_ALLOWED":"N","BRANCHNAME":"DWARKA NEW
    DELHI","IFSCCODE":"INDB0001394","ADDRESS":"SHOP NO 1 2 3 4 59 60 61, MANISH GLOBAL MALL PLOT NO 2 LSC 1 SECTOR 22
    DWARKA","CITY":"NEW DELHI","ISIP_ALLOWED":"Y","CORP_STATUS":"N","CHAKRA_BANK_CODE":"234","BANK_TYPE":"D"}

    if not found: returns {}
 * */
class GetBankDetail{
  static final String path = 'api/getBankDetail';
  static final String fldPan = 'firstpan';
  static final String fldIFSC = 'ifsc';

  static final String resBankCode = 'BANK_CODE';
  static final String resBankName = 'BANK_NAME';
  static final String resStatus = 'STATUS';
  static final String resBranchName = 'BRANCHNAME';
  static final String resAddress = 'ADDRESS';
  static final String resCity = 'CITY';
}

/**
 * Sample output: [{"BANK_ACT_TYPE":"Savings Account","BANK_ACT_VALUE":"SB"},
 * {"BANK_ACT_TYPE":"Current Account","BANK_ACT_VALUE":"CA"}]
 * */
class GetBankActType{
  static final String path = 'api/getBankActType';
  static final String fldPan = 'firstpan';

  static final String resActType = 'BANK_ACT_TYPE';
  static final String resActValue = 'BANK_ACT_VALUE';
}

/**
 * Sample output: {"STATUS":"Y"}
 * or if failed: {}
 * */
class SubmitBankDetails{
  static final String path = 'api/submitBankDetails';
  static final String fldId = 'appid';
  static final String fldPayMode = 'paymode';
  static final String fldAccType = 'acctype';
  static final String fldBankAccNo = 'bankaccno';
  static final String fldBankName = 'bankname';
  static final String fldBankCode = 'bankcode';
  static final String fldIfsc = 'ifsc';
  static final String fldCity = 'city';
  static final String fldBranch = 'branch';
  static final String fldAddress = 'address';
  static final String fldPan = 'firstpan';

  static final String resStatus = 'STATUS';
}

class GetSavedDetail{
  static final String path = 'api/getSavedDetail';
  static final String fldPan = 'firstpan';
  static final String fldId = 'appid';

  static final String resPan = 'PRIMARY_PAN_NO';
  static final String resName = 'PRIMARY_INVESTOR_NAME';
  static final String resInvestorName = 'PRIMARY_INVESTOR_NAME1';
  static final String resDob = 'PRIMARY_DOB';
  static final String resTaxStatus = 'TAX_STATUS';
  static final String resAnnualIncome = 'INVGROSSANNUALINC';
  static final String resEmailId = 'EMAIL_ID';
  static final String resMobile = 'MOBILE_NO';
}

/**
 * Sample output: {"STATUS":"1","OTPID":"185103"}
 * */
class SendOtp{
  static final String path = 'api/requestSendOtp';
  static final String fldEmail = 'email';
  static final String fldMobile = 'mobile';

  static final String resStatus = 'STATUS';
  static final String resOtpId = 'OTPID';

  static const String STATUS_SENT_EMAIL_MOBILE = '1';
  static const String STATUS_SENT_EMAIL = '2';
  static const String STATUS_SENT_MOBILE = '3';
  static const String STATUS_NOT_SENT = '4';
}

/**
 * Sample output: {"STATUS":"1","OTPID":"185103"}
 * */
class ResendOtp{
  static final String path = 'api/requestSendOtp';
  static final String fldEmail = 'email';
  static final String fldMobile = 'mobile';
  static final String fldOtpId = 'otpid';

  static final String resStatus = 'STATUS';
  static final String resOtpId = 'OTPID';

  static const String STATUS_SENT_EMAIL_MOBILE = '1';
  static const String STATUS_SENT_EMAIL = '2';
  static const String STATUS_SENT_MOBILE = '3';
  static const String STATUS_NOT_SENT = '4';
}

/**
 * Sample output: {"STATUS":"1","OTPID":"185103"}
 * */
class VerifyOtp{
  static final String path = 'api/verifyOtp';
  static final String fldOtpId = 'otpid';
  static final String fldOtp = 'otp';

  static final String resStatus = 'STATUS';
  static final String resOtpId = 'OTPID';

  static const String STATUS_OTP_VALID = '1';
  static const String STATUS_OTP_INVALID = '2';
  static const String STATUS_OTP_EXPIRED = '3';
  static const String STATUS_TRIES_EXCEEDED = '4'; //after 3 tries usually
}

/**
 * Sample output:
 * [{"Return_Code":"7","Return_Msg":"Input Exceeds Maximum length.","Category":"F"}]
 * or [{"Return_Code":"1","Return_Msg":"Please Enter INV_Address_1,Inv_City"}]
 * or [{"Return_Code":"0","Return_Msg":"Record updated successfully","Exp_Date":"31-Dec-2018","Folio_No":"2000028046"}]
 * or [{"Return_Code":"0","Return_Msg":"Record updated
    successfully","Exp_Date":"22-Apr-2021","Folio_No":"16042280","Chk_Digit_No":"01","AMC_Ref_No":"IPRU752990","Payout_ID":"3010208"}]
    or [{"Return_Code":"237","Return_Msg":"Duplicate transaction - Folio_No: (16042281) already created for this AMC Ref No.","Category":"F"}]
 * */
class CreatePortfolio{
  static final String path = 'api/createPortfolio';
  static final String fldId = 'appid';
  static final String fldOtpId = 'otpid';

  static final String resReturnCode = "Return_Code";
  static final String resRetMessage = "Return_Msg";
  static final String resFolioNo = "Folio_No";
  static final String resExpiryDate = "Exp_Date";
  static final String resAMCRefNo = "AMC_Ref_No";
  static final String resPayoutId = "Payout_ID";
  static final String resChkDigit = "Chk_Digit_No";

  static const String STATUS_PORTFOLIO_CREATED = '0';

  //rest not known yet
}