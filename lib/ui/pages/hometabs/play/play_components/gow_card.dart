import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_title.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/widgets/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class GOWCard extends StatelessWidget {
  final PlayViewModel model;
  const GOWCard({
    @required this.model,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (model.isGamesListDataLoading)
        ? GameCardShimmer()
        : (model.gow == null
            ? SizedBox
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleSubtitleContainer(
                    title: "Game of the week",
                    subTitle: "Win upto ${model.gow?.prizeAmount ?? 25000}",
                  ),
                  GestureDetector(
                    onTap: () {
                      Haptic.vibrate();
                      AppState.delegate.parseRoute(
                        Uri.parse(model.gow.route),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: model.gow.shadowColor,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness12)),
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins,
                          vertical: SizeConfig.padding16),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      width: double.infinity,
                      height: SizeConfig.screenWidth * 0.456,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(model.gow.gameName.split(' ').first,
                                    style: TextStyles.rajdhaniB.title1),
                                Text(model.gow.gameName.split(' ').last,
                                    style: TextStyles.rajdhaniSB.title3),
                                SizedBox(height: SizeConfig.padding16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      Assets.token,
                                      height: SizeConfig.padding20,
                                      width: SizeConfig.padding20,
                                    ),
                                    SizedBox(width: SizeConfig.padding4),
                                    Text(model.gow.playCost.toString(),
                                        style: TextStyles.sourceSans.body1),
                                  ],
                                ),
                              ]),
                          Expanded(
                            child: SvgPicture.network(model.gow.icon,
                                fit: BoxFit.cover,
                                height: SizeConfig.screenWidth * 0.5,
                                width: SizeConfig.screenWidth * 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }
}

class GameCardShimmer extends StatelessWidget {
  const GameCardShimmer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: UiConstants.kUserRankBackgroundColor,
      highlightColor: UiConstants.kBackgroundColor,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding24,
          vertical: SizeConfig.padding12,
        ),
        height: SizeConfig.screenWidth * 0.456,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: UiConstants.gameCardColor,
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConfig.roundness16)),
        ),
      ),
    );
  }
}
