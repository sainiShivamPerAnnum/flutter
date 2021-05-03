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
  static final String resAppMode = 'APP_KYC_MODE';

  static const String KYC_STATUS_INVALID = '0';
  static const String KYC_STATUS_VALID = '1';
  static const String KYC_STATUS_FETCH_FAILED = '2';
  static const String KYC_STATUS_SERVICE_DOWN = '3';
  static const String KYC_STATUS_ALLOW_VIDEO = '4';

  static const String FATCA_FLAG_NN = 'NN';
  static const String FATCA_FLAG_YY = 'YY';
  static const String FATCA_FLAG_YN = 'YN';
  static const String FATCA_FLAG_PC = 'PC';
  static const String FATCA_FLAG_UC = 'UC';

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

class SubmitFatca{
  static final String path = 'api/submitFatca';
  static final String fldId = 'appid';
  static final String fldPan = 'firstpan';
  static final String fldTaxId = 'taxid';
  static final String fldIdType = 'idtype';
  static final String fldFatcaOption = 'fatcaop';
  static final String fldBirthplace = 'birthplace';
  static final String fldTinResn = 'tinresn';//'A'
  static final String fldTinResnText = 'tinresntext';//no idea

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

/////////////////////TRANSACTION APIS//////////////////////
// ignore: slash_for_doc_comments
/**
 * [{"TRANID":"3433315","TRXN_DATE":"27/01/2021","TRXN_TIME":"12:41:11 PM","INV_NAME":"SHOURYADITYA RAY
    LALA","MOBILE_NO":7019658746,"SCH_NAME":"ICICI Prudential Liquid Fund -
    Growth","MULTIPLE_ID":"3433314","AMOUNT":100,"UPI_DATE_TIME":"27/01/2021 12:44
    PM","TRIG_SCHEME":null,"USERNAME":null,"TRAN_ID":"3433315","DISPLAY_NAME":null,"IS_TAX":"N","LTEF_URL":null}]
    or
   [{"ID_":"752994","SCH_CODE":"1565","MSG":"We are currently unable to process this transaction. Either update your App or
    try again1","STATUS":"We are currently unable to process this transaction. Either update your App or try again1"}]
 *
 * [{"TRANID":"3433599","TRXN_DATE":"01/02/2021","TRXN_TIME":"12:47:39 PM","INV_NAME":"SHOURYADITYA RAY LALA",
 * "MOBILE_NO":9986643444,"SCH_NAME":"ICICI Prudential Liquid Fund - Growth","MULTIPLE_ID":"3433598",
 * "AMOUNT":100,"UPI_DATE_TIME":"01/02/2021 12:50 PM","TRIG_SCHEME":null,"USERNAME":null,"TRAN_ID":"3433599",
 * "DISPLAY_NAME":null,"IS_TAX":"N","LTEF_URL":null}]
 * */
class SubmitUpiNewInvestor{
  //static final String path = 'api/submitUpiPurchase';
  static final String path = 'api/submitIBankUpiPurchase';
  static final String fldId = 'appid';
  static final String fldEmail = 'email';
  static final String fldBankCode = 'bankcode';
  static final String fldPan = 'firstpan';
  static final String fldFolioNo = 'foliono';
  static final String fldKycMode = 'kycmode';
  static final String fldAmount = 'amount';
  static final String fldVPA = 'vpa';

  static final String resTrnId = "TRANID";
  static final String resTrnDate = "TRXN_DATE";
  static final String resUpiTime = 'UPI_DATE_TIME';
  static final String resMultipleId = "MULTIPLE_ID";
  static final String resAmount = "AMOUNT";
  static final String resMsg = 'MSG';
}

/**
 *  [{"TRANID":"16376097","TRXN_DATE":"15/02/2021","TRXN_TIME":"11:41:26 AM","TRANID1":"16376097",
 *  "MULTIPLE_ID":"16376098","AMOUNT":10,"IS_TAX":"N","UPI_DATE_TIME":"15/02/2021 11:44 AM",
 *  "SCH_NAME":"ICICI Prudential Liquid Fund - Growth","SCH_CODE":"1565","TAX_STATUS":"01",
 *  "MINOR_FOLIO":"N","OperationCode":"92","OperationErrorMessage":"Transaction initiated successfully.
 *  Please accept the request in your bank UPI App within 3 minutes to complete the transaction."}]
 * */
class SubmitUpiExistingInvestor{
  static final String path = 'api/submitIBankUpiPurchaseExt';
  static final String fldFolioNo = 'foliono';
  static final String fldChkDigit = 'chkdigit';
  static final String fldAmount = 'amount';
  static final String fldBankCode = 'bankcode';
  static final String fldBankAccNo = 'bankaccno';
  static final String fldPan = 'firstpan';
  static final String fldVPA = 'vpa';

  static final String resTrnId = "TRANID";
  static final String resSessionId = "SESSION";
  static final String resUpiTime = 'UPI_DATE_TIME';
  static final String resMultipleId = "MULTIPLE_ID";
  static final String resMsg = 'MSG';
}

/**
 * {"STATUS":"0","ERR_DESCRIPTION":""}
 * [{"STATUS":"","ERR_DESCRIPTION":"Reference No does not exist"}]
 * */
class GetPaidStatus{
  static final String path = 'api/getPaidStatus';
  static final String fldTranId = 'tranid';
  static final String fldPan = 'firstpan';

  static final String resStatus = 'STATUS';
  static final String resErrorDesc = 'ERR_DESCRIPTION';

  static const String STATUS_SUCCESS = '1';
  static const String STATUS_INCOMPLETE = '0';
  static const String STATUS_REJECTED = '2';
}

////////////////////////////REDEMPTION QUERIES////////////////////////////////
/**
 * [{"BAL":"0.291","AUM":"78.88","RETURNCODE":"000","ALLOWIMPS":"Y","MESSAGE":null,"SCH_DET":[{"SCH_TYPE":"DF","TYPE_NAME":"Debt
    Funds","SCH_CODE":"1565","SCH_NAME":"ICICI Prudential Liquid Fund - Growth","STATUS":"N","MRED_AMT":1,"CUT_OFF":"3:0:0
    PM","ALLOW_REDEEM":"Y","RED_ALLOWED":"Y","REDEM_FROM_DAY":0,"REDEM_TO_DAY":0,"FOLIO_NO":"16832662","TAX_BASED_SCHEME":"N",
    "BAL":0.331,"AUM":99.8725307,"NAV":301.7297,"NAVDATE":"2021-02-10T00:00:00","ALLOW_IMPS":"Y"}],"REDEEMABLEAMOUNT":78.88,
    "TAMOUNT":87.8033427,"SESSIONID":"FL178407",":B2":"Y",":B1":"N"}]
 *
 */
class CheckFolioBalance{
  static final String path = 'api/checkIMPSAllowed';
  static final String fldFolioNo = 'foliono';

  static final String resInstantBalance = "REDEEMABLEAMOUNT";
  static final String resTotalBalance = "TAMOUNT";
}

// ignore: slash_for_doc_comments
/**
 * Allowed IMPS Redemption:
    [{"BAL":"101.988","AUM":"27454.62","RETURNCODE":"000","ALLOWIMPS":"Y","MESSAGE":null,
    "SCH_DET":[{ SCH_TYPE":"EF","TYPE_NAME":"Equity Funds","SCH_CODE":"8030",
    "SCH_NAME":"ICICI Prudential Multicap Fund - Direct Plan - Growth","STATUS":"N",
    "MRED_AMT":500.0,"CUT_OFF":"3:0:0 PM","ALLOW_REDEEM":"Y","RED_ALLOWED":"Y","REDEM_FROM_DAY":0.0,
    "REDEM_TO_DAY":0.0,"FOLIO_NO":"4189582","TAX_BASED_SCHEME":"N","BAL":58.3030,
    "AUM":17536.959370,"NAV":300.79,"NAVDATE":"2019-09-20T00:00:00","ALLOW_IMPS":"N"}],
    "REDEEMABLEAMOUNT":27454.62,"TAMOUNT":28987.63108920,"SESSIONID":"PH10"}]
    Not Allowed IMPS Redemption :
    [{"BAL":"0","AUM":"0","RETURNCODE":"222","ALLOWIMPS":"N",
    "MESSAGE":"For Quick Withdrawal mode , Available Balance should not be nil","SCH_DET":[]}]
 *or
 * [{"RETURNCODE":"100","ALLOWIMPS":"Y","MESSAGE":"Only Individual folio allowed","SCH_DET":[]}]
 *
 * [{"BAL":"112.352","AUM":"1011.17","RETURNCODE":"000","ALLOWIMPS":"Y","MESSAGE":null,"SCH_DET":[{"SCH_TYPE":"DF","TYPE_NAME":"Debt
    Funds","SCH_CODE":"1565","SCH_NAME":"ICICI Prudential Liquid Fund - Growth","STATUS":"N","MRED_AMT":1,"CUT_OFF":"3:0:0
    PM","ALLOW_REDEEM":"Y","RED_ALLOWED":"Y","REDEM_FROM_DAY":0,"REDEM_TO_DAY":0,"FOLIO_NO":"8490923","TAX_BASED_SCHEME":"N",
    "BAL":172.352,"AUM":48986.9023168,"NAV":284.2259,"NAVDATE":"2019-09-22T00:00:00","ALLOW_IMPS":"Y"}],"REDEEMABLEAMOUNT":1011.17,
    "TAMOUNT":31933.3483168,"SESSIONID":"FL1670",":B2":"Y",":B1":"N"}]
 * */
class CheckIMPSStatus{
  static final String path = 'api/checkIMPSAllowed';
  static final String fldFolioNo = 'foliono';
  static final String fldAmount = 'amount';

  static final String resReturnCode = "RETURNCODE";
  static final String resReturnMsg = "MESSAGE";
  static final String resAllowIMPSFlag =  "ALLOWIMPS";
  static final String resInstantBalance = "REDEEMABLEAMOUNT";
  static final String resTotalBalance = "TAMOUNT";

  static const String STATUS_ALLOWED = "000";
  static const String STATUS_LESS_THAN_MIN_ALLOWED = "101";
  static const String STATUS_BALANCE_NIL_1 = "222";
  static const String STATUS_BALANCE_NIL_2 = "333";
  static const String STATUS_REQUEST_AMT_EXCEEDED_1 = "444";
  static const String STATUS_ERROR = "555";
  static const String STATUS_ONCE_A_DAY_ALLOWED = "666";
  static const String STATUS_REQUEST_AMT_EXCEEDED_2 = "777";
  static const String STATUS_FOLIO_NOT_MAPPED = "888";
}

/**
 * {"ApproxLoadAmt": "0.00","PopUpFlag": "N"}
 * */
class GetExitLoad{
  static final String path = 'api/getExitLoad';
  static final String fldFolioNo = 'foliono';
  static final String fldAmount = 'amount';

  static final String resApproxLoadAmt = 'ApproxLoadAmt';
  static final String resPopUpFlag = 'PopUpFlag';

  static const String SHOW_POPUP = 'Y';
  static const String DONT_SHOW_POPUP = 'N';
}

/**
 *  [{“Bank_Name”:”ICICI Bank Ltd”,
    ”Bank_details”:” 001501011212825#ICIC000125#229”,
    ”Redeem_bank_details”:”ICICI Bank Ltd#001501011212825#SB#null#null#DC-ICIC”,
    }]
    or if not found: ""

    [{"BANK_NAME":"CITI-BANK N.A.","BANK_DETAILS":"5603612223#CNRB0000001#37","REDEEM_BANK_DETAILS":"CITI-BANK
    N.A.#5603612223#SB#Delhi#DELHI#NEFT"},{"BANK_NAME":"CITI-BANK
    N.A.","BANK_DETAILS":"5603612223#CNRB0000001#37","REDEEM_BANK_DETAILS":"CITI-BANK N.A.#5603612223#SB#Delhi#NEW
    DELHI#NEFT"}]

    [{"BANK_NAME":"ICICI BANK LTD","BANK_DETAILS":"003901070908#ICIC0000000#229","REDEEM_BANK_DETAILS":"ICICI BANK
    LTD#003901070908#SB#PuneShivaji Nagar##DC-ICIC"},{"BANK_NAME":"ICICI BANK
    LTD","BANK_DETAILS":"003901070908#ICIC0000000#229","REDEEM_BANK_DETAILS":"ICICI BANK LTD#003901070908#SB#PUNE - SHIVAJI
    NAGAR##DC-ICIC"}]

    [{"BANK_NAME":"IndusInd Bank Ltd","BANK_DETAILS":"159986643444#INDB0001394#234","REDEEM_BANK_DETAILS":"IndusInd Bank
    Ltd#159986643444#SB#DWARKA NEW DELHI##NEFT"}]
 * */
class GetBankRedemptionDetail{
  static final String path = 'api/getRedeemBankDetails';
  static final String fldFolioNo = 'foliono';

  static final String resBankName = "BANK_NAME";
  static final String resCombinedAccountDetails = "BANK_DETAILS";
  static final String resCombinedBankDetails = "REDEEM_BANK_DETAILS";
  
  static String getBankAccNo(String rawStr) =>  rawStr.split('#')[0];
  static String getBankIfsc(String rawStr) =>  rawStr.split('#')[1];
  static String getBankCode(String rawStr) =>  rawStr.split('#')[2];

  static String getBankAccType(String rawStr) =>  rawStr.split('#')[2];
  static String getBankBranch(String rawStr) =>  rawStr.split('#')[3];
  static String getBankCity(String rawStr) =>  rawStr.split('#')[4];
  static String getRedeemMode(String rawStr) =>  rawStr.split('#')[5];
}

/**
 *
    {"TRANID":"16338804","TRXN_DATE":"11/02/2021","TRXN_TIME":"08:05:39
    PM","BANK_RRN":"","IMPS_CODE":"1005","IMPS_STATUS":"The Redemption transaction value is more than the eligible amount."}

    {"TRANID":"16338811","TRXN_DATE":"11/02/2021","TRXN_TIME":"08:06:23
    PM","BANK_RRN":"104220778133","IMPS_CODE":"0","IMPS_STATUS":"Transaction Successful"}
 * */
class SubmitRedemption{
  static final String path = 'api/submitRedemption';
  static final String fldFolioNo = 'foliono';
  static final String fldAmount = 'amount';
  static final String fldBankCode = 'bankcode';
  static final String fldMobile = 'mobile'; //'919986643444' format
  static final String fldBankName = 'bankname';
  static final String fldAccNo = 'accno';
  static final String fldAccType = 'acctype';
  static final String fldBankBranch = 'bankbranch';
  static final String fldBankCity = 'bankcity';
  static final String fldRedeemMode = 'redeemmode';
  static final String fldIfsc = 'ifsc';
  static final String fldExitLoadTick = 'exitloadtick';
  static final String fldApproxLoadAmount = 'approxloadamt';

  static final String resTranId = 'TRANID';
  static final String resTrnTime = 'TRXN_TIME';
  static final String resBankRnn = 'BANK_RNN';
  static final String resIMPSCode = 'IMPS_CODE';
  static final String resIMPSStatus = 'IMPS_STATUS';

  static const String IMPS_TRANSACTION_SUCCESS = '0';
}

class SubmitRedemptionNonInstant{
  static final String path = 'api/submitRedemptionNonInstant';
  static final String fldFolioNo = 'foliono';
  static final String fldPan = 'firstpan';
  static final String fldAmount = 'amount';
  static final String fldBankCode = 'bankcode';
  static final String fldBankName = 'bankname';
  static final String fldAccNo = 'accno';
  static final String fldAccType = 'acctype';
  static final String fldBankBranch = 'bankbranch';
  static final String fldBankCity = 'bankcity';
  static final String fldRedeemMode = 'redeemmode';
  static final String fldIfsc = 'ifsc';

  static final String resTranId = 'TRANID';
  static final String resTrnTime = 'TRXN_TIME';
  static final String resBankRnn = 'BANK_RNN';
  static final String resIMPSCode = 'IMPS_CODE';
  static final String resIMPSStatus = 'IMPS_STATUS';

  static const String IMPS_TRANSACTION_SUCCESS = '0';
}

class SendRedemptionOtp{
  static final String path = 'api/sendRedemptionOtp';
  static final String fldFolioNo = 'foliono';
  static final String fldTranId = 'tranid';

  static final String resOtpId = 'OTP_ID';
}

class VerifyRedemptionOtp{
  static final String path = 'api/verifyRedemptionOtp';
  static final String fldFolioNo = 'foliono';
  static final String fldTranId = 'tranid';
  static final String fldOtpId = 'otpid';
  static final String fldOtp = 'otp';

  static final String resStatus = 'STATUS';
}