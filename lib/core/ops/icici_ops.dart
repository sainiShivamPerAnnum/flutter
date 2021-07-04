import 'dart:convert';

import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ICICIModel extends ChangeNotifier {
  final Log log = new Log('ICICIModel');
  DBModel _dbModel = locator<DBModel>();
  final String defaultBaseUri =
      'https://jh4sg5o8n2.execute-api.ap-south-1.amazonaws.com/prod';
  String _baseUri;
  String _apiKey;
  var headers;

  Future<bool> init() async {
    if (_dbModel == null) return false;
    Map<String, String> cMap = await _dbModel.getActiveAwsIciciApiKey();
    if (cMap == null) return false;

    _baseUri = (cMap['baseuri'] == null || cMap['baseuri'].isEmpty)
        ? defaultBaseUri
        : cMap['baseuri'];
    _apiKey = cMap['key'];
    headers = {'x-api-key': _apiKey};
    return true;
  }

  bool isInit() => (_apiKey != null);

  Future<Map<String, dynamic>> getKycStatus(String panNumber) async {
    var _params = {GetKycStatus.fldPan: panNumber};
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(GetKycStatus.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      log.debug(resMap[GetKycStatus.resPanStatus]);
      log.debug(resMap[GetKycStatus.resStatus]);
      log.debug(
          (resMap[GetKycStatus.resStatus] == GetKycStatus.KYC_STATUS_VALID)
              .toString());
      resMap["flag"] = QUERY_PASSED;

      return resMap;
    }
  }

  Future<Map<String, dynamic>> submitPanDetails(
      String panNumber, String fullName) async {
    var _params = {
      SubmitPanDetail.fldPan: panNumber,
      SubmitPanDetail.fldName: fullName
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(SubmitPanDetail.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      log.debug(resMap[SubmitPanDetail.resStatus]);
      log.debug(resMap[SubmitPanDetail.resId]);
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;

      return resMap;
    }
  }

  Future<Map<String, dynamic>> submitBasicDetails(String appid,
      String panNumber, String mobile, String email, String dob) async {
    var _params = {
      SubmitInvoiceDetail.fldPan: panNumber,
      SubmitInvoiceDetail.fldId: appid,
      SubmitInvoiceDetail.fldMobile: mobile,
      SubmitInvoiceDetail.fldEmail: email,
      SubmitInvoiceDetail.fldDob: dob,
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(SubmitInvoiceDetail.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      log.debug(resMap[SubmitInvoiceDetail.resStatus]);
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;

      return resMap;
    }
  }

  Future<Map<String, dynamic>> submitSecondaryDetails(
      String id,
      String occupationCode,
      String incomeCode,
      String politicalCode,
      String panNumber,
      String srcOfWealth) async {
    var _params = {
      SubmitInvKYCDetail.fldId: id,
      SubmitInvKYCDetail.fldPan: panNumber,
      SubmitInvKYCDetail.fldOccpCde: occupationCode,
      SubmitInvKYCDetail.fldPolOp: politicalCode,
      SubmitInvKYCDetail.fldSrcWealth: srcOfWealth,
      SubmitInvKYCDetail.fldIncome: incomeCode
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(SubmitInvKYCDetail.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      log.debug(resMap[SubmitInvKYCDetail.resStatus]);
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;

      return resMap;
    }
  }

  Future<Map<String, dynamic>> submitFatcaDetails(
      String id, String panNumber, bool fatcaOption) async {
    var _params = {
      SubmitFatca.fldId: id,
      SubmitFatca.fldPan: panNumber,
      SubmitFatca.fldTaxId: '',
      SubmitFatca.fldIdType: 'PAN',
      SubmitFatca.fldFatcaOption: fatcaOption ? 'Y' : 'N',
      SubmitFatca.fldBirthplace: '',
      SubmitFatca.fldTinResn: 'A',
      SubmitFatca.fldTinResnText: ''
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(SubmitFatca.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      log.debug(resMap[SubmitFatca.resStatus]);
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;

      return resMap;
    }
  }

  Future<Map<String, dynamic>> submitBankDetails(
      String appid,
      String panNumber,
      String paymode,
      String acctype,
      String accno,
      String bankname,
      String bankcode,
      String ifsc,
      String city,
      String branch,
      String address) async {
    var _params = {
      SubmitBankDetails.fldPan: panNumber,
      SubmitBankDetails.fldId: appid,
      SubmitBankDetails.fldPayMode: paymode,
      SubmitBankDetails.fldAccType: acctype,
      SubmitBankDetails.fldBankAccNo: accno,
      SubmitBankDetails.fldBankName: bankname,
      SubmitBankDetails.fldBankCode: bankcode,
      SubmitBankDetails.fldIfsc: ifsc,
      SubmitBankDetails.fldCity: city,
      SubmitBankDetails.fldBranch: branch,
      SubmitBankDetails.fldAddress: address,
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(SubmitBankDetails.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
      return resMap;
    }
  }

  Future<Map<String, dynamic>> getBankInfo(
      String panNumber, String ifsc) async {
    var _params = {
      GetBankDetail.fldPan: panNumber,
      GetBankDetail.fldIFSC: ifsc
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(GetBankDetail.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
      return resMap;
    }
  }

  Future<List<Map<String, String>>> getBankAcctTypes(String panNumber) async {
    var _params = {
      GetBankActType.fldPan: panNumber,
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(GetBankActType.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resList = await processBankAcctResponse(_response);
    if (resList == null) {
      log.error('Query Failed');
      return null;
    } else {
      return resList;
    }
  }

  Future<Map<String, dynamic>> sendOtp(String mobile, String email) async {
    var _params = {SendOtp.fldMobile: mobile, SendOtp.fldEmail: email};
    var _request =
        http.Request('GET', Uri.parse(constructRequest(SendOtp.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else {
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
      return resMap;
    }
  }

  Future<Map<String, dynamic>> resendOtp(
      String prevOtpId, String mobile, String email) async {
    var _params = {
      ResendOtp.fldOtpId: prevOtpId,
      ResendOtp.fldMobile: mobile,
      ResendOtp.fldEmail: email
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(ResendOtp.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
      return resMap;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String prevOtpId, String otp) async {
    var _params = {VerifyOtp.fldOtpId: prevOtpId, VerifyOtp.fldOtp: otp};
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(VerifyOtp.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
      return resMap;
    }
  }

  Future<Map<String, dynamic>> getSavedApplication(
      String panNumber, String id) async {
    var _params = {GetSavedDetail.fldId: id, GetSavedDetail.fldPan: panNumber};
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(GetSavedDetail.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else {
      return {QUERY_SUCCESS_FLAG: QUERY_PASSED};
    }
  }

  Future<Map<String, dynamic>> createPortfolio(String id, String otpId) async {
    var _params = {CreatePortfolio.fldId: id, CreatePortfolio.fldOtpId: otpId};
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(CreatePortfolio.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resList = await processPortfolioResponse(_response);
    if (resList == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else {
      Map<String, dynamic> yMap = resList[0];
      if (yMap != null && yMap[CreatePortfolio.resReturnCode] != null) {
        yMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
        return yMap;
      } else {
        return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
      }
    }
  }

  Future<Map<String, dynamic>> initiateUPIPurchaseForNewInvestor(
      String id,
      String email,
      String bankCode,
      String panNumber,
      String folioNumber,
      String kycMode,
      String amount,
      String vpaAddress) async {
    var _params = {
      SubmitUpiNewInvestor.fldId: id,
      SubmitUpiNewInvestor.fldEmail: email,
      SubmitUpiNewInvestor.fldBankCode: bankCode,
      SubmitUpiNewInvestor.fldPan: panNumber,
      SubmitUpiNewInvestor.fldFolioNo: folioNumber,
      SubmitUpiNewInvestor.fldKycMode: kycMode,
      SubmitUpiNewInvestor.fldAmount: amount,
      SubmitUpiNewInvestor.fldVPA: vpaAddress
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(SubmitUpiNewInvestor.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resList = await processPurchaseResponse(_response);
    if (resList == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else {
      Map<String, dynamic> yMap = resList[0];
      if (yMap != null && yMap[SubmitUpiNewInvestor.resTrnId] != null) {
        yMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
        return yMap;
      } else {
        yMap[QUERY_SUCCESS_FLAG] = QUERY_FAILED;
        return yMap;
      }
    }
  }

  Future<Map<String, dynamic>> initiateUPIPurchaseForExistingInvestor(
      String folioNumber,
      String chkDigit,
      String amount,
      String bankCode,
      String bankAccNo,
      String panNumber,
      String vpaAddress) async {
    var _params = {
      SubmitUpiExistingInvestor.fldFolioNo: folioNumber,
      SubmitUpiExistingInvestor.fldChkDigit: chkDigit,
      SubmitUpiExistingInvestor.fldAmount: amount,
      SubmitUpiExistingInvestor.fldBankCode: bankCode,
      SubmitUpiExistingInvestor.fldBankAccNo: bankAccNo,
      SubmitUpiExistingInvestor.fldPan: panNumber,
      SubmitUpiExistingInvestor.fldVPA: vpaAddress,
    };
    var _request = http.Request('GET',
        Uri.parse(constructRequest(SubmitUpiExistingInvestor.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resList = await processPurchaseResponse(_response);
    if (resList == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else {
      Map<String, dynamic> yMap = resList[0];
      if (yMap != null && yMap[SubmitUpiNewInvestor.resTrnId] != null) {
        yMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
        return yMap;
      } else {
        yMap[QUERY_SUCCESS_FLAG] = QUERY_FAILED;
        return yMap;
      }
    }
  }

  Future<Map<String, dynamic>> getPaidStatus(
      String tranId, String panNumber) async {
    var _params = {
      GetPaidStatus.fldTranId: tranId,
      GetPaidStatus.fldPan: panNumber
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(GetPaidStatus.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();
    //return {"STATUS": "1", "ERR_DESCRIPTION": ""};
    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      if (resMap[GetPaidStatus.resStatus] != null) {
        resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
        return resMap;
      } else {
        return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
      }
    }
  }

  Future<Map<String, dynamic>> checkIMPSEligible(
      String folioNumber, String amount) async {
    var _params = {
      CheckIMPSStatus.fldFolioNo: folioNumber,
      CheckIMPSStatus.fldAmount: amount
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(CheckIMPSStatus.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resList = await processCheckIMPSResponse(_response);
    if (resList == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else {
      Map<String, dynamic> resMap = resList[0];
      if (resMap[CheckIMPSStatus.resReturnCode] == null) {
        resMap[QUERY_SUCCESS_FLAG] = QUERY_FAILED;
        return resMap;
      } else {
        resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
        return resMap;
      }
    }
  }

  Future<Map<String, dynamic>> getExitLoadStatus(
      String folioNumber, String amount) async {
    var _params = {
      GetExitLoad.fldFolioNo: folioNumber,
      GetExitLoad.fldAmount: amount
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(GetExitLoad.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      if (resMap[GetExitLoad.resPopUpFlag] == null) {
        resMap[QUERY_SUCCESS_FLAG] = QUERY_FAILED;
        return resMap;
      } else {
        resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
        return resMap;
      }
    }
  }

  Future<Map<String, dynamic>> getBankRedeemDetails(String folioNumber) async {
    var _params = {
      GetBankRedemptionDetail.fldFolioNo: folioNumber,
    };
    var _request = http.Request('GET',
        Uri.parse(constructRequest(GetBankRedemptionDetail.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resList = await processBankRedeemDetailResponse(_response);
    if (resList == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else {
      Map<String, dynamic> resMap = resList[0];
      if (resMap[GetBankRedemptionDetail.resCombinedAccountDetails] == null ||
          resMap[GetBankRedemptionDetail.resCombinedBankDetails] == null) {
        resMap[QUERY_SUCCESS_FLAG] = QUERY_FAILED;
        return resMap;
      } else {
        resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
        return resMap;
      }
    }
  }

  Future<Map<String, dynamic>> submitInstantWithdrawal(
      String folioNumber,
      String amount,
      String bankCode,
      String mobile,
      String bankName,
      String accNo,
      String accType,
      String bankBranch,
      String bankCity,
      String redeemMode,
      String ifsc,
      String exitLoadTick,
      String apprxLoadAmt) async {
    var _params = {
      SubmitRedemption.fldFolioNo: folioNumber,
      SubmitRedemption.fldAmount: amount,
      SubmitRedemption.fldBankCode: bankCode,
      SubmitRedemption.fldMobile: mobile,
      SubmitRedemption.fldBankName: bankName,
      SubmitRedemption.fldAccNo: accNo,
      SubmitRedemption.fldAccType: accType,
      SubmitRedemption.fldBankBranch: bankBranch,
      SubmitRedemption.fldBankCity: bankCode,
      SubmitRedemption.fldRedeemMode: redeemMode,
      SubmitRedemption.fldIfsc: ifsc,
    };
    if (exitLoadTick != null && apprxLoadAmt != null) {
      _params[SubmitRedemption.fldExitLoadTick] = exitLoadTick;
      _params[SubmitRedemption.fldApproxLoadAmount] = apprxLoadAmt;
    }
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(SubmitRedemption.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
      return resMap;
    }
  }

  Future<Map<String, dynamic>> submitNonInstantWithdrawal(
      String folioNumber,
      String pan,
      String amount,
      String bankCode,
      String bankName,
      String accNo,
      String accType,
      String bankBranch,
      String bankCity,
      String redeemMode,
      String ifsc) async {
    var _params = {
      SubmitRedemptionNonInstant.fldFolioNo: folioNumber,
      SubmitRedemptionNonInstant.fldPan: pan,
      SubmitRedemptionNonInstant.fldAmount: amount,
      SubmitRedemptionNonInstant.fldBankCode: bankCode,
      SubmitRedemptionNonInstant.fldBankName: bankName,
      SubmitRedemptionNonInstant.fldAccNo: accNo,
      SubmitRedemptionNonInstant.fldAccType: accType,
      SubmitRedemptionNonInstant.fldBankBranch: bankBranch,
      SubmitRedemptionNonInstant.fldBankCity: bankCode,
      SubmitRedemptionNonInstant.fldRedeemMode: redeemMode,
      SubmitRedemptionNonInstant.fldIfsc: ifsc,
    };

    var _request = http.Request('GET',
        Uri.parse(constructRequest(SubmitRedemptionNonInstant.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else if (!resMap[INTERNAL_FAIL_FLAG]) {
      return {
        QUERY_SUCCESS_FLAG: QUERY_FAILED,
        QUERY_FAIL_REASON: resMap["userMessage"]
      };
    } else {
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
      return resMap;
    }
  }

  Future<Map<String, dynamic>> sendRedemptionOtp(
      String foliono, String tranid) async {
    var _params = {
      SendRedemptionOtp.fldFolioNo: foliono,
      SendRedemptionOtp.fldTranId: tranid
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(SendRedemptionOtp.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null ||
        resMap[SendRedemptionOtp.resOtpId] == null ||
        resMap[SendRedemptionOtp.resOtpId] == '') {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else {
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
      return resMap;
    }
  }

  Future<Map<String, dynamic>> verifyRedemptionOtp(
      String foliono, String tranid, String otpid, String otp) async {
    var _params = {
      VerifyRedemptionOtp.fldFolioNo: foliono,
      VerifyRedemptionOtp.fldTranId: tranid,
      VerifyRedemptionOtp.fldOtpId: otpid,
      VerifyRedemptionOtp.fldOtp: otp
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(VerifyRedemptionOtp.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null ||
        resMap[VerifyRedemptionOtp.resStatus] == null ||
        resMap[VerifyRedemptionOtp.resStatus] != '1') {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    } else {
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;
      return resMap;
    }
  }

  String constructRequest(String subPath, Map<String, String> params) {
    String _path = '$_baseUri/$subPath';
    if (params != null && params.length > 0) {
      String _p = '';
      if (params.length == 1) {
        _p = params.keys.elementAt(0) +
            '=' +
            Uri.encodeComponent(params.values.elementAt(0));
        _path = '$_path?$_p';
      } else {
        params.forEach((key, value) {
          _p = '$_p$key=$value&';
        });
        _p = _p.substring(0, _p.length - 1);
        _path = '$_path?$_p';
      }
    }
    return _path;
  }

  Future<Map<String, dynamic>> processResponse(
      http.StreamedResponse response) async {
    if (response == null) {
      log.error('response is null');
    }
    if (response.statusCode != 200) {
      log.error(
          'Query Failed:: Status:${response.statusCode}, Reason:${response.reasonPhrase}');
      if (response.statusCode == 502)
        return {
          INTERNAL_FAIL_FLAG: false,
          "userMessage": "ICICI did not respond correctly"
        };
      else
        return {
          INTERNAL_FAIL_FLAG: false,
          "userMessage": "Unknown error occurred while sending request"
        };
    }
    try {
      String res = await response.stream.bytesToString();
      log.debug(res);
      if (res == null || res.isEmpty || res == "\"\"") {
        log.error('Returned empty response');
        return {
          INTERNAL_FAIL_FLAG: false,
          "userMessage": "The entered data was not accepted"
        };
      }
      var rMap = json.decode(res);
      rMap[INTERNAL_FAIL_FLAG] = true;
      return rMap;
    } catch (e) {
      log.error('Failed to decode json');
      return null;
    }
  }

  Future<List<Map<String, String>>> processBankAcctResponse(
      http.StreamedResponse response) async {
    if (response == null) {
      log.error('response is null');
    }
    if (response.statusCode != 200) {
      log.error(
          'Query Failed:: Status:${response.statusCode}, Reason:${response.reasonPhrase}');
      if (response.statusCode == 502)
        return null;
      else
        return null;
    }
    try {
      String res = await response.stream.bytesToString();
      log.debug(res);
      if (res == null || res.isEmpty || res == "\"\"") {
        log.error('Returned empty response');
        return null;
      }
      List<dynamic> rList = json.decode(res);
      //rMap[INTERNAL_FAIL_FLAG] = true;
      List<Map<String, String>> refList = new List();
      rList.forEach((element) {
        refList.add({
          'CODE': element['BANK_ACT_VALUE'],
          'NAME': element['BANK_ACT_TYPE']
        });
      });
      log.debug(refList.toString());
      return refList;
    } catch (e) {
      log.error('Failed to decode json');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> processPortfolioResponse(
      http.StreamedResponse response) async {
    if (response == null) {
      log.error('response is null');
    }
    if (response.statusCode != 200) {
      log.error(
          'Query Failed:: Status:${response.statusCode}, Reason:${response.reasonPhrase}');
      if (response.statusCode == 502)
        return null;
      else
        return null;
    }
    try {
      String res = await response.stream.bytesToString();
      log.debug(res);
      if (res == null || res.isEmpty || res == "\"\"") {
        log.error('Returned empty response');
        return null;
      }
      List<dynamic> rList = json.decode(res);
      List<Map<String, dynamic>> refList = new List();
      rList.forEach((element) {
        refList.add({
          CreatePortfolio.resReturnCode: element[CreatePortfolio.resReturnCode],
          CreatePortfolio.resRetMessage: element[CreatePortfolio.resRetMessage],
          CreatePortfolio.resFolioNo: element[CreatePortfolio.resFolioNo] ?? '',
          CreatePortfolio.resExpiryDate:
              element[CreatePortfolio.resExpiryDate] ?? '',
          CreatePortfolio.resAMCRefNo:
              element[CreatePortfolio.resAMCRefNo] ?? '',
          CreatePortfolio.resPayoutId:
              element[CreatePortfolio.resPayoutId] ?? '',
          CreatePortfolio.resChkDigit:
              element[CreatePortfolio.resChkDigit] ?? '',
        });
      });
      log.debug(refList.toString());
      return refList;
    } catch (e) {
      log.error('Failed to decode json');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> processPurchaseResponse(
      http.StreamedResponse response) async {
    if (response == null) {
      log.error('response is null');
    }
    if (response.statusCode != 200) {
      log.error(
          'Query Failed:: Status:${response.statusCode}, Reason:${response.reasonPhrase}');
      if (response.statusCode == 502)
        return null;
      else
        return null;
    }
    try {
      String res = await response.stream.bytesToString();
      log.debug(res);
      if (res == null || res.isEmpty || res == "\"\"") {
        log.error('Returned empty response');
        return null;
      }
      //  String dummmy = '[{"TRANID":"3433599","TRXN_DATE":"01/02/2021","TRXN_TIME":"12:47:39 PM","INV_NAME":"SHOURYADITYA RAY LALA",'
      //       +'"MOBILE_NO":9986643444,"SCH_NAME":"ICICI Prudential Liquid Fund - Growth","MULTIPLE_ID":"3433598",'
      // + '"AMOUNT":100,"UPI_DATE_TIME":"01/02/2021 12:50 PM","TRIG_SCHEME":null,"USERNAME":null,"TRAN_ID":"3433599",'
      // + '"DISPLAY_NAME":null,"IS_TAX":"N","LTEF_URL":null}]';
      List<dynamic> rList = json.decode(res);
      List<Map<String, dynamic>> refList = [];
      rList.forEach((element) {
        refList.add({
          SubmitUpiNewInvestor.resTrnId: element[SubmitUpiNewInvestor.resTrnId],
          SubmitUpiNewInvestor.resMultipleId:
              element[SubmitUpiNewInvestor.resMultipleId] ?? '',
          SubmitUpiNewInvestor.resTrnDate:
              element[SubmitUpiNewInvestor.resTrnDate],
          SubmitUpiNewInvestor.resUpiTime:
              element[SubmitUpiNewInvestor.resUpiTime]
        });
      });
      log.debug(refList.toString());
      return refList;
    } catch (e) {
      log.error('Failed to decode json');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> processCheckIMPSResponse(
      http.StreamedResponse response) async {
    if (response == null) {
      log.error('response is null');
    }
    if (response.statusCode != 200) {
      log.error(
          'Query Failed:: Status:${response.statusCode}, Reason:${response.reasonPhrase}');
      if (response.statusCode == 502)
        return null;
      else
        return null;
    }
    try {
      String res = await response.stream.bytesToString();
      log.debug(res);
      if (res == null || res.isEmpty || res == "\"\"") {
        log.error('Returned empty response');
        return null;
      }
      List<dynamic> rList = json.decode(res);
      List<Map<String, dynamic>> refList = [];
      rList.forEach((element) {
        refList.add({
          CheckIMPSStatus.resReturnCode: element[CheckIMPSStatus.resReturnCode],
          CheckIMPSStatus.resAllowIMPSFlag:
              element[CheckIMPSStatus.resAllowIMPSFlag],
          CheckIMPSStatus.resReturnMsg: element[CheckIMPSStatus.resReturnMsg],
          CheckIMPSStatus.resInstantBalance:
              element[CheckIMPSStatus.resInstantBalance],
          CheckIMPSStatus.resTotalBalance:
              element[CheckIMPSStatus.resTotalBalance]
        });
      });
      log.debug(refList.toString());
      return refList;
    } catch (e) {
      log.error('Failed to decode json');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> processBankRedeemDetailResponse(
      http.StreamedResponse response) async {
    if (response == null) {
      log.error('response is null');
    }
    if (response.statusCode != 200) {
      log.error(
          'Query Failed:: Status:${response.statusCode}, Reason:${response.reasonPhrase}');
      if (response.statusCode == 502)
        return null;
      else
        return null;
    }
    try {
      String res = await response.stream.bytesToString();
      log.debug(res);
      if (res == null || res.isEmpty || res == "\"\"") {
        log.error('Returned empty response');
        return null;
      }
      List<dynamic> rList = json.decode(res);
      List<Map<String, dynamic>> refList = new List();
      rList.forEach((element) {
        refList.add({
          GetBankRedemptionDetail.resBankName:
              element[GetBankRedemptionDetail.resBankName],
          GetBankRedemptionDetail.resCombinedAccountDetails:
              element[GetBankRedemptionDetail.resCombinedAccountDetails],
          GetBankRedemptionDetail.resCombinedBankDetails:
              element[GetBankRedemptionDetail.resCombinedBankDetails],
        });
      });
      log.debug(refList.toString());
      return refList;
    } catch (e) {
      log.error('Failed to decode json');
      return null;
    }
  }
}
