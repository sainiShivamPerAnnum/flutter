import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/game_stats_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class GOWCard extends StatelessWidget {
  final PlayViewModel model;
  const GOWCard({
    required this.model,
    Key? key,
  }) : super(key: key);

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
    final AnalyticsService _analyticsService = locator<AnalyticsService>();
    S locale = S.of(context);
    return (model.isGamesListDataLoading)
        ? const GameCardShimmer()
        : (model.gow == null
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleSubtitleContainer(
                    title: locale.gameOfWeek,
                  ),
                  GestureDetector(
                    onTap: () {
                      Haptic.vibrate();
                      _analyticsService.track(
                          eventName: AnalyticsEvents.gameTapped,
                          properties: AnalyticsProperties
                              .getDefaultPropertiesMap(extraValuesMap: {
                            'Game name': model.gow!.gameName,
                            "Entry fee": model.gow!.playCost,
                            "Win upto": model.gow!.prizeAmount,
                            "Time left for draw Tambola (mins)":
                                AnalyticsProperties.getTimeLeftForTambolaDraw(),
                            "Tambola Tickets Owned":
                                AnalyticsProperties.getTambolaTicketCount(),
                            "location": "Game of the Week"
                          }));
                      // AppState.delegate!.parseRoute(
                      //   Uri.parse(model.gow!.route!),
                      // );
                      BaseUtil.openGameModalSheet(
                        model.gow!.gameCode!,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: model.gow!.shadowColor,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness12)),
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins,
                          vertical: SizeConfig.padding16),
                      padding: EdgeInsets.only(
                          left: SizeConfig.pageHorizontalMargins),
                      width: double.infinity,
                      height: SizeConfig.screenHeight! * 0.18,
                      child: Row(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(model.gow!.gameName!,
                                    style: TextStyles.rajdhaniB.title3),
                                Text(
                                    locale.gameWinUptoTitle +
                                        NumberFormat.compact()
                                            .format(model.gow!.prizeAmount),
                                    style: TextStyles.sourceSans.body4),
                                SizedBox(height: SizeConfig.padding16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff232326),
                                    border: Border.all(
                                        color: const Color(0xff919193)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        Assets.token,
                                        height: SizeConfig.padding20,
                                        width: SizeConfig.padding20,
                                      ),
                                      SizedBox(width: SizeConfig.padding4),
                                      Text(model.gow!.playCost.toString(),
                                          style: TextStyles.sourceSans.body1),
                                    ],
                                  ),
                                ),
                              ]),
                          const Spacer(),
                          SvgPicture.network(
                            model.gow!.thumbnailUri!,
                            fit: BoxFit.cover,
                            height: SizeConfig.screenHeight! * 0.2,
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
    Key? key,
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
        height: SizeConfig.screenWidth! * 0.456,
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
