import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SubProcessText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SubService>(
      builder: (context, model, property) => Container(
        height: SizeConfig.padding64,
        child: Column(
          children: [
            SpinKitWave(
              color: UiConstants.primaryColor,
              size: SizeConfig.padding24,
            ),
            SizedBox(height: SizeConfig.padding4),
            Text(
              "",
              style: TextStyles.rajdhaniSB.body3,
            ),
          ],
        ),
      ),
    );
  }
}
