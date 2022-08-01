import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/game_model4.0.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/gameRewards.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class TrendingGamesSection extends StatelessWidget {
  final PlayViewModel model;

  const TrendingGamesSection({
    @required this.model,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenWidth * 0.536,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: SizeConfig.padding35),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: model.isGamesListDataLoading
            ? 3
            : model.trendingGamesListData.length,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
        itemBuilder: (ctx, index) {
          return model.isGamesListDataLoading
              ? TrendingGamesShimmer()
              : TrendingGames(
                  game: model.trendingGamesListData[index],
                );
        },
      ),
    );
  }
}

class TrendingGames extends StatelessWidget {
  final GameDataModel game;
  const TrendingGames({
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
        margin: EdgeInsets.only(right: SizeConfig.padding16),
        height: SizeConfig.screenWidth * 0.536,
        width: SizeConfig.screenWidth * 0.610,
        decoration: BoxDecoration(
          color: Color(0xff39393C),
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(SizeConfig.padding6),
              height: SizeConfig.screenWidth * 0.314,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness8),
                  topRight: Radius.circular(SizeConfig.roundness8),
                ),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(game.thumbnailUri),
                    fit: BoxFit.cover),
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.padding8,
                        top: SizeConfig.padding6,
                        bottom: SizeConfig.padding16,
                      ),
                      child: Text(
                        game.gameName,
                        style: TextStyles.rajdhaniSB.body2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: SizeConfig.padding8),
                      child: GameRewards(prizeAmount: game.prizeAmount),
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: SizeConfig.padding12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            Assets.aFelloToken,
                            height: SizeConfig.padding16,
                          ),
                          SizedBox(width: SizeConfig.padding2),
                          Text(
                            game.playCost.toString(),
                            style: TextStyles.sourceSansSB.body2,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TrendingGamesShimmer extends StatelessWidget {
  const TrendingGamesShimmer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: SizeConfig.padding16),
      height: SizeConfig.screenWidth * 0.688,
      width: SizeConfig.screenWidth * 0.610,
      decoration: BoxDecoration(
        color: Color(0xff39393C),
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
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.screenWidth * 0.300,
                width: SizeConfig.screenWidth * 0.610,
              ),
              //
              Container(
                margin: EdgeInsets.all(SizeConfig.padding16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                ),
                height: SizeConfig.screenWidth * 0.07,
                width: SizeConfig.screenWidth * 0.610,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
