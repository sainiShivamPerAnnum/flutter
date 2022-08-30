import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/razorpay_api_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayModel extends ChangeNotifier {
  final Log log = Log('RazorpayModel');
  UserTransaction _currentTxn;
  ValueChanged<UserTransaction> _txnUpdateListener;
  Razorpay _razorpay;

  bool init() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    return true;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    String paymentId = response.paymentId;
    String checkoutOrderId = response.orderId;
    String paySignature = response.signature;
    log.debug(
        "SUCCESS: " + paymentId + " " + checkoutOrderId + " " + paySignature);

    _currentTxn.rzp[UserTransaction.subFldRzpPaymentId] = paymentId;
    if (_currentTxn.rzp[UserTransaction.subFldRzpOrderId] != checkoutOrderId) {
      //Received success for a different transaction. Discard this
      _currentTxn.rzp[UserTransaction.subFldRzpStatus] =
          UserTransaction.RZP_TRAN_STATUS_FAILED;
      if (_txnUpdateListener != null) _txnUpdateListener(_currentTxn);
      return;
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log.debug("ERROR: " + response.code.toString() + " - " + response.message);
    _currentTxn.rzp[UserTransaction.subFldRzpStatus] =
        UserTransaction.RZP_TRAN_STATUS_FAILED;
    if (_txnUpdateListener != null) _txnUpdateListener(_currentTxn);
    return;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log.debug("EXTERNAL_WALLET: " + response.walletName);
    //TODO
  }

  //generate order id
  //update transaction
  //create map
  //open gateway
  Future<UserTransaction> submitAugmontTransaction(
      String mobile, String email, String orderId, double amount) async {
    if (!init()) return null; //initialise razorpay

    String _keyId = RZP_KEY[FlavorConfig.instance.values.razorpayStage.value()];
    print(_keyId);
    var options = {
      'key': _keyId,
      'amount': amount.toInt() * 100,
      'name': 'Augmont Gold',
      // 'order_id': orderId,
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
