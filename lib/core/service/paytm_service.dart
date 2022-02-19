import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/util/credentials_stage.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class PaytmService {
  final String devMid = "qpHRfp13374268724583";
  final String prodMid = "CMTNKX90967647249644";
  String mid;
  bool isStaging;

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
      {String id,
      String orderId,
      String amount,
      String txnToken,
      bool restrictAppInvoke}) async {
    var result;

    try {
      final response = await AllInOneSdk.startTransaction(
          mid, orderId, amount, txnToken, null, isStaging, restrictAppInvoke);
      print(response);
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
