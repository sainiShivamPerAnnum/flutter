import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/deposit_response_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/investment_actions_repo.dart';
import 'package:felloapp/core/repository/report_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/augmont_invoice_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/augmont_api_util.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AugmontService extends ChangeNotifier {
  final Log log = const Log('AugmontService');
  final CustomLogger _logger = locator<CustomLogger>();
  final ApiPath _apiPaths = locator<ApiPath>();
  final InternalOpsService _internalOpsService = locator<InternalOpsService>();

  final InvestmentActionsRepository _investmentActionsRepository =
      locator<InvestmentActionsRepository>();

  final DBModel _dbModel = locator<DBModel>();
  final BaseUtil _baseProvider = locator<BaseUtil>();
  final UserService _userService = locator<UserService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final AugmontTransactionService _augTxnService =
      locator<AugmontTransactionService>();
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();
  S locale = locator<S>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  List<String> _sellingReasons = [];
  String _selectedReasonForSelling = '';

  ValueChanged<UserTransaction>? _augmontTxnProcessListener;
  // final String defaultBaseUri =
  //     'https://jg628sk4s2.execute-api.ap-south-1.amazonaws.com/prod';
  // String? _baseUri;
  String? _apiKey;
  late var headers;

  List<String> get sellingReasons => _sellingReasons;
  String get selectedReasonForSelling => _selectedReasonForSelling;

  set selectedReasonForSelling(String val) {
    _selectedReasonForSelling = val;
    notifyListeners();
  }

  ApiResponse<DepositResponseModel>? _initialDepositResponse;

  Future<bool> _init() async {
    _sellingReasons = [
      'Not interested in the asset',
      'Returns are not good enough',
      'Require immediate funds',
      'Others'
    ];
    if (_dbModel == null) return false;

    // _baseUri = defaultBaseUri;
    headers = {'x-api-key': _apiKey};
    return true;
  }

  bool isInit() => (_apiKey != null);

  Future<AugmontRates?> getRates() async {
    if (!isInit()) await _init();
    ApiResponse<Map<String, dynamic>> response =
        await _investmentActionsRepository!.getGoldRates();
    if (response.code == 400) {
      _logger!.e(response.errorMessage);
      return null;
    } else {
      return AugmontRates.fromMap(response.model!);
    }
  }

  Future<bool> initiateWithdrawal(
      AugmontRates sellRates, double quantity) async {
    if (!isInit()) await _init();

    Map<String, dynamic> _params = {
      SubmitGoldSell.fldQuantity: quantity,
      SubmitGoldSell.fldBlockId: sellRates.blockId,
      SubmitGoldSell.fldLockPrice: sellRates.goldSellPrice,
    };

    _logger!.d(_params);
    ApiResponse<bool> _onSellCompleteResponse =
        await _investmentActionsRepository!.withdrawlComplete(
      amount: -1 * BaseUtil.digitPrecision(quantity * sellRates.goldSellPrice!),
      sellGoldMap: _params,
      userUid: _userService!.baseUser!.uid,
    );

    if (_onSellCompleteResponse.code == 200) {
      return true;
    } else {
      _augTxnService!.currentTransactionState = TransactionState.idle;
      AppState.unblockNavigation();
      if (_onSellCompleteResponse.errorMessage != null &&
          _onSellCompleteResponse.errorMessage!.isNotEmpty) {
        BaseUtil.showNegativeAlert(
            _onSellCompleteResponse.errorMessage, locale.obPleaseTryAgain);
      } else {
        BaseUtil.showNegativeAlert(locale.txnVerify, locale.txnVerifySubTitle);
      }

      _internalOpsService!.logFailure(
          _userService!.baseUser!.uid, FailType.WithdrawlCompleteApiFailed, {
        'message':
            _initialDepositResponse?.errorMessage ?? "Withdrawal api failed"
      });
      AppState.backButtonDispatcher!.didPopRoute();
      return false;
    }
  }

  // showTransactionPendingDialog() {
  //   BaseUtil.openDialog(
  //     addToScreenStack: true,
  //     hapticVibrate: true,
  //     isBarrierDismissible: false,
  //     content: PendingDialog(
  //       title: locale.withDrawalProcessing,
  //       subtitle: locale.amountWillbeCreditedShortly,
  //       duration: '',
  //     ),
  //   );
  // }

  ///returns path where invoice is generated and saved
  Future<String?> generatePurchaseInvoicePdf(
      String? txnId, Map<String, String?>? userDetails) async {
    AugmontInvoiceService _pdfService = AugmontInvoiceService();
    final _reportRepo = locator<ReportRepository>();
    if (!isInit()) await _init();
    Map<String, dynamic>? resMap;
    final res = await _reportRepo.getReport(txnId);
    if (res.isSuccess()) {
      resMap = res.model;
    }

    if (resMap == null) {
      log.error('Query Failed');
      return null;
    } else {
      log.debug(resMap[GetInvoice.resTransactionId].toString());
      resMap["flag"] = QUERY_PASSED;
      String? _path = await _pdfService.generateInvoice(resMap, userDetails);
      return _path;
    }
  }

  completeTransaction() {
    // _baseProvider.currentAugmontTxn = null;
    _augmontTxnProcessListener = null;

    _baseProvider!.userMiniTxnList = null;
    _baseProvider!.hasMoreTransactionListDocuments = true;
    _baseProvider!.lastTransactionListDocument =
        null; //this is to ensure that the transactions list gets refreshed
  }

  double getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
  }

  double getGoldQuantityFromTaxedAmount(double amount, double rate) {
    return BaseUtil.digitPrecision((amount / rate), 4, false);
  }

  double getGoldQuantityFromSellAmount(double amount, double rate) {
    double qnt = amount / rate;
    return BaseUtil.digitPrecision(qnt, 4, false);
  }
}

class GoldGraphPoint {
  final double rate;
  final DateTime timestamp;

  GoldGraphPoint(this.rate, this.timestamp);

  @override
  String toString() {
    return ("Rate $rate Time $timestamp");
    // return super.toString();
  }
}
