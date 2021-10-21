import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/tambola-global/weekly_picks.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/current_picks.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PicksCardView extends StatelessWidget {
  final ValueChanged<bool> showBuyTicketModal;
  PicksCardView({this.showBuyTicketModal});
  @override
  Widget build(BuildContext context) {
    return BaseView<PicksCardViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => GestureDetector(
        onTap: () => model.onTap(showBuyTicketModal),
        child: AnimatedContainer(
          width: SizeConfig.screenWidth,
          height: model.topCardHeight,
          duration: Duration(seconds: 1),
          curve: Curves.ease,
          decoration: BoxDecoration(),
          margin: EdgeInsets.all(
            SizeConfig.pageHorizontalMargins,
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                heightFactor: 0.8,
                alignment: Alignment.topCenter,
                widthFactor: 1,
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.ease,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness32),
                    color: UiConstants.primaryColor,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: SvgPicture.asset(
                  Assets.dailyPickCard,
                  width: SizeConfig.screenWidth -
                      SizeConfig.pageHorizontalMargins * 2,
                ),
              ),
              AnimatedContainer(
                width: SizeConfig.screenWidth,
                height: model.topCardHeight,
                duration: Duration(seconds: 1),
                curve: Curves.ease,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (model.isShowingAllPicks)
                      SizedBox(
                        height: SizeConfig.screenWidth * 0.04,
                      ),
                    model.isShowingAllPicks
                        ? Text(
                            "Weekly Picks",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: SizeConfig.cardTitleTextSize,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : (model.todaysPicks != null &&
                                model.todaysPicks.isNotEmpty
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
                    SizedBox(height: SizeConfig.padding12),
                    !model.isShowingAllPicks
                        ? CurrentPicks(
                            dailyPicksCount: model.dailyPicksCount,
                            todaysPicks: model.todaysPicks,
                          )
                        : WeeklyPicks(
                            weeklyDraws: model.weeklyDigits,
                          ),
                    if (!model.isShowingAllPicks)
                      SizedBox(
                        height: SizeConfig.screenWidth * 0.04,
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
