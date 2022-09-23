import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/base_transaction_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/core/service/payments/razorpay_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';

class LendboxTransactionService extends BaseTransactionService {
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

  bool skipMl = false;

  Future<void> initiateTransaction(double txnAmount, bool skipMl) async {
    this.currentTxnAmount = txnAmount;
    this.skipMl = skipMl;
    String paymentMode = this.getPaymentMode();

    switch (paymentMode) {
      case "PAYTM-PG":
        await processPaytmTransaction();
        break;
      case "PAYTM":
        await getUserUpiAppChoice(this);
        break;
      case "RZP-PG":
        await processRazorpayTransaction();
        break;
    }

    return null;
  }

  Future<void> processPaytmTransaction() async {
    AppState.blockNavigation();
    final createdPaytmTransactionData =
        await this.createPaytmTransaction(this.skipMl);

    if (createdPaytmTransactionData != null) {
      bool _status = await _paytmService.initiatePaytmPGTransaction(
        paytmSubscriptionModel: createdPaytmTransactionData,
        restrictAppInvoke: FlavorConfig.isDevelopment(),
        investmentType: InvestmentType.LENDBOXP2P,
      );

      currentTransactionState = TransactionState.ongoing;

      if (_status) {
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
      // resetBuyOptions();
    } else {
      AppState.unblockNavigation();
      return BaseUtil.showNegativeAlert(
          'Failed to create transaction', 'Please try after sometime');
    }
  }

  Future<CreatePaytmTransactionModel> createPaytmTransaction(
    bool skipMl,
  ) async {
    if (this.currentTxnAmount == null) return null;

    final ApiResponse<CreatePaytmTransactionModel>
        paytmSubscriptionApiResponse = await _paytmRepo.createTransaction(
      this.currentTxnAmount.toDouble(),
      null,
      {},
      null,
      skipMl ?? false,
      InvestmentType.LENDBOXP2P,
    );

    if (!paytmSubscriptionApiResponse.isSuccess()) return null;
    this.currentTxnOrderId = paytmSubscriptionApiResponse.model.data.orderId;
    return paytmSubscriptionApiResponse.model;
  }

  Future<void> processRazorpayTransaction() async {
    AppState.blockNavigation();

    await _razorpayService.initiateRazorpayTxn(
      amount: this.currentTxnAmount,
      augMap: {},
      lbMap: {},
      email: _userService.baseUser.email,
      mobile: _userService.baseUser.mobile,
      skipMl: this.skipMl,
      investmentType: InvestmentType.LENDBOXP2P,
    );

    AppState.unblockNavigation();
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
              amount: this.currentTxnAmount,
              gtId: currentTxnOrderId,
            );
          }
          break;
        case Constants.TXN_STATUS_RESPONSE_PENDING:
          break;
        case Constants.TXN_STATUS_RESPONSE_FAILURE:
          timer.cancel();
          currentTransactionState = TransactionState.idle;
          BaseUtil.showNegativeAlert(
            'Transaction failed',
            'Your transaction was unsuccessful. Please try again',
          );
          break;
      }
    }
  }

  Future<void> transactionResponseUpdate({String gtId, double amount}) async {
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
            source: GTSOURCE.prize,
          );
        }
      }

      _txnHistoryService.updateTransactions();
    } catch (e) {
      _logger.e(e);
      _internalOpsService.logFailure(
          _userService.baseUser.uid, FailType.DepositPayloadError, e);
    }
  }

  dynamic getAmount(double amount) {
    if (amount > amount.toInt())
      return amount;
    else
      return amount.toInt();
  }

  @override
  Future<void> processUpiTransaction() {
    throw UnimplementedError();
  }
}
