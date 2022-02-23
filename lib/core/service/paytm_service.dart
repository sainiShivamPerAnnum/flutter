import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
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

  Future initiateTransactions(
      {double amount, bool restrictAppInvoke = false}) async {
    var result;

    final ApiResponse<CreatePaytmTransactionModel> paytmTransactionApiResponse =
        await _paytmRepo.createPaytmTransaction(amount);

    if (paytmTransactionApiResponse.code == 400) {
      _logger.e(paytmTransactionApiResponse.errorMessage);
      return;
    }

    final paytmTransactionModel = paytmTransactionApiResponse.model;

    try {
      final response = await AllInOneSdk.startTransaction(
          mid,
          paytmTransactionModel.data.orderId,
          amount.toString(),
          paytmTransactionModel.data.temptoken,
          paytmTransactionModel.data.callbackUrl,
          isStaging,
          restrictAppInvoke);
      _logger.d("Paytm Response:${response.toString()}");
      result = response.toString();
    } catch (onError) {
      if (onError is PlatformException) {
        result = onError.message + " \n  " + onError.details.toString();
      } else {
        result = onError.toString();
      }
    }

    return result;
  }
}
