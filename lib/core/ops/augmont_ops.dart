import 'dart:async';
import 'dart:convert';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/deposit_response_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/investment_actions_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/augmont_invoice_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/augmont_api_util.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AugmontService extends ChangeNotifier {
  final Log log = new Log('AugmontService');
  final CustomLogger _logger = locator<CustomLogger>();
  final _apiPaths = locator<ApiPath>();
  final _internalOpsService = locator<InternalOpsService>();

  final InvestmentActionsRepository _investmentActionsRepository =
      locator<InvestmentActionsRepository>();

  final DBModel _dbModel = locator<DBModel>();
  final BaseUtil _baseProvider = locator<BaseUtil>();
  final UserService _userService = locator<UserService>();
  final _userCoinService = locator<UserCoinService>();
  final AugmontTransactionService _augTxnService =
      locator<AugmontTransactionService>();
  final TransactionHistoryService _txnHistoryService =
      locator<TransactionHistoryService>();
  final _analyticsService = locator<AnalyticsService>();
  List<String> _sellingReasons = [];
  String _selectedReasonForSelling = '';

  ValueChanged<UserTransaction> _augmontTxnProcessListener;
  final String defaultBaseUri =
      'https://jg628sk4s2.execute-api.ap-south-1.amazonaws.com/prod';
  String _baseUri;
  String _apiKey;
  var headers;

  List<String> get sellingReasons => _sellingReasons;
  String get selectedReasonForSelling => _selectedReasonForSelling;

  set selectedReasonForSelling(String val) {
    this._selectedReasonForSelling = val;
    notifyListeners();
  }

  ApiResponse<DepositResponseModel> _initialDepositResponse;

  Future<bool> _init() async {
    _sellingReasons = [
      'Not interested in the asset',
      'Returns are not good enough',
      'Require immediate funds',
      'Others'
    ];
    if (_dbModel == null) return false;

    _baseUri = defaultBaseUri;
    headers = {'x-api-key': _apiKey};
    return true;
  }

  bool isInit() => (_apiKey != null);

  Future<AugmontRates> getRates() async {
    if (!isInit()) await _init();

    // New rates api code, requires conformation from augmont for dev enviroment.
    ApiResponse<Map<String, dynamic>> response =
        await _investmentActionsRepository.getGoldRates();
    if (response.code == 400) {
      _logger.e(response.errorMessage);
      return null;
    } else {
      return AugmontRates.fromMap(response.model);
    }
  }

  Future<double> getGoldBalance() async {
    if (!isInit()) await _init();
    Map<String, String> _params = {
      Passbook.fldAugmontUid: _baseProvider.augmontDetail.userId,
    };
    var _request = http.Request(
        'GET', Uri.parse(_constructRequest(Passbook.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await _processResponse(_response);
    if (resMap == null || !resMap[INTERNAL_FAIL_FLAG]) {
      log.error('Query Failed');
      return null;
    } else {
      log.debug(resMap[Passbook.resGoldGrams].toString());
      resMap["flag"] = QUERY_PASSED;

      String goldGrmsStr = resMap[Passbook.resGoldGrams];
      double goldGrms = 0;
      try {
        goldGrms = double.parse(goldGrmsStr);
        return goldGrms;
      } catch (e) {
        return 0.0;
      }
    }
  }

  Future<List<GoldGraphPoint>> getGoldRateChart(
      DateTime fromTime, DateTime toTime) async {
    if (fromTime == null || toTime == null || fromTime.isAfter(toTime))
      return null;
    if (!isInit()) await _init();

    var _params = {
      GetRateChart.fldFromTime: '${fromTime.millisecondsSinceEpoch}',
      GetRateChart.fldToTime: '${toTime.millisecondsSinceEpoch}',
    };
    var _request = http.Request(
        'GET', Uri.parse(_constructRequest(GetRateChart.path, _params)));
    _request.headers.addAll(headers);
    http.StreamedResponse _response = await _request.send();

    final resMap = await _processResponse(_response);
    if (resMap == null ||
        resMap['Items'] == null ||
        !resMap[INTERNAL_FAIL_FLAG]) {
      log.error('Query Failed');
      return null;
    } else {
      List<GoldGraphPoint> pointData = [];
      for (var rPoint in resMap['Items']) {
        try {
          GoldGraphPoint point = GoldGraphPoint(
              BaseUtil.toDouble(rPoint['rRate']),
              DateTime.fromMillisecondsSinceEpoch(rPoint['rTimestamp']));
          pointData.add(point);
        } catch (e) {
          continue;
        }
      }
      return pointData;
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

    _logger.d(_params);
    ApiResponse<bool> _onSellCompleteResponse =
        await _investmentActionsRepository.withdrawlComplete(
      amount: -1 * BaseUtil.digitPrecision(quantity * sellRates.goldSellPrice),
      sellGoldMap: _params,
      userUid: _userService.baseUser.uid,
    );

    if (_onSellCompleteResponse.code == 200) {
      return true;
    } else {
      _augTxnService.currentTransactionState = TransactionState.idle;
      AppState.unblockNavigation();
      if (_onSellCompleteResponse.errorMessage != null &&
          _onSellCompleteResponse.errorMessage.isNotEmpty)
        BaseUtil.showNegativeAlert(
            _onSellCompleteResponse.errorMessage, 'Please try again!');
      else
        BaseUtil.showNegativeAlert('Verifying transaction',
            'Your transaction is being verified and will be updated shortly');

      _internalOpsService.logFailure(
          _userService.baseUser.uid, FailType.WithdrawlCompleteApiFailed, {
        'message':
            _initialDepositResponse?.errorMessage ?? "Withdrawal api failed"
      });
      AppState.backButtonDispatcher.didPopRoute();
      return false;
    }
  }

  showTransactionPendingDialog() {
    BaseUtil.openDialog(
      addToScreenStack: true,
      hapticVibrate: true,
      isBarrierDismissable: false,
      content: PendingDialog(
        title: "Withdrawal processing",
        subtitle:
            "The amount will be credited to your UPI registered bank account shortly.",
        duration: '',
      ),
    );
  }

  ///returns path where invoice is generated and saved
  Future<String> generatePurchaseInvoicePdf(
      String txnId, Map<String, String> userDetails) async {
    AugmontInvoiceService _pdfService = AugmontInvoiceService();
    if (!isInit()) await _init();
    var _params = {
      GetInvoice.fldTranId: txnId,
    };
    var _request = http.Request(
        'GET', Uri.parse(_constructRequest(GetInvoice.path, _params)));
    _request.headers
        .addAll({'x-api-key': "aOwnj8SQ8k1TFl1gIZCbq7nrgemhnBAb5YPwzP8z"});
    http.StreamedResponse _response = await _request.send();

    final resMap = await _processResponse(_response);
    if (resMap == null || !resMap[INTERNAL_FAIL_FLAG]) {
      log.error('Query Failed');
      return null;
    } else {
      log.debug(resMap[GetInvoice.resTransactionId].toString());
      resMap["flag"] = QUERY_PASSED;

      // final pdfFile =
      //     await PdfInvoiceApi.generate(await generateInvoiceContent());
      // return pdfFile.path;
      String _path = await _pdfService.generateInvoice(resMap, userDetails);
      return _path;
    }
  }

  String _constructRequest(String subPath, Map<String, String> params) {
    String _path = '$_baseUri/$subPath';
    if (params != null && params.length > 0) {
      String _p = '';
      if (params.length == 1) {
        _p = params.keys.elementAt(0) +
            '=' +
            Uri.encodeComponent(params.values.elementAt(0));
        _path = '$_path?$_p';
      } else {
        params.forEach((key, value) {
          _p = '$_p$key=$value&';
        });
        _p = _p.substring(0, _p.length - 1);
        _path = '$_path?$_p';
      }
    }
    return _path;
  }

  Future<Map<String, dynamic>> _processResponse(
      http.StreamedResponse response) async {
    if (response == null) {
      log.error('response is null');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      log.error(
          'Query Failed:: Status:${response.statusCode}, Reason:${response.reasonPhrase}');
      if (response.statusCode == 502)
        return {
          INTERNAL_FAIL_FLAG: false,
          "userMessage": "Augmont did not respond correctly"
        };
      else
        return {
          INTERNAL_FAIL_FLAG: false,
          "userMessage": "Unknown error occurred while sending request"
        };
    }
    try {
      String res = await response.stream.bytesToString();
      log.debug(res);
      if (res == null || res.isEmpty || res == "\"\"") {
        log.error('Returned empty response');
        return {
          INTERNAL_FAIL_FLAG: false,
          "userMessage": "The entered data was not accepted"
        };
      }
      var rMap = json.decode(res);
      rMap[INTERNAL_FAIL_FLAG] = true;
      return rMap;
    } catch (e) {
      log.error('Failed to decode json');
      return null;
    }
  }

  completeTransaction() {
    // _baseProvider.currentAugmontTxn = null;
    _augmontTxnProcessListener = null;

    _baseProvider.userMiniTxnList = null;
    _baseProvider.hasMoreTransactionListDocuments = true;
    _baseProvider.lastTransactionListDocument =
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
    return ("Rate ${this.rate} Time ${this.timestamp}");
    // return super.toString();
  }
}
