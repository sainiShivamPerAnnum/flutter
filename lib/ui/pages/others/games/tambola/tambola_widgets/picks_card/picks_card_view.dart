import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/tambola-global/weekly_picks.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/current_picks.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/tambola_appBar.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PicksCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<PicksCardViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => GestureDetector(
        onTap: model.onTap,
        child: AnimatedContainer(
          width: SizeConfig.screenWidth,
          height: model.topCardHeight,
          duration: Duration(seconds: 1),
          curve: Curves.ease,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/Tambola/tranbg.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
              color: UiConstants.primaryColor),
          margin: EdgeInsets.all(SizeConfig.globalMargin),
          child: Column(
            children: [
              TambolaAppBar(),
              !model.isShowingAllPicks
                  ? TambolaTitle(titleOpacity: model.titleOpacity)
                  : SizedBox(),
              model.isShowingAllPicks
                  ? Text(
                      "Weekly Picks",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: SizeConfig.cardTitleTextSize,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : (model.todaysPicks != null && model.todaysPicks.isNotEmpty
                      ? Text(
                          "Today's Picks",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: SizeConfig.cardTitleTextSize,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          "Today's picks will be drawn at 6 pm.",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: SizeConfig.mediumTextSize,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
              !model.isShowingAllPicks
                  ? CurrentPicks(
                      dailyPicksCount: model.dailyPicksCount,
                      todaysPicks: model.todaysPicks,
                    )
                  : WeeklyPicks(
                      weeklyDraws: model.weeklyDigits,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class TambolaTitle extends StatelessWidget {
  const TambolaTitle({
    Key key,
    @required this.titleOpacity,
  }) : super(key: key);

  final double titleOpacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: titleOpacity,
      duration: Duration(seconds: 1),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              "TAMBOLA",
              style: GoogleFonts.montserrat(
                // fontFamily: "Cucciolo",
                color: Colors.white,
                fontSize: SizeConfig.cardTitleTextSize * 1.6,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                shadows: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(1, 1),
                      blurRadius: 5,
                      spreadRadius: 5)
                ],
              ),
            ),
            // Text(
            //   "[ GLOBAL ]",
            //   style: GoogleFonts.montserrat(
            //     color: Colors.white,
            //     fontSize: 12,
            //     letterSpacing: 5,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
