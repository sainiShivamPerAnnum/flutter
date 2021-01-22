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

  static final int KYC_STATUS_INVALID = 0;
  static final int KYC_STATUS_VALID = 1;
  static final int KYC_STATUS_FETCH_FAILED = 2;
  static final int KYC_STATUS_SERVICE_DOWN = 3;
  static final int KYC_STATUS_ALLOW_VIDEO = 4;
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
  static final String fldBankAccNo = 'bankaccno';
  static final String fldBankName = 'bankname';
  static final String fldBankCode = 'bankcode';
  static final String fldIfsc = 'ifsc';
  static final String fldCity = 'city';
  static final String fldBranch = 'branch';
  static final String fldAddress = 'address';
  static final String fldPan = 'firstpan';
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