import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
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
            SvgPicture.asset(
              Assets.noWinnersAsset,
              width: SizeConfig.screenWidth * 0.4,
            ),
            SizedBox(
              height: SizeConfig.padding54,
            ),
            Text(
              "Better luck next time!",
              style: TextStyles.rajdhaniB.title3.colour(Colors.white),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding20,
              ),
              child: Text(
                  "None of your tickets matched this time.\nSave & get Tambola tickets for the coming week!",
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.kFAQsAnswerColor)),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.pageHorizontalMargins),
              width: SizeConfig.navBarWidth,
              child: AppPositiveBtn(
                  btnText: "SAVE MORE",
                  onPressed: () {
                    AppState.backButtonDispatcher.didPopRoute();
                    AppState.backButtonDispatcher.didPopRoute();
                    AppState.backButtonDispatcher.didPopRoute();
                    AppState.delegate.appState.setCurrentTabIndex = 0;
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
