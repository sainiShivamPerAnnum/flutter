import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/power_play/leaderboard/prediction_leaderboard_view.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_home_view.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_vm.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/ipl_teams_score_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LiveMatch extends StatelessWidget {
  const LiveMatch({
    required this.model,
    super.key,
  });

  final PowerPlayHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                UiConstants.kTambolaMidTextColor,
                const Color(0xff272727),
              ]),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: const Offset(2, 2),
                  blurRadius: SizeConfig.roundness5,
                  spreadRadius: SizeConfig.padding2,
                )
              ],
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Haptic.vibrate();

                    AppState.delegate!.appState.currentAction = PageAction(
                        widget: PredictionLeaderboard(
                          matchData: model.liveMatchData![0],
                        ),
                        page: PowerPlayLeaderBoardConfig,
                        state: PageState.addWidget);
                    locator<AnalyticsService>().track(
                      eventName: AnalyticsEvents.iplLiveCardTapped,
                      properties: {
                        "team1": model.liveMatchData![0].teams![0],
                        "team2": model.liveMatchData![0].teams![1],
                        "totalWonFromPowerPay": model.powerPlayReward,
                        "announcementText": model.liveMatchData![0].headsUpText
                      },
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 8,
                        ),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(5),
                          ),
                          color: UiConstants.kBackgroundColor2,
                        ),
                        child: Row(
                          children: [
                            Text(
                              model.liveMatchData?[0].matchTitle ?? 'IPL MATCH',
                              style: TextStyles.sourceSansB.body2
                                  .colour(Colors.white),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(
                                  'PREDICTION LEADERBOARD',
                                  style: TextStyles.sourceSans
                                      .colour(Colors.white.withOpacity(0.7))
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.screenWidth! * 0.030),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 10,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding18,
                        ),
                        child: IplTeamsScoreWidget(
                          matchData: model.liveMatchData![0],
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding8),
                        ),
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/svg/bell_icon.svg'),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              model.liveMatchData![0].headsUpText ?? '',
                              style: TextStyles.sourceSans.copyWith(
                                fontSize: 12,
                                height: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (model.liveMatchData?[0].status ==
                    MatchStatus.active.name) ...[
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                    ),
                    child: MaterialButton(
                      color: Colors.white,
                      onPressed: model.predict,
                      child: Center(
                        child: model.isPredictionInProgress
                            ? SizedBox(
                                height: SizeConfig.padding20,
                                width: SizeConfig.padding20,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 1,
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                'PREDICT NOW',
                                style: TextStyles.rajdhaniB.body3
                                    .colour(Colors.black),
                              ),
                      ),
                    ),
                  ),
                ],
                SizedBox(
                  height: SizeConfig.padding10,
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.padding16),
          const LiveUserPredictionsButton(
            margin: false,
          ),
          InkWell(
            onTap: () {
              Haptic.vibrate();
              AppState.delegate!.appState.currentAction = PageAction(
                  widget: PredictionLeaderboard(
                    matchData: model.liveMatchData![0],
                  ),
                  page: PowerPlayLeaderBoardConfig,
                  state: PageState.addWidget);
              locator<AnalyticsService>().track(
                eventName: AnalyticsEvents.iplPopularPredictionsTapped,
                properties: {
                  "team1": model.liveMatchData![0].teams![0],
                  "team2": model.liveMatchData![0].teams![1],
                  "totalWonFromPowerPay": model.powerPlayReward,
                  "announcementText": model.liveMatchData![0].headsUpText
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
              ),
              padding: EdgeInsets.only(
                left: SizeConfig.pageHorizontalMargins,
                right: SizeConfig.padding12,
                top: SizeConfig.padding12,
                bottom: SizeConfig.padding12,
              ),
              margin: EdgeInsets.symmetric(
                vertical: SizeConfig.padding10,
              ),
              child: Row(
                children: [
                  Text('View Popular Predictions',
                      style: TextStyles.sourceSans.body2),
                  const Spacer(),
                  const Icon(
                    Icons.navigate_next_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.4,
          )
        ],
      ),
    );
  }
}
