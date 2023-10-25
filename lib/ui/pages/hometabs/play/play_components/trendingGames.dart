import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/game_stats_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/pages/static/sticky_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class TrendingGamesSection extends StatelessWidget {
  final PlayViewModel model;

  const TrendingGamesSection({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = locator<S>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSubtitleContainer(
          title: locale.allgames,
        ),
        SizedBox(
          height: SizeConfig.padding12,
        ),
        Center(
          child: StickyNote(
            trailingWidget: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: SizeConfig.padding16,
                ),
                SvgPicture.asset(
                  Assets.token,
                  height: SizeConfig.padding20,
                ),
                SizedBox(
                  width: SizeConfig.padding4,
                ),
                Text("1", style: TextStyles.sourceSansB.title3),
                SizedBox(
                  width: SizeConfig.padding8,
                ),
                Text(
                  "Gaming Token",
                  style: TextStyles.sourceSansSB.body4,
                )
              ],
            ),
            amount: "1",
          ),
        ),
        SizedBox(
          height: SizeConfig.padding12,
        ),
        Container(
          width: SizeConfig.screenWidth,
          margin: EdgeInsets.symmetric(
              vertical: SizeConfig.pageHorizontalMargins / 2),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: model.isGamesListDataLoading
                ? 3
                : model.trendingGamesListData.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
            itemBuilder: (ctx, index) {
              return model.isGamesListDataLoading
                  ? const TrendingGamesShimmer()
                  : TrendingGames(
                      game: model.trendingGamesListData[index],
                      model: model,
                      key: ValueKey(model.trendingGamesListData[index].code));
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: .63,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12),
          ),
        ),
      ],
    );
  }
}

class TrendingGames extends StatelessWidget {
  final GameModel? game;
  final PlayViewModel model;
  const TrendingGames({
    required this.model,
    this.game,
    Key? key,
  });

  Gm? getGameInfo(String gameCode) {
    switch (gameCode) {
      case "GM_CRICKET_HERO":
        return model.gameStats?.data?.gmCricketHero;

      case "GM_FOOTBALL_KICKOFF":
        return model.gameStats?.data?.gmFootballKickoff;

      case "GM_CANDY_FIESTA":
        return model.gameStats?.data?.gmCandyFiesta;

      case "GM_ROLLY_VORTEX":
        return model.gameStats?.data?.gmRallyVertex;
      case "GM_POOL_CLUB":
        return model.gameStats?.data?.gmPoolClub;
      case "GM_KNIFE_HIT":
        return model.gameStats?.data?.gmKnifeHit;
      case "GM_BOWLING":
        return model.gameStats?.data?.gmBowling;
      case "GM_BOTTLE_FLIP":
        return model.gameStats?.data?.gmBottleFlip;

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    final AnalyticsService _analyticsService = locator<AnalyticsService>();
    return GestureDetector(
      onTap: () {
        Haptic.vibrate();
        _analyticsService.track(
            eventName: AnalyticsEvents.gameTapped,
            properties:
                AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
              'Game name': game!.gameName,
              "Entry fee": game!.playCost,
              "Win upto": game!.prizeAmount,
              "Time left for draw Tambola (mins)":
                  AnalyticsProperties.getTimeLeftForTambolaDraw(),
              "Tambola Tickets Owned":
                  AnalyticsProperties.getTambolaTicketCount(),
              "location": "Trending games"
            }));

        BaseUtil.openGameModalSheet(game!.gameCode!);
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Color(0xff39393C),
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.padding4),
            SvgPicture.network(
              game!.icon!,
              fit: BoxFit.cover,
              width: SizeConfig.screenWidth! * 0.2,
              height: SizeConfig.screenWidth! * 0.2,
            ),
            Text(
              game!.gameName!,
              textAlign: TextAlign.center,
              style: TextStyles.sourceSans.body3.colour(Colors.white),
            ),
            SizedBox(height: SizeConfig.padding4),

            // SizedBox(height: SizeConfig.padding10),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding10, vertical: 4),
              decoration: BoxDecoration(
                color: UiConstants.kBackgroundColor,
                border: Border.all(color: UiConstants.kTextColor2),
                borderRadius: BorderRadius.circular(SizeConfig.padding8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "PLAY  ",
                    style: TextStyles.sourceSans.body3.colour(Colors.white),
                  ),
                  SvgPicture.asset(
                    Assets.token,
                    height: SizeConfig.padding12,
                    width: SizeConfig.padding12,
                  ),
                  Text(" ${game!.playCost}",
                      style: TextStyles.sourceSans.body3),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.padding10),
          ],
        ),
      ),
    );
  }
}

class TrendingGamesShimmer extends StatelessWidget {
  const TrendingGamesShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: SizeConfig.padding20),
      width: SizeConfig.screenWidth! * 0.32,
      padding: EdgeInsets.all(SizeConfig.padding12),
      decoration: BoxDecoration(
          color: UiConstants.kSecondaryBackgroundColor,
          borderRadius:
              BorderRadius.all(Radius.circular(SizeConfig.padding14))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        child: Shimmer.fromColors(
          baseColor: UiConstants.kUserRankBackgroundColor,
          highlightColor: UiConstants.kBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: SizeConfig.screenWidth! * 0.23,
                width: SizeConfig.screenWidth! * 0.23,
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
