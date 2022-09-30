import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class PrizeProcessing extends StatelessWidget {
  const PrizeProcessing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return SafeArea(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 1,
            ),
            FullScreenLoader(size: SizeConfig.padding64),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            Text(
              locale.tProcessingTitle,
              style: TextStyles.rajdhaniB.bold.title1.colour(Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                locale.tProcessingSubtitle,
                textAlign: TextAlign.center,
                style: TextStyles.body3.colour(Colors.white),
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
