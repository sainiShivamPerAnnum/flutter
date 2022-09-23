import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/gameRewards.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_title.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GameTitleWithSubTitle(
            title: "Your favorites",
            subtitle:
                "Play using fello tokens. Money from savings will not be deducted"),
        Container(
          height: SizeConfig.screenWidth * 0.6,
          width: SizeConfig.screenWidth,
          margin:
              EdgeInsets.symmetric(vertical: SizeConfig.pageHorizontalMargins),
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
        ),
      ],
    );
  }
}

class TrendingGames extends StatelessWidget {
  final GameModel game;
  const TrendingGames({
    this.game,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Haptic.vibrate();
        AppState.delegate.parseRoute(
          Uri.parse(game.route),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: SizeConfig.padding20),
        width: SizeConfig.screenWidth * 0.32,
        padding: EdgeInsets.all(SizeConfig.padding12),
        decoration: BoxDecoration(
            color: UiConstants.kSecondaryBackgroundColor,
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.roundness112))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipOval(
              child: SvgPicture.network(
                game.icon,
                fit: BoxFit.cover,
                width: SizeConfig.screenWidth * 0.32,
              ),
            ),
            Text(
              game.gameName,
              textAlign: TextAlign.center,
              style: TextStyles.sourceSans.body1.colour(Colors.white),
            ),
            SizedBox(height: SizeConfig.padding12),
            Column(
              children: [
                SvgPicture.asset(
                  Assets.aFelloToken,
                  height: SizeConfig.padding20,
                ),
                SizedBox(height: SizeConfig.padding6),
                Text(
                  game.playCost.toString(),
                  style: TextStyles.sourceSans.body2.colour(Colors.white),
                )
              ],
            ),
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
      margin: EdgeInsets.only(right: SizeConfig.padding20),
      width: SizeConfig.screenWidth * 0.32,
      padding: EdgeInsets.all(SizeConfig.padding12),
      decoration: BoxDecoration(
          color: UiConstants.kSecondaryBackgroundColor,
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConfig.roundness112))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        child: Shimmer.fromColors(
          baseColor: UiConstants.kUserRankBackgroundColor,
          highlightColor: UiConstants.kBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: SizeConfig.screenWidth * 0.23,
                width: SizeConfig.screenWidth * 0.23,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade600,
                ),
              ),
              Container(
                height: SizeConfig.padding14,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                ),
              ),
              Column(
                children: [
                  Container(
                    height: SizeConfig.padding20,
                    width: SizeConfig.padding20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding6),
                  Container(
                    height: SizeConfig.padding14,
                    width: SizeConfig.padding24,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
