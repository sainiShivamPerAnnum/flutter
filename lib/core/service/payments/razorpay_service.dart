import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/base_transaction_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService extends ChangeNotifier {
  final Log log = const Log('RazorpayService');
  CustomLogger? _logger;
  UserTransaction? _currentTxn;
  ValueChanged<UserTransaction?>? _txnUpdateListener;
  Razorpay? _razorpay;
  // PaytmService? _paytmService;
  PaytmRepository? _paytmRepo;
  AugmontTransactionService? _augTxnService;
  BaseTransactionService? _txnService;
  AnalyticsService? _analyticsService;
  InvestmentType? currentInvestmentType;
  final _userService = locator<UserService>();
  S locale = locator<S>();

  bool init(InvestmentType investmentType) {
    _razorpay = Razorpay();
    _logger = locator<CustomLogger>();
    // _paytmService = locator<PaytmService>();
    _analyticsService = locator<AnalyticsService>();

    _paytmRepo = locator<PaytmRepository>();
    _augTxnService = locator<AugmontTransactionService>();
    _txnService = investmentType == InvestmentType.LENDBOXP2P
        ? locator<LendboxTransactionService>()
        : locator<AugmontTransactionService>();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    return true;
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    locator<BackButtonActions>().isTransactionCancelled = false;
    _txnService!.currentTransactionState = TransactionState.ongoing;
    _txnService!.checkTransactionStatus();
    cleanListeners();
    return;
  }

  void handlePaymentError(PaymentFailureResponse response) {
    _txnService!.currentTransactionState = TransactionState.idle;
    AppState.unblockNavigation();
    // if (response.code == 2)
    //   locator<BackButtonActions>().isTransactionCancelled = true;
    // else
    //   locator<BackButtonActions>().isTransactionCancelled = false;
    BaseUtil.showNegativeAlert(locale.txnFailed, locale.txnFailedSubtitle);
    log.debug("ERROR: " + response.code.toString() + " - " + response.message!);
    Map<String, dynamic>? currentTxnDetails =
        _augTxnService?.currentTransactionAnalyticsDetails;

    currentTxnDetails?["Error message"] = response.message;
    _analyticsService!.track(
        eventName: AnalyticsEvents.paymentCancelled,
        properties: _txnService!.currentTransactionAnalyticsDetails ?? {});

    locator<InternalOpsService>().logFailure(
      _userService.baseUser!.uid,
      FailType.RazorpayTransactionFailed,
      {'message': "Razorpay payment cancelled or failed"},
    );
    _currentTxn?.rzp?[UserTransaction.subFldRzpStatus] =
        UserTransaction.RZP_TRAN_STATUS_FAILED;
    if (_txnUpdateListener != null) _txnUpdateListener!(_currentTxn);

    cleanListeners();
    return;
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    log.debug("EXTERNAL_WALLET: " + response.walletName!);
  }

  //generate order id // update transaction //creatre<UserTransaction> submitAu
  Future<bool?> initiateRazorpayTxn({
    required InvestmentType investmentType,
    String? mobile,
    String? email,
    double? amount,
    Map<String, dynamic>? augMap,
    Map<String, dynamic>? lbMap,
    bool? skipMl,
    String? couponCode,
    Map<String, dynamic>? goldProMap,
  }) async {
    init(investmentType);
    final mid = AppConfig.getValue(AppConfigKey.rzpMid);
    final ApiResponse<CreatePaytmTransactionModel> txnResponse =
        await _paytmRepo!.createTransaction(amount, augMap, lbMap, couponCode,
            skipMl, mid, investmentType, null, goldProMap);
    if (txnResponse.isSuccess()) {
      final txnModel = txnResponse.model!;
      print(txnResponse.model!.data!.orderId);
      _txnService!.currentTxnOrderId = txnResponse.model!.data!.txnId;
      _txnService!.currentTxnAmount = amount;
      String _keyId = AppConfig.getValue(AppConfigKey.rzpMid);
      // RZP_KEY[FlavorConfig.instance.values.razorpayStage.value()];
      final options = {
        'key': _keyId,
        'amount': amount!.toInt() * 100,
        'name': investmentType == InvestmentType.AUGGOLD99
            ? 'Digital Gold Purchase'
            : 'Fello Flo Saving',
        'order_id': txnModel.data!.orderId,
        'description':
            investmentType == InvestmentType.AUGGOLD99 ? 'GOLD' : 'FLO',
        'timeout': 120, // in seconds
        'image': Assets.logoBase64,
        'remember_customer': false,
        'readonly': {'contact': true, 'email': true, 'name': true},
        'theme': {
          'hide_topbar': false,
          'color': '#2EB19F',
          'backdrop_color': '#F1F1F1'
        },
        'prefill': {'contact': mobile, 'email': "hello@fello.in"}
      };

      if (txnResponse.isSuccess()) {
        final txnModel = txnResponse.model!;
        print(txnResponse.model!.data!.orderId);

        _txnService!.currentTxnOrderId = txnResponse.model!.data!.txnId;
        _txnService!.currentTxnAmount = amount;
        // String _keyId =
        //     RZP_KEY[FlavorConfig.instance.values.razorpayStage.value()];
        final options = {
          'key': _keyId,
          'amount': amount.toInt() * 100,
          'name': investmentType == InvestmentType.AUGGOLD99
              ? 'Digital Gold Purchase'
              : 'Fello Flo Saving',
          'order_id': txnModel.data!.orderId,
          'description':
              investmentType == InvestmentType.AUGGOLD99 ? 'GOLD' : 'FLO',
          'timeout': 120, // in seconds
          'image': Assets.logoBase64,
          'remember_customer': false,
          'readonly': {'contact': true, 'email': true, 'name': true},
          'theme': {
            'hide_topbar': false,
            'color': '#2EB19F',
            'backdrop_color': '#F1F1F1'
          },
          'prefill': {'contact': mobile, 'email': "hello@fello.in"}
        };

        _razorpay!.open(options);
        return true;
      } else {
        BaseUtil.showNegativeAlert(txnResponse.errorMessage, locale.tryLater);
        AppState.unblockNavigation();

        return false;
      }
    } else {
      BaseUtil.showNegativeAlert(
        locale.txnFailed,
        txnResponse.errorMessage,
      );
      AppState.unblockNavigation();
    }
  }

  void cleanListeners() {
    if (_razorpay != null) _razorpay?.clear();

    if (_txnUpdateListener != null) _txnUpdateListener = null;
  }

  setTransactionListener(ValueChanged<UserTransaction?> listener) {
    _txnUpdateListener = listener;
  }
}
