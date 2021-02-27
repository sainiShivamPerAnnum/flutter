import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/UserTransaction.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/razorpay_api_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:felloapp/util/credentials_stage.dart';

class RazorpayModel extends ChangeNotifier {
  final Log log = new Log('RazorpayModel');
  DBModel _dbModel = locator<DBModel>();
  HttpModel _httpModel = locator<HttpModel>();
  Razorpay _razorpay;

  bool init() {
    if (_dbModel == null) return false;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    return true;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log.debug("SUCCESS: " + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log.debug("ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log.debug("EXTERNAL_WALLET: " + response.walletName);
  }

  void cleanListeners() {
    if (_razorpay != null) _razorpay.clear();
  }

  Future<Map<String, dynamic>> _generateOrderId(int amount, String notes) async{
    if(amount != null && amount>0) {
      return await _httpModel.getRzpOrderId(amount, notes);
      //
    }else return null;
  }

  //generate order id
  //create transaction
  //create map
  //open gateway
  submitAugmontTransaction(UserTransaction txn, String mobile, String email) async{
    String _keyid = RZP_KEY[BaseUtil.activeRazorpayStage.value()];
    Map<String, dynamic> orderDetails = await _generateOrderId(txn.amount.round(), null);
    if(orderDetails == null) {
      log.error('Failed to generate order id');
      return null;
    }
    //TODO store order id and created time in txn
    var options = {
      'key': _keyid,
      'amount': txn.amount.round(),
      'name': 'Augmont Gold',
      'order_id': orderDetails['order_id'],
      'description': 'Gold Purchase',
      'timeout': 60, // in seconds
      'prefill': {
        'contact': mobile,
        'email': email
      }
    };

    _razorpay.open(options);
  }
}
