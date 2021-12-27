import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/winnerbox.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class PrizePWin extends StatefulWidget {
  final Map<String, int> winningsMap;
  const PrizePWin({Key key, this.winningsMap}) : super(key: key);

  @override
  _PrizePWinState createState() => _PrizePWinState();
}

class _PrizePWinState extends State<PrizePWin> {
  double slothPos = 0, slothOpacity = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          slothOpacity = 1;
          slothPos = SizeConfig.screenWidth * 0.16;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Spacer(
              flex: 3,
            ),
            Text(
              locale.tParWinTitle,
              style: TextStyles.title1.bold,
            ),
            Spacer(),
            Container(
              height: SizeConfig.screenHeight / 2.5,
              width: SizeConfig.screenWidth,
              child: Stack(
                children: [
                  WinnerBox(
                    winningsmap: widget.winningsMap,
                  ),
                  // AnimatedPositioned(
                  //   child: AnimatedOpacity(
                  //     opacity: slothOpacity,
                  //     duration: Duration(seconds: 2),
                  //     child: Image.asset(
                  //       "images/Tambola/sloth.png",
                  //       height: SizeConfig.screenHeight / 3.5,
                  //       width: SizeConfig.screenWidth * 0.8,
                  //       fit: BoxFit.contain,
                  //     ),
                  //   ),
                  //   top: slothPos,
                  //   left: -20,
                  //   duration: Duration(seconds: 2),
                  // )
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                locale.tParWinsubtitle,
                textAlign: TextAlign.center,
                style: TextStyles.body2.bold.colour(UiConstants.tertiarySolid),
              ),
            ),
            Spacer(flex: 3),
            Container(
              width: SizeConfig.navBarWidth,
              child: FelloButtonLg(
                  color: UiConstants.tertiarySolid,
                  child: Text(
                    "Save",
                    style: TextStyles.body3.bold.colour(Colors.white),
                  ),
                  onPressed: () {
                    AppState.backButtonDispatcher.didPopRoute();
                    AppState.backButtonDispatcher.didPopRoute();
                    AppState.backButtonDispatcher.didPopRoute();
                    AppState.delegate.appState.setCurrentTabIndex = 0;
                  }),
            ),
            Spacer(
              flex: 3,
            )
          ],
        ),
      ),
    );
  }
}
