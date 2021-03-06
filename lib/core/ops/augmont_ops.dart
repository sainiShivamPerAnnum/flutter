import 'dart:convert';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/AugGoldRates.dart';
import 'package:felloapp/core/model/UserAugmontDetail.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/util/augmont_api_util.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AugmontModel extends ChangeNotifier {
  final Log log = new Log('AugmontModel');
  DBModel _dbModel = locator<DBModel>();
  RazorpayModel _rzpGateway = locator<RazorpayModel>();
  BaseUtil _baseProvider = locator<BaseUtil>();
  ValueChanged<UserTransaction> _augmontTxnProcessListener;
  final String defaultBaseUri =
      'https://ug0949ai64.execute-api.ap-south-1.amazonaws.com/dev';
  String _baseUri;
  String _apiKey;
  var headers;

  Future<bool> init() async {
    if (_dbModel == null) return false;
    Map<String, String> cMap = await _dbModel.getActiveAwsAugmontApiKey();
    if (cMap == null) return false;

    _baseUri = (cMap['baseuri'] == null || cMap['baseuri'].isEmpty)
        ? defaultBaseUri
        : cMap['baseuri'];
    _apiKey = cMap['key'];
    headers = {'x-api-key': _apiKey};
    return true;
  }

  bool isInit() => (_apiKey != null);

  String _constructUid(String pan) => 'fello$pan';

  String _constructUsername(String mobile) => 'fello$mobile';

  Future<UserAugmontDetail> createUser(
      String mobile, String pan, String stateId) async {
    String _uid = _constructUid(pan);
    String _uname = _constructUsername(mobile);
    var _params = {
      CreateUser.fldMobile: mobile,
      CreateUser.fldID: _uid,
      CreateUser.fldUserName: _uname,
      CreateUser.fldStateId: stateId,
    };

    var _request = http.Request(
        'GET', Uri.parse(constructRequest(CreateUser.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null || !resMap[INTERNAL_FAIL_FLAG]) {
      log.error('Query Failed');
      return null;
    } else {
      log.debug(resMap[CreateUser.resStatusCode].toString());
      resMap["flag"] = QUERY_PASSED;

      return UserAugmontDetail.newUser(_uid, _uname, stateId);
    }
  }

  Future<AugmontRates> getRates() async {
    var _request =
        http.Request('GET', Uri.parse(constructRequest(GetRates.path, null)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null || !resMap[INTERNAL_FAIL_FLAG]) {
      log.error('Query Failed');
      return null;
    } else {
      log.debug(resMap[CreateUser.resStatusCode].toString());
      resMap["flag"] = QUERY_PASSED;

      return AugmontRates.fromMap(resMap);
    }
  }

  ///create a new transaction object and set all fields
  ///call razorpay to initiate purchase for given amount
  ///wait for callback from razorpay payment completion
  ///update db object
  Future<UserTransaction> initiateGoldPurchase(
      AugmontRates buyRates, double amount) async {
    if (_baseProvider.augmontDetail == null ||
        _baseProvider.augmontDetail.userId == null ||
        _baseProvider.augmontDetail.userName == null ||
        buyRates == null ||
        amount == null ||
        amount <= 0) {
      return null;
    }
    _baseProvider.currentAugmontTxn = UserTransaction.newGoldDeposit(amount, buyRates.blockId,
        buyRates.goldBuyPrice, 'RZP', _baseProvider.myUser.uid);
    _baseProvider.currentAugmontTxn = _rzpGateway.submitAugmontTransaction(
        _baseProvider.currentAugmontTxn,
        _baseProvider.myUser.mobile,
        _baseProvider.myUser.email,
        'BlockID: ${buyRates.blockId},gPrice: ${buyRates.goldBuyPrice}');
    _rzpGateway.setTransactionListener(_onRazorpayPaymentProcessed);

    String _docKey =
        await _dbModel.addUserTransaction(_baseProvider.myUser.uid, _baseProvider.currentAugmontTxn);
    _baseProvider.currentAugmontTxn.docKey = _docKey;

    return _baseProvider.currentAugmontTxn;
  }

  _onRazorpayPaymentProcessed(UserTransaction goldTxn) {
    String key = _baseProvider.currentAugmontTxn.docKey;
    goldTxn.docKey = key; //add the firebase document key to this object as it was added later
    _baseProvider.currentAugmontTxn = goldTxn;

    if (_baseProvider.currentAugmontTxn.rzp[UserTransaction.subFldRzpStatus] ==
        UserTransaction.RZP_TRAN_STATUS_COMPLETE) {
      //payment completed successfully
      _onPaymentComplete();
    } else {
      _onPaymentFailed();
    }
  }

  ///submit gold purchase augmont api
  ///update object
  _onPaymentComplete() async {
    var _params = {
      SubmitGoldPurchase.fldMobile: _baseProvider.myUser.mobile,
      SubmitGoldPurchase.fldStateId: _baseProvider.augmontDetail.userStateId,
      SubmitGoldPurchase.fldAmount: _baseProvider.currentAugmontTxn.amount.toString(),
      SubmitGoldPurchase.fldUsername: _baseProvider.augmontDetail.userName,
      SubmitGoldPurchase.fldUid: _baseProvider.augmontDetail.userId,
      SubmitGoldPurchase.fldBlockId: _baseProvider.currentAugmontTxn.augmnt[UserTransaction.subFldAugBlockId],
      SubmitGoldPurchase.fldLockPrice: _baseProvider.currentAugmontTxn.augmnt[UserTransaction.subFldAugLockPrice],
      SubmitGoldPurchase.fldPaymode: _baseProvider.currentAugmontTxn.augmnt[UserTransaction.subFldAugPaymode],
    };
    var _request = http.Request(
        'GET', Uri.parse(constructRequest(SubmitGoldPurchase.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await processResponse(_response);
    if (resMap == null || !resMap[INTERNAL_FAIL_FLAG] || resMap[SubmitGoldPurchase.resTranId] == null) {
      log.error('Query Failed');
      var _failMap = {
        'txnDocId': _baseProvider.currentAugmontTxn.docKey
      };
      await _dbModel.logFailure(_baseProvider.myUser.uid, FailType.UserAugmontPurchaseFailed, _failMap);
      if(_augmontTxnProcessListener != null)_augmontTxnProcessListener(_baseProvider.currentAugmontTxn);
    } else {
      //success
      _baseProvider.currentAugmontTxn.tranStatus = UserTransaction.TRAN_STATUS_COMPLETE;
      _baseProvider.currentAugmontTxn.augmnt[UserTransaction.subFldAugTranId] = resMap[SubmitGoldPurchase.resAugTranId];
      _baseProvider.currentAugmontTxn.augmnt[UserTransaction.subFldMerchantTranId] = resMap[SubmitGoldPurchase.resTranId];
      bool flag = await _dbModel.updateUserTransaction(_baseProvider.myUser.uid, _baseProvider.currentAugmontTxn);
      if(!_baseProvider.augmontDetail.firstInvMade){
        _baseProvider.augmontDetail.firstInvMade = true;
        await _dbModel.updateUserAugmontDetails(_baseProvider.myUser.uid, _baseProvider.augmontDetail);
      }
      if(_augmontTxnProcessListener != null)_augmontTxnProcessListener(_baseProvider.currentAugmontTxn);
    }
  }

  _onPaymentFailed() async{
    log.error('Query Failed');
    var _failMap = {
      'txnDocId': _baseProvider.currentAugmontTxn.docKey
    };
    await _dbModel.logFailure(_baseProvider.myUser.uid, FailType.UserRazorpayPurchaseFailed, _failMap);
    if(_augmontTxnProcessListener != null)_augmontTxnProcessListener(_baseProvider.currentAugmontTxn);
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
    if (response.statusCode != 200 && response.statusCode != 201) {
      log.error(
          'Query Failed:: Status:${response.statusCode}, Reason:${response.reasonPhrase}');
      if (response.statusCode == 502)
        return {
          INTERNAL_FAIL_FLAG: false,
          "userMessage": "Augmont did not respond correctly"
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

  setAugmontTxnProcessListener(ValueChanged<UserTransaction> listener) {
    _augmontTxnProcessListener = listener;
  }

  completeTransaction() {
    _rzpGateway.cleanListeners();
    _baseProvider.currentAugmontTxn = null;
    _augmontTxnProcessListener = null;
  }
}
