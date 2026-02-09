// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/model/aug_silver_rates_model.dart';
import 'package:felloapp/core/model/paytm_models/deposit_fcm_response_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/base_transaction_service.dart';
import 'package:felloapp/core/service/payments/razorpay_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/netbanking_web_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/services.dart';
import 'package:upi_pay/upi_pay.dart';
import 'transaction_service_mixin.dart';

class AugmontSilverTransactionService extends BaseTransactionService
    with TransactionPredictionDefaultMixing {
  @override
  PaytmRepository get paytmRepo => _paytmRepo;

  final UserService _userService = locator<UserService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final PaytmRepository _paytmRepo = locator<PaytmRepository>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();
  final RazorpayService _razorpayService = locator<RazorpayService>();

  double? currentTxnGms = 0.0;
  bool _isSilverBuyInProgress = false;
  bool _isSilverSellInProgress = false;

  DepositFcmResponseModel? depositFcmResponseModel;
  TransactionResponseModel? transactionResponseModel;
  TransactionState get currentTxnState => currentTransactionState;

  late SilverPurchaseDetails currentSilverPurchaseDetails;
  bool get isSilverBuyInProgress => _isSilverBuyInProgress;

  set isSilverBuyInProgress(bool value) {
    _isSilverBuyInProgress = value;
    notifyListeners();
  }

  bool get isSilverSellInProgress => _isSilverSellInProgress;
  set isSilverSellInProgress(bool value) {
    _isSilverSellInProgress = value;
    notifyListeners();
  }

  Future<void> initiateAugmontSilverTransaction({
    required SilverPurchaseDetails details,
  }) async {
    currentSilverPurchaseDetails = details;
    currentTxnAmount = details.silverBuyAmount;

    if ((currentTxnAmount ?? 0) >= Constants.mandatoryNetBankingThreshold) {
      return await processNBTransaction();
    }

    if (details.isIntentFlow && details.upiChoice != null) {
      return await processUpiTransaction();
    }

    if (!details.isIntentFlow) {
      return await processRazorpayTransaction();
    }
  }

  //6 -- UPI
  @override
  Future<void> processUpiTransaction() async {
    isSilverBuyInProgress = true;
    AppState.blockNavigation();

    final amount = currentSilverPurchaseDetails.silverBuyAmount!;
    final augmontRates = currentSilverPurchaseDetails.silverRates!;
    double netTax = augmontRates.cgstPercent! + augmontRates.sgstPercent!;
    currentTxnGms = currentSilverPurchaseDetails.silverInGrams;

    final augMap = {
      "aBlockId": augmontRates.blockId.toString(),
      "aLockPrice": augmontRates.silverBuyPrice,
      "aPaymode": 'RZP',
      "aSilverInTxn": _getSilverQuantityFromTaxedAmount(
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax)),
          augmontRates.silverBuyPrice!,),
      "aTaxedSilverBalance":
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax)),
    };
    currentTxnGms = currentSilverPurchaseDetails.silverInGrams;
    final txnResponse = await _paytmRepo.createTransaction(
      amount,
      augMap,
      {},
      currentSilverPurchaseDetails.couponCode,
      currentSilverPurchaseDetails.skipMl,
      '',
      InvestmentType.SILVER,
      currentSilverPurchaseDetails.upiChoice!.upiApplication.appName
          .formatUpiAppName(),
      currentSilverPurchaseDetails.isAutoLeaseChecked,
    );
    if (txnResponse.isSuccess()) {
      currentTxnOrderId = txnResponse.model!.data!.txnId;

      try {
        if (Platform.isIOS) {
          isIOSTxnInProgress = true;
          final res =
              await BaseUtil.launchUrl(txnResponse.model!.data!.intent!);
          if (!res) {
            isIOSTxnInProgress = false;
            isSilverBuyInProgress = false;
            currentTransactionState = TransactionState.idle;
            AppState.unblockNavigation();
          }
        } else {
          const platform = MethodChannel("methodChannel/upiIntent");
          final result = await platform.invokeMethod('initiatePsp', {
            'redirectUrl': txnResponse.model!.data!.intent,
            'packageName': currentSilverPurchaseDetails.upiChoice!.packageName
          });
          _logger.d("Result from initiatePsp: $result");

          if (result.toString().toLowerCase().contains('failure')) {
            isSilverBuyInProgress = false;
            currentTransactionState = TransactionState.idle;

            AppState.unblockNavigation();

            return BaseUtil.showNegativeAlert(
                "Transaction Cancelled", locale.tryLater);
          }
          isSilverBuyInProgress = false;
          currentTransactionState = TransactionState.ongoing;
          checkTransactionStatus();
        }

        locator<BackButtonActions>().isTransactionCancelled = false;
      } catch (e) {
        _logger.e("Intent payement exception $e");
        locator<BackButtonActions>().isTransactionCancelled = false;

        if (Platform.isAndroid) {
          isSilverBuyInProgress = false;
          currentTransactionState = TransactionState.ongoing;
          checkTransactionStatus();
        }
      }
    } else {
      isSilverBuyInProgress = false;
      currentTransactionState = TransactionState.idle;

      AppState.unblockNavigation();

      return BaseUtil.showNegativeAlert(
        txnResponse.errorMessage,
        locale.tryLater,
      );
    }
  }

  @override
  Future<void> processNBTransaction() async {
    isSilverBuyInProgress = true;
    AppState.blockNavigation();

    final amount = currentSilverPurchaseDetails.silverBuyAmount!;
    final augmontRates = currentSilverPurchaseDetails.silverRates!;
    double netTax = augmontRates.cgstPercent! + augmontRates.sgstPercent!;
    currentTxnGms = currentSilverPurchaseDetails.silverInGrams;

    
    final augMap = {
      "aBlockId": augmontRates.blockId.toString(),
      "aLockPrice": augmontRates.silverBuyPrice,
      "aPaymode": "NET_BANKING",
      "aSilverInTxn": _getSilverQuantityFromTaxedAmount(
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax)),
          augmontRates.silverBuyPrice!),
      "aTaxedSilverBalance":
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax))
    };

    currentTxnGms = currentSilverPurchaseDetails.silverInGrams;

    final txnResponse = await _paytmRepo.createTransaction(
      amount,
      augMap,
      null, //lb map.
      currentSilverPurchaseDetails.couponCode,
      currentSilverPurchaseDetails.skipMl,
      '',
      InvestmentType.AUGGOLD99,
      null, //app use

      currentSilverPurchaseDetails.isAutoLeaseChecked,
      {},
      'NET_BANKING', // pay-mode
    );

    if (txnResponse.isSuccess()) {
      currentTxnOrderId = txnResponse.model!.data!.txnId;
      isNetBankingInProgress = true;
      AppState.delegate!.appState.currentAction = PageAction(
        page: WebViewPageConfig,
        state: PageState.addWidget,
        widget: NetBankingWebView(
          url: txnResponse.model!.data!.nbIntent!,
          onPageClosed: () => _validateTransaction(shouldPop: false),
          onUrlChanged: (value) {
            // when transaction gets completed with success then it would be
            // redirecting to the the defined url and on that we will be
            // validating transaction status.
            if (value == Constants.postNBRedirectionURL) {
              _validateTransaction();
            }
          },
        ),
      );

      locator<BackButtonActions>().isTransactionCancelled = false;
    } else {
      isSilverBuyInProgress = false;
      currentTransactionState = TransactionState.idle;

      AppState.unblockNavigation();

      return BaseUtil.showNegativeAlert(
        txnResponse.errorMessage,
        locale.tryLater,
      );
    }
  }

  Future<void> _validateTransaction({bool shouldPop = true}) async {
    isNetBankingInProgress = false;
    AppState.unblockNavigation();
    if (shouldPop) await AppState.backButtonDispatcher?.didPopRoute();
    isSilverBuyInProgress = false;
    currentTransactionState = TransactionState.ongoing;
    checkTransactionStatus();
    await Future.delayed(
        const Duration(milliseconds: 200),); // to avoid frequent set state.
    notifyListeners();
  }

  // RAZORPAY
  @override
  Future<void> processRazorpayTransaction() async {
    isSilverBuyInProgress = true;
    AppState.blockNavigation();
    final amount = currentSilverPurchaseDetails.silverBuyAmount!;
    final augmontRates = currentSilverPurchaseDetails.silverRates!;
    double netTax = augmontRates.cgstPercent! + augmontRates.sgstPercent!;
    currentTxnGms = currentSilverPurchaseDetails.silverInGrams;
   

    final augMap = {
      "aBlockId": augmontRates.blockId.toString(),
      "aLockPrice": augmontRates.silverBuyPrice,
      "aPaymode": 'RZP',
      "aSilverInTxn": _getSilverQuantityFromTaxedAmount(
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax)),
          augmontRates.silverBuyPrice!,
        ),
      "aTaxedSilverBalance":
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax))
    };
    currentTxnGms = currentSilverPurchaseDetails.silverInGrams;

    await _razorpayService.initiateRazorpayTxn(
      amount: currentSilverPurchaseDetails.silverBuyAmount,
      augMap: augMap,
      lbMap: {},
      couponCode: currentSilverPurchaseDetails.couponCode,
      email: _userService.baseUser!.email,
      mobile: _userService.baseUser!.mobile,
      skipMl: currentSilverPurchaseDetails.skipMl,
      investmentType: InvestmentType.SILVER,
    );

    isSilverBuyInProgress = false;
  }

  @override
  Future<void> transactionResponseUpdate(
      {List<String>? gtIds, double? amount,}) async {
    _logger.d("Polling response processing");
    try {
      //add this to augmontBuyVM
      unawaited(_userCoinService.getUserCoinBalance());
      unawaited(_userService.getUserFundWalletData());
      if (currentTransactionState == TransactionState.ongoing) {
        ScratchCardService.scratchCardsList = gtIds;
        AppState.unblockNavigation();
        currentTransactionState = TransactionState.success;
        Haptic.vibrate();
      }
      unawaited(
          _txnHistoryService.updateTransactions(InvestmentType.AUGGOLD99));
    } catch (e) {
      _logger.e(e);
      unawaited(_internalOpsService.logFailure(_userService.baseUser!.uid,
          FailType.DepositPayloadError, e as Map<String, dynamic>));
    }
  }

  @override
  Future<void> onComplete(ApiResponse<TransactionResponseModel> value) async {
    if (value.isSuccess()) {
      TransactionResponseModel txnStatus = value.model!;
      switch (txnStatus.data!.status) {
        case Constants.TXN_STATUS_RESPONSE_SUCCESS:
          if (!txnStatus.data!.isUpdating!) {
              await locator<BaseUtil>().updateUser();
              unawaited(_userService.getUserFundWalletData());
              unawaited(_userService.updatePortFolio());
              transactionResponseModel = value.model;
              currentTxnTambolaTicketsCount = value.model!.data!.tickets!;
              currentTxnScratchCardCount =
                  value.model?.data?.gtIds?.length ?? 0;
              if (value.model!.data != null &&
                  value.model!.data!.goldInTxnBought != null && //todo changes new transaction model for silver
                  value.model!.data!.goldInTxnBought! > 0) {
                currentTxnGms = value.model!.data!.goldInTxnBought;
              }
              unawaited(transactionResponseUpdate(
                  gtIds: transactionResponseModel?.data?.gtIds ?? []));
            final upiChoice = currentSilverPurchaseDetails.upiChoice;
            if (upiChoice != null) {
              await PreferenceHelper.insertUsedPaymentIntent(
                upiChoice.upiApplication.appName,
              );
            }
            AppState.unblockNavigation();
          }
          break;
        case Constants.TXN_STATUS_RESPONSE_PENDING:
          break;
        case Constants.TXN_STATUS_RESPONSE_FAILURE:
          AppState.unblockNavigation();
          isSilverBuyInProgress = false;
          currentTransactionState = TransactionState.idle;
          BaseUtil.showNegativeAlert(
            'Transaction failed',
            'Your transaction was unsuccessful. Please try again',
          );
          break;
      }
    }
  }

  double _getSilverQuantityFromTaxedAmount(double amount, double rate) {
    return BaseUtil.digitPrecision(amount / rate, 4, false);
  }

  double _getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
  }

  void showTransactionPendingDialog(String? subtitle) {
    S locale = locator<S>();
    locator<BackButtonActions>().isTransactionCancelled = false;
    AppState.onTap = null;
    AppState.amt = 0;
    AppState.isRepeated = false;
    AppState.type = null;
    AppState.isTxnProcessing = true;
    Future.delayed(const Duration(seconds: 1), () {
      BaseUtil.openDialog(
        addToScreenStack: true,
        hapticVibrate: true,
        isBarrierDismissible: false,
        content: PendingDialog(
          title: "Oh no!",
          subtitle: subtitle ?? locale.txnDelay,
          duration: '15 ${locale.minutes}',
        ),
      );
    });
  }
}


class SilverPurchaseDetails {
  double? silverBuyAmount;
  AugmontSilverRates? silverRates;
  String couponCode;
  bool skipMl;
  double silverInGrams;
  ApplicationMeta? upiChoice;
  double? leaseQty;
  bool isIntentFlow;
  bool isAutoLeaseChecked;

  SilverPurchaseDetails({
    required this.silverBuyAmount,
    required this.silverRates,
    required this.couponCode,
    required this.skipMl,
    required this.silverInGrams,
    this.upiChoice,
    this.leaseQty,
    this.isIntentFlow = false,
    this.isAutoLeaseChecked = true,
  });
}
