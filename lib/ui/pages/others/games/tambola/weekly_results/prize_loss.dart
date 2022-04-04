import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loser extends StatelessWidget {
  const Loser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return SafeArea(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Spacer(),
            Text(
              locale.tLossTitle,
              style: TextStyles.title1.bold,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                locale.tLossSubtitle,
                textAlign: TextAlign.center,
                style: TextStyles.title2.bold.colour(UiConstants.tertiarySolid),
              ),
            ),
            Spacer(),
            SvgPicture.asset(
              "assets/vectors/broken_piggy_bank.svg",
              width: SizeConfig.screenWidth * 0.8,
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: SizeConfig.blockSizeHorizontal * 5),
              child: Text(locale.tLossSubtitle2,
                  textAlign: TextAlign.center, style: TextStyles.body3),
            ),
            Column(
              children: [
                Container(
                  width: SizeConfig.screenWidth,
                  child: FelloButtonLg(
                    child: Text(
                      "Buy Tickets",
                      style: TextStyles.body3.bold.colour(Colors.white),
                    ),
                    onPressed: () {
                      AppState.backButtonDispatcher.didPopRoute();
                    },
                  ),
                ),
                SizedBox(height: SizeConfig.padding12),
                Container(
                  width: SizeConfig.navBarWidth,
                  child: FelloButtonLg(
                      color: UiConstants.tertiarySolid,
                      child: Text(
                        "Save More Money",
                        style: TextStyles.body3.bold.colour(Colors.white),
                      ),
                      onPressed: () {
                        AppState.backButtonDispatcher.didPopRoute();
                        AppState.backButtonDispatcher.didPopRoute();
                        AppState.backButtonDispatcher.didPopRoute();
                        AppState.delegate.appState.setCurrentTabIndex = 0;
                      }),
                ),
              ],
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
