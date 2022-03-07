import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/repository/paytm_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class PaytmService {
  final _logger = locator<CustomLogger>();
  final _paytmRepo = locator<PaytmRepository>();

  final String devMid = "qpHRfp13374268724583";
  final String prodMid = "CMTNKX90967647249644";

  String mid;
  bool isStaging;
  String callbackUrl;

  PaytmService() {
    final stage = FlavorConfig.instance.values.paytmStage;
    if (stage == PaytmStage.DEV) {
      mid = devMid;
      isStaging = true;
    } else {
      mid = prodMid;
      isStaging = false;
    }
  }

  double _getGoldQuantityFromTaxedAmount(double amount, double rate) {
    return BaseUtil.digitPrecision((amount / rate), 4, false);
  }

  double _getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
  }

  Future<void> validateTransaction(String orderId) async {
    final ApiResponse<TransactionResponseModel> transactionResponseModel =
        await _paytmRepo.getTransactionStatus(orderId);

    if (transactionResponseModel.code == 200) {
      _logger.d(transactionResponseModel.model.toString());
    }
  }

  Future<bool> initiateTransactions(
      {double amount,
      AugmontRates augmontRates,
      String couponCode,
      bool restrictAppInvoke = false}) async {
    if (augmontRates == null) return false;

    double netTax = augmontRates.cgstPercent + augmontRates.sgstPercent;

    final augMap = {
      "aBlockId": augmontRates.blockId.toString(),
      "aLockPrice": augmontRates.goldBuyPrice,
      "aPaymode": "PYTM",
      "aGoldInTxn": _getGoldQuantityFromTaxedAmount(
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax)),
          augmontRates.goldBuyPrice),
      "aTaxedGoldBalance":
          BaseUtil.digitPrecision(amount - _getTaxOnAmount(amount, netTax))
    };

    final ApiResponse<CreatePaytmTransactionModel> paytmTransactionApiResponse =
        await _paytmRepo.createPaytmTransaction(amount, augMap, couponCode);

    if (paytmTransactionApiResponse.code == 400) {
      _logger.e(paytmTransactionApiResponse.errorMessage);
      return false;
    }

    final paytmTransactionModel = paytmTransactionApiResponse.model;

    try {
      _logger.d("Paytm order id: ${paytmTransactionModel.data.orderId}");
      final response = await AllInOneSdk.startTransaction(
          mid,
          paytmTransactionModel.data.orderId,
          amount.toString(),
          paytmTransactionModel.data.temptoken,
          paytmTransactionModel.data.callbackUrl,
          isStaging,
          restrictAppInvoke);
      _logger.d("Paytm Response:${response.toString()}");

      //For debug mode to check transaction status from paytm.
      // validateTransaction(paytmTransactionModel.data.orderId);
      return true;
    } catch (onError) {
      if (onError is PlatformException) {
        _logger.e(onError.message + " \n  " + onError.details.toString());
      } else {
        _logger.e(onError.toString());
      }
      return false;
    }
  }
}
