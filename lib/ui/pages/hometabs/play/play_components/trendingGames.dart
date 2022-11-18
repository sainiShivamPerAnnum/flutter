import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_viewModel.dart';
import 'package:felloapp/ui/widgets/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/util/locator.dart';

class TrendingGamesSection extends StatelessWidget {
  final PlayViewModel model;

  const TrendingGamesSection({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSubtitleContainer(
          title: "All games",
        ),
        Container(
          width: SizeConfig.screenWidth,
          margin: EdgeInsets.symmetric(
              vertical: SizeConfig.pageHorizontalMargins / 2),
          child: GridView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: model.isGamesListDataLoading
                ? 3
                : model.trendingGamesListData.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
            itemBuilder: (ctx, index) {
              return model.isGamesListDataLoading
                  ? TrendingGamesShimmer()
                  : TrendingGames(
                      game: model.trendingGamesListData[index],
                    );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: .58,
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
  const TrendingGames({
    this.game,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AnalyticsService? _analyticsService = locator<AnalyticsService>();
    return GestureDetector(
      onTap: () {
        _analyticsService!.track(
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
        Haptic.vibrate();
        AppState.delegate!.parseRoute(
          Uri.parse(game!.route!),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xff39393C),
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.network(
              game!.thumbnailUri!,
              fit: BoxFit.cover,
              width: SizeConfig.screenWidth! * 0.24,
              height: SizeConfig.screenWidth! * 0.24,
            ),
            Text(
              game!.gameName!,
              textAlign: TextAlign.center,
              style: TextStyles.rajdhani.body3
                  .colour(Colors.white.withOpacity(0.7)),
            ),
            SizedBox(height: SizeConfig.padding4),
            RichText(
                text: TextSpan(
                    text: 'Win ',
                    style: TextStyles.sourceSans.body3.colour(Colors.white),
                    children: [
                  TextSpan(
                      text:
                          '${NumberFormat.compact().format(game!.prizeAmount)}',
                      style: TextStyles.sourceSansB.body3.colour(Colors.white))
                ])),
            SizedBox(height: SizeConfig.padding10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xff232326),
                border: Border.all(color: Color(0xff919193)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    Assets.token,
                    height: SizeConfig.padding12,
                    width: SizeConfig.padding12,
                  ),
                  SizedBox(width: SizeConfig.padding4),
                  Text(game!.playCost.toString(),
                      style: TextStyles.sourceSans.body3),
                ],
              ),
            ),
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
