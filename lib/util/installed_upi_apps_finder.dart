import 'dart:io';

import 'package:flutter/services.dart';
import 'package:upi_pay/upi_pay.dart';

class UpiUtils {
  static Future<List<ApplicationMeta>> getUpiApps() async {
    List<ApplicationMeta> upiApps = [];

    if (Platform.isAndroid) {
      upiApps = await UpiPay.getInstalledUpiApplications(
          statusType: UpiApplicationDiscoveryAppStatusType.all);
    } else if (Platform.isIOS) {
      try {
        const platform = MethodChannel("methodChannel/deviceData");

        List<UpiApplication> applications = [
          UpiApplication.airtel,
          // UpiApplication.amazonPay,
          UpiApplication.googlePay,
          UpiApplication.cred,
          UpiApplication.phonePe,
          UpiApplication.phonePePreprod,
          UpiApplication.paytm,
          UpiApplication.whatsApp,
          // UpiApplication.myJio
        ];
        for (final element in applications) {
          final result = await platform.invokeMethod('isAppInstalled',
              {"appName": element.discoveryCustomScheme?.toLowerCase()});
          if (result) {
            upiApps.add(ApplicationMeta.ios(element));
          }
        }
      } catch (e) {
        upiApps = [];
      }
    }

    return upiApps;
  }
}
