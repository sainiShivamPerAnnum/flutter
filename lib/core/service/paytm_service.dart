import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class PaytmService {
  //Set mid and isStaging from flavor values.
  String mid = "";

  Future initiateTransactions(
      {String id,
      String orderId,
      String amount,
      String txnToken,
      bool isStaging,
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
