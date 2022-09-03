import 'dart:async';
import 'dart:developer';

import 'package:app_install_date/utils.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_subscription_response_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/model/paytm_models/process_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/validate_vpa_response_model.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:url_launcher/url_launcher.dart';

//ERROR CODE
const int ERR_CREATE_SUBSCRIPTION_FAILED = 0;
const int ERR_INITIATE_SUBSCRIPTION_FAILED = 1;
const int ERR_VALIDATE_VPA_FAILED = 2;
const int ERR_INVALID_VPA_DETECTED = 3;
const int ERR_UNSUPPORTED_BANK_DETECTED = 4;
const int ERR_PAYTM_POST_CALL_FAILED = 5;
const int ERR_PROCESS_SUBSCRIPTION_FAILED = 6;

class PaytmService extends PropertyChangeNotifier<PaytmServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _paytmRepo = locator<PaytmRepository>();
  final _rzpModel = locator<RazorpayModel>();
  final _userService = locator<UserService>();
  final _getterRepo = locator<GetterRepository>();

  bool _isFirstTime = true;
  bool _autosaveVisible = true;
  bool get autosaveVisible => this._autosaveVisible;
  String _nextDebitString;
  String get nextDebitString => this._nextDebitString;

  set nextDebitString(String nextDebitString) {
    this._nextDebitString = nextDebitString;
    notifyListeners(PaytmServiceProperties.NextDebitString);
    _logger.d("Paytm Service: Next Debit String properties notified");
  }

  set autosaveVisible(bool autosaveVisible) {
    this._autosaveVisible = autosaveVisible;
    notifyListeners(PaytmServiceProperties.AutosaveVisibility);
    _logger.d("Paytm Service:Autosave Visibility Properties notified");
  }

  List<AmountChipsModel> defaultAmountChipList = [
    AmountChipsModel(order: 0, value: 100, best: false),
    AmountChipsModel(order: 0, value: 250, best: true),
    AmountChipsModel(order: 0, value: 500, best: false),
    AmountChipsModel(order: 0, value: 750, best: false),
    AmountChipsModel(order: 0, value: 1000, best: false),
  ];

  bool isOnSubscriptionFlow = false;

  bool get isFirstTime => this._isFirstTime;

  set isFirstTime(isFirstTime) {
    this._isFirstTime = isFirstTime;
    notifyListeners(PaytmServiceProperties.FirstTimeView);
    _logger.d("Paytm Service:Active Subscription Properties notified");
  }

  int _fraction = 0;
  get fraction => this._fraction;

  set fraction(value) {
    this._fraction = value;
    notifyListeners(PaytmServiceProperties.ProcessFraction);
    _logger.d("Fraction value: $_fraction");
  }

  String _processText = "processing";

  final String devMid = "qpHRfp13374268724583";
  final String prodMid = "CMTNKX90967647249644";
  final String devPostPrefix = "https://securegw-stage.paytm.in/order/pay?";
  final String prodPostPrefix = "https://securegw.paytm.in/order/pay?";
  final PageController subscriptionFlowPageController = new PageController();
  String currentSubscriptionId;
  ActiveSubscriptionModel _activeSubscription;
  String mid;
  String postPrefix;
  bool isStaging;
  String callbackUrl;

  ActiveSubscriptionModel get activeSubscription => this._activeSubscription;

  set activeSubscription(ActiveSubscriptionModel value) {
    this._activeSubscription = value;
    notifyListeners(PaytmServiceProperties.ActiveSubscription);
    _logger.d("Paytm Service:Active Subscription Properties notified");
  }

  get processText => this._processText;

  set processText(value) {
    this._processText = value;
    notifyListeners(PaytmServiceProperties.SubscriptionProcess);
    _logger.d("Paytm Service: Subscription process notified");
  }

  PaytmService() {
    final stage = FlavorConfig.instance.values.paytmStage;
    if (stage == PaytmStage.DEV) {
      mid = devMid;
      isStaging = true;
      postPrefix = devPostPrefix;
    } else {
      mid = prodMid;
      isStaging = false;
      postPrefix = prodPostPrefix;
    }
  }

  Future init() async {
    await getActiveSubscriptionDetails();
    if (await CacheManager.exits(
        CacheManager.CACHE_IS_SUBSCRIPTION_FIRST_TIME)) {
      isFirstTime = await CacheManager.readCache(
          key: CacheManager.CACHE_IS_SUBSCRIPTION_FIRST_TIME,
          type: CacheType.bool);
    }
  }

  Future signout() async {
    activeSubscription = null;
    currentSubscriptionId = null;
    isFirstTime = true;
    autosaveVisible = true;
    nextDebitString = "";
    fraction = 0;
    isOnSubscriptionFlow = false;
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

  Future<bool> validateTransaction(String orderId) async {
    final ApiResponse<TransactionResponseModel> transactionResponseModel =
        await _paytmRepo.getTransactionStatus(
            orderId, BaseRemoteConfig.ACTIVE_PG == 'rzp');

    print(transactionResponseModel.code);

    if (transactionResponseModel.code == 200) {
      _logger.d(transactionResponseModel.model.toString());
      return true;
    } else {
      return false;
    }
  }

  Future<bool> initiateTransactions(
      {double amount,
      AugmontRates augmontRates,
      String couponCode,
      bool restrictAppInvoke = false}) async {
    if (augmontRates == null) return false;

    double netTax = augmontRates.cgstPercent + augmontRates.sgstPercent;

    bool isRzpTxn = BaseRemoteConfig.ACTIVE_PG == 'rzp';

    final augMap = {
      "aBlockId": augmontRates.blockId.toString(),
      "aLockPrice": augmontRates.goldBuyPrice,
      "aPaymode": isRzpTxn ? 'RZP' : 'PYTM',
      "aGoldInTxn": _getGoldQuantityFromTaxedAmount(
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax)),
          augmontRates.goldBuyPrice),
      "aTaxedGoldBalance":
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax))
    };

    final ApiResponse<CreatePaytmTransactionModel>
        paytmSubscriptionApiResponse = await _paytmRepo.createTransaction(
            amount, augMap, couponCode, isRzpTxn);

    if (paytmSubscriptionApiResponse.code == 400) {
      _logger.e(paytmSubscriptionApiResponse.errorMessage);
      return false;
    }

    final paytmSubscriptionModel = paytmSubscriptionApiResponse.model;

    try {
      _logger.d("Transaction order id: ${paytmSubscriptionModel.data.orderId}");
      _logger.d("Transaction app invoke: $restrictAppInvoke");
      var response;
      response = await AllInOneSdk.startTransaction(
          mid,
          paytmSubscriptionModel.data.orderId,
          amount.toString(),
          paytmSubscriptionModel.data.temptoken,
          paytmSubscriptionModel.data.callbackUrl,
          isStaging,
          restrictAppInvoke);
      _logger.d("Transaction Response:${response.toString()}");
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
      _logger.d("Paytm Response:${response.toString()}");

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
    ApiResponse<ActiveSubscriptionModel> response =
        await _paytmRepo.getActiveSubscription();
    if (response.code == 200)
      activeSubscription = response.model;
    else
      activeSubscription = null;
    if (activeSubscription != null &&
        activeSubscription.status == Constants.SUBSCRIPTION_ACTIVE) {
      final ApiResponse<String> nextDebitResponse =
          await _paytmRepo.getNextDebitDate();
      if (nextDebitResponse.code == 200)
        nextDebitString = nextDebitResponse.model;
      else
        nextDebitString = "";
    }
  }

  Future<List<AmountChipsModel>> getAmountChips({@required String freq}) async {
    ApiResponse<List<AmountChipsModel>> data =
        await _getterRepo.getAmountChips(freq: freq);
    if (data != null && data.code == 200)
      return data.model;
    else
      return defaultAmountChipList;
  }

  Future<PaytmResponse> initiateCustomSubscription(String vpa) async {
    processText = "Creating your Autosave account";
    final ApiResponse<CreateSubscriptionResponseModel>
        paytmSubscriptionApiResponse =
        await _paytmRepo.createPaytmSubscription();

    if (paytmSubscriptionApiResponse.code == 400) {
      _logger.e(
          "Subscription Message: ${paytmSubscriptionApiResponse.errorMessage}");
      return PaytmResponse(
          errorCode: ERR_INITIATE_SUBSCRIPTION_FAILED,
          title: "Unable to create your Autosave account",
          subtitle: "Please try again after sometime",
          status: false);
    }

    final paytmSubscriptionModel = paytmSubscriptionApiResponse.model;

    processText = "Verifying your UPI address";
    final ApiResponse<ValidateVpaResponseModel> isVpaValidResponse =
        await _paytmRepo.validateVPA(paytmSubscriptionModel, vpa);

    _logger.d("Validate vpa response: $isVpaValidResponse");
    if (isVpaValidResponse.code == 400) {
      _logger.e(isVpaValidResponse.errorMessage);
      return PaytmResponse(
          errorCode: ERR_VALIDATE_VPA_FAILED,
          title: "Unable to validate your UPI address",
          subtitle: "Please try again",
          status: false);
    }

    if (!isVpaValidResponse.model.data.valid) {
      _logger.e("Invalid UPI");
      return PaytmResponse(
          errorCode: ERR_INVALID_VPA_DETECTED,
          title: "Entered UPI address is not valid ",
          subtitle: "Please retry with a different UPI address",
          status: false);
    }

    if (!isVpaValidResponse.model.data.bankSupportedRecurring ||
        !isVpaValidResponse.model.data.pspSupportedRecurring) {
      _logger.e("Bank does not support UPI Autosave");
      return PaytmResponse(
          errorCode: ERR_UNSUPPORTED_BANK_DETECTED,
          title: "Your bank does not support UPI Autosave",
          subtitle: "Please retry with a different UPI address",
          status: false);
    }
    try {
      _logger.d("Paytm order id: ${paytmSubscriptionModel.data.orderId}");
      processText = "Connecting to your bank";
      ApiResponse<bool> postResponse = await makePostRequest(
          paytmSubscriptionModel.data.orderId,
          vpa,
          paytmSubscriptionModel.data.temptoken,
          paytmSubscriptionModel.data.subscriptionId);
      if (postResponse.model) {
        processText = "Sending payment request";
        bool processResponse = await processSubscription();
        if (processResponse) {
          return PaytmResponse(title: "Everything seems good!", status: true);
        } else {
          return PaytmResponse(
              errorCode: ERR_PROCESS_SUBSCRIPTION_FAILED,
              title: "Unable to update the Subscription status",
              subtitle: "Please try again after sometime",
              status: false);
        }
      } else
        return PaytmResponse(
            title: "Your Autosave account could not be verified",
            subtitle: "Please try again after sometime",
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
          title: "Your Autosave account could not be verified",
          subtitle: "Please try again after sometime",
          errorCode: ERR_CREATE_SUBSCRIPTION_FAILED,
          status: false);
    }
  }

  Future processTransaction(
      double amount,
      String osType,
      String pspApp,
      String paymentMode,
      AugmontRates augmontRates,
      String couponCode,
      ApplicationMeta appMeta) async {
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
        await _paytmRepo.createTransaction(amount, augMap, couponCode, false);

    if (paytmSubscriptionApiResponse.code == 400) {
      _logger.e(paytmSubscriptionApiResponse.errorMessage);
      return false;
    }

    final paytmSubscriptionModel = paytmSubscriptionApiResponse.model;
    print(paytmSubscriptionApiResponse.model.data.orderId);

    final ApiResponse<ProcessTransactionModel> processTransactionApiResponse =
        await _paytmRepo.processPaytmTransaction(
            tempToken: paytmSubscriptionModel.data.temptoken,
            osType: osType,
            pspApp: pspApp,
            orderId: paytmSubscriptionModel.data.orderId,
            paymentMode: paymentMode);

    print(processTransactionApiResponse.model.data.body.deepLinkInfo.deepLink);

    if (processTransactionApiResponse.code == 400) {
      _logger.e(processTransactionApiResponse.errorMessage);
      return;
    } else {
      await doUpiTransation(
          url: processTransactionApiResponse
              .model.data.body.deepLinkInfo.deepLink,
          orderId: paytmSubscriptionModel.data.orderId,
          androidPackageName: appMeta.packageName);
    }
  }

  Future doUpiTransation(
      {String url, String orderId, String androidPackageName}) async {
    //regex check for the uRL in case its buggy
    //
    MethodChannel _platform =
        MethodChannel("fello.in/dev/payments/paytmService");
    var response;
    if (PlatformUtils.isAndroid) {
      // launchUrl(Uri.parse(url));
      try {
        response = await _platform.invokeMethod<String>(
            'initiatePaytmTransaction',
            {"url": url, "app": androidPackageName});
        print(response);
        AppState.backButtonDispatcher.didPopRoute();
        AppState.delegate.appState.isTxnLoaderInView = true;
        AppState.delegate.appState.txnTimer =
            Timer(Duration(seconds: 30), () async {
          bool isValidated = await validateTransaction(orderId);
          print(isValidated);
          AppState.delegate.appState.isTxnLoaderInView = false;
          if (isValidated) {
            AppState.delegate.appState.txnTimer.cancel();
            BaseUtil.openDialog(
              addToScreenStack: true,
              hapticVibrate: true,
              isBarrierDismissable: false,
              content: PendingDialog(
                title: "We're still processing!",
                subtitle:
                    "Your transaction is taking longer than usual. We'll get back to you in ",
                duration: '15 minutes',
              ),
            );
          } else {
            AppState.delegate.appState.txnTimer.cancel();
            BaseUtil.showNegativeAlert(
              'Transaction failed',
              'Your transaction was unsuccessful. Please try again',
            );
          }
        });
      } catch (e) {
        print(e);
      }
    }
    if (PlatformUtils.isIOS) {
      launchUrl(Uri.parse(url)).then((value) async {
        AppState.backButtonDispatcher.didPopRoute();
        AppState.delegate.appState.isTxnLoaderInView = true;
        AppState.delegate.appState.txnTimer =
            Timer(Duration(seconds: 30), () async {
          bool isValidated = await validateTransaction(orderId);
          print(isValidated);
          AppState.delegate.appState.isTxnLoaderInView = false;
          if (isValidated) {
            AppState.delegate.appState.txnTimer.cancel();
            BaseUtil.openDialog(
              addToScreenStack: true,
              hapticVibrate: true,
              isBarrierDismissable: false,
              content: PendingDialog(
                title: "We're still processing!",
                subtitle:
                    "Your transaction is taking longer than usual. We'll get back to you in ",
                duration: '15 minutes',
              ),
            );
          } else {
            AppState.delegate.appState.txnTimer.cancel();
            BaseUtil.showNegativeAlert(
              'Transaction failed',
              'Your transaction was unsuccessful. Please try again',
            );
          }
        });
      });
    }
  }

  Future<bool> updateDailySubscriptionAmount(
      {@required double amount, @required String freq}) async {
    _logger.d("Amount: $amount || Frequency: $freq");
    ApiResponse response =
        await _paytmRepo.updateDailyAmount(amount: amount, freq: freq);
    await getActiveSubscriptionDetails();
    if (response.code == 200)
      return response.model;
    else
      return false;
  }

  Future<bool> pauseSubscription(String daysCode) async {
    ApiResponse response = await _paytmRepo.pauseSubscription(daysCode);
    await getActiveSubscriptionDetails();
    if (response.code == 200)
      return response.model;
    else
      return false;
  }

  Future<bool> resumeSubscription() async {
    ApiResponse response = await _paytmRepo.resumeSubscription();
    await getActiveSubscriptionDetails();
    if (response.code == 200)
      return response.model;
    else
      return false;
  }

  Future<void> getNextDebitDate() async {
    ApiResponse<String> response = await _paytmRepo.getNextDebitDate();
    if (response.code == 200) {
      nextDebitString = response.model;
    } else
      nextDebitString = "";
  }

  Future<bool> processSubscription() async {
    ApiResponse response = await _paytmRepo.processSubscription();
    await getActiveSubscriptionDetails();
    if (response.code == 200)
      return response.model;
    else
      return false;
  }

  Future<ApiResponse<bool>> makePostRequest(
      String orderId, String vpa, String txnToken, String subId) async {
    try {
      String responseString = "";
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
          'POST', Uri.parse('${postPrefix}mid=$mid&orderId=$orderId'));
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
}

class PaytmResponse {
  String title;
  String subtitle;
  bool status;
  int errorCode;
  PaytmResponse({
    this.title,
    this.subtitle,
    this.status,
    this.errorCode,
  });
}
