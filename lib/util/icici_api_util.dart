const int QUERY_FAILED = 500;
const int QUERY_PASSED = 200;
const String QUERY_SUCCESS_FLAG = "flag";
const String QUERY_FAIL_REASON = "reason";
const String INTERNAL_FAIL_FLAG = "fello_flag";
const String PAYMODE = "UPI";
const int ICICI_OTP_LEN = 5;

class GetTaxStatus {
  static const String path = 'api/getTaxStatus';
  static const String resTaxCode = 'TAX_CODE';
  static const String resTaxDescription = 'TAX_DESC';
}

// ignore: slash_for_doc_comments
/**
 * YY – Show Fatca Popup with message as
    “Is any of the applicant's/guardian/Power of Attorney holder's country
    of birth/citizenship/nationality/tax residency status other than India?”

    NN – Don’t show Fatca Popup

    YN –Show Fatca Popup with message as “FATCA Status as per our recoords is
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

class GetKycStatus {
  static const String path = 'api/getKycStatus';
  static const String fldPan = 'firstpan';
  static const String resName = 'F_PAN_NAME';
  static const String resStatus = 'STATUS';
  static const String resFatcaStatus = 'FATCA_FLAG_1';
  static const String resPanStatus = 'F_PAN_STATUS'; //should be 'OK'
  static const String resAppMode = 'APP_KYC_MODE';

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
class SubmitPanDetail {
  static const String path = 'api/submitPanDetails';
  static const String fldPan = 'firstpan';
  static const String fldName = 'panname';

  static const String resStatus = 'STATUS'; //should be 'Y'
  static const String resId = 'ID'; //should be saved
}

/**
 * Sample output: {"STATUS":"Y"}
 * */
class SubmitInvoiceDetail {
  static const String path = 'api/submitInvoiceDetails';
  static const String fldId = 'appid';
  static const String fldDob = 'dob'; //format= '29-Aug-1996'
  static const String fldEmail = 'email'; //encoded
  static const String fldMobile = 'mobile'; //919986643444
  static const String fldPan = 'firstpan';

  static const String resStatus = 'STATUS';
}

class SubmitFatca {
  static const String path = 'api/submitFatca';
  static const String fldId = 'appid';
  static const String fldPan = 'firstpan';
  static const String fldTaxId = 'taxid';
  static const String fldIdType = 'idtype';
  static const String fldFatcaOption = 'fatcaop';
  static const String fldBirthplace = 'birthplace';
  static const String fldTinResn = 'tinresn'; //'A'
  static const String fldTinResnText = 'tinresntext'; //no idea

  static const String resStatus = 'STATUS';
}

/**
 * Sample output: {"STATUS":"Y"}
 * */
class SubmitInvKYCDetail {
  static const String path = 'api/submitInvoiceKycDetails';
  static const String fldId = 'appid';
  static const String fldOccpCde = 'occpcde';
  static const String fldIncome = 'income';
  static const String fldPolOp = 'polopt';
  static const String fldPan = 'firstpan';
  static const String fldSrcWealth = 'srcwealth';

  static const String resStatus = 'STATUS';
}

/**
 * Sample Output:
 * {"BANK_CODE":"14","BANK_NAME":"INDUSIND BANK LTD","STATUS":"Y","LIQUID_ALLOWED":"N","BRANCHNAME":"DWARKA NEW
    DELHI","IFSCCODE":"INDB0001394","ADDRESS":"SHOP NO 1 2 3 4 59 60 61, MANISH GLOBAL MALL PLOT NO 2 LSC 1 SECTOR 22
    DWARKA","CITY":"NEW DELHI","ISIP_ALLOWED":"Y","CORP_STATUS":"N","CHAKRA_BANK_CODE":"234","BANK_TYPE":"D"}

    if not found: returns {}
 * */
class GetBankDetail {
  static const String path = 'api/getBankDetail';
  static const String fldPan = 'firstpan';
  static const String fldIFSC = 'ifsc';

  static const String resBankCode = 'BANK_CODE';
  static const String resBankName = 'BANK_NAME';
  static const String resStatus = 'STATUS';
  static const String resBranchName = 'BRANCHNAME';
  static const String resAddress = 'ADDRESS';
  static const String resCity = 'CITY';
}

/**
 * Sample output: [{"BANK_ACT_TYPE":"Savings Account","BANK_ACT_VALUE":"SB"},
 * {"BANK_ACT_TYPE":"Current Account","BANK_ACT_VALUE":"CA"}]
 * */
class GetBankActType {
  static const String path = 'api/getBankActType';
  static const String fldPan = 'firstpan';

  static const String resActType = 'BANK_ACT_TYPE';
  static const String resActValue = 'BANK_ACT_VALUE';
}

/**
 * Sample output: {"STATUS":"Y"}
 * or if failed: {}
 * */
class SubmitBankDetails {
  static const String path = 'api/submitBankDetails';
  static const String fldId = 'appid';
  static const String fldPayMode = 'paymode';
  static const String fldAccType = 'acctype';
  static const String fldBankAccNo = 'bankaccno';
  static const String fldBankName = 'bankname';
  static const String fldBankCode = 'bankcode';
  static const String fldIfsc = 'ifsc';
  static const String fldCity = 'city';
  static const String fldBranch = 'branch';
  static const String fldAddress = 'address';
  static const String fldPan = 'firstpan';

  static const String resStatus = 'STATUS';
}

class GetSavedDetail {
  static const String path = 'api/getSavedDetail';
  static const String fldPan = 'firstpan';
  static const String fldId = 'appid';

  static const String resPan = 'PRIMARY_PAN_NO';
  static const String resName = 'PRIMARY_INVESTOR_NAME';
  static const String resInvestorName = 'PRIMARY_INVESTOR_NAME1';
  static const String resDob = 'PRIMARY_DOB';
  static const String resTaxStatus = 'TAX_STATUS';
  static const String resAnnualIncome = 'INVGROSSANNUALINC';
  static const String resEmailId = 'EMAIL_ID';
  static const String resMobile = 'MOBILE_NO';
}

/**
 * Sample output: {"STATUS":"1","OTPID":"185103"}
 * */
class SendOtp {
  static const String path = 'api/requestSendOtp';
  static const String fldEmail = 'email';
  static const String fldMobile = 'mobile';

  static const String resStatus = 'STATUS';
  static const String resOtpId = 'OTPID';

  static const String STATUS_SENT_EMAIL_MOBILE = '1';
  static const String STATUS_SENT_EMAIL = '2';
  static const String STATUS_SENT_MOBILE = '3';
  static const String STATUS_NOT_SENT = '4';
}

/**
 * Sample output: {"STATUS":"1","OTPID":"185103"}
 * */
class ResendOtp {
  static const String path = 'api/requestSendOtp';
  static const String fldEmail = 'email';
  static const String fldMobile = 'mobile';
  static const String fldOtpId = 'otpid';

  static const String resStatus = 'STATUS';
  static const String resOtpId = 'OTPID';

  static const String STATUS_SENT_EMAIL_MOBILE = '1';
  static const String STATUS_SENT_EMAIL = '2';
  static const String STATUS_SENT_MOBILE = '3';
  static const String STATUS_NOT_SENT = '4';
}

/**
 * Sample output: {"STATUS":"1","OTPID":"185103"}
 * */
class VerifyOtp {
  static const String path = 'api/verifyOtp';
  static const String fldOtpId = 'otpid';
  static const String fldOtp = 'otp';

  static const String resStatus = 'STATUS';
  static const String resOtpId = 'OTPID';

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
class CreatePortfolio {
  static const String path = 'api/createPortfolio';
  static const String fldId = 'appid';
  static const String fldOtpId = 'otpid';

  static const String resReturnCode = "Return_Code";
  static const String resRetMessage = "Return_Msg";
  static const String resFolioNo = "Folio_No";
  static const String resExpiryDate = "Exp_Date";
  static const String resAMCRefNo = "AMC_Ref_No";
  static const String resPayoutId = "Payout_ID";
  static const String resChkDigit = "Chk_Digit_No";

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
class SubmitUpiNewInvestor {
  //static final String path = 'api/submitUpiPurchase';
  static const String path = 'api/submitIBankUpiPurchase';
  static const String fldId = 'appid';
  static const String fldEmail = 'email';
  static const String fldBankCode = 'bankcode';
  static const String fldPan = 'firstpan';
  static const String fldFolioNo = 'foliono';
  static const String fldKycMode = 'kycmode';
  static const String fldAmount = 'amount';
  static const String fldVPA = 'vpa';

  static const String resTrnId = "TRANID";
  static const String resTrnDate = "TRXN_DATE";
  static const String resUpiTime = 'UPI_DATE_TIME';
  static const String resMultipleId = "MULTIPLE_ID";
  static const String resAmount = "AMOUNT";
  static const String resMsg = 'MSG';
}

/**
 *  [{"TRANID":"16376097","TRXN_DATE":"15/02/2021","TRXN_TIME":"11:41:26 AM","TRANID1":"16376097",
 *  "MULTIPLE_ID":"16376098","AMOUNT":10,"IS_TAX":"N","UPI_DATE_TIME":"15/02/2021 11:44 AM",
 *  "SCH_NAME":"ICICI Prudential Liquid Fund - Growth","SCH_CODE":"1565","TAX_STATUS":"01",
 *  "MINOR_FOLIO":"N","OperationCode":"92","OperationErrorMessage":"Transaction initiated successfully.
 *  Please accept the request in your bank UPI App within 3 minutes to complete the transaction."}]
 * */
class SubmitUpiExistingInvestor {
  static const String path = 'api/submitIBankUpiPurchaseExt';
  static const String fldFolioNo = 'foliono';
  static const String fldChkDigit = 'chkdigit';
  static const String fldAmount = 'amount';
  static const String fldBankCode = 'bankcode';
  static const String fldBankAccNo = 'bankaccno';
  static const String fldPan = 'firstpan';
  static const String fldVPA = 'vpa';

  static const String resTrnId = "TRANID";
  static const String resSessionId = "SESSION";
  static const String resUpiTime = 'UPI_DATE_TIME';
  static const String resMultipleId = "MULTIPLE_ID";
  static const String resMsg = 'MSG';
}

/**
 * {"STATUS":"0","ERR_DESCRIPTION":""}
 * [{"STATUS":"","ERR_DESCRIPTION":"Reference No does not exist"}]
 * */
class GetPaidStatus {
  static const String path = 'api/getPaidStatus';
  static const String fldTranId = 'tranid';
  static const String fldPan = 'firstpan';

  static const String resStatus = 'STATUS';
  static const String resErrorDesc = 'ERR_DESCRIPTION';

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
class CheckFolioBalance {
  static const String path = 'api/checkIMPSAllowed';
  static const String fldFolioNo = 'foliono';

  static const String resInstantBalance = "REDEEMABLEAMOUNT";
  static const String resTotalBalance = "TAMOUNT";
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
class CheckIMPSStatus {
  static const String path = 'api/checkIMPSAllowed';
  static const String fldFolioNo = 'foliono';
  static const String fldAmount = 'amount';

  static const String resReturnCode = "RETURNCODE";
  static const String resReturnMsg = "MESSAGE";
  static const String resAllowIMPSFlag = "ALLOWIMPS";
  static const String resInstantBalance = "REDEEMABLEAMOUNT";
  static const String resTotalBalance = "TAMOUNT";

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
class GetExitLoad {
  static const String path = 'api/getExitLoad';
  static const String fldFolioNo = 'foliono';
  static const String fldAmount = 'amount';

  static const String resApproxLoadAmt = 'ApproxLoadAmt';
  static const String resPopUpFlag = 'PopUpFlag';

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
class GetBankRedemptionDetail {
  static const String path = 'api/getRedeemBankDetails';
  static const String fldFolioNo = 'foliono';

  static const String resBankName = "BANK_NAME";
  static const String resCombinedAccountDetails = "BANK_DETAILS";
  static const String resCombinedBankDetails = "REDEEM_BANK_DETAILS";

  static String getBankAccNo(String rawStr) => rawStr.split('#')[0];
  static String getBankIfsc(String rawStr) => rawStr.split('#')[1];
  static String getBankCode(String rawStr) => rawStr.split('#')[2];

  static String getBankAccType(String rawStr) => rawStr.split('#')[2];
  static String getBankBranch(String rawStr) => rawStr.split('#')[3];
  static String getBankCity(String rawStr) => rawStr.split('#')[4];
  static String getRedeemMode(String rawStr) => rawStr.split('#')[5];
}

/**
 *
    {"TRANID":"16338804","TRXN_DATE":"11/02/2021","TRXN_TIME":"08:05:39
    PM","BANK_RRN":"","IMPS_CODE":"1005","IMPS_STATUS":"The Redemption transaction value is more than the eligible amount."}

    {"TRANID":"16338811","TRXN_DATE":"11/02/2021","TRXN_TIME":"08:06:23
    PM","BANK_RRN":"104220778133","IMPS_CODE":"0","IMPS_STATUS":"Transaction Successful"}
 * */
class SubmitRedemption {
  static const String path = 'api/submitRedemption';
  static const String fldFolioNo = 'foliono';
  static const String fldAmount = 'amount';
  static const String fldBankCode = 'bankcode';
  static const String fldMobile = 'mobile'; //'919986643444' format
  static const String fldBankName = 'bankname';
  static const String fldAccNo = 'accno';
  static const String fldAccType = 'acctype';
  static const String fldBankBranch = 'bankbranch';
  static const String fldBankCity = 'bankcity';
  static const String fldRedeemMode = 'redeemmode';
  static const String fldIfsc = 'ifsc';
  static const String fldExitLoadTick = 'exitloadtick';
  static const String fldApproxLoadAmount = 'approxloadamt';

  static const String resTranId = 'TRANID';
  static const String resTrnTime = 'TRXN_TIME';
  static const String resBankRnn = 'BANK_RNN';
  static const String resIMPSCode = 'IMPS_CODE';
  static const String resIMPSStatus = 'IMPS_STATUS';

  static const String IMPS_TRANSACTION_SUCCESS = '0';
}

class SubmitRedemptionNonInstant {
  static const String path = 'api/submitRedemptionNonInstant';
  static const String fldFolioNo = 'foliono';
  static const String fldPan = 'firstpan';
  static const String fldAmount = 'amount';
  static const String fldBankCode = 'bankcode';
  static const String fldBankName = 'bankname';
  static const String fldAccNo = 'accno';
  static const String fldAccType = 'acctype';
  static const String fldBankBranch = 'bankbranch';
  static const String fldBankCity = 'bankcity';
  static const String fldRedeemMode = 'redeemmode';
  static const String fldIfsc = 'ifsc';

  static const String resTranId = 'TRANID';
  static const String resTrnTime = 'TRXN_TIME';
  static const String resBankRnn = 'BANK_RNN';
  static const String resIMPSCode = 'IMPS_CODE';
  static const String resIMPSStatus = 'IMPS_STATUS';

  static const String IMPS_TRANSACTION_SUCCESS = '0';
}

class SendRedemptionOtp {
  static const String path = 'api/sendRedemptionOtp';
  static const String fldFolioNo = 'foliono';
  static const String fldTranId = 'tranid';

  static const String resOtpId = 'OTP_ID';
}

class VerifyRedemptionOtp {
  static const String path = 'api/verifyRedemptionOtp';
  static const String fldFolioNo = 'foliono';
  static const String fldTranId = 'tranid';
  static const String fldOtpId = 'otpid';
  static const String fldOtp = 'otp';

  static const String resStatus = 'STATUS';
}
