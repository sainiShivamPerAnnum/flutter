import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_title.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameTitleWithSubTitle(
          title: "Game of the week",
          subtitle: "Win upto ${model?.gow?.prizeAmount}",
        ),
        (model.isGamesListDataLoading)
            ? GameCardShimmer()
            : (model.gow == null
                ? SizedBox
                : GestureDetector(
                    onTap: () {
                      Haptic.vibrate();
                      AppState.delegate.parseRoute(
                        Uri.parse(model.gow.route),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins,
                          vertical: SizeConfig.padding16),
                      width: double.infinity,
                      height: SizeConfig.screenWidth * 0.456,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.roundness16)),
                        child: SvgPicture.network(
                          model.gow.thumbnailUri,
                          width: double.maxFinite,
                          height: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
      ],
    );
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
