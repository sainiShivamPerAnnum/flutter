// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/payment_mode_enum.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/deposit_fcm_response_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/base_transaction_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/core/service/payments/razorpay_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';

class AugmontTransactionService extends BaseTransactionService {
  final UserService? _userService = locator<UserService>();
  final CustomLogger? _logger = locator<CustomLogger>();
  final UserCoinService? _userCoinService = locator<UserCoinService>();
  final PaytmRepository? _paytmRepo = locator<PaytmRepository>();
  final _gtService = GoldenTicketService();
  final InternalOpsService? _internalOpsService = locator<InternalOpsService>();
  final TransactionHistoryService? _txnHistoryService =
      locator<TransactionHistoryService>();
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  final PaytmService? _paytmService = locator<PaytmService>();
  final RazorpayService? _razorpayService = locator<RazorpayService>();
  final TambolaService? _tambolaService = locator<TambolaService>();
  S locale = locator<S>();
  double? currentTxnGms = 0.0;
  DepositFcmResponseModel? depositFcmResponseModel;
  bool _isGoldBuyInProgress = false;
  bool _isGoldSellInProgress = false;

  late GoldPurchaseDetails currentGoldPurchaseDetails;
  get isGoldBuyInProgress => this._isGoldBuyInProgress;

  set isGoldBuyInProgress(value) {
    this._isGoldBuyInProgress = value;
    notifyListeners(TransactionServiceProperties.transactionStatus);
  }

  TransactionResponseModel? _model;

  TransactionResponseModel? get transactionResponseModel => _model;

  set transactionResponseModel(TransactionResponseModel? model) {
    _model = model;
  }

  bool get isGoldSellInProgress => this._isGoldSellInProgress;

  set isGoldSellInProgress(bool value) {
    this._isGoldSellInProgress = value;
    notifyListeners(TransactionServiceProperties.transactionStatus);
  }

  Future<void>? initateAugmontTransaction(
      {required GoldPurchaseDetails details}) {
    currentGoldPurchaseDetails = details;
    String paymentMode = this.getPaymentMode();

    switch (paymentMode) {
      case "PAYTM-PG":
        return processPaytmTransaction();
        break;
      case "PAYTM":
        return getUserUpiAppChoice(this);
        break;
      case "RZP-PG":
        return processRazorpayTransaction();
        break;
    }

    return null;
  }

  //6 -- UPI
  Future<void> processUpiTransaction() async {
    isGoldBuyInProgress = true;
    AppState.blockNavigation();
    CreatePaytmTransactionModel? createdPaytmTransactionData =
        await this.createPaytmTransaction(
      PaymentMode.UPI,
      currentGoldPurchaseDetails.goldBuyAmount,
      currentGoldPurchaseDetails.goldRates,
      currentGoldPurchaseDetails.couponCode,
      currentGoldPurchaseDetails.skipMl,
    );
    if (createdPaytmTransactionData != null) {
      currentTxnGms = currentGoldPurchaseDetails.goldInGrams;

      final deepUri = await _paytmService!.generateUpiTransactionDeepUri(
          selectedUpiApplicationName, createdPaytmTransactionData, "FELLOTXN");
      if (deepUri != null && deepUri.isNotEmpty) {
        final res = await _paytmService!.initiateUpiTransaction(
          amount: currentGoldPurchaseDetails.goldBuyAmount,
          orderId: createdPaytmTransactionData.data!.orderId,
          upiApplication: upiApplication,
          url: deepUri,
          investmentType: InvestmentType.AUGGOLD99,
        );
        if (res && Platform.isAndroid) initiatePolling();
        // resetBuyOptions();
        isGoldBuyInProgress = false;
        AppState.unblockNavigation();
      } else {
        isGoldBuyInProgress = false;
        AppState.unblockNavigation();

        BaseUtil.showNegativeAlert(
            locale.upiConnectFailed, locale.tryLater);
      }
    } else {
      isGoldBuyInProgress = false;
      AppState.unblockNavigation();

      return BaseUtil.showNegativeAlert(
          locale.failedToCreateTxn, locale.tryLater);
    }
  }

  // RAZORPAY
  Future<void> processRazorpayTransaction() async {
    isGoldBuyInProgress = true;
    AppState.blockNavigation();
    final amount = currentGoldPurchaseDetails.goldBuyAmount!;
    final augmontRates = currentGoldPurchaseDetails.goldRates!;
    double netTax = augmontRates.cgstPercent! + augmontRates.sgstPercent!;
    currentTxnGms = currentGoldPurchaseDetails.goldInGrams;

    final augMap = {
      "aBlockId": augmontRates.blockId.toString(),
      "aLockPrice": augmontRates.goldBuyPrice,
      "aPaymode": 'RZP',
      "aGoldInTxn": _getGoldQuantityFromTaxedAmount(
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax)),
          augmontRates.goldBuyPrice!),
      "aTaxedGoldBalance":
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax))
    };
    log("AUGMAP : $augMap");
    currentTxnGms = currentGoldPurchaseDetails.goldInGrams;

    await _razorpayService!.initiateRazorpayTxn(
      amount: currentGoldPurchaseDetails.goldBuyAmount,
      augMap: augMap,
      lbMap: {},
      couponCode: currentGoldPurchaseDetails.couponCode,
      email: _userService!.baseUser!.email,
      mobile: _userService!.baseUser!.mobile,
      skipMl: currentGoldPurchaseDetails.skipMl,
      investmentType: InvestmentType.AUGGOLD99,
    );

    isGoldBuyInProgress = false;
  }

  // PAYTM METHODS
  Future<void> processPaytmTransaction() async {
    AppState.blockNavigation();
    isGoldBuyInProgress = true;
    CreatePaytmTransactionModel? createdPaytmTransactionData =
        await this.createPaytmTransaction(
      PaymentMode.PAYTM,
      currentGoldPurchaseDetails.goldBuyAmount,
      currentGoldPurchaseDetails.goldRates,
      currentGoldPurchaseDetails.couponCode,
      currentGoldPurchaseDetails.skipMl,
    );
    if (createdPaytmTransactionData != null) {
      currentTxnGms = currentGoldPurchaseDetails.goldInGrams;

      bool _status = await _paytmService!.initiatePaytmPGTransaction(
        paytmSubscriptionModel: createdPaytmTransactionData,
        restrictAppInvoke: FlavorConfig.isDevelopment(),
        investmentType: InvestmentType.AUGGOLD99,
      );

      if (_status) {
        currentTransactionState = TransactionState.ongoing;
        AppState.blockNavigation();
        _logger!
            .d("Txn Timer Function reinitialised and set with 30 secs delay");
        initiatePolling();
      } else {
        if (currentTransactionState == TransactionState.ongoing) {
          currentTransactionState = TransactionState.idle;
        }
        AppState.unblockNavigation();
        BaseUtil.showNegativeAlert(
        locale.txnFailed , locale.txnFailedSubtitle,
        );
      }
      AppState.unblockNavigation();
      isGoldBuyInProgress = false;
      // resetBuyOptions();
    } else {
      isGoldBuyInProgress = false;
      AppState.unblockNavigation();
      return BaseUtil.showNegativeAlert(
          locale.failedToCreateTxn, locale.tryLater);
    }
  }

  transactionResponseUpdate({String? gtId}) async {
    _logger!.d("Polling response processing");
    try {
      if (gtId != null) {
        print("Hey a new fcm recived with gtId: $gtId");
        if (GoldenTicketService.lastGoldenTicketId != null) {
          if (GoldenTicketService.lastGoldenTicketId == gtId) {
            return;
          } else {
            GoldenTicketService.lastGoldenTicketId = gtId;
          }
        } else {
          GoldenTicketService.lastGoldenTicketId = gtId;
        }
      }

      //add this to augmontBuyVM
      _userCoinService!.getUserCoinBalance();
      _userService!.getUserFundWalletData();
      print(gtId);
      if (currentTransactionState == TransactionState.ongoing) {
        GoldenTicketService.goldenTicketId = gtId;
        await _gtService.fetchAndVerifyGoldenTicketByID();
        await _userService!.getUserJourneyStats();
        AppState.unblockNavigation();
        currentTransactionState = TransactionState.success;
        Haptic.vibrate();
      }
      _txnHistoryService!.updateTransactions(InvestmentType.AUGGOLD99);
    } catch (e) {
      _logger!.e(e);
      _internalOpsService!.logFailure(_userService!.baseUser!.uid,
          FailType.DepositPayloadError, e as Map<String, dynamic>);
    }
  }

  Future<void> processPolling(Timer? timer) async {
    final res = await _paytmRepo!.getTransactionStatus(currentTxnOrderId);
    if (res.isSuccess()) {
      TransactionResponseModel txnStatus = res.model!;
      switch (txnStatus.data!.status) {
        case Constants.TXN_STATUS_RESPONSE_SUCCESS:
          if (!txnStatus.data!.isUpdating!) {
            transactionResponseModel = res.model;
            _tambolaService!.weeklyTicksFetched = false;
            currentTxnTambolaTicketsCount = res.model!.data!.tickets!;

            if (res.model!.data != null &&
                res.model!.data!.goldInTxnBought != null &&
                res.model!.data!.goldInTxnBought! > 0)
              currentTxnGms = res.model!.data!.goldInTxnBought;
            timer!.cancel();
            return transactionResponseUpdate(
              gtId: transactionResponseModel?.data?.gtId ?? "",
            );
          }
          break;
        case Constants.TXN_STATUS_RESPONSE_PENDING:
          break;
        case Constants.TXN_STATUS_RESPONSE_FAILURE:
          timer!.cancel();
          AppState.unblockNavigation();
          isGoldBuyInProgress = false;
          currentTransactionState = TransactionState.idle;
          BaseUtil.showNegativeAlert(
            'Transaction failed',
            'Your transaction was unsuccessful. Please try again',
          );
          break;
      }
    }
  }

  Future<CreatePaytmTransactionModel?> createPaytmTransaction(
    PaymentMode mode,
    double? amount,
    AugmontRates? augmontRates,
    String couponCode,
    bool skipMl,
  ) async {
    if (augmontRates == null || amount == null || augmontRates == null)
      return null;

    double netTax = augmontRates.cgstPercent! + augmontRates.sgstPercent!;
    final mid = AppConfig.getValue(AppConfigKey.paytmMid);
    final Map<String, dynamic> augMap = {
      "aBlockId": augmontRates.blockId.toString(),
      "aLockPrice": augmontRates.goldBuyPrice,
      "aPaymode": 'PYTM',
      "aGoldInTxn": _getGoldQuantityFromTaxedAmount(
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax)),
          augmontRates.goldBuyPrice!),
      "aTaxedGoldBalance":
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax))
    };

    final ApiResponse<CreatePaytmTransactionModel>
        paytmSubscriptionApiResponse = await _paytmRepo!.createTransaction(
      amount,
      augMap,
      null,
      couponCode ?? '',
      skipMl ?? false,
      mid,
      InvestmentType.AUGGOLD99,
    );

    if (!paytmSubscriptionApiResponse.isSuccess()) {
      AppState.unblockNavigation();
      return BaseUtil.showNegativeAlert(
          paytmSubscriptionApiResponse.errorMessage, "");
    }

    this.currentTxnOrderId = paytmSubscriptionApiResponse.model!.data!.orderId;
    this.currentTxnAmount = amount;
    return paytmSubscriptionApiResponse.model;
  }

  double _getGoldQuantityFromTaxedAmount(double amount, double rate) {
    return BaseUtil.digitPrecision((amount / rate), 4, false);
  }

  double _getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
  }
}

class GoldPurchaseDetails {
  double? goldBuyAmount;
  AugmontRates? goldRates;
  String couponCode;
  bool skipMl;
  double goldInGrams;

  GoldPurchaseDetails({
    required this.goldBuyAmount,
    required this.goldRates,
    required this.couponCode,
    required this.skipMl,
    required this.goldInGrams,
  });
}
