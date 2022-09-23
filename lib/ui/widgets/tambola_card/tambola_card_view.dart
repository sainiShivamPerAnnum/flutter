import 'dart:math';

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/current_picks.dart';
import 'package:felloapp/ui/pages/static/game_card_big.dart';
import 'package:felloapp/ui/widgets/tambola_card/tambola_card_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TambolaCard extends StatelessWidget {
  const TambolaCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<TambolaCardModel>(onModelReady: (model) {
      model.init();
    }, builder: (ctx, model, child) {
      return GestureDetector(
        onTap: () {
          Haptic.vibrate();
          AppState.delegate.parseRoute(
            Uri.parse(model.game.route),
          );
        },
        child: Container(
          margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
          padding: EdgeInsets.fromLTRB(
            SizeConfig.pageHorizontalMargins,
            SizeConfig.pageHorizontalMargins,
            SizeConfig.pageHorizontalMargins,
            SizeConfig.padding12,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: UiConstants.kSnackBarPositiveContentColor,
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.roundness24)),
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                Assets.tambolaCardAsset,
                width: SizeConfig.screenWidth * 0.5,
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.padding4, top: SizeConfig.padding4),
                    child: Text(
                      "Tambola",
                      style: TextStyles.rajdhaniEB.title50
                          .colour(UiConstants.kBlogCardRandomColor2),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.padding2, top: SizeConfig.padding2),
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
                "Play and Win rewards",
                style: TextStyles.sourceSans.body3.bold
                    .colour(UiConstants.kBlogCardRandomColor2),
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              (model.isForDemo)
                  ? CurrentPicks(
                      dailyPicksCount: model.dailyPicksCount,
                      todaysPicks: List.generate(model.dailyPicksCount,
                          (index) => Random().nextInt(90)),
                    )
                  : model.todaysPicks != null
                      ? CurrentPicks(
                          dailyPicksCount: model.dailyPicksCount,
                          todaysPicks: model.todaysPicks,
                        )
                      : CurrentPicks(
                          dailyPicksCount: model.dailyPicksCount,
                          todaysPicks: List.generate(
                              model.dailyPicksCount, (index) => 0),
                        ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              TextButton(
                  onPressed: () {
                    Haptic.vibrate();
                    AppState.delegate.parseRoute(
                      Uri.parse(model.game.route),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text(
                        "Next draw at 6 PM",
                        style: TextStyles.sourceSans.body3.colour(Colors.white),
                      ),
                      SvgPicture.asset(
                        Assets.chevRonRightArrow,
                        color: Colors.white,
                        width: SizeConfig.padding24,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      );
    });
  }
}
