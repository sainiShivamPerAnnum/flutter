import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loser extends StatelessWidget {
  const Loser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SvgPicture.asset(
              Assets.noWinnersAsset,
              width: SizeConfig.screenWidth! * 0.4,
            ),
            SizedBox(
              height: SizeConfig.padding54,
            ),
            Flexible(
              child: Text(
                'Your last week tickets did not win',
                style:
                    TextStyles.rajdhaniB.title3.colour(Colors.white).copyWith(),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding20,
              ),
              child: Text(
                  "None of your tickets matched this time.\nSave & get tickets for the coming week!",
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.kFAQsAnswerColor)),
            ),
            const Spacer(
              flex: 3,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.pageHorizontalMargins),
              width: SizeConfig.navBarWidth,
              child: const AppPositiveBtn(
                  btnText: 'GET MORE TICKETS',
                  onPressed: BaseUtil.openDepositOptionsModalSheet),
            ),
          ],
        ),
      ),
    );
  }
}
