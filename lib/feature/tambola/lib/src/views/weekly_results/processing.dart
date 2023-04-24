import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class PrizeProcessing extends StatelessWidget {
  const PrizeProcessing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context)!;
    return SafeArea(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            const FullScreenLoader(),
            SizedBox(
              height: SizeConfig.padding24,
            ),
            Text(
              "Prize Day",
              style: TextStyles.rajdhaniB.bold.title1.colour(Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "We are processing your tickets to see if any of your tickets has won a category..",
                textAlign: TextAlign.center,
                style: TextStyles.body3.colour(Colors.white),
              ),
            ),
            const Spacer(
              flex: 2,
            )
          ],
        ),
      ),
    );
  }
}
