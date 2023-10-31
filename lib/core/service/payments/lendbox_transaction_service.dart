import 'dart:async';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
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
import 'package:felloapp/core/service/payments/transaction_service_mixin.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/services.dart';
import 'package:upi_pay/upi_pay.dart';

class LendboxTransactionService
    extends BaseTransactionService<ApiResponse<TransactionResponseModel>>
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

  TransactionResponseModel? transactionResponseModel;
  FloPurchaseDetails? currentFloPurchaseDetails;
  String? floAssetType;

  /// Holds the future object of [run] method which can be awaited later on when
  /// it crosses maximum waiting duration.
  Future<void>? _transactionFuture;

  Future<void>? get transactionProcessFuture => _transactionFuture;

  Future<void> initiateWithdrawal(double txnAmount, String? txnId) async {
    currentTransactionState = TransactionState.success;
    await _txnHistoryService.updateTransactions(InvestmentType.LENDBOXP2P);
  }

  Future<void> initiateTransaction(FloPurchaseDetails details) async {
    currentFloPurchaseDetails = details;
    currentTxnAmount = details.txnAmount;
    return details.upiChoice != null
        ? processUpiTransaction()
        : processRazorpayTransaction();
  }

  @override
  Future<void> processRazorpayTransaction() async {
    AppState.blockNavigation();

    await _razorpayService.initiateRazorpayTxn(
      amount: currentTxnAmount,
      augMap: {},
      lbMap: {
        "fundType": currentFloPurchaseDetails!.floAssetType,
        "maturityPref": currentFloPurchaseDetails!.maturityPref,
      },
      couponCode: currentFloPurchaseDetails!.couponCode,
      email: _userService.baseUser!.email,
      mobile: _userService.baseUser!.mobile,
      skipMl: currentFloPurchaseDetails!.skipMl,
      investmentType: InvestmentType.LENDBOXP2P,
    );
  }

  @override
  Future<void> validateResponse(
      ApiResponse<TransactionResponseModel> value) async {
    if (value.isSuccess()) {
      TransactionResponseModel txnStatus = value.model!;

      switch (txnStatus.data!.status) {
        case Constants.TXN_STATUS_RESPONSE_SUCCESS:
          if (!txnStatus.data!.isUpdating!) {
            PowerPlayService.powerPlayDepositFlow = false;
            MatchData? liveMatchData =
                locator<PowerPlayService>().liveMatchData;
            if (liveMatchData != null) {
              unawaited(locator<PowerPlayService>()
                  .getUserTransactionHistory(matchData: liveMatchData));
            }
            currentTxnTambolaTicketsCount = value.model!.data!.tickets!;
            currentTxnScratchCardCount = value.model?.data?.gtIds?.length ?? 0;
            await locator<BaseUtil>().newUserCheck();
            transactionResponseModel = value.model!;
            return transactionResponseUpdate(
              amount: currentTxnAmount,
              gtIds: transactionResponseModel?.data?.gtIds ?? [],
            );
          }
          break;
        case Constants.TXN_STATUS_RESPONSE_PENDING:
          break;
        case Constants.TXN_STATUS_RESPONSE_FAILURE:
          currentTransactionState = TransactionState.idle;
          AppState.unblockNavigation();
          BaseUtil.showNegativeAlert(
            locale.txnFailed,
            locale.txnFailedSubtitle,
          );
          break;
      }
    }
  }

  @override
  Future<void> transactionResponseUpdate(
      {List<String>? gtIds, double? amount}) async {
    _logger.d("Polling response processing");
    try {
      //add this to augmontBuyVM
      unawaited(_userCoinService.getUserCoinBalance());
      double newFlcBalance = amount ?? 0;
      if (newFlcBalance > 0) {
        _userCoinService.setFlcBalance(
            (_userCoinService.flcBalance! + newFlcBalance).toInt());
      }
      unawaited(_userService.getUserFundWalletData());
      if (currentTransactionState == TransactionState.ongoing) {
        ScratchCardService.scratchCardsList = gtIds;
        // await _gtService.fetchAndVerifyScratchCardByID();
        await _userService.getUserJourneyStats();

        AppState.unblockNavigation();
        currentTransactionState = TransactionState.success;
        Haptic.vibrate();
      }

      unawaited(
          _txnHistoryService.updateTransactions(InvestmentType.LENDBOXP2P));
    } catch (e) {
      _logger.e(e);
      unawaited(_internalOpsService.logFailure(_userService.baseUser!.uid,
          FailType.DepositPayloadError, e as Map<String, dynamic>));
    }
  }

  @override
  Future<void> processUpiTransaction() async {
    AppState.blockNavigation();

    final ApiResponse<CreatePaytmTransactionModel> txnResponse =
        await _paytmRepo.createTransaction(
      currentTxnAmount,
      {},
      {
        "fundType": currentFloPurchaseDetails!.floAssetType,
        "maturityPref": currentFloPurchaseDetails!.maturityPref,
      },
      currentFloPurchaseDetails!.couponCode,
      currentFloPurchaseDetails!.skipMl,
      '',
      InvestmentType.LENDBOXP2P,
      currentFloPurchaseDetails!.upiChoice!.upiApplication.appName
          .formatUpiAppName(),
    );
    if (txnResponse.isSuccess()) {
      currentTxnOrderId = txnResponse.model!.data!.txnId;
      const platform = MethodChannel("methodChannel/upiIntent");

      try {
        if (Platform.isIOS) {
          isIOSTxnInProgress = true;
          final res =
              await BaseUtil.launchUrl(txnResponse.model!.data!.intent!);
          if (!res) {
            isIOSTxnInProgress = false;
            currentTransactionState = TransactionState.idle;
            AppState.unblockNavigation();
          }
        } else {
          final result = await platform.invokeMethod('initiatePsp', {
            'redirectUrl': txnResponse.model!.data!.intent,
            'packageName': currentFloPurchaseDetails!.upiChoice!.packageName
          });
          _logger.d("Result from initiatePsp: $result");
          if (result.toString().toLowerCase().contains('failure')) {
            currentTransactionState = TransactionState.idle;

            AppState.unblockNavigation();

            return BaseUtil.showNegativeAlert(
                "Transaction Cancelled", locale.tryLater);
          }
        }

        locator<BackButtonActions>().isTransactionCancelled = false;

        if (Platform.isAndroid) {
          currentTransactionState = TransactionState.ongoing;
          _transactionFuture = run();
        }
      } catch (e) {
        _logger.e("Intent payement exception $e");
        locator<BackButtonActions>().isTransactionCancelled = false;

        if (Platform.isAndroid) {
          currentTransactionState = TransactionState.ongoing;
          _transactionFuture = run();
        }
      }
    } else {
      currentTransactionState = TransactionState.idle;
      AppState.unblockNavigation();
      return BaseUtil.showNegativeAlert(
          txnResponse.errorMessage, locale.tryLater);
    }
  }
}

class FloPurchaseDetails {
  double? txnAmount;
  bool skipMl;
  String? floAssetType;
  String? maturityPref;
  String couponCode;
  ApplicationMeta? upiChoice;

  FloPurchaseDetails({
    required this.txnAmount,
    required this.floAssetType,
    this.skipMl = false,
    this.maturityPref,
    this.couponCode = '',
    this.upiChoice,
  });
}
