import 'dart:io';

import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/services.dart';
import 'package:upi_pay/upi_pay.dart';

class UpiUtils {
  static Future<List<ApplicationMeta>> getUpiApps() async {
    List<ApplicationMeta> upiApps = [];

    if (Platform.isAndroid) {
      final List<ApplicationMeta> allUpiApps =
          await UpiPay.getInstalledUpiApplications(
              statusType: UpiApplicationDiscoveryAppStatusType.all);
      if (FlavorConfig.isProduction()) {
        for (final app in allUpiApps) {
          if (app.upiApplication.appName == "Google Pay" ||
              app.upiApplication.appName == "PhonePe" ||
              app.upiApplication.appName == "Paytm") {
            upiApps.add(app);
          }
        }
      } else {
        upiApps = allUpiApps;
      }
    } else if (Platform.isIOS) {
      try {
        const platform = MethodChannel("methodChannel/deviceData");

        List<UpiApplication> applications = [
          UpiApplication.googlePay,
          UpiApplication.phonePe,
          UpiApplication.paytm,
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
