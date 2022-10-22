import 'dart:math';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/current_picks.dart';
import 'package:felloapp/ui/pages/static/game_card_big.dart';
import 'package:felloapp/ui/widgets/tambola_card/tambola_card_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TambolaCard extends StatelessWidget {
  const TambolaCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _analyticsService = locator<AnalyticsService>();
    return BaseView<TambolaCardModel>(onModelReady: (model) {
      model.init();
    }, builder: (ctx, model, child) {
      return GestureDetector(
        onTap: () {
          Haptic.vibrate();
          _analyticsService.track(eventName: AnalyticsEvents.tambolaGameCard);
          AppState.delegate.parseRoute(
            Uri.parse(model.game.route),
          );
        },
        child: Container(
          height: SizeConfig.screenWidth * 0.94,
          margin: EdgeInsets.only(
              right: SizeConfig.pageHorizontalMargins,
              top: SizeConfig.pageHorizontalMargins / 2,
              bottom: SizeConfig.pageHorizontalMargins,
              left: SizeConfig.pageHorizontalMargins),
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
          decoration: BoxDecoration(
            color: UiConstants.kSnackBarPositiveContentColor,
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.roundness24)),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      Assets.tambolaCardAsset,
                      width: SizeConfig.screenWidth * 0.5,
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.padding2,
                              top: SizeConfig.padding3),
                          child: Text(
                            "Tambola",
                            style: TextStyles.rajdhaniEB.title50
                                .colour(UiConstants.kBlogCardRandomColor2),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.padding1,
                              top: SizeConfig.padding2),
                          child: Text(
                            "Tambola",
                            style: TextStyles.rajdhaniEB.title50
                                .colour(UiConstants.kTambolaMidTextColor),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Tambola",
                            style: TextStyles.rajdhaniEB.title50
                                .colour(UiConstants.kWinnerPlayerPrimaryColor),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Win ₹1 Crore!",
                      style: TextStyles.sourceSans.body1.bold
                          .colour(UiConstants.kWinnerPlayerLightPrimaryColor),
                    ),
                    SizedBox(
                      height: SizeConfig.padding20,
                    ),
                    SizedBox(
                      child: CurrentPicks(
                        dailyPicksCount: model.dailyPicksCount ?? 3,
                        todaysPicks: model.todaysPicks != null
                            ? model.todaysPicks
                            : List.generate(
                                model.dailyPicksCount ?? 3,
                                (index) => 0,
                              ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.padding20),
                      child: Text(
                        "Next draws at 6 PM",
                        style: TextStyles.sourceSans.body3.colour(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.padding16),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white, width: 1),
                        shape: BoxShape.circle,
                      ),
                      height: SizeConfig.avatarRadius * 2,
                      width: SizeConfig.avatarRadius * 2,
                      padding: EdgeInsets.all(SizeConfig.padding4),
                      child: GestureDetector(
                        onTap: () {
                          Haptic.vibrate();
                          print(model.game.route);
                          AppState.delegate.parseRoute(
                            Uri.parse(model.game.route),
                          );
                        },
                        child: SvgPicture.asset(
                          Assets.chevRonRightArrow,
                          color: Colors.white,
                          width: SizeConfig.padding24,
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
