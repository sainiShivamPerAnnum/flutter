import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_subscription_response_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_subscription_response_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/model/paytm_models/validate_vpa_response_model.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/paytm_loader.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

//ERROR CODE
const int CREATE_SUBSCRIPTION_FAILED = 0;
const int INITIATE_SUBSCRIPTION_FAILED = 1;
const int VALIDATE_VPA_FAILED = 2;
const int INVALID_VPA_DETECTED = 3;

class PaytmService {
  final _logger = locator<CustomLogger>();
  final _paytmRepo = locator<PaytmRepository>();

  final String devMid = "qpHRfp13374268724583";
  final String prodMid = "CMTNKX90967647249644";

  String mid;
  bool isStaging;
  String callbackUrl;

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

  Future<void> validateSubscription(String subId) async {
    final ApiResponse<SubscriptionResponseModel> subscriptionResponseModel =
        await _paytmRepo.getSubscriptionStatus(subId);
    if (subscriptionResponseModel.code == 200) {
      _logger.d(subscriptionResponseModel.model.toString());
    }
    return subscriptionResponseModel;
  }

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
      String htmlCode = """
      <form name="paytm_form" method="POST" action="https://securegw-stage.paytm.in/order/pay?mid=$mid&orderId=${paytmSubscriptionModel.data.orderId}">
         <input type="hidden" name="txnToken" value="${paytmSubscriptionModel.data.temptoken}" />
         <input type="hidden" name="SUBSCRIPTION_ID" value="${paytmSubscriptionModel.data.subscriptionId}" />
         <input type="hidden" name="paymentMode" value="UPI" />
         <input type="hidden" name="AUTH_MODE" value="USRPWD" />
         <input type="hidden" name="payerAccount" value="$vpa" />
      </form>
      <script type="text/javascript">
         document.paytm_form.submit();
      </script>
      """;
      AppState.screenStack.add(ScreenItem.dialog);
      Navigator.of(AppState.delegate.navigatorKey.currentContext).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => PaytmLoader(
            htmlCode: htmlCode,
          ),
        ),
      );

      //validateSubscription(paytmSubscriptionModel.data.subscriptionId);
      return PaytmResponse(reason: "Everything seems good!", status: true);
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
