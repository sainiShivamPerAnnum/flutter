import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_vm.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/ipl_teams_score_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'power_play_matches.dart';

class UpcomingMatch extends StatelessWidget {
  const UpcomingMatch({
    required this.model,
    super.key,
  });

  final PowerPlayHomeViewModel model;

  String getDate(int index) {
    return DateFormat('d MMMM, yyyy')
        .format(model.upcomingMatchData![index].startsAt!.toDate());
  }

  String getTime(int index) {
    return DateFormat('hh:mm a')
        .format(model.upcomingMatchData![index].startsAt!.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return model.state == ViewState.Busy
        ? const Center(child: CircularProgressIndicator())
        : ((model.upcomingMatchData?.length ?? 0) <= 0)
            ? NoLiveMatch(
                timeStamp: TimestampModel(
                  seconds: 0,
                  nanoseconds: 0,
                ),
                matchStatus: MatchStatus.upcoming,
              )
            : ListView.builder(
                itemCount: model.upcomingMatchData?.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  log('Upcoming Match Data index: ${model.upcomingMatchData?.length}');

                  return Column(
                    children: [
                      Container(
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 8),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5),
                                ),
                                color: UiConstants.kBackgroundColor2,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    model.upcomingMatchData?[index]
                                            .matchTitle ??
                                        'IPL MATCH',
                                    style: TextStyles.sourceSansB.body2
                                        .colour(Colors.white),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      // AppState.delegate!.appState.currentAction =
                                      //     PageAction(
                                      //         widget: PredictionLeaderboard(
                                      //           matchData: model
                                      //               .upcomingMatchData![index]!,
                                      //         ),
                                      //         page: PowerPlayLeaderBoardConfig,
                                      //         state: PageState.addWidget);
                                    },
                                    child: Text(
                                      getDate(index),
                                      style: TextStyles.sourceSans.body5
                                          .colour(Colors.white.withOpacity(0.7))
                                          .copyWith(
                                              fontSize:
                                                  SizeConfig.screenWidth! *
                                                      0.030),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding16),
                              child: IplTeamsScoreWidget(
                                matchData: model.upcomingMatchData![index],
                                isUpcoming: true,
                              ),
                            ),
                            const SizedBox(
                              height: 19,
                            ),
                            Center(
                              child: Text(
                                model.upcomingMatchData?[index].headsUpText ??
                                    '',
                                style: TextStyles.sourceSans.copyWith(
                                    fontSize: SizeConfig.screenWidth! * 0.030),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding8),
                              decoration: BoxDecoration(
                                color: const Color(0xff000000).withOpacity(0.3),
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(5),
                                ),
                              ),
                              child: Center(
                                child: index == 0
                                    ? CountdownTimerWidget(
                                        model: model,
                                        endTime: model
                                            .upcomingMatchData![0].startsAt!)
                                    : Text(
                                        'Predictions start on ${getDate(index)}',
                                        style: TextStyles.sourceSans.body3
                                            .colour(
                                                Colors.white.withOpacity(0.7)),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              );
  }
}

class CountdownTimerWidget extends StatefulWidget {
  final TimestampModel endTime;
  final PowerPlayHomeViewModel model;

  const CountdownTimerWidget(
      {required this.endTime, required this.model, super.key});

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  Timer? _timer;
  int? _timeRemaining;

  @override
  void initState() {
    super.initState();
    _timeRemaining =
        widget.endTime.toDate().difference(DateTime.now()).inMilliseconds;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Predictions start in ${_formatDuration(Duration(milliseconds: _timeRemaining!))} Hrs",
      style: TextStyles.sourceSans.body3.colour(Colors.white.withOpacity(0.7)),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _timeRemaining = _timeRemaining! - 1000;
        if (_timeRemaining! <= 0) {
          widget.model.getMatchesByStatus(MatchStatus.active.name, 10, 0);
          widget.model.getMatchesByStatus(MatchStatus.upcoming.name, 10, 0);
          // widget.model.tabController!.animateTo(0);

          _timer!.cancel();
          _timeRemaining = 0;
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    return "${(duration.inHours % 24).toString().padLeft(2, '0')} : "
        "${(duration.inMinutes % 60).toString().padLeft(2, '0')} : "
        "${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }
}
