// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:felloapp/ui/pages/others/finance/augmont/gold_buy/upi_intent_view.dart';
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

class AugmontTransactionService
    extends PropertyChangeNotifier<GoldTransactionServiceProperties> {
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
  static double currentTxnAmount = 0.0;
  static double currentTxnGms = 0.0;
  static String currentTxnOrderId;
  static bool isIOSTxnInProgress = false;

  DepositFcmResponseModel depositFcmResponseModel;
  bool _isGoldBuyInProgress = false;
  List<ApplicationMeta> appMetaList = [];
  UpiApplication upiApplication;
  String selectedUpiApplicationName;
  TransactionState _currentTransactionState = TransactionState.idleTrasantion;
  GoldPurchaseDetails currentGoldPurchaseDetails;
  get isGoldBuyInProgress => this._isGoldBuyInProgress;
  TransactionState get currentTransactionState => _currentTransactionState;

  set isGoldBuyInProgress(value) {
    this._isGoldBuyInProgress = value;
    notifyListeners(GoldTransactionServiceProperties.transactionStatus);
  }

  set currentTransactionState(TransactionState state) {
    _currentTransactionState = state;
    notifyListeners(GoldTransactionServiceProperties.transactionState);
  }

  Future<void> initateAugmontTransaction(
      {@required GoldPurchaseDetails details}) {
    currentGoldPurchaseDetails = details;
    String paymentMode = "PAYTM-PG";
    if (Platform.isAndroid)
      paymentMode = BaseRemoteConfig.remoteConfig
          .getString(BaseRemoteConfig.ACTIVE_PG_ANDROID);
    else if (Platform.isIOS)
      paymentMode = BaseRemoteConfig.remoteConfig
          .getString(BaseRemoteConfig.ACTIVE_PG_IOS);

    switch (paymentMode) {
      case "PAYTM-PG":
        processPaytmTransaction();
        break;
      case "PAYTM":
        getUserUpiAppChoice();
        break;
      case "RZP-PG":
        processRazorpayTransaction();
        break;
    }
    return null;
  }

  getUPIApps() async {
    try {
      List<ApplicationMeta> allUpiApps =
          await UpiPay.getInstalledUpiApplications(
              statusType: UpiApplicationDiscoveryAppStatusType.all);
      allUpiApps.forEach((element) {
        if (element.upiApplication.appName == "Paytm" &&
            BaseRemoteConfig.remoteConfig
                .getString(BaseRemoteConfig.ENABLED_PSP_APPS)
                .contains('P')) {
          appMetaList.add(element);
        }
        if (element.upiApplication.appName == "PhonePe" &&
            BaseRemoteConfig.remoteConfig
                .getString(BaseRemoteConfig.ENABLED_PSP_APPS)
                .contains('E')) {
          appMetaList.add(element);
        }
        if (element.upiApplication.appName == "Google Pay" &&
            BaseRemoteConfig.remoteConfig
                .getString(BaseRemoteConfig.ENABLED_PSP_APPS)
                .contains('G')) {
          appMetaList.add(element);
        }
      });
    } catch (e) {
      BaseUtil.showNegativeAlert(
          "Unable to get Upi apps", "Please try again in sometime");
    }
  }

  //5 -- UPI
  getUserUpiAppChoice() async {
    await getUPIApps();
    BaseUtil.openModalBottomSheet(
        addToScreenStack: true,
        backgroundColor: Colors.transparent,
        isBarrierDismissable: false,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness12),
            topRight: Radius.circular(SizeConfig.roundness12)),
        content: UPIAppsBottomSheet(txnServiceInstance: this));
  }

  //6 -- UPI
  Future<void> processUpiTransaction() async {
    isGoldBuyInProgress = true;
    AppState.blockNavigation();
    _analyticsService.track(eventName: AnalyticsEvents.buyGold);
    CreatePaytmTransactionModel createdPaytmTransactionData =
        await _paytmService.createPaytmTransaction(
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

  //7 -- RAZORPAY
  processRazorpayTransaction() async {
    isGoldBuyInProgress = true;
    AppState.blockNavigation();
    await _razorpayService.initiateRazorpayTxn(
      amount: currentGoldPurchaseDetails.goldBuyAmount,
      augmontRates: currentGoldPurchaseDetails.goldRates,
      couponCode: currentGoldPurchaseDetails.couponCode,
      email: _userService.baseUser.email,
      mobile: _userService.baseUser.mobile,
    );
    isGoldBuyInProgress = false;
    AppState.unblockNavigation();
    // resetBuyOptions();
  }
//PAYTM METHODS

  Future<void> processPaytmTransaction() async {
    AppState.blockNavigation();
    isGoldBuyInProgress = true;
    _analyticsService.track(eventName: AnalyticsEvents.buyGold);
    CreatePaytmTransactionModel createdPaytmTransactionData =
        await _paytmService.createPaytmTransaction(
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
          restrictAppInvoke: FlavorConfig.isDevelopment());

      if (_status) {
        currentTransactionState = TransactionState.ongoingTransaction;
        AppState.blockNavigation();
        _logger
            .d("Txn Timer Function reinitialised and set with 30 secs delay");
        initiatePolling();
      } else {
        if (currentTransactionState == TransactionState.ongoingTransaction) {
          currentTransactionState = TransactionState.idleTrasantion;
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
    AppState.pollingPeriodicTimer?.cancel();
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
      if (currentTransactionState == TransactionState.ongoingTransaction) {
        if (AppState.screenStack.last == ScreenItem.loader) {
          AppState.screenStack.remove(AppState.screenStack.last);
        }
        currentTransactionState = TransactionState.successTransaction;
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
      if (currentTransactionState == TransactionState.ongoingTransaction) {
        if (AppState.screenStack.last == ScreenItem.loader) {
          AppState.screenStack.remove(AppState.screenStack.last);
        }
        currentTransactionState = TransactionState.successTransaction;
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

  Future<void> initiatePolling() async {
    AppState.pollingPeriodicTimer = Timer.periodic(
      Duration(seconds: 5),
      this.processPolling,
    );
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
}

// BEER FEST SPECIFIC CODE

// bool isOfferStillValid(Timestamp time) {
//   String _timeoutMins = BaseRemoteConfig.remoteConfig
//       .getString(BaseRemoteConfig.OCT_FEST_OFFER_TIMEOUT);
//   if (_timeoutMins == null || _timeoutMins.isEmpty) _timeoutMins = '10';
//   int _timeout = int.tryParse(_timeoutMins);

//   DateTime tTime =
//       DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
//   Duration difference = DateTime.now().difference(tTime);
//   if (difference.inSeconds <= _timeout * 60) {
//     return true;
//   }
//   return false;
// }

// bool getBeerTicketStatus(UserTransaction transaction) {
//   double minBeerDeposit = double.tryParse(BaseRemoteConfig.remoteConfig
//           .getString(BaseRemoteConfig.OCT_FEST_MIN_DEPOSIT) ??
//       '150.0');
//   _logger.d(_baseUtil.firstAugmontTransaction);
//   if (_baseUtil.firstAugmontTransaction != null &&
//       _baseUtil.firstAugmontTransaction == transaction &&
//       transaction.amount >= minBeerDeposit &&
//       isOfferStillValid(transaction.timestamp)) return true;
//   return false;
// }

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
