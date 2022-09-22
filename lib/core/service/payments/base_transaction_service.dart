import 'dart:io';

import 'package:felloapp/core/base_remote_config.dart';

mixin BaseTransactionService {
  String getPaymentMode() {
    String paymentMode = "PAYTM-PG";
    if (Platform.isAndroid)
      paymentMode = BaseRemoteConfig.remoteConfig
          .getString(BaseRemoteConfig.ACTIVE_PG_ANDROID);
    else if (Platform.isIOS)
      paymentMode = BaseRemoteConfig.remoteConfig
          .getString(BaseRemoteConfig.ACTIVE_PG_IOS);

    return paymentMode;
  }
}
