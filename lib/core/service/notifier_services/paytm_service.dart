import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_subscription_response_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/model/paytm_models/validate_vpa_response_model.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

//ERROR CODE
const int CREATE_SUBSCRIPTION_FAILED = 0;
const int INITIATE_SUBSCRIPTION_FAILED = 1;
const int VALIDATE_VPA_FAILED = 2;
const int INVALID_VPA_DETECTED = 3;
const int PAYTM_POST_CALL_FAILED = 4;

class PaytmService extends PropertyChangeNotifier<PaytmServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _paytmRepo = locator<PaytmRepository>();
  final _userService = locator<UserService>();
  final _api = locator<Api>();

  final String devMid = "qpHRfp13374268724583";
  final String prodMid = "CMTNKX90967647249644";
  final PageController subscriptionFlowPageController = new PageController();
  String currentSubscriptionId;
  ActiveSubscriptionModel _activeSubscription;
  String mid;
  bool isStaging;
  String callbackUrl;

  ActiveSubscriptionModel get activeSubscription => this._activeSubscription;

  set activeSubscription(value) {
    this._activeSubscription = value;
    notifyListeners(PaytmServiceProperties.ActiveSubscription);
    _logger.d("Paytm Service:Active Subscription Properties notified");
  }

  PaytmService() {
    final stage = FlavorConfig.instance.values.paytmStage;
    if (stage == PaytmStage.DEV) {
      mid = devMid;
      isStaging = true;
    } else {
      mid = prodMid;
      isStaging = false;
    }
  }

  Future init() async {
    await getActiveSubscriptionDetails();
  }

  jumpToSubPage(int index) {
    subscriptionFlowPageController.jumpToPage(index);
  }

  double _getGoldQuantityFromTaxedAmount(double amount, double rate) {
    return BaseUtil.digitPrecision((amount / rate), 4, false);
  }

  double _getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
  }

  Future<void> validateTransaction(String orderId) async {
    final ApiResponse<TransactionResponseModel> transactionResponseModel =
        await _paytmRepo.getTransactionStatus(orderId);

    if (transactionResponseModel.code == 200) {
      _logger.d(transactionResponseModel.model.toString());
    }
  }

  // Future<void> validateSubscription(String subId) async {
  //   final ApiResponse<SubscriptionResponseModel> subscriptionResponseModel =
  //       await _paytmRepo.getSubscriptionStatus(subId);
  //   if (subscriptionResponseModel.code == 200) {
  //     _logger.d(subscriptionResponseModel.model.toString());
  //   }
  //   return subscriptionResponseModel;
  // }

  Future<bool> initiateTransactions(
      {double amount,
      AugmontRates augmontRates,
      String couponCode,
      bool restrictAppInvoke = false}) async {
    if (augmontRates == null) return false;

    double netTax = augmontRates.cgstPercent + augmontRates.sgstPercent;

    final augMap = {
      "aBlockId": augmontRates.blockId.toString(),
      "aLockPrice": augmontRates.goldBuyPrice,
      "aPaymode": "PYTM",
      "aGoldInTxn": _getGoldQuantityFromTaxedAmount(
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax)),
          augmontRates.goldBuyPrice),
      "aTaxedGoldBalance":
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax))
    };

    final ApiResponse<CreatePaytmTransactionModel>
        paytmSubscriptionApiResponse =
        await _paytmRepo.createPaytmTransaction(amount, augMap, couponCode);

    if (paytmSubscriptionApiResponse.code == 400) {
      _logger.e(paytmSubscriptionApiResponse.errorMessage);
      return false;
    }

    final paytmSubscriptionModel = paytmSubscriptionApiResponse.model;

    try {
      _logger.d("Paytm order id: ${paytmSubscriptionModel.data.orderId}");
      final response = await AllInOneSdk.startTransaction(
          mid,
          paytmSubscriptionModel.data.orderId,
          amount.toString(),
          paytmSubscriptionModel.data.temptoken,
          paytmSubscriptionModel.data.callbackUrl,
          isStaging,
          restrictAppInvoke);
      _logger.d("Paytm Response:${response.toString()}");

      //For debug mode to check transaction status from paytm.
      // validateTransaction(paytmTransactionModel.data.orderId);
      validateTransaction(paytmSubscriptionModel.data.orderId);
      return true;
    } catch (onError) {
      if (onError is PlatformException) {
        _logger.e(onError.message + " \n  " + onError.details.toString());
      } else {
        _logger.e(onError.toString());
      }
      return false;
    }
  }

  Future<bool> initiateSubscription() async {
    final ApiResponse<CreateSubscriptionResponseModel>
        paytmSubscriptionApiResponse =
        await _paytmRepo.createPaytmSubscription();

    if (paytmSubscriptionApiResponse.code == 400) {
      _logger.e(paytmSubscriptionApiResponse.errorMessage);
      return false;
    }

    final paytmSubscriptionModel = paytmSubscriptionApiResponse.model;
    // final sresponse = {
    //   "success": true,
    //   "data": {
    //     "temptoken": "9c66abe52da541c383e8177b4024c8201646477278128",
    //     "subscriptionId": "100433743164",
    //     "orderId": "7oSXBAfmKF4psLMaP0PM",
    //     "callbackUrl":
    //         "https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=7oSXBAfmKF4psLMaP0PM",
    //     "authenticateUrl":
    //         "https://securegw.paytm.in/order/pay?mid=CMTNKX90967647249644&orderId=7oSXBAfmKF4psLMaP0PM"
    //   }
    // };

    // final paytmSubscriptionModel =
    //     CreateSubscriptionResponseModel.fromMap(sresponse);

    try {
      _logger.d("Paytm order id: ${paytmSubscriptionModel.data.orderId}");
      final response = await AllInOneSdk.startTransaction(
          mid,
          paytmSubscriptionModel.data.orderId,
          '1',
          paytmSubscriptionModel.data.temptoken,
          paytmSubscriptionModel.data.callbackUrl,
          isStaging,
          true);
      // final response = await AllInOneSdk.startTransaction(
      //     prodMid,
      //     paytmSubscriptionModel.data.orderId,
      //     "0",
      //     paytmSubscriptionModel.data.temptoken,
      //     paytmSubscriptionModel.data.callbackUrl,
      //     false,
      //     true);
      _logger.d("Paytm Response:${response.toString()}");

      // validateSubscription(paytmSubscriptionModel.data.subscriptionId);
      return true;
    } catch (onError) {
      if (onError is PlatformException) {
        _logger.e(onError.message + " \n  " + onError.details.toString());
      } else {
        _logger.e(onError.toString());
      }
      return false;
    }
  }

  Future<void> getActiveSubscriptionDetails() async {
    try {
      QuerySnapshot response =
          await _api.fetchActiveSubscriptionDetails(_userService.baseUser.uid);
      if (response.docs.first.data() != null) {
        _logger.d(response.docs.first.data());
        activeSubscription = ActiveSubscriptionModel.fromJson(
            response.docs.first.data(), response.docs.first.id);
      }
    } catch (e) {
      _logger.e(e.toString());
      activeSubscription = null;
    }
  }

  Future<PaytmResponse> initiateCustomSubscription(String vpa) async {
    final ApiResponse<CreateSubscriptionResponseModel>
        paytmSubscriptionApiResponse =
        await _paytmRepo.createPaytmSubscription();

    if (paytmSubscriptionApiResponse.code == 400) {
      _logger.e(paytmSubscriptionApiResponse.errorMessage);
      return PaytmResponse(
          errorCode: INITIATE_SUBSCRIPTION_FAILED,
          reason: "Unable to create subscription",
          status: false);
    }

    final paytmSubscriptionModel = paytmSubscriptionApiResponse.model;

    // final response = {
    //   "success": true,
    //   "data": {
    //     "temptoken": "78a05f432a13487b894073eaa5c4c1d91646471852981",
    //     "subscriptionId": "283638",
    //     "orderId": "g0w7RYbDctbG4NKUJxqU",
    //     "callbackUrl":
    //         "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=g0w7RYbDctbG4NKUJxqU",
    //     "authenticateUrl":
    //         "https://securegw-stage.paytm.in/order/pay?mid=qpHRfp13374268724583&orderId=g0w7RYbDctbG4NKUJxqU"
    //   }
    // };

    // final paytmSubscriptionModel =
    //     CreateSubscriptionResponseModel.fromMap(response);

    final ApiResponse<ValidateVpaResponseModel> isVpaValidResponse =
        await _paytmRepo.validateVPA(paytmSubscriptionModel, vpa);

    if (isVpaValidResponse.code == 400) {
      _logger.e(isVpaValidResponse.errorMessage);

      return PaytmResponse(
          errorCode: VALIDATE_VPA_FAILED,
          reason: "Unable to verify vpa",
          status: false);
    }

    if (!isVpaValidResponse.model.success) {
      _logger.e("Invalid VPA");
      return PaytmResponse(
          errorCode: INVALID_VPA_DETECTED,
          reason: "Entered VPA Address is invalid",
          status: false);
    }

    try {
      _logger.d("Paytm order id: ${paytmSubscriptionModel.data.orderId}");
      // AppState.backButtonDispatcher.didPopRoute();
      // AppState.screenStack.add(ScreenItem.dialog);
      // Navigator.of(AppState.delegate.navigatorKey.currentContext).push(
      //   PageRouteBuilder(
      //     opaque: false,
      //     pageBuilder: (BuildContext context, _, __) => PaytmLoader(
      //       mid: mid,
      //       paytmSubscriptionModel: paytmSubscriptionModel,
      //       vpa: vpa,
      //     ),
      //   ),
      // );
      ApiResponse<bool> postResponse = await makePostRequest(
          paytmSubscriptionModel.data.orderId,
          vpa,
          paytmSubscriptionModel.data.temptoken,
          paytmSubscriptionModel.data.subscriptionId);
      if (postResponse.model)
        return PaytmResponse(reason: "Everything seems good!", status: true);
      else
        PaytmResponse(
            reason: "Unable to connect to Paytm Servers",
            errorCode: 4,
            status: false);
      //validateSubscription(paytmSubscriptionModel.data.subscriptionId);
    } catch (onError) {
      if (onError is PlatformException) {
        _logger.e(onError.message + " \n  " + onError.details.toString());
      } else {
        _logger.e(onError.toString());
      }
      return PaytmResponse(
          reason: "Subscription failed, please try again in sometime",
          errorCode: CREATE_SUBSCRIPTION_FAILED,
          status: false);
    }
  }

  Future<ApiResponse<bool>> makePostRequest(
      String orderId, String vpa, String txnToken, String subId) async {
    try {
      String responseString = "";
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://securegw-stage.paytm.in/order/pay?mid=$mid&orderId=$orderId'));
      request.bodyFields = {
        'txnToken': '$txnToken',
        'SUBSCRIPTION_ID': '$subId',
        'paymentMode': 'UPI',
        'AUTH_MODE': 'USRPWD',
        'payerAccount': '$vpa'
      };
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        responseString = await response.stream.bytesToString();
        log(responseString);
        String identifierString =
            "Check pending requests and approve payment by entering UPI PIN";
        if (responseString.contains(identifierString))
          return ApiResponse(model: true, code: 200);
      } else {
        log(response.reasonPhrase);
        return ApiResponse(model: false, code: 400);
      }
    } catch (e) {
      return ApiResponse(model: false, code: 400);
    }
    return ApiResponse(model: false, code: 400);
  }

  Future<bool> updateDailySubscriptionAmount(
      {@required String subId,
      @required double amount,
      @required String freq}) async {
    ApiResponse response = await _paytmRepo.updateDailyAmount(
        subId: subId, amount: amount, freq: freq);
    if (response.code == 200)
      return response.model;
    else
      return false;
  }

  Future<bool> pauseDailySubscription(String subId, int days) async {
    ApiResponse response = await _paytmRepo.pauseSubscription(subId);
    if (response.code == 200)
      return response.model;
    else
      return false;
  }
}

class PaytmResponse {
  String reason;
  bool status;
  int errorCode;
  PaytmResponse({
    this.reason,
    this.status,
    this.errorCode,
  });
}
