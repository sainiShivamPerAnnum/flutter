import 'package:felloapp/core/enums/paytm_service_enums.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class AutosaveStatusText extends StatelessWidget {
  const AutosaveStatusText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<PaytmService, PaytmServiceProperties>(
      builder: (context, model, property) => Container(
        child: model!.activeSubscription != null &&
                model.activeSubscription!.status == Constants.SUBSCRIPTION_ACTIVE
            ? Text(
                "ACTIVE SIP",
                style:
                    TextStyles.rajdhaniB.body4.colour(UiConstants.primaryColor),
              )
            : SizedBox(),
      ),
    );
  }
}
