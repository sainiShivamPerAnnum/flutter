import 'dart:async';
import 'dart:io';

import 'package:app_install_date/utils.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_subscription_response_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/process_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/txn_result_model.dart';
import 'package:felloapp/core/model/paytm_models/validate_vpa_response_model.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/base_transaction_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:url_launcher/url_launcher.dart';

//SUBSCRIPTION ERROR CODE
const int ERR_CREATE_SUBSCRIPTION_FAILED = 0;
const int ERR_INITIATE_SUBSCRIPTION_FAILED = 1;
const int ERR_VALIDATE_VPA_FAILED = 2;
const int ERR_INVALID_VPA_DETECTED = 3;
const int ERR_UNSUPPORTED_BANK_DETECTED = 4;
const int ERR_PAYTM_POST_CALL_FAILED = 5;
const int ERR_PROCESS_SUBSCRIPTION_FAILED = 6;

//PAYMENT MODE

class PaytmService extends PropertyChangeNotifier<PaytmServiceProperties> {
  final _logger = locator<CustomLogger>();
  final _paytmRepo = locator<PaytmRepository>();
  final _getterRepo = locator<GetterRepository>();

  final String devMid = "qpHRfp13374268724583";
  final String prodMid = "CMTNKX90967647249644";
  final String devPostPrefix = "https://securegw-stage.paytm.in/order/pay?";
  final String prodPostPrefix = "https://securegw.paytm.in/order/pay?";

  final PageController subscriptionFlowPageController = new PageController();
  int _fraction = 0;
  bool isOnSubscriptionFlow = false;
  bool _isFirstTime = true;
  bool _autosaveVisible = true;
  bool isStaging;
  String _nextDebitString;
  String _processText = "processing";
  String currentSubscriptionId;
  String mid;
  String postPrefix;
  String callbackUrl;
  String orderId;
  ActiveSubscriptionModel _activeSubscription;

  int get fraction => this._fraction;
  bool get autosaveVisible => this._autosaveVisible;
  bool get isFirstTime => this._isFirstTime;
  String get nextDebitString => this._nextDebitString;
  String get processText => this._processText;
  ActiveSubscriptionModel get activeSubscription => this._activeSubscription;

  BaseTransactionService _txnService;

  set nextDebitString(String nextDebitString) {
    this._nextDebitString = nextDebitString;
    notifyListeners(PaytmServiceProperties.NextDebitString);
    _logger.d("Paytm Service: Next Debit String properties notified");
  }

  set autosaveVisible(bool autosaveVisible) {
    this._autosaveVisible = autosaveVisible;
    notifyListeners(PaytmServiceProperties.AutosaveVisibility);
    _logger.d("Paytm Service: Autosave Visibility Properties notified");
  }

  set isFirstTime(isFirstTime) {
    this._isFirstTime = isFirstTime;
    notifyListeners(PaytmServiceProperties.FirstTimeView);
    _logger.d("Paytm Service:Active Subscription Properties notified");
  }

  set fraction(value) {
    this._fraction = value;
    notifyListeners(PaytmServiceProperties.ProcessFraction);
    _logger.d("Fraction value: $_fraction");
  }

  set activeSubscription(ActiveSubscriptionModel value) {
    this._activeSubscription = value;
    notifyListeners(PaytmServiceProperties.ActiveSubscription);
    _logger.d("Paytm Service:Active Subscription Properties notified");
  }

  set processText(value) {
    this._processText = value;
    notifyListeners(PaytmServiceProperties.SubscriptionProcess);
    _logger.d("Paytm Service: Subscription process notified");
  }

  List<AmountChipsModel> defaultAmountChipList = [
    AmountChipsModel(order: 0, value: 100, best: false),
    AmountChipsModel(order: 0, value: 250, best: true),
    AmountChipsModel(order: 0, value: 500, best: false),
    AmountChipsModel(order: 0, value: 750, best: false),
    AmountChipsModel(order: 0, value: 1000, best: false),
  ];

  //CONSTRUCTOR
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

  //INIT
  Future init() async {
    await getActiveSubscriptionDetails();
    if (await CacheManager.exits(
        CacheManager.CACHE_IS_SUBSCRIPTION_FIRST_TIME)) {
      isFirstTime = await CacheManager.readCache(
        key: CacheManager.CACHE_IS_SUBSCRIPTION_FIRST_TIME,
        type: CacheType.bool,
      );
    }
  }

  //DISPOSE
  Future signout() async {
    activeSubscription = null;
    currentSubscriptionId = null;
    isFirstTime = true;
    autosaveVisible = true;
    nextDebitString = "";
    fraction = 0;
    isOnSubscriptionFlow = false;
  }

  //Initiate paytm pg transaction
  Future<bool> initiatePaytmPGTransaction({
    bool restrictAppInvoke = false,
    CreatePaytmTransactionModel paytmSubscriptionModel,
    @required InvestmentType investmentType,
  }) async {
    try {
      _txnService = investmentType == InvestmentType.LENDBOXP2P
          ? locator<LendboxTransactionService>()
          : locator<AugmontTransactionService>();

      _logger.d("Transaction order id: ${paytmSubscriptionModel.data.txnId}");
      _logger.d("Transaction app invoke: $restrictAppInvoke");

      final response = await AllInOneSdk.startTransaction(
        mid,
        paytmSubscriptionModel.data.orderId,
        _txnService.currentTxnAmount.toString(),
        paytmSubscriptionModel.data.temptoken,
        paytmSubscriptionModel.data.callbackUrl,
        isStaging,
        restrictAppInvoke,
      );

      _logger.d("Transaction Response:${response.toString()}");
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

  //TRANSACTION METHODS -- END

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

  Future<PaytmResponse> initiateCustomSubscription(String vpa) async {
    processText = "Creating your Autosave account";
    final ApiResponse<CreateSubscriptionResponseModel>
        paytmSubscriptionApiResponse =
        await _paytmRepo.createPaytmSubscription();

    if (!paytmSubscriptionApiResponse.isSuccess()) {
      _logger.e(
          "Subscription Message: ${paytmSubscriptionApiResponse.errorMessage}");
      return PaytmResponse(
          errorCode: ERR_INITIATE_SUBSCRIPTION_FAILED,
          title: paytmSubscriptionApiResponse.errorMessage ??
              "Unable to create your Autosave account",
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
          title: isVpaValidResponse.errorMessage ??
              "Unable to validate your UPI address",
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
      ApiResponse<bool> postResponse = await APIService.instance
          .paytmSubscriptionPostRequest(
              mid: mid,
              orderId: paytmSubscriptionModel.data.orderId,
              vpa: vpa,
              postPrefix: postPrefix,
              txnToken: paytmSubscriptionModel.data.temptoken,
              subId: paytmSubscriptionModel.data.subscriptionId);
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

  Future<bool> updateDailySubscriptionAmount(
      {@required double amount, @required String freq}) async {
    _logger.d("Amount: $amount || Frequency: $freq");
    ApiResponse response =
        await _paytmRepo.updateDailyAmount(amount: amount, freq: freq);
    await getActiveSubscriptionDetails();
    if (response.code == 200)
      return response.model;
    else {
      BaseUtil.showNegativeAlert(response.errorMessage, "");
      return false;
    }
  }

  Future<bool> pauseSubscription(String daysCode) async {
    ApiResponse response = await _paytmRepo.pauseSubscription(daysCode);
    await getActiveSubscriptionDetails();
    if (response.code == 200)
      return response.model;
    else {
      BaseUtil.showNegativeAlert(
          response.errorMessage ?? "Unable to pause subscription", '');
      return false;
    }
  }

  Future<bool> resumeSubscription() async {
    ApiResponse response = await _paytmRepo.resumeSubscription();
    await getActiveSubscriptionDetails();
    if (response.code == 200)
      return response.model;
    else {
      BaseUtil.showNegativeAlert(response.errorMessage, '');
      return false;
    }
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

  //SUBSCRIPTION METHODS -- END

  //HELPER METHODS -- START
  jumpToSubPage(int index) {
    subscriptionFlowPageController.jumpToPage(index);
  }

  Future<List<AmountChipsModel>> getAmountChips({@required String freq}) async {
    ApiResponse<List<AmountChipsModel>> data =
        await _getterRepo.getAmountChips(freq: freq);
    if (data != null && data.code == 200)
      return data.model;
    else
      return defaultAmountChipList;
  }
  //HELPER METHODS -- END

  // UPI METHODS -- START
  Future<String> generateUpiTransactionDeepUri(
    String pspApp,
    CreatePaytmTransactionModel paytmTransactionModel,
  ) async {
    final ApiResponse<ProcessTransactionModel> processTransactionApiResponse =
        await _paytmRepo.processPaytmTransaction(
      tempToken: paytmTransactionModel.data.temptoken,
      osType: Platform.isAndroid ? 'android' : 'ios',
      pspApp: pspApp,
      orderId: paytmTransactionModel.data.orderId,
      paymentMode: 'UPI_INTENT',
    );
    if (processTransactionApiResponse.isSuccess()) {
      if (processTransactionApiResponse
              ?.model?.data?.body?.deepLinkInfo?.deepLink ==
          null) {
        BaseUtil.showNegativeAlert("Something went wrong", "Please try again");
        return null;
      }
      String url =
          processTransactionApiResponse.model.data.body.deepLinkInfo.deepLink +
              '&tn=FELLOGOLD';

      _logger.d("Transaction Url: $url");
      return url;
    } else {
      BaseUtil.showNegativeAlert(
          processTransactionApiResponse.errorMessage, "");
    }
    return null;
  }

  Future<bool> initiateUpiTransaction({
    String url,
    double amount,
    String orderId,
    UpiApplication upiApplication,
    @required InvestmentType investmentType,
  }) async {
    if (url.isEmpty) {
      BaseUtil.showNegativeAlert("Something went wrong", "Please try again");
      return false;
    }

    //ANDROID Handling
    if (PlatformUtils.isAndroid) {
      UpiTransactionResponse response;
      AppState.backButtonDispatcher.didPopRoute();
      try {
        response = await UpiPay.initiateTransaction(
            app: upiApplication, deepLinkUrl: url);
        print(response);
      } catch (e) {
        print(e);
        BaseUtil.showNegativeAlert(
          'Transaction failed',
          'Your transaction was unsuccessful. Please try again',
        );
        return false;
      }
      if (response.status == UpiTransactionStatus.failure) {
        BaseUtil.showNegativeAlert(
          'Transaction failed',
          'Your transaction was unsuccessful. Please try again',
        );
        return false;
      } else if (response.status == UpiTransactionStatus.submitted ||
          response.status == UpiTransactionStatus.success) {
        return true;
      }
      return false;
    }
    //iOS Handling
    else if (PlatformUtils.isIOS) {
      if (upiApplication.appName == "Google Pay") {
        url = "tez:" + url.split(":").last;
      } else if (upiApplication.appName == "PhonePe") {
        url = "phonepe:" + url.split(":").last;
      }
      launchUrl(Uri.parse(url)).then((value) async {
        _txnService = investmentType == InvestmentType.LENDBOXP2P
            ? locator<LendboxTransactionService>()
            : locator<AugmontTransactionService>();

        AppState.backButtonDispatcher.didPopRoute();
        _txnService.isIOSTxnInProgress = true;
        _txnService.currentTxnAmount = amount;
      });
      return true;
    }
    return false;
  }

  // UPI METHODS -- END
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
