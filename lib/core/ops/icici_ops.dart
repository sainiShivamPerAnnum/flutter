import 'dart:convert';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:felloapp/util/icici_api_util.dart';

class ICICIModel extends ChangeNotifier{
  final Log log = new Log('ICICIModel');
  DBModel _dbModel = locator<DBModel>();
  final String defaultBaseUri = 'https://r3bb6bx3p6.execute-api.ap-south-1.amazonaws.com/dev';
  String _baseUri;
  String _apiKey;
  var headers;

  Future<bool> init() async{
    if(_dbModel == null) return false;
    Map<String,String> cMap = await _dbModel.getActiveAwsApiKey();
    if(cMap == null) return false;

    _baseUri = (cMap['baseuri'] == null || cMap['baseuri'].isEmpty)?defaultBaseUri:cMap['baseuri'];
    _apiKey = cMap['key'];
    headers = {
      'x-api-key': _apiKey
    };
    return true;
  }

  bool isInit() => (_apiKey != null);

  Future<Map<String, dynamic>> getKycStatus(String panNumber) async{
    var _params = {GetKycStatus.fldPan: panNumber};
    var _request = http.Request('GET',
        Uri.parse(constructRequest(GetKycStatus.path,_params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if(resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    }else if(!resMap[INTERNAL_FAIL_FLAG]){
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED, QUERY_FAIL_REASON: resMap["userMessage"]};
    }else{
      log.debug(resMap[GetKycStatus.resPanStatus]);
      log.debug(resMap[GetKycStatus.resStatus]);
      log.debug((resMap[GetKycStatus.resStatus] == GetKycStatus.KYC_STATUS_VALID).toString());
      resMap["flag"] = QUERY_PASSED;

      return resMap;
    }
  }

  Future<Map<String, dynamic>> submitPanDetails(String panNumber, String fullName) async{
    var _params = {
      SubmitPanDetail.fldPan: panNumber,
      SubmitPanDetail.fldName: fullName
    };
    var _request = http.Request('GET',
        Uri.parse(constructRequest(SubmitPanDetail.path,_params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if(resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    }else if(!resMap[INTERNAL_FAIL_FLAG]){
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED, QUERY_FAIL_REASON: resMap["userMessage"]};
    }else{
      log.debug(resMap[SubmitPanDetail.resStatus]);
      log.debug(resMap[SubmitPanDetail.resId]);
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;

      return resMap;
    }
  }

  Future<Map<String, dynamic>> submitBasicDetails(String appid,
      String panNumber, String mobile, String email, String dob) async{
    var _params = {
      SubmitInvoiceDetail.fldPan: panNumber,
      SubmitInvoiceDetail.fldId: appid,
      SubmitInvoiceDetail.fldMobile: mobile,
      SubmitInvoiceDetail.fldEmail: email,
      SubmitInvoiceDetail.fldDob: dob,
    };
    var _request = http.Request('GET',
        Uri.parse(constructRequest(SubmitInvoiceDetail.path,_params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if(resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    }else if(!resMap[INTERNAL_FAIL_FLAG]){
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED, QUERY_FAIL_REASON: resMap["userMessage"]};
    }else{
      log.debug(resMap[SubmitInvoiceDetail.resStatus]);
      resMap[QUERY_SUCCESS_FLAG] = QUERY_PASSED;

      return resMap;
    }
  }

  Future<Map<String, dynamic>> submitSecondaryDetails(String id,
      String occupationCode, String incomeCode, String politicalCode,
      String panNumber, String srcOfWealth) async{
    var _params = {
      SubmitInvKYCDetail.fldId:id,
      SubmitInvKYCDetail.fldPan:panNumber,
      SubmitInvKYCDetail.fldOccpCde:occupationCode,
      SubmitInvKYCDetail.fldPolOp:politicalCode,
      SubmitInvKYCDetail.fldSrcWealth:srcOfWealth,
      SubmitInvKYCDetail.fldIncome:incomeCode
    };
    var _request = http.Request('GET',
        Uri.parse(constructRequest(SubmitInvKYCDetail.path,_params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if(resMap == null) {
      log.error('Query Failed');
      return {"flag": QUERY_FAILED};
    }else{
      // log.debug(resMap[SubmitPanDetail.resStatus]);
      // log.debug(resMap[SubmitPanDetail.resId]);
      return {"flag": QUERY_PASSED};
    }
  }

  Future<Map<String, dynamic>> submitBankDetails(String appid,
      String panNumber, String paymode, String acctype, String accno,
      String bankname, String bankcode, String ifsc, String city,
      String branch, String address) async{
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
    var _request = http.Request('GET',
        Uri.parse(constructRequest(SubmitBankDetails.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if(resMap == null) {
      log.error('Query Failed');
      return {"flag": QUERY_FAILED};
    }else{
      // log.debug(resMap[SubmitPanDetail.resStatus]);
      // log.debug(resMap[SubmitPanDetail.resId]);
      return {"flag": QUERY_PASSED};
    }
  }

  Future<Map<String, dynamic>> getBankInfo(String panNumber
      ,String ifsc) async{
    var _params = {
      GetBankDetail.fldPan:panNumber,
      GetBankDetail.fldIFSC:ifsc
    };
    var _request = http.Request('GET',
        Uri.parse(constructRequest(GetBankDetail.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if(resMap == null) {
      log.error('Query Failed');
      return {"flag": QUERY_FAILED};
    }else{
      // log.debug(resMap[SubmitPanDetail.resStatus]);
      // log.debug(resMap[SubmitPanDetail.resId]);
      return {"flag": QUERY_PASSED};
    }
  }

  Future<Map<String, dynamic>> getBankAcctTypes(String panNumber) async{
    var _params = {
      GetBankActType.fldPan:panNumber,
    };
    var _request = http.Request('GET',
        Uri.parse(constructRequest(GetBankActType.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processArrayResponse(_response);
    if(resMap == null) {
      log.error('Query Failed');
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED};
    }else if(!resMap[INTERNAL_FAIL_FLAG]){
      return {QUERY_SUCCESS_FLAG: QUERY_FAILED, QUERY_FAIL_REASON: resMap["userMessage"]};
    }else{

      return {"flag": QUERY_PASSED};
    }
  }

  Future<Map<String, dynamic>> sendOtp(String mobile, String email) async{
    var _params = {
      SendOtp.fldMobile:mobile,
      SendOtp.fldEmail:email
    };
    var _request = http.Request('GET',
        Uri.parse(constructRequest(SendOtp.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if(resMap == null) {
      log.error('Query Failed');
      return {"flag": QUERY_FAILED};
    }else{
      // log.debug(resMap[SubmitPanDetail.resStatus]);
      // log.debug(resMap[SubmitPanDetail.resId]);
      return {"flag": QUERY_PASSED};
    }
  }

  Future<Map<String, dynamic>> resendOtp(String prevOtpId,
      String mobile, String email) async{
    var _params = {
      ResendOtp.fldOtpId:prevOtpId,
      ResendOtp.fldMobile:mobile,
      ResendOtp.fldEmail:email
    };
    var _request = http.Request('GET',
        Uri.parse(constructRequest(ResendOtp.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if(resMap == null) {
      log.error('Query Failed');
      return {"flag": QUERY_FAILED};
    }else{
      // log.debug(resMap[SubmitPanDetail.resStatus]);
      // log.debug(resMap[SubmitPanDetail.resId]);
      return {"flag": QUERY_PASSED};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String prevOtpId,
      String otp) async{
    var _params = {
      VerifyOtp.fldOtpId:prevOtpId,
      VerifyOtp.fldOtp:otp
    };
    var _request = http.Request('GET',
        Uri.parse(constructRequest(VerifyOtp.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if(resMap == null) {
      log.error('Query Failed');
      return {"flag": QUERY_FAILED};
    }else{
      // log.debug(resMap[SubmitPanDetail.resStatus]);
      // log.debug(resMap[SubmitPanDetail.resId]);
      return {"flag": QUERY_PASSED};
    }
  }

  Future<Map<String, dynamic>> getSavedApplication(String panNumber,
      String id) async{
    var _params = {
      GetSavedDetail.fldId:id,
      GetSavedDetail.fldPan:panNumber
    };
    var _request = http.Request('GET',
        Uri.parse(constructRequest(GetSavedDetail.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if(resMap == null) {
      log.error('Query Failed');
      return {"flag": QUERY_FAILED};
    }else{
      // log.debug(resMap[SubmitPanDetail.resStatus]);
      // log.debug(resMap[SubmitPanDetail.resId]);
      return {"flag": QUERY_PASSED};
    }
  }

  Future<Map<String, dynamic>> createPortfolio(String id,
      String otpId) async{
    var _params = {
      CreatePortfolio.fldId:id,
      CreatePortfolio.fldOtpId:otpId
    };
    var _request = http.Request('GET',
        Uri.parse(constructRequest(CreatePortfolio.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if(resMap == null) {
      log.error('Query Failed');
      return {"flag": QUERY_FAILED};
    }else{
      // log.debug(resMap[SubmitPanDetail.resStatus]);
      // log.debug(resMap[SubmitPanDetail.resId]);
      return {"flag": QUERY_PASSED};
    }
  }

  String constructRequest(String subPath, Map<String, String> params) {
    String _path = '$_baseUri/$subPath';
    if(params != null && params.length>0) {
      String _p = '';
      if(params.length == 1) {
        _p = params.keys.elementAt(0) + '=' + Uri.encodeComponent(params.values.elementAt(0));
        _path = '$_path?$_p';
      }else{
        params.forEach((key, value) {
          _p = '$_p$key=$value&';
        });
        _p = _p.substring(0, _p.length-2);
        _path = '$_path?$_p';
      }
    }
    return _path;
  }

  Future<Map<String, dynamic>> processResponse(http.StreamedResponse response) async{
    if(response == null){
      log.error('response is null');
    }
    if(response.statusCode != 200) {
      log.error('Query Failed:: Status:${response.statusCode}, Reason:${response.reasonPhrase}');
      if(response.statusCode == 502)
        return {INTERNAL_FAIL_FLAG: false, "userMessage": "ICICI did not respond correctly"};
      else
        return {INTERNAL_FAIL_FLAG: false, "userMessage": "Unknown error occurred while sending request"};
    }
    try {
      String res = await response.stream.bytesToString();
      log.debug(res);
      if(res == null || res.isEmpty || res == "\"\"") {
        log.error('Returned empty response');
        return {INTERNAL_FAIL_FLAG: false, "userMessage": "The entered data was not accepted"};
      }
      var rMap = json.decode(res);
      rMap[INTERNAL_FAIL_FLAG] = true;
      return rMap;
    }catch(e){
      log.error('Failed to decode json');
      return null;
    }
  }

  Future<List<Map<String, String>>> processArrayResponse(http.StreamedResponse response) async{
    if(response == null){
      log.error('response is null');
    }
    if(response.statusCode != 200) {
      log.error('Query Failed:: Status:${response.statusCode}, Reason:${response.reasonPhrase}');
      if(response.statusCode == 502)
        return null;
      else
        return null;
    }
    try {
      String res = await response.stream.bytesToString();
      log.debug(res);
      if(res == null || res.isEmpty || res == "\"\"") {
        log.error('Returned empty response');
        return null;
      }
      List<dynamic> rList = json.decode(res);
      //rMap[INTERNAL_FAIL_FLAG] = true;
      List<Map<String, String>> refList = new List();
      rList.forEach((element) {
        refList.add({'CODE':element['BANK_ACT_VALUE'], 'NAME':element['BANK_ACT_TYPE']});
      });
      log.debug(refList.toString());
      return refList;
    }catch(e){
      log.error('Failed to decode json');
      return null;
    }
  }

}