import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PrizeProcessing extends StatelessWidget {
  const PrizeProcessing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 1,
            ),
            Text(
              locale.tProcessingTitle,
              style: TextStyles.title1.bold,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                locale.tProcessingSubtitle,
                textAlign: TextAlign.center,
                style: TextStyles.body3.letterSpace(2),
              ),
            ),
            LottieBuilder.asset(
              "images/Tambola/process.json",
              width: SizeConfig.screenWidth * 0.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "PROCESSING...",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: UiConstants.primaryColor,
                    fontSize: SizeConfig.largeTextSize,
                    height: 1.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 5),
              ),
            ),
            Spacer(
              flex: 2,
            )
          ],
        ),
      ),
    );
  }
}
