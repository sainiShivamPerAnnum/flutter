import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/model/paytm_models/txn_result_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/razorpay_api_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayModel extends ChangeNotifier {
  final Log log = Log('RazorpayModel');
  CustomLogger _logger;
  UserTransaction _currentTxn;
  ValueChanged<UserTransaction> _txnUpdateListener;
  Razorpay _razorpay;
  PaytmService _paytmService;
  PaytmRepository _paytmRepo;
  TransactionService _txnService;

  bool init() {
    _razorpay = Razorpay();
    _logger = locator<CustomLogger>();
    _paytmService = locator<PaytmService>();
    _paytmRepo = locator<PaytmRepository>();
    _txnService = locator<TransactionService>();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    return true;
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    String paymentId = response.paymentId;
    String checkoutOrderId = response.orderId;
    String paySignature = response.signature;
    AppState.delegate.appState.isTxnLoaderInView = true;
    _paytmService.handleTransactionPolling();
    // AppState.delegate.appState.txnTimer =
    //     Timer(Duration(seconds: 30), () async {
    //   AppState.pollingPeriodicTimer?.cancel();
    //   if (AppState.delegate.appState.isTxnLoaderInView) {
    //     AppState.delegate.appState.isTxnLoaderInView = false;
    //     _paytmService.showTransactionPendingDialog();
    //   }
    // });
    log.debug(
        "SUCCESS: " + paymentId + " " + checkoutOrderId + " " + paySignature);
    _currentTxn.rzp[UserTransaction.subFldRzpPaymentId] = paymentId;
    if (_currentTxn.rzp[UserTransaction.subFldRzpOrderId] != checkoutOrderId) {
      _currentTxn.rzp[UserTransaction.subFldRzpStatus] =
          UserTransaction.RZP_TRAN_STATUS_COMPLETE;
      if (_txnUpdateListener != null) _txnUpdateListener(_currentTxn);
      cleanListeners();
      return;
    }
  }

  void handlePaymentError(PaymentFailureResponse response) {
    if (AppState.delegate.appState.isTxnLoaderInView == true) {
      AppState.delegate.appState.isTxnLoaderInView = false;
    }
    BaseUtil.showNegativeAlert(
      'Transaction failed',
      'Your transaction was unsuccessful. Please try again',
    );
    log.debug("ERROR: " + response.code.toString() + " - " + response.message);
    _currentTxn.rzp[UserTransaction.subFldRzpStatus] =
        UserTransaction.RZP_TRAN_STATUS_FAILED;
    if (_txnUpdateListener != null) _txnUpdateListener(_currentTxn);
    cleanListeners();
    return;
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    log.debug("EXTERNAL_WALLET: " + response.walletName);
  }

  //generate order id // update transaction //creatre<UserTransaction> submitAu
  Future initiateRazorpayTxn(
      {String mobile,
      String email,
      double amount,
      AugmontRates augmontRates,
      String couponCode}) async {
    if (!init()) return null; //initialise razorpay

    double netTax = augmontRates.cgstPercent + augmontRates.sgstPercent;

    final augMap = {
      "aBlockId": augmontRates.blockId.toString(),
      "aLockPrice": augmontRates.goldBuyPrice,
      "aPaymode": 'RZP',
      "aGoldInTxn": _getGoldQuantityFromTaxedAmount(
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax)),
          augmontRates.goldBuyPrice),
      "aTaxedGoldBalance":
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax))
    };

    final ApiResponse<CreatePaytmTransactionModel>
        paytmSubscriptionApiResponse =
        await _paytmRepo.createTransaction(amount, augMap, couponCode, true);

    final paytmSubscriptionModel = paytmSubscriptionApiResponse.model;
    print(paytmSubscriptionApiResponse.model.data.orderId);
    AppState.currentTxnOrderId = paytmSubscriptionApiResponse.model.data.txnId;
    AppState.currentTxnAmount = amount;
    _logger.d("Current Txn Id: ${AppState.currentTxnOrderId}");
    String _keyId = RZP_KEY[FlavorConfig.instance.values.razorpayStage.value()];
    var options = {
      'key': _keyId,
      'amount': amount.toInt() * 100,
      'name': 'Digital Gold Purchase',
      'order_id': paytmSubscriptionModel.data.orderId,
      'description': 'GOLD',
      'timeout': 120, // in seconds
      'image': Assets.logoBase64,
      'remember_customer': false,
      'readonly': {'contact': true, 'email': true, 'name': true},
      'theme': {
        'hide_topbar': false,
        'color': '#2EB19F',
        'backdrop_color': '#F1F1F1'
      },
      'prefill': {'contact': mobile, 'email': email}
    };

    _razorpay.open(options);
    return _currentTxn;
  }

  double _getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
  }

  double _getGoldQuantityFromTaxedAmount(double amount, double rate) {
    return BaseUtil.digitPrecision((amount / rate), 4, false);
  }

  void cleanListeners() {
    if (_razorpay != null) _razorpay.clear();
    if (_txnUpdateListener != null) _txnUpdateListener = null;
  }

  setTransactionListener(ValueChanged<UserTransaction> listener) {
    _txnUpdateListener = listener;
  }
}
