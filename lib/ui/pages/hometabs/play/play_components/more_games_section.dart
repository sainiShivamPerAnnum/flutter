import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/game_model4.0.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/gameRewards.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/widgets/button4.0/appBar_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class MoreGamesSection extends StatelessWidget {
  final PlayViewModel model;
  const MoreGamesSection({
    @required this.model,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        model.isTrendingCount == 0 ? 3 : model.isTrendingCount,
        (index) {
          return model.isGamesListDataLoading
              ? MoreGamesShimmer()
              : MoreGames(
                  game: model.gamesListData[index],
                );
        },
      ),
    );
  }
}

class MoreGames extends StatelessWidget {
  final GameData game;

  const MoreGames({
    this.game,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Haptic.vibrate();
        AppState.delegate.parseRoute(
          Uri.parse(game.route),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          left: SizeConfig.padding24,
          right: SizeConfig.padding24,
          bottom: SizeConfig.padding12,
        ),
        height: SizeConfig.screenWidth * 0.218,
        width: SizeConfig.screenWidth * 0.901,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.padding8,
                right: SizeConfig.padding12,
              ),
              child: Container(
                height: SizeConfig.screenWidth * 0.170,
                width: SizeConfig.screenWidth * 0.170,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(game.thumbnailUri),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.gameName,
                  style: TextStyles.rajdhaniSB.body2,
                ),
                SizedBox(height: SizeConfig.padding4),
               GameRewards(prizeAmount: game.prizeAmount),
              ],
            ),
            Spacer(),
            AppBarButton(
              svgAsset: Assets.aFelloToken,
              coin: game.playCost.toString(),
              borderColor: Colors.transparent,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class MoreGamesShimmer extends StatelessWidget {
  const MoreGamesShimmer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.padding16),
      height: SizeConfig.screenWidth * 0.218,
      width: SizeConfig.screenWidth * 0.901,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        child: Shimmer.fromColors(
          baseColor: UiConstants.kUserRankBackgroundColor,
          highlightColor: UiConstants.kBackgroundColor,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
                child: Container(
                  width: SizeConfig.screenWidth * 0.16,
                  height: SizeConfig.screenWidth * 0.16,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness5),
                    ),
                    width: SizeConfig.screenWidth * 0.213,
                    height: SizeConfig.screenWidth * 0.053,
                  ),
                  Container(
                    width: SizeConfig.screenWidth * 0.266,
                    height: SizeConfig.screenWidth * 0.026,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness5),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
                child: Container(
                  width: SizeConfig.screenWidth * 0.106,
                  height: SizeConfig.screenWidth * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
