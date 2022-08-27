import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/gameRewards.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GOWCard extends StatelessWidget {
  final PlayViewModel model;
  const GOWCard({
    @required this.model,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return model.isGamesListDataLoading
        ? GameCardShimmer()
        : (model.gow == null
            ? SizedBox
            : InkWell(
                onTap: () {
                  Haptic.vibrate();
                  AppState.delegate.parseRoute(
                    Uri.parse(model.gow.route),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.padding16,
                    left: SizeConfig.padding24,
                    right: SizeConfig.padding24,
                    bottom: SizeConfig.padding35,
                  ),
                  height: SizeConfig.screenWidth * 0.688,
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  ),
                  child: Column(
                    children: [
                      // Hero(
                      //   tag: model.gow.code,
                      // child:
                      Container(
                        height: SizeConfig.screenWidth * 0.474,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  model.gow.thumbnailUri),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.roundness12),
                            topRight: Radius.circular(SizeConfig.roundness12),
                          ),
                        ),
                      ),
                      // ),
                      Container(
                        height: SizeConfig.screenWidth * 0.213,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          color: UiConstants.gameCardColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(SizeConfig.roundness8),
                            bottomRight: Radius.circular(SizeConfig.roundness8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding16),
                              child: Container(
                                height: SizeConfig.screenWidth * 0.117,
                                width: SizeConfig.screenWidth * 0.117,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness8),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          model.gow.thumbnailUri),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.gow.gameName, // 'Cricket',
                                  style: TextStyles.rajdhaniSB.title5,
                                ),
                                GameRewards(prizeAmount: model.gow.prizeAmount),
                              ],
                            ),
                            Spacer(),
                            AppBarButton(
                              svgAsset: Assets.aFelloToken,
                              size: SizeConfig.padding28,
                              coin: model.gow.playCost.toString(),
                              borderColor: Colors.transparent,
                              onTap: () {},
                              style: TextStyles.sourceSansSB.title4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}

class GameCardShimmer extends StatelessWidget {
  const GameCardShimmer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding24,
        vertical: SizeConfig.padding12,
      ),
      height: SizeConfig.screenWidth * 0.688,
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: UiConstants.gameCardColor,
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        child: Shimmer.fromColors(
          baseColor: UiConstants.kUserRankBackgroundColor,
          highlightColor: UiConstants.kBackgroundColor,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(SizeConfig.padding16),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.screenWidth * 0.400,
                width: SizeConfig.screenWidth,
              ),
              //
              Container(
                margin: EdgeInsets.all(SizeConfig.padding16),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.screenWidth * 0.120,
                width: SizeConfig.screenWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
