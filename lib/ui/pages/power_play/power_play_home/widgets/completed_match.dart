import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/power_play/completed_match_details/completed_match_details_view.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_vm.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/power_play_matches.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/ipl_teams_score_widget.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class CompletedMatch extends StatelessWidget {
  const CompletedMatch({
    required this.model,
    super.key,
  });

  final PowerPlayHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return model.state == ViewState.Busy
        ? const Center(child: CircularProgressIndicator())
        : model.completedMatchData == null || model.completedMatchData!.isEmpty
            ? const NoLiveMatch(
                timeStamp: null,
                matchStatus: MatchStatus.completed,
              )
            : ListView.separated(
                itemCount: model.completedMatchData!.length,
                padding:
                    EdgeInsets.only(bottom: SizeConfig.pageHorizontalMargins),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      Haptic.vibrate();
                      AppState.delegate!.appState.currentAction = PageAction(
                          page: FppCompletedMatchDetailsConfig,
                          widget: CompletedMatchDetailsView(
                              matchData: model.completedMatchData![i]),
                          state: PageState.addWidget);
                      locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.iplCompleteCardTapped,
                        properties: {
                          "team1": model.completedMatchData![i].teams![0],
                          "team2": model.completedMatchData![i].teams![1],
                          "prediction count":
                              model.completedMatchData![i].matchStats!.count,
                          "reward won":
                              model.completedMatchData![i].matchStats?.didWon,
                          "Chasing score": model.completedMatchData![i].target,
                          "total Won from PowerPay": model.powerPlayReward,
                          "verdict Text": model.liveMatchData![0].verdictText
                        },
                      );
                    },
                    child: Container(
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
                          Container(
                            height: SizeConfig.padding40,
                            padding: EdgeInsets.only(
                              left: SizeConfig.pageHorizontalMargins,
                              right: SizeConfig.padding14,
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
                                  model.completedMatchData![i].matchTitle ?? "",
                                  style: TextStyles.sourceSansB.body2
                                      .colour(Colors.white),
                                ),
                                const Spacer(),
                                Text(
                                  model.completedMatchData![i].matchStats!
                                              .count >
                                          0
                                      ? "You made ${model.completedMatchData![i].matchStats!.count} predictions"
                                      : "",
                                  style: TextStyles.sourceSans.body5
                                      .colour(Colors.white.withOpacity(0.7))
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.screenWidth! * 0.030),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: SizeConfig.padding14,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 17),
                            child: IplTeamsScoreWidget(
                              matchData: model.completedMatchData![i],
                            ),
                          ),
                          const SizedBox(
                            height: 19,
                          ),
                          Center(
                            child: Text(
                              model.completedMatchData?[i].verdictText ?? '',
                              style: TextStyles.sourceSans.body4,
                            ),
                          ),
                          SizedBox(height: SizeConfig.padding4),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Chasing score: ",
                                  style: TextStyles.sourceSansSB.body4,
                                ),
                                Text(
                                  "${model.completedMatchData?[i].target}",
                                  style: TextStyles.sourceSans.body4,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins,
                                vertical: SizeConfig.padding8),
                            decoration: BoxDecoration(
                                color: const Color(0xff000000).withOpacity(0.3),
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5))),
                            child: Center(
                              child: Text(
                                (model.completedMatchData![i].matchStats!
                                                .count >
                                            0 &&
                                        model.completedMatchData![i].matchStats!
                                            .didWon)
                                    ? 'Congratulations! you won a reward'
                                    : model.completedMatchData![i].matchStats!
                                                .count >
                                            0
                                        ? "Your prediction was not correct"
                                        : "You did not make a prediction",
                                textAlign: TextAlign.center,
                                style: (model.completedMatchData![i].matchStats!
                                                .count >
                                            0 &&
                                        model.completedMatchData![i].matchStats!
                                            .didWon)
                                    ? TextStyles.sourceSansSB.body3
                                        .colour(UiConstants.primaryColor)
                                    : TextStyles.sourceSans.body3
                                        .colour(Colors.white60),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, i) =>
                    SizedBox(height: SizeConfig.padding16),
              );
  }
}
