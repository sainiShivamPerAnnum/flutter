// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_scheme_model.dart';
import 'package:felloapp/core/model/paytm_models/deposit_fcm_response_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/base_transaction_service.dart';
import 'package:felloapp/core/service/payments/razorpay_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
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

class AugmontTransactionService extends BaseTransactionService
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
  DepositFcmResponseModel? depositFcmResponseModel;
  bool _isGoldBuyInProgress = false;
  bool _isGoldSellInProgress = false;
  GoldProSchemeModel? _goldProScheme;

  GoldProSchemeModel? get goldProScheme => _goldProScheme;

  set goldProScheme(GoldProSchemeModel? value) {
    _goldProScheme = value;
    notifyListeners();
  }

  TransactionState get currentTxnState => currentTransactionState;

  late GoldPurchaseDetails currentGoldPurchaseDetails;

  bool get isGoldBuyInProgress => _isGoldBuyInProgress;

  set isGoldBuyInProgress(bool value) {
    _isGoldBuyInProgress = value;
    notifyListeners();
  }

  TransactionResponseModel? transactionResponseModel;

  bool get isGoldSellInProgress => _isGoldSellInProgress;

  set isGoldSellInProgress(bool value) {
    _isGoldSellInProgress = value;
    notifyListeners();
  }

  Future<void> initiateAugmontTransaction({
    required GoldPurchaseDetails details,
  }) async {
    currentGoldPurchaseDetails = details;
    currentTxnAmount = details.goldBuyAmount;

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
    isGoldBuyInProgress = true;
    AppState.blockNavigation();

    final amount = currentGoldPurchaseDetails.goldBuyAmount!;
    final augmontRates = currentGoldPurchaseDetails.goldRates!;
    double netTax = augmontRates.cgstPercent! + augmontRates.sgstPercent!;
    currentTxnGms = currentGoldPurchaseDetails.goldInGrams;

    Map<String, dynamic>? augProMap = {};
    if (currentGoldPurchaseDetails.isPro) {
      augProMap["schemeId"] = goldProScheme!.id;
      augProMap["leaseQty"] = currentGoldPurchaseDetails.leaseQty;
    }

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
    currentTxnGms = currentGoldPurchaseDetails.goldInGrams;
    final txnResponse = await _paytmRepo.createTransaction(
      amount,
      augMap,
      {},
      currentGoldPurchaseDetails.couponCode,
      currentGoldPurchaseDetails.skipMl,
      '',
      InvestmentType.AUGGOLD99,
      currentGoldPurchaseDetails.upiChoice!.upiApplication.appName
          .formatUpiAppName(),
      augProMap,
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
            isGoldBuyInProgress = false;
            currentTransactionState = TransactionState.idle;
            AppState.unblockNavigation();
          }
        } else {
          const platform = MethodChannel("methodChannel/upiIntent");
          final result = await platform.invokeMethod('initiatePsp', {
            'redirectUrl': txnResponse.model!.data!.intent,
            'packageName': currentGoldPurchaseDetails.upiChoice!.packageName
          });
          _logger.d("Result from initiatePsp: $result");

          if (result.toString().toLowerCase().contains('failure')) {
            isGoldBuyInProgress = false;
            currentTransactionState = TransactionState.idle;

            AppState.unblockNavigation();

            return BaseUtil.showNegativeAlert(
                "Transaction Cancelled", locale.tryLater);
          }
          isGoldBuyInProgress = false;
          currentTransactionState = TransactionState.ongoing;
          checkTransactionStatus();
        }

        locator<BackButtonActions>().isTransactionCancelled = false;
      } catch (e) {
        _logger.e("Intent payement exception $e");
        locator<BackButtonActions>().isTransactionCancelled = false;

        if (Platform.isAndroid) {
          isGoldBuyInProgress = false;
          currentTransactionState = TransactionState.ongoing;
          checkTransactionStatus();
        }
      }
    } else {
      isGoldBuyInProgress = false;
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
    isGoldBuyInProgress = true;
    AppState.blockNavigation();

    final amount = currentGoldPurchaseDetails.goldBuyAmount!;
    final augmontRates = currentGoldPurchaseDetails.goldRates!;
    double netTax = augmontRates.cgstPercent! + augmontRates.sgstPercent!;
    currentTxnGms = currentGoldPurchaseDetails.goldInGrams;

    Map<String, dynamic>? augProMap = {};
    if (currentGoldPurchaseDetails.isPro) {
      augProMap["schemeId"] = goldProScheme!.id;
      augProMap["leaseQty"] = currentGoldPurchaseDetails.leaseQty;
    }

    final augMap = {
      "aBlockId": augmontRates.blockId.toString(),
      "aLockPrice": augmontRates.goldBuyPrice,
      "aPaymode": "NET_BANKING",
      "aGoldInTxn": _getGoldQuantityFromTaxedAmount(
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax)),
          augmontRates.goldBuyPrice!),
      "aTaxedGoldBalance":
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax))
    };

    currentTxnGms = currentGoldPurchaseDetails.goldInGrams;

    final txnResponse = await _paytmRepo.createTransaction(
      amount,
      augMap,
      null, //lb map.
      currentGoldPurchaseDetails.couponCode,
      currentGoldPurchaseDetails.skipMl,
      '',
      InvestmentType.AUGGOLD99,
      null, //app use
      augProMap,
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
      isGoldBuyInProgress = false;
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
    isGoldBuyInProgress = false;
    currentTransactionState = TransactionState.ongoing;
    checkTransactionStatus();
    await Future.delayed(
        const Duration(milliseconds: 200)); // to avoid frequent set state.
    notifyListeners();
  }

  // RAZORPAY
  @override
  Future<void> processRazorpayTransaction() async {
    isGoldBuyInProgress = true;
    AppState.blockNavigation();
    final amount = currentGoldPurchaseDetails.goldBuyAmount!;
    final augmontRates = currentGoldPurchaseDetails.goldRates!;
    double netTax = augmontRates.cgstPercent! + augmontRates.sgstPercent!;
    currentTxnGms = currentGoldPurchaseDetails.goldInGrams;
    if (currentGoldPurchaseDetails.isPro && goldProScheme == null) {
      isGoldBuyInProgress = false;
      AppState.unblockNavigation();
      BaseUtil.showNegativeAlert("Gold Scheme not available right now",
          "Please try again after sometime");
      return;
    }
    Map<String, dynamic>? augProMap = {};
    if (currentGoldPurchaseDetails.isPro) {
      augProMap["schemeId"] = goldProScheme!.id;
      augProMap["leaseQty"] = currentGoldPurchaseDetails.leaseQty;
    }

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
    currentTxnGms = currentGoldPurchaseDetails.goldInGrams;

    await _razorpayService.initiateRazorpayTxn(
      amount: currentGoldPurchaseDetails.goldBuyAmount,
      augMap: augMap,
      lbMap: {},
      couponCode: currentGoldPurchaseDetails.couponCode,
      email: _userService.baseUser!.email,
      mobile: _userService.baseUser!.mobile,
      skipMl: currentGoldPurchaseDetails.skipMl,
      investmentType: InvestmentType.AUGGOLD99,
      goldProMap: augProMap,
    );

    isGoldBuyInProgress = false;
  }

  @override
  Future<void> transactionResponseUpdate(
      {List<String>? gtIds, double? amount}) async {
    _logger.d("Polling response processing");
    try {
      //add this to augmontBuyVM
      unawaited(_userCoinService.getUserCoinBalance());
      unawaited(_userService.getUserFundWalletData());
      if (currentTransactionState == TransactionState.ongoing) {
        ScratchCardService.scratchCardsList = gtIds;
        await _userService.getUserJourneyStats();
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
            if (currentGoldPurchaseDetails.isPro) {
              if (txnStatus.data!.fd!.status ==
                  Constants.GOLD_PRO_TXN_STATUS_ACTIVE) {
                await locator<BaseUtil>().updateUser();
                PowerPlayService.powerPlayDepositFlow = false;
                MatchData? liveMatchData =
                    locator<PowerPlayService>().liveMatchData;
                unawaited(_userService.getUserFundWalletData());
                unawaited(_userService.updatePortFolio());
                unawaited(
                    _txnHistoryService.getGoldProTransactions(forced: true));
                if (liveMatchData != null) {
                  unawaited(locator<PowerPlayService>()
                      .getUserTransactionHistory(matchData: liveMatchData));
                }
                transactionResponseModel = value.model;
                currentTxnTambolaTicketsCount = value.model!.data!.tickets!;
                currentTxnScratchCardCount =
                    value.model?.data?.gtIds?.length ?? 0;
                if (value.model!.data != null &&
                    value.model!.data!.goldInTxnBought != null &&
                    value.model!.data!.goldInTxnBought! > 0) {
                  currentTxnGms = value.model!.data!.goldInTxnBought;
                }
                unawaited(transactionResponseUpdate(
                    gtIds: transactionResponseModel?.data?.gtIds ?? []));
              } else if (txnStatus.data!.fd!.status ==
                  Constants.GOLD_PRO_TXN_STATUS_FAILED) {
                AppState.unblockNavigation();
                unawaited(transactionResponseUpdate(
                    gtIds: transactionResponseModel?.data?.gtIds ?? []));
                AppState.isGoldProBuyInProgress = false;
                unawaited(
                  AppState.backButtonDispatcher!.didPopRoute().then(
                        (value) => showTransactionPendingDialog(
                            transactionResponseModel?.data?.txnDisplayMsg),
                      ),
                );
              }
            } else {
              await locator<BaseUtil>().updateUser();
              PowerPlayService.powerPlayDepositFlow = false;
              MatchData? liveMatchData =
                  locator<PowerPlayService>().liveMatchData;
              unawaited(_userService.getUserFundWalletData());
              unawaited(_userService.updatePortFolio());
              if (liveMatchData != null) {
                unawaited(locator<PowerPlayService>()
                    .getUserTransactionHistory(matchData: liveMatchData));
              }
              transactionResponseModel = value.model;
              currentTxnTambolaTicketsCount = value.model!.data!.tickets!;
              currentTxnScratchCardCount =
                  value.model?.data?.gtIds?.length ?? 0;
              if (value.model!.data != null &&
                  value.model!.data!.goldInTxnBought != null &&
                  value.model!.data!.goldInTxnBought! > 0) {
                currentTxnGms = value.model!.data!.goldInTxnBought;
              }
              unawaited(transactionResponseUpdate(
                  gtIds: transactionResponseModel?.data?.gtIds ?? []));
            }
            final upiChoice = currentGoldPurchaseDetails.upiChoice;
            if (upiChoice != null) {
              await PreferenceHelper.insertUsedPaymentIntent(
                upiChoice.upiApplication.appName,
              );
            }
          }
          break;
        case Constants.TXN_STATUS_RESPONSE_PENDING:
          break;
        case Constants.TXN_STATUS_RESPONSE_FAILURE:
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

  double _getGoldQuantityFromTaxedAmount(double amount, double rate) {
    return BaseUtil.digitPrecision((amount / rate), 4, false);
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

class GoldPurchaseDetails {
  double? goldBuyAmount;
  AugmontRates? goldRates;
  String couponCode;
  bool skipMl;
  double goldInGrams;
  ApplicationMeta? upiChoice;
  double? leaseQty;
  bool isPro;
  bool isIntentFlow;

  GoldPurchaseDetails({
    required this.goldBuyAmount,
    required this.goldRates,
    required this.couponCode,
    required this.skipMl,
    required this.goldInGrams,
    this.upiChoice,
    this.leaseQty,
    this.isPro = false,
    this.isIntentFlow = false,
  });
}
