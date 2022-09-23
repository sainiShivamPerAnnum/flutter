// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/service/payments/base_transaction_service.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/gold_buy/upi_intent_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:upi_pay/upi_pay.dart';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/payment_mode_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/deposit_fcm_response_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/service/payments/razorpay_service.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';

class AugmontTransactionService extends BaseTransactionService {
  final _userService = locator<UserService>();
  final _logger = locator<CustomLogger>();
  final _userCoinService = locator<UserCoinService>();
  final _paytmRepo = locator<PaytmRepository>();
  final _gtService = GoldenTicketService();
  final _internalOpsService = locator<InternalOpsService>();
  final _txnHistoryService = locator<TransactionHistoryService>();
  final _analyticsService = locator<AnalyticsService>();
  final _paytmService = locator<PaytmService>();
  final _razorpayService = locator<RazorpayService>();

  static double currentTxnGms = 0.0;

  DepositFcmResponseModel depositFcmResponseModel;
  bool _isGoldBuyInProgress = false;
  GoldPurchaseDetails currentGoldPurchaseDetails;
  get isGoldBuyInProgress => this._isGoldBuyInProgress;

  set isGoldBuyInProgress(value) {
    this._isGoldBuyInProgress = value;
    notifyListeners(TransactionServiceProperties.transactionStatus);
  }

  Future<void> initateAugmontTransaction(
      {@required GoldPurchaseDetails details}) {
    currentGoldPurchaseDetails = details;
    String paymentMode = this.getPaymentMode();

    switch (paymentMode) {
      case "PAYTM-PG":
        processPaytmTransaction();
        break;
      case "PAYTM":
        getUserUpiAppChoice(this);
        break;
      case "RZP-PG":
        processRazorpayTransaction();
        break;
    }

    return null;
  }

  //6 -- UPI
  Future<void> processUpiTransaction() async {
    isGoldBuyInProgress = true;
    AppState.blockNavigation();
    _analyticsService.track(eventName: AnalyticsEvents.buyGold);
    CreatePaytmTransactionModel createdPaytmTransactionData =
        await this.createPaytmTransaction(
      PaymentMode.UPI,
      currentGoldPurchaseDetails.goldBuyAmount,
      currentGoldPurchaseDetails.goldRates,
      currentGoldPurchaseDetails.couponCode,
      currentGoldPurchaseDetails.skipMl,
    );
    if (createdPaytmTransactionData != null) {
      final deepUri = await _paytmService.generateUpiTransactionDeepUri(
        selectedUpiApplicationName,
        createdPaytmTransactionData,
      );
      if (deepUri != null && deepUri.isNotEmpty) {
        final res = await _paytmService.initiateUpiTransaction(
          amount: currentGoldPurchaseDetails.goldBuyAmount,
          orderId: createdPaytmTransactionData.data.orderId,
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
            'Failed to connect to upi app', 'Please try after sometime');
      }
    } else {
      isGoldBuyInProgress = false;
      AppState.unblockNavigation();

      return BaseUtil.showNegativeAlert(
          'Failed to create transaction', 'Please try after sometime');
    }
  }

  // RAZORPAY
  Future<void> processRazorpayTransaction() async {
    isGoldBuyInProgress = true;
    AppState.blockNavigation();
    final amount = currentGoldPurchaseDetails.goldBuyAmount;
    final augmontRates = currentGoldPurchaseDetails.goldRates;
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

    await _razorpayService.initiateRazorpayTxn(
      amount: currentGoldPurchaseDetails.goldBuyAmount,
      augMap: augMap,
      lbMap: {},
      couponCode: currentGoldPurchaseDetails.couponCode,
      email: _userService.baseUser.email,
      mobile: _userService.baseUser.mobile,
      investmentType: InvestmentType.AUGGOLD99,
    );

    isGoldBuyInProgress = false;
    AppState.unblockNavigation();
  }

  // PAYTM METHODS
  Future<void> processPaytmTransaction() async {
    AppState.blockNavigation();
    isGoldBuyInProgress = true;
    _analyticsService.track(eventName: AnalyticsEvents.buyGold);
    CreatePaytmTransactionModel createdPaytmTransactionData =
        await this.createPaytmTransaction(
      PaymentMode.PAYTM,
      currentGoldPurchaseDetails.goldBuyAmount,
      currentGoldPurchaseDetails.goldRates,
      currentGoldPurchaseDetails.couponCode,
      currentGoldPurchaseDetails.skipMl,
    );
    if (createdPaytmTransactionData != null) {
      currentTxnGms = currentGoldPurchaseDetails.goldInGrams;

      bool _status = await _paytmService.initiatePaytmPGTransaction(
        paytmSubscriptionModel: createdPaytmTransactionData,
        restrictAppInvoke: FlavorConfig.isDevelopment(),
        investmentType: InvestmentType.AUGGOLD99,
      );

      if (_status) {
        currentTransactionState = TransactionState.ongoing;
        AppState.blockNavigation();
        _logger
            .d("Txn Timer Function reinitialised and set with 30 secs delay");
        initiatePolling();
      } else {
        if (currentTransactionState == TransactionState.ongoing) {
          currentTransactionState = TransactionState.idle;
        }
        AppState.unblockNavigation();
        BaseUtil.showNegativeAlert(
          'Transaction failed',
          'Your transaction was unsuccessful. Please try again',
        );
      }
      AppState.unblockNavigation();
      isGoldBuyInProgress = false;
      // resetBuyOptions();
    } else {
      isGoldBuyInProgress = false;
      AppState.unblockNavigation();
      return BaseUtil.showNegativeAlert(
          'Failed to create transaction', 'Please try after sometime');
    }
  }
// helpers

  getAmount(double amount) {
    if (amount > amount.toInt())
      return amount;
    else
      return amount.toInt();
  }

  fcmTransactionResponseUpdate(fcmDataPayload) async {
    //Stop loader if loading.

    _logger.i("Updating fcm response value. $fcmDataPayload");
    // AppState.delegate.appState.txnFunction.timeout(Duration(seconds: 1));
    // AppState.delegate.appState.txnTimer?.cancel();
    this.pollingPeriodicTimer?.cancel();
    _logger.d("timer cancelled");

    try {
      final DepositFcmResponseModel depositFcmResponseModel =
          DepositFcmResponseModel.fromJson(json.decode(fcmDataPayload));

      //Handle failed condition here.
      if (!depositFcmResponseModel.status) {
        // AppState.delegate.appState.isTxnLoaderInView = false;
        BaseUtil.showNegativeAlert("Transaction failed",
            "Your gold purchase did not complete successfully");
        return;
      }
      //handle multiple fcm command for same transaction
      if (depositFcmResponseModel.gtId != null) {
        print(
            "Hey a new fcm recived with gtId: ${depositFcmResponseModel.gtId}");
        if (GoldenTicketService.lastGoldenTicketId != null) {
          if (GoldenTicketService.lastGoldenTicketId ==
              depositFcmResponseModel.gtId) {
            return;
          } else {
            GoldenTicketService.lastGoldenTicketId =
                depositFcmResponseModel.gtId;
          }
        } else {
          GoldenTicketService.lastGoldenTicketId = depositFcmResponseModel.gtId;
        }
      }

      double newAugPrinciple = depositFcmResponseModel.augmontPrinciple;
      if (newAugPrinciple != null && newAugPrinciple > 0) {
        _userService.augGoldPrinciple = newAugPrinciple;
      }
      double newAugQuantity = depositFcmResponseModel.augmontGoldQty;
      if (newAugQuantity != null && newAugQuantity > 0) {
        _userService.augGoldQuantity = newAugQuantity;
      }
      //add this to augmontBuyVM
      int newFlcBalance = depositFcmResponseModel?.flcBalance ?? 0;
      if (newFlcBalance > 0) {
        _userCoinService.setFlcBalance(newFlcBalance);
      }
      _userService.getUserFundWalletData();
      if (currentTransactionState == TransactionState.ongoing) {
        if (AppState.screenStack.last == ScreenItem.loader) {
          AppState.screenStack.remove(AppState.screenStack.last);
        }
        currentTransactionState = TransactionState.success;
        Haptic.vibrate();
        GoldenTicketService.goldenTicketId = depositFcmResponseModel.gtId;
        if (await _gtService.fetchAndVerifyGoldenTicketByID()) {
          _gtService.showInstantGoldenTicketView(
              amount: depositFcmResponseModel.amount,
              title:
                  "You have successfully saved ₹${getAmount(depositFcmResponseModel.amount)}",
              source: GTSOURCE.prize);
        }
      }
      _txnHistoryService.updateTransactions();
    } catch (e) {
      _logger.e(e);
      _internalOpsService.logFailure(
          _userService.baseUser.uid, FailType.DepositPayloadError, e);
    }
  }

  transactionResponseUpdate({String gtId, double amount}) async {
    _logger.d("Polling response processing");
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
      _userCoinService.getUserCoinBalance();
      double newFlcBalance = amount ?? 0;
      if (newFlcBalance > 0) {
        _userCoinService.setFlcBalance(
            (_userCoinService.flcBalance + newFlcBalance).toInt());
      }
      _userService.getUserFundWalletData();
      print(gtId);
      if (currentTransactionState == TransactionState.ongoing) {
        if (AppState.screenStack.last == ScreenItem.loader) {
          AppState.screenStack.remove(AppState.screenStack.last);
        }
        currentTransactionState = TransactionState.success;
        Haptic.vibrate();

        GoldenTicketService.goldenTicketId = gtId;
        if (await _gtService.fetchAndVerifyGoldenTicketByID()) {
          _gtService.showInstantGoldenTicketView(
              amount: amount,
              title: "You have successfully saved ₹${getAmount(amount)}",
              source: GTSOURCE.prize);
        }
      }

      _txnHistoryService.updateTransactions();
    } catch (e) {
      _logger.e(e);
      _internalOpsService.logFailure(
          _userService.baseUser.uid, FailType.DepositPayloadError, e);
    }
  }

  Future<void> processPolling(Timer timer) async {
    final res = await _paytmRepo.getTransactionStatus(currentTxnOrderId);
    if (res.isSuccess()) {
      TransactionResponseModel txnStatus = res.model;
      switch (txnStatus.data.status) {
        case Constants.TXN_STATUS_RESPONSE_SUCCESS:
          if (!txnStatus.data.isUpdating) {
            timer.cancel();
            return transactionResponseUpdate(
              amount: currentTxnAmount,
              gtId: currentTxnOrderId,
            );
          }
          break;
        case Constants.TXN_STATUS_RESPONSE_PENDING:
          break;
        case Constants.TXN_STATUS_RESPONSE_FAILURE:
          timer.cancel();
          BaseUtil.showNegativeAlert(
            'Transaction failed',
            'Your transaction was unsuccessful. Please try again',
          );
          break;
      }
    }
  }

  Future<CreatePaytmTransactionModel> createPaytmTransaction(
    PaymentMode mode,
    double amount,
    AugmontRates augmontRates,
    String couponCode,
    bool skipMl,
  ) async {
    if (augmontRates == null || amount == null || augmontRates == null)
      return null;

    double netTax = augmontRates.cgstPercent + augmontRates.sgstPercent;

    final Map<String, dynamic> augMap = {
      "aBlockId": augmontRates.blockId.toString(),
      "aLockPrice": augmontRates.goldBuyPrice,
      "aPaymode": 'PYTM',
      "aGoldInTxn": _getGoldQuantityFromTaxedAmount(
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax)),
          augmontRates.goldBuyPrice),
      "aTaxedGoldBalance":
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax))
    };

    final ApiResponse<CreatePaytmTransactionModel>
        paytmSubscriptionApiResponse = await _paytmRepo.createTransaction(
      amount,
      augMap,
      null,
      couponCode ?? '',
      skipMl ?? false,
      InvestmentType.AUGGOLD99,
    );

    if (!paytmSubscriptionApiResponse.isSuccess()) return null;
    this.currentTxnOrderId = paytmSubscriptionApiResponse.model.data.orderId;
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
  double goldBuyAmount;
  AugmontRates goldRates;
  String couponCode;
  bool skipMl;
  double goldInGrams;

  GoldPurchaseDetails({
    @required this.goldBuyAmount,
    @required this.goldRates,
    @required this.couponCode,
    @required this.skipMl,
    @required this.goldInGrams,
  });
}
