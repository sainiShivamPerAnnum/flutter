import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/razorpay_api_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayModel extends ChangeNotifier {
  final Log log = Log('RazorpayModel');
  UserTransaction _currentTxn;
  ValueChanged<UserTransaction> _txnUpdateListener;
  Razorpay _razorpay;
  PaytmService _paytmService;

  bool init() {
    _razorpay = Razorpay();
    _paytmService = locator<PaytmService>();
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
    AppState.delegate.appState.txnTimer =
        Timer(Duration(seconds: 30), () async {
      bool isValidated =
          await _paytmService.validateTransaction(response.orderId);
      AppState.delegate.appState.isTxnLoaderInView = false;
      print(isValidated);
      if (!isValidated) {
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
      }
      AppState.delegate.appState.txnTimer.cancel();
    });
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

  //generate order id // update transaction //create map //open gateway
  Future<UserTransaction> submitAugmontTransaction(
      String mobile, String email, String orderId, double amount) async {
    if (!init()) return null; //initialise razorpay

    String _keyId = RZP_KEY[FlavorConfig.instance.values.razorpayStage.value()];
    print(_keyId);
    bool isDev = FlavorConfig.isDevelopment();
    print(isDev);
    var options = {
      'key': _keyId,
      'amount': amount.toInt() * 100,
      'name': 'Augmont Gold',
      'order_id': orderId,
      'description': 'Digital Gold Purchase',
      'timeout': 120, // in seconds
      'image': Assets.logoBase64,
      'remember_customer': true,
      'readonly': {'contact': true, 'email': false, 'name': false},
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

  void cleanListeners() {
    if (_razorpay != null) _razorpay.clear();
    if (_txnUpdateListener != null) _txnUpdateListener = null;
  }

  setTransactionListener(ValueChanged<UserTransaction> listener) {
    _txnUpdateListener = listener;
  }
}
