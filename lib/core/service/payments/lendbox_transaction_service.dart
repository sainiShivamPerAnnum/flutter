import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
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
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:upi_pay/upi_pay.dart';

class LendboxTransactionService extends BaseTransactionService {
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

  Future<void> initiateWithdrawal(double txnAmount, String? txnId) async {
    currentTransactionState = TransactionState.success;
    await _txnHistoryService.updateTransactions(InvestmentType.LENDBOXP2P);
  }

  Future<void> initiateTransaction(FloPurchaseDetails details) async {
    currentFloPurchaseDetails = details;
    currentTxnAmount = details.txnAmount;
    if (details.upiChoice != null) {
      //Intent flow
      return processUpiTransaction();
    } else {
      //RazorPay gateway
      return processRazorpayTransaction();
    }
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
  Future<void> processPolling(Timer? timer) async {
    final res = await _paytmRepo.getTransactionStatus(currentTxnOrderId);
    if (res.isSuccess()) {
      TransactionResponseModel txnStatus = res.model!;

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
            currentTxnTambolaTicketsCount = res.model!.data!.tickets!;
            currentTxnScratchCardCount = res.model?.data?.gtIds?.length ?? 0;
            await locator<BaseUtil>().newUserCheck();
            transactionResponseModel = res.model!;
            timer!.cancel();
            return transactionResponseUpdate(
              amount: currentTxnAmount,
              gtIds: transactionResponseModel?.data?.gtIds ?? [],
            );
          }
          break;
        case Constants.TXN_STATUS_RESPONSE_PENDING:
          break;
        case Constants.TXN_STATUS_RESPONSE_FAILURE:
          timer!.cancel();
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
    // AppState.blockNavigation();
    // CreatePaytmTransactionModel? createdPaytmTransactionData =
    //     await this.createPaytmTransaction();

    // if (createdPaytmTransactionData != null) {
    //   final deepUri = await _paytmService!.generateUpiTransactionDeepUri(
    //       selectedUpiApplicationName, createdPaytmTransactionData, "FELLOTXN");

    //   if (deepUri != null && deepUri.isNotEmpty) {
    //     final res = await _paytmService!.initiateUpiTransaction(
    //       amount: this.currentTxnAmount,
    //       orderId: createdPaytmTransactionData.data!.orderId,
    //       upiApplication: upiApplication,
    //       url: deepUri,
    //       investmentType: InvestmentType.AUGGOLD99,
    //     );

    //     if (res && Platform.isAndroid) initiatePolling();
    //     AppState.unblockNavigation();
    //   } else {
    //     AppState.unblockNavigation();

    //     BaseUtil.showNegativeAlert(locale.upiConnectFailed, locale.tryLater);
    //   }
    // } else {
    //   AppState.unblockNavigation();
    //   return BaseUtil.showNegativeAlert(
    //     locale.failedToCreateTxn,
    //     locale.tryLater,
    //   );
    // }
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
    this.skipMl = false,
    required this.floAssetType,
    this.maturityPref,
    this.couponCode = '',
    this.upiChoice,
  });
}
