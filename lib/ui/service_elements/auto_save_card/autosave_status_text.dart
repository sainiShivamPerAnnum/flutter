import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutosaveStatusText extends StatelessWidget {
  const AutosaveStatusText({required this.asset, Key? key}) : super(key: key);
  final String asset;
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Consumer<SubService>(
      builder: (context, model, property) => Container(
        child: ((asset == "Digital Gold" &&
                    (model.subscriptionData != null &&
                        model.subscriptionData!.status ==
                            Constants.SUBSCRIPTION_ACTIVE &&
                        (model.subscriptionData!.augAmt ?? '0') != '0')) ||
                (asset == "Fello Flo" &&
                    (model.subscriptionData != null &&
                        model.subscriptionData!.status ==
                            Constants.SUBSCRIPTION_ACTIVE &&
                        (model.subscriptionData!.lbAmt ?? '0') != '0')))
            ? Text(
                locale.autoSIP,
                style:
                    TextStyles.rajdhaniB.body4.colour(UiConstants.primaryColor),
              )
            : const SizedBox(),
      ),
    );
  }
}
