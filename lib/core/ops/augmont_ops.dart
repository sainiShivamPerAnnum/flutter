import 'dart:convert';
import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/deposit_response_model.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/core/repository/investment_actions_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/augmont_invoice_service.dart';
import 'package:felloapp/core/service/analytics/webengage_analytics.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/augmont_api_util.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/core/service/analytics/analytics_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:felloapp/util/custom_logger.dart';

class AugmontModel extends ChangeNotifier {
  final Log log = new Log('AugmontModel');
  final CustomLogger _logger = locator<CustomLogger>();
  final _apiPaths = locator<ApiPath>();

  final InvestmentActionsRepository _investmentActionsRepository =
      locator<InvestmentActionsRepository>();

  final DBModel _dbModel = locator<DBModel>();
  final RazorpayModel _rzpGateway = locator<RazorpayModel>();
  final BaseUtil _baseProvider = locator<BaseUtil>();
  final UserService _userService = locator<UserService>();
  final _userCoinService = locator<UserCoinService>();
  final TransactionService _txnService = locator<TransactionService>();
  final _analyticsService = locator<WebEngageAnalytics>();

  ValueChanged<UserTransaction> _augmontTxnProcessListener;
  final String defaultBaseUri =
      'https://jg628sk4s2.execute-api.ap-south-1.amazonaws.com/prod';
  String _baseUri;
  String _apiKey;
  var headers;

  ApiResponse<DepositResponseModel> _initialDepositResponse;
  ApiResponse<String> _tranIdResponse;

  Future<bool> _init() async {
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

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  // String _constructUid(String pan) {
  //   var rnd = new Random();
  //   int u = rnd.nextInt(100);
  //   return 'fello${u.toString()}$pan';
  // }

  String _constructUid(String mobile) {
    var rnd = new Random();
    int u = rnd.nextInt(100);
    return 'fello${u.toString()}$mobile';
  }

  String _constructUsername() {
    var rnd = new Random();
    int u = rnd.nextInt(26);
    String _randomChar = String.fromCharCode(u + 65);
    String _baseUsername =
        _baseProvider.myUser.uid.replaceAll(new RegExp(r"[0-9]"), "");
    return 'fello$_randomChar$_baseUsername';
  }

  Future<UserAugmontDetail> createUser(
      String mobile,
      String pan,
      String stateId,
      String bankHolderName,
      String bankAccNo,
      String ifsc) async {
    if (!isInit()) await _init();

    String _uid = _constructUid(mobile);
    String _uname = _constructUsername();
    var _params = {
      CreateUser.fldMobile: mobile,
      CreateUser.fldID: _uid,
      CreateUser.fldUserName: _uname,
      CreateUser.fldStateId: stateId,
    };

    var _request = http.Request(
        'GET', Uri.parse(_constructRequest(CreateUser.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await _processResponse(_response);
    if (resMap == null || !resMap[INTERNAL_FAIL_FLAG]) {
      log.error('Query Failed');
      return null;
    } else {
      log.debug(resMap[CreateUser.resStatusCode].toString());
      resMap["flag"] = QUERY_PASSED;

      ///create augmont detail object
      _baseProvider.augmontDetail = UserAugmontDetail.newUser(
          _uid, _uname, stateId, bankHolderName, bankAccNo, ifsc);
      bool _p = false, _a = false;

      ///add the pan number
      if (_baseProvider.userRegdPan == null ||
          _baseProvider.userRegdPan.isEmpty ||
          _baseProvider.userRegdPan != pan) {
        if (pan != null) {
          _baseProvider.userRegdPan = pan;
          _p = await _baseProvider.panService
              .saveUserPan(_baseProvider.userRegdPan);
        }
      }

      ///push the augmont detail object
      _a = await _dbModel.updateUserAugmontDetails(
          _baseProvider.myUser.uid, _baseProvider.augmontDetail);

      ///switch augmont onboarding to true and notify listeners if everything goes in order
      if (_p && _a) {
        _baseProvider.updateAugmontOnboarded(true);
        await _dbModel.updateUser(_baseProvider.myUser);
      }

      return _baseProvider.augmontDetail;
    }
  }

  Future<UserAugmontDetail> createSimpleUser(
      String mobile, String stateId) async {
    if (!isInit()) await _init();

    String uid = _userService.baseUser.uid;
    var data = {
      CreateUser.fldMobile: mobile,
      CreateUser.fldID: uid,
      CreateUser.fldStateId: stateId,
    };
    Map<String, dynamic> _body = {"data": data};
    _logger.d(_body);

    try {
      final String _bearer = await _getBearerToken();
      final res = await APIService.instance
          .postData(_apiPaths.kCreateSimpleUser, body: _body, token: _bearer);
      _logger.d("Create Simple User Api response: ${res.toString()})");
      if (res["flag"]) {
        final _uid = res['aUid'];
        final _uname = res['aUname'];
        _baseProvider.augmontDetail =
            UserAugmontDetail.newUser(_uid, _uname, stateId, '', '', '');

        _baseProvider.updateAugmontOnboarded(true);
      } else {
        _logger.e('Create Simple user failed.');
        return null;
      }
    } catch (e) {
      _logger.e('Query Failed $e');
      return null;
    }

    return _baseProvider.augmontDetail;
  }

  Future<AugmontRates> getRates() async {
    if (!isInit()) await _init();

    var _request =
        http.Request('GET', Uri.parse(_constructRequest(GetRates.path, null)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await _processResponse(_response);
    if (resMap == null || !resMap[INTERNAL_FAIL_FLAG]) {
      log.error('Query Failed');
      return null;
    } else {
      log.debug(resMap[CreateUser.resStatusCode].toString());
      resMap["flag"] = QUERY_PASSED;

      return AugmontRates.fromMap(resMap);
    }
  }

  Future<double> getGoldBalance() async {
    if (!isInit()) await _init();
    Map<String, String> _params = {
      Passbook.fldAugmontUid: _baseProvider.augmontDetail.userId,
    };
    var _request = http.Request(
        'GET', Uri.parse(_constructRequest(Passbook.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await _processResponse(_response);
    if (resMap == null || !resMap[INTERNAL_FAIL_FLAG]) {
      log.error('Query Failed');
      return null;
    } else {
      log.debug(resMap[Passbook.resGoldGrams].toString());
      resMap["flag"] = QUERY_PASSED;

      String goldGrmsStr = resMap[Passbook.resGoldGrams];
      double goldGrms = 0;
      try {
        goldGrms = double.parse(goldGrmsStr);
        return goldGrms;
      } catch (e) {
        return 0.0;
      }
    }
  }

  ///create a new transaction object and set all fields
  ///call razorpay to initiate purchase for given amount
  ///wait for callback from razorpay payment completion
  ///update db object
  Future<UserTransaction> initiateGoldPurchase(
      AugmontRates buyRates, double amount) async {
    if (!isInit()) await _init();

    if (_baseProvider.augmontDetail == null ||
        _baseProvider.augmontDetail.userId == null ||
        _baseProvider.augmontDetail.userName == null ||
        buyRates == null ||
        amount == null ||
        amount <= 0) {
      return null;
    }

    _tranIdResponse = await _investmentActionsRepository.createTranId(
        userUid: _baseProvider.myUser.uid);
    if (_tranIdResponse.code != 200 ||
        _tranIdResponse.model == null ||
        _tranIdResponse.model.isEmpty) {
      _logger.e('Failed to create a transaction id');
      return null;
    }

    String _note1 =
        'BlockID: ${buyRates.blockId},gPrice: ${buyRates.goldBuyPrice}';
    String _note2 =
        'UserId:${_baseProvider.myUser.uid},MerchantTxnID: ${_tranIdResponse.model}';
    String rzpOrderId = await _rzpGateway.createOrderId(amount, _note1, _note2);
    if (rzpOrderId == null) {
      _logger.e("Received null from create Order id");
      return null;
    }

    double netTax = buyRates.cgstPercent + buyRates.sgstPercent;

    Map<String, dynamic> _initAugMap = {
      "aBlockId": buyRates.blockId.toString(),
      "aLockPrice": buyRates.goldBuyPrice,
      "aPaymode": "RZP",
      "aGoldInTxn": getGoldQuantityFromTaxedAmount(
          BaseUtil.digitPrecision(amount - getTaxOnAmount(amount, netTax)),
          buyRates.goldBuyPrice),
      "aTaxedGoldBalance":
          BaseUtil.digitPrecision(amount - getTaxOnAmount(amount, netTax))
    };

    Map<String, dynamic> _initRzpMap = {"rOrderId": rzpOrderId};

    _initialDepositResponse =
        await _investmentActionsRepository.initiateUserDeposit(
            tranId: _tranIdResponse.model,
            userUid: _baseProvider.myUser.uid,
            amount: amount,
            initAugMap: _initAugMap,
            initRzpMap: _initRzpMap);

    if (_initialDepositResponse.code == 200) {
      _baseProvider.currentAugmontTxn = _initialDepositResponse
          .model.response.transactionDoc.transactionDetail;

      UserTransaction tTxn = await _rzpGateway.submitAugmontTransaction(
          _baseProvider.currentAugmontTxn,
          _baseProvider.myUser.mobile,
          _baseProvider.myUser.email);

      if (tTxn != null) {
        _baseProvider.currentAugmontTxn = tTxn;
        _rzpGateway.setTransactionListener(_onRazorpayPaymentProcessed);
      }
    } else {
      _dbModel.logFailure(
          _baseProvider.myUser.uid,
          FailType.InitiateUserDepositApiFailed,
          {'message': _initialDepositResponse?.errorMessage});
      return null;
    }

    return _baseProvider.currentAugmontTxn;
  }

  Future<List<GoldGraphPoint>> getGoldRateChart(
      DateTime fromTime, DateTime toTime) async {
    if (fromTime == null || toTime == null || fromTime.isAfter(toTime))
      return null;
    if (!isInit()) await _init();

    var _params = {
      GetRateChart.fldFromTime: '${fromTime.millisecondsSinceEpoch}',
      GetRateChart.fldToTime: '${toTime.millisecondsSinceEpoch}',
    };
    var _request = http.Request(
        'GET', Uri.parse(_constructRequest(GetRateChart.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await _processResponse(_response);
    if (resMap == null ||
        resMap['Items'] == null ||
        !resMap[INTERNAL_FAIL_FLAG]) {
      log.error('Query Failed');
      return null;
    } else {
      List<GoldGraphPoint> pointData = [];
      for (var rPoint in resMap['Items']) {
        try {
          GoldGraphPoint point = GoldGraphPoint(
              BaseUtil.toDouble(rPoint['rRate']),
              DateTime.fromMillisecondsSinceEpoch(rPoint['rTimestamp']));
          pointData.add(point);
        } catch (e) {
          continue;
        }
      }
      return pointData;
    }
  }

  _onRazorpayPaymentProcessed(UserTransaction goldTxn) {
    String key = _baseProvider.currentAugmontTxn.docKey;
    goldTxn.docKey =
        key; //add the firebase document key to this object as it was added later
    _baseProvider.currentAugmontTxn = goldTxn;

    if (_baseProvider.currentAugmontTxn.rzp[UserTransaction.subFldRzpStatus] ==
        UserTransaction.RZP_TRAN_STATUS_COMPLETE) {
      //payment completed successfully
      _analyticsService.track(
          eventName: AnalyticsEvents.investedInGold,
          properties: {'goldQuantity': goldTxn.amount});
      _onPaymentComplete();
    } else {
      _onPaymentFailed();
    }
  }

  ///submit gold purchase augmont api
  ///update object
  _onPaymentComplete() async {
    Map<String, String> _params = {
      SubmitGoldPurchase.fldMobile: _baseProvider.myUser.mobile,
      SubmitGoldPurchase.fldStateId: _baseProvider.augmontDetail.userStateId,
      SubmitGoldPurchase.fldAmount:
          _baseProvider.currentAugmontTxn.amount.toString(),
      SubmitGoldPurchase.fldUsername: _baseProvider.augmontDetail.userName,
      SubmitGoldPurchase.fldUid: _baseProvider.augmontDetail.userId,
      SubmitGoldPurchase.fldBlockId: _baseProvider
          .currentAugmontTxn.augmnt[UserTransaction.subFldAugBlockId],
      SubmitGoldPurchase.fldLockPrice: _baseProvider
          .currentAugmontTxn.augmnt[UserTransaction.subFldAugLockPrice]
          .toString(),
      SubmitGoldPurchase.fldPaymode: _baseProvider
          .currentAugmontTxn.augmnt[UserTransaction.subFldAugPaymode],
      SubmitGoldPurchase.fldMerchantTranId:
          _baseProvider.currentAugmontTxn.docKey
    };

    Map<String, dynamic> rzpUpdates = {
      "rOrderId":
          _baseProvider.currentAugmontTxn.rzp[UserTransaction.subFldRzpOrderId],
      "rPaymentId": _baseProvider
          .currentAugmontTxn.rzp[UserTransaction.subFldRzpPaymentId],
      "rStatus":
          _baseProvider.currentAugmontTxn.rzp[UserTransaction.subFldRzpStatus],
    };

    _logger.d(_baseProvider.currentAugmontTxn.amount);
    _logger.d(rzpUpdates);
    _logger.d(_params);
    _logger.d(_baseProvider.myUser.uid);
    _logger
        .d(_initialDepositResponse.model.response.transactionDoc.transactionId);
    _logger.d(_initialDepositResponse
        .model.response.transactionDoc.enqueuedTaskDetails);

    ApiResponse<DepositResponseModel> _onCompleteDepositResponse =
        await _investmentActionsRepository.completeUserDeposit(
      amount: _baseProvider.currentAugmontTxn.amount,
      rzpUpdates: rzpUpdates,
      submitGoldUpdates: _params,
      userUid: _baseProvider.myUser.uid,
      txnId:
          _initialDepositResponse.model.response.transactionDoc.transactionId,
      enqueuedTaskDetails: _initialDepositResponse
          .model.response.transactionDoc.enqueuedTaskDetails,
    );

    if (_onCompleteDepositResponse.code == 200) {
      //Update these feilds from deposit API
      _baseProvider.currentAugmontTxn.tranStatus =
          UserTransaction.TRAN_STATUS_COMPLETE;
      _baseProvider.currentAugmontTxn.augmnt[UserTransaction.subFldAugTranId] =
          _onCompleteDepositResponse.model.augResponse.data.transactionId;
      _baseProvider
              .currentAugmontTxn.augmnt[UserTransaction.subFldMerchantTranId] =
          _onCompleteDepositResponse
              .model.augResponse.data.merchantTransactionId;
      _baseProvider.currentAugmontTxn
          .augmnt[UserTransaction.subFldAugTotalGoldGm] = double.tryParse(
              _onCompleteDepositResponse.model.augResponse.data.goldBalance) ??
          0.0;

      double newAugPrinciple =
          _onCompleteDepositResponse.model.response.augmontPrinciple;
      if (newAugPrinciple != null && newAugPrinciple > 0) {
        _userService.augGoldPrinciple = newAugPrinciple;
      }
      double newAugQuantity =
          _onCompleteDepositResponse.model.response.augmontGoldQty;
      if (newAugQuantity != null && newAugQuantity > 0) {
        _userService.augGoldQuantity = newAugQuantity;
      }
      int newFlcBalance = _onCompleteDepositResponse.model.response.flcBalance;
      if (newFlcBalance > 0) {
        _userCoinService.setFlcBalance(newFlcBalance);
      }
      _baseProvider.currentAugmontTxn = _onCompleteDepositResponse
          .model.response.transactionDoc.transactionDetail;

      _txnService.updateTransactions();

      if (_augmontTxnProcessListener != null)
        _augmontTxnProcessListener(_baseProvider.currentAugmontTxn);
    } else {
      _dbModel.logFailure(
          _baseProvider.myUser.uid,
          FailType.CompleteUserDepositApiFailed,
          {'message': _initialDepositResponse?.errorMessage});

      if (_onCompleteDepositResponse?.model != null &&
          _onCompleteDepositResponse?.model?.note != null &&
          _onCompleteDepositResponse?.model?.note?.title != null &&
          _onCompleteDepositResponse.model.note.title.isNotEmpty) {
        final title = _onCompleteDepositResponse.model.note.title;
        String body =
            'Your transaction is being verified and will be updated shortly';

        if (_onCompleteDepositResponse?.model?.note?.body != null &&
            _onCompleteDepositResponse.model.note.body.isNotEmpty) {
          body = _onCompleteDepositResponse.model.note.body;
        }

        BaseUtil.showNegativeAlert(title, body);
      } else {
        BaseUtil.showNegativeAlert('Verifying transaction',
            'Your transaction is being verified and will be updated shortly');
      }

      _baseProvider.currentAugmontTxn.tranStatus =
          UserTransaction.TRAN_STATUS_CANCELLED;

      if (_augmontTxnProcessListener != null)
        _augmontTxnProcessListener(_baseProvider.currentAugmontTxn);

      AppState.backButtonDispatcher.didPopRoute();
    }
  }

  _onPaymentFailed() async {
    log.error('Query Failed');

    Map<String, dynamic> rzpMap = {
      "rOrderId":
          _baseProvider.currentAugmontTxn.rzp[UserTransaction.subFldRzpOrderId],
      "rPaymentId": _baseProvider
          .currentAugmontTxn.rzp[UserTransaction.subFldRzpPaymentId],
      "rStatus":
          _baseProvider.currentAugmontTxn.rzp[UserTransaction.subFldRzpStatus],
    };

    Map<String, dynamic> augMap = {
      "aTranId": _baseProvider
          .currentAugmontTxn.augmnt[UserTransaction.subFldAugTranId],
      "aAugTranId": _baseProvider
          .currentAugmontTxn.augmnt[UserTransaction.subFldMerchantTranId],
      "aGoldBalance": _baseProvider
          .currentAugmontTxn.augmnt[UserTransaction.subFldAugTotalGoldGm],
      "aBlockId": _baseProvider
          .currentAugmontTxn.augmnt[UserTransaction.subFldAugBlockId],
      "aLockPrice": _baseProvider
          .currentAugmontTxn.augmnt[UserTransaction.subFldAugLockPrice],
      "aPaymode": "RZP",
      "aGoldInTxn": _baseProvider
          .currentAugmontTxn.augmnt[UserTransaction.subFldAugCurrentGoldGm],
      "aTaxedGoldBalance": _baseProvider
          .currentAugmontTxn.augmnt[UserTransaction.subFldAugPostTaxTotal],
    };

    Map<String, dynamic> _failMap = {
      'txnDocId': _baseProvider.currentAugmontTxn.docKey
    };

    await _dbModel.logFailure(_baseProvider.myUser.uid,
        FailType.UserRazorpayPurchaseFailed, _failMap);
    _baseProvider.currentAugmontTxn.tranStatus =
        UserTransaction.TRAN_STATUS_CANCELLED;

    ApiResponse<DepositResponseModel> _onCancleUserDepositResponse =
        await _investmentActionsRepository.cancelUserDeposit(
            txnId: _initialDepositResponse
                .model.response.transactionDoc.transactionId,
            userUid: _baseProvider.myUser.uid,
            rzpMap: rzpMap,
            augMap: augMap,
            enqueuedTaskDetails: _initialDepositResponse
                .model.response.transactionDoc.enqueuedTaskDetails);

    _txnService.updateTransactions();
    if (_onCancleUserDepositResponse.code == 400) {
      _dbModel.logFailure(
          _baseProvider.myUser.uid, FailType.CompleteUserDepositApiFailed, {
        'message': _onCancleUserDepositResponse?.errorMessage ??
            "Cancel user deposit failed"
      });

      if (_onCancleUserDepositResponse?.model != null &&
          _onCancleUserDepositResponse?.model?.note != null &&
          _onCancleUserDepositResponse?.model?.note?.title != null &&
          _onCancleUserDepositResponse.model.note.title.isNotEmpty) {
        final title = _onCancleUserDepositResponse.model.note.title;
        String body = 'Your payment failed. Please try again';

        if (_onCancleUserDepositResponse?.model?.note?.body != null &&
            _onCancleUserDepositResponse.model.note.body.isNotEmpty) {
          body = _onCancleUserDepositResponse.model.note.body;
        }

        BaseUtil.showNegativeAlert(title, body);
      } else {
        BaseUtil.showNegativeAlert(
            'Deposit failed', 'Your payment failed. Please try again');
      }

      _baseProvider.currentAugmontTxn.tranStatus =
          UserTransaction.TRAN_STATUS_CANCELLED;

      if (_augmontTxnProcessListener != null)
        _augmontTxnProcessListener(_baseProvider.currentAugmontTxn);

      AppState.backButtonDispatcher.didPopRoute();
    } else {
      if (_augmontTxnProcessListener != null)
        _augmontTxnProcessListener(_baseProvider.currentAugmontTxn);
    }
  }

  ///submit gold purchase augmont api
  ///update object
  initiateWithdrawal(AugmontRates sellRates, double quantity) async {
    if (!isInit()) await _init();

    if (_baseProvider.augmontDetail == null ||
        _baseProvider.augmontDetail.userId == null ||
        _baseProvider.augmontDetail.userName == null ||
        _baseProvider.augmontDetail.bankHolderName == null ||
        _baseProvider.augmontDetail.bankAccNo == null ||
        _baseProvider.augmontDetail.ifsc == null ||
        sellRates == null ||
        quantity == null ||
        quantity <= 0.0) {
      return null;
    }

    _baseProvider.currentAugmontTxn = UserTransaction.newGoldWithdrawal(
        BaseUtil.digitPrecision(quantity * sellRates.goldSellPrice),
        sellRates.blockId,
        sellRates.goldSellPrice,
        quantity,
        _baseProvider.myUser.uid);

    _tranIdResponse = await _investmentActionsRepository.createTranId(
        userUid: _baseProvider.myUser.uid);
    if (_tranIdResponse.code != 200 ||
        _tranIdResponse.model == null ||
        _tranIdResponse.model.isEmpty) {
      _logger.e('Failed to create a transaction id');
      return null;
    }

    Map<String, String> _params = {
      SubmitGoldSell.fldMobile: _baseProvider.myUser.mobile,
      SubmitGoldSell.fldQuantity: quantity.toString(),
      SubmitGoldSell.fldAugmontUid: _baseProvider.augmontDetail.userId,
      SubmitGoldSell.fldBlockId: sellRates.blockId,
      SubmitGoldSell.fldLockPrice: sellRates.goldSellPrice.toString(),
      SubmitGoldSell.fldAccHolderName:
          _baseProvider.augmontDetail.bankHolderName,
      SubmitGoldSell.fldAccNo: _baseProvider.augmontDetail.bankAccNo,
      SubmitGoldSell.fldIfsc: _baseProvider.augmontDetail.ifsc,
      SubmitGoldSell.fldMerchantTranId: _tranIdResponse.model
    };

    _logger.d(_params);
    ApiResponse<DepositResponseModel> _onSellCompleteResponse =
        await _investmentActionsRepository.withdrawlComplete(
            tranDocId: _tranIdResponse.model,
            amount: -1 * _baseProvider.currentAugmontTxn.amount,
            sellGoldMap: _params,
            userUid: _baseProvider.myUser.uid);

    bool _successFlag = true;
    if (_onSellCompleteResponse.code == 200) {
      try {
        _baseProvider.currentAugmontTxn.tranStatus =
            UserTransaction.TRAN_STATUS_COMPLETE;
        _baseProvider
                .currentAugmontTxn.augmnt[UserTransaction.subFldAugTranId] =
            _onSellCompleteResponse.model.augResponse.data.transactionId;
        _baseProvider.currentAugmontTxn
                .augmnt[UserTransaction.subFldMerchantTranId] =
            _onSellCompleteResponse
                .model.augResponse.data.merchantTransactionId;
        _baseProvider.currentAugmontTxn
            .augmnt[UserTransaction.subFldAugTotalGoldGm] = double.tryParse(
                _onSellCompleteResponse.model.augResponse.data.goldBalance) ??
            0.0;

        double newAugPrinciple =
            _onSellCompleteResponse.model.response.augmontPrinciple;
        if (newAugPrinciple != null && newAugPrinciple > 0) {
          _userService.augGoldPrinciple = newAugPrinciple;
        }
        double newAugQuantity =
            _onSellCompleteResponse.model.response.augmontGoldQty;
        if (newAugQuantity != null && newAugQuantity >= 0) {
          _userService.augGoldQuantity = newAugQuantity;
        }
        int newFlcBalance = _onSellCompleteResponse.model.response.flcBalance;
        if (newFlcBalance > 0) {
          _userCoinService.setFlcBalance(newFlcBalance);
        }
        _baseProvider.currentAugmontTxn = _onSellCompleteResponse
            .model.response.transactionDoc.transactionDetail;
        _txnService.updateTransactions();
        if (_augmontTxnProcessListener != null)
          _augmontTxnProcessListener(_baseProvider.currentAugmontTxn);
      } catch (e) {
        _successFlag = false;
      }
    } else {
      _successFlag = false;
    }

    if (!_successFlag) {
      _dbModel.logFailure(
          _baseProvider.myUser.uid, FailType.WithdrawlCompleteApiFailed, {
        'message':
            _initialDepositResponse?.errorMessage ?? "Withdrawal api failed"
      });

      if (_onSellCompleteResponse?.model != null &&
          _onSellCompleteResponse?.model?.note != null &&
          _onSellCompleteResponse?.model?.note?.title != null &&
          _onSellCompleteResponse.model.note.title.isNotEmpty) {
        final title = _onSellCompleteResponse.model.note.title;
        String body =
            'Your transaction is being verified and will be updated shortly';

        if (_onSellCompleteResponse?.model?.note?.body != null &&
            _onSellCompleteResponse.model.note.body.isNotEmpty) {
          body = _onSellCompleteResponse.model.note.body;
        }

        BaseUtil.showNegativeAlert(title, body);
      } else {
        BaseUtil.showNegativeAlert('Verifying transaction',
            'Your transaction is being verified and will be updated shortly');
      }

      _baseProvider.currentAugmontTxn.tranStatus =
          UserTransaction.TRAN_STATUS_CANCELLED;
      if (_augmontTxnProcessListener != null)
        _augmontTxnProcessListener(_baseProvider.currentAugmontTxn);

      AppState.backButtonDispatcher.didPopRoute();
    }
  }

  ///returns path where invoice is generated and saved
  Future<String> generatePurchaseInvoicePdf(String txnId) async {
    AugmontInvoiceService _pdfService = AugmontInvoiceService();
    if (!isInit()) await _init();
    var _params = {
      GetInvoice.fldTranId: txnId,
    };
    var _request = http.Request(
        'GET', Uri.parse(_constructRequest(GetInvoice.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await _processResponse(_response);
    if (resMap == null || !resMap[INTERNAL_FAIL_FLAG]) {
      log.error('Query Failed');
      return null;
    } else {
      log.debug(resMap[GetInvoice.resTransactionId].toString());
      resMap["flag"] = QUERY_PASSED;

      // final pdfFile =
      //     await PdfInvoiceApi.generate(await generateInvoiceContent());
      // return pdfFile.path;
      String _path = await _pdfService.generateInvoice(resMap);
      return _path;
    }
  }

  String _constructRequest(String subPath, Map<String, String> params) {
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

  Future<Map<String, dynamic>> _processResponse(
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

    _baseProvider.userMiniTxnList = null;
    _baseProvider.hasMoreTransactionListDocuments = true;
    _baseProvider.lastTransactionListDocument =
        null; //this is to ensure that the transactions list gets refreshed
  }

  double getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
  }

  double getGoldQuantityFromTaxedAmount(double amount, double rate) {
    return BaseUtil.digitPrecision((amount / rate), 4, false);
  }

  double getGoldQuantityFromSellAmount(double amount, double rate) {
    double qnt = amount / rate;
    return BaseUtil.digitPrecision(qnt, 4, false);
  }
}

class GoldGraphPoint {
  final double rate;
  final DateTime timestamp;

  GoldGraphPoint(this.rate, this.timestamp);

  @override
  String toString() {
    return ("Rate ${this.rate} Time ${this.timestamp}");
    // return super.toString();
  }
}
