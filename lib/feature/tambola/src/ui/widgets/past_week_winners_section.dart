import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/leaderBoards.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TambolaLeaderboardView extends StatefulWidget {
  const TambolaLeaderboardView({
    Key? key,
  }) : super(key: key);

  @override
  State<TambolaLeaderboardView> createState() => _TambolaLeaderboardViewState();
}

class _TambolaLeaderboardViewState extends State<TambolaLeaderboardView> {
  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
    return Selector<TambolaService, List<Winners>?>(
        selector: (_, tambolaService) => tambolaService.pastWeekWinners,
        builder: (context, winners, child) {
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height:
                      SizeConfig.pageHorizontalMargins - SizeConfig.padding16,
                ),
                Text(
                  "Weekly Leaderboard",
                  style: TextStyles.sourceSansSB.title3,
                ),
                SizedBox(
                  height: SizeConfig.padding12,
                ),
                winners == null
                    ? Center(
                        child: Column(
                          children: [
                            FullScreenLoader(size: SizeConfig.padding80),
                            SizedBox(
                              height: SizeConfig.padding16,
                            ),
                            Text(
                              "Fetching last week winners..",
                              style: TextStyles.rajdhaniB.body2
                                  .colour(Colors.white),
                            ),
                          ],
                        ),
                      )
                    : LeaderBoards(
                        winners: winners,
                        showMyRankings: true,
                        backgroundTransparent: false,
                        showSeeAllButton: true)
              ],
            ),
          );
        });
  }
}
