import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

import 'winnerbox.dart';

class PrizePWin extends StatefulWidget {
  final Winners winner;
  final bool isEligible;
  const PrizePWin({required this.winner, required this.isEligible, Key? key})
      : super(key: key);

  @override
  _PrizePWinState createState() => _PrizePWinState();
}

class _PrizePWinState extends State<PrizePWin> {
  double slothPos = 0, slothOpacity = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          slothOpacity = 1;
          slothPos = SizeConfig.screenWidth! * 0.16;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context)!;
    return SafeArea(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        child: Column(
          children: [
            const Spacer(
              flex: 3,
            ),
            Text(
              "Tambola Results",
              style: TextStyles.title1.bold,
            ),
            const Spacer(),
            SizedBox(
              height: SizeConfig.screenHeight! / 2.5,
              width: SizeConfig.screenWidth,
              child: Stack(
                children: [
                  WinnerBox(
                    winner: widget.winner,
                    tPrize: null,
                    isEligible: widget.isEligible,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "Only users with minimum savings balance of ₹ 100 are eliglble for prizes",
                textAlign: TextAlign.center,
                style: TextStyles.body2.bold.colour(UiConstants.tertiarySolid),
              ),
            ),
            const Spacer(flex: 3),
            SizedBox(
              width: SizeConfig.navBarWidth,
              child: FelloButtonLg(
                  color: UiConstants.tertiarySolid,
                  child: Text(
                    "Save",
                    style: TextStyles.body3.bold.colour(Colors.white),
                  ),
                  onPressed: () {
                    while (AppState.screenStack.length > 1) {
                      AppState.backButtonDispatcher!.didPopRoute();
                    }
                    AppState.delegate!.appState.setCurrentTabIndex = 0;
                  }),
            ),
            const Spacer(
              flex: 3,
            )
          ],
        ),
      ),
    );
  }
}
