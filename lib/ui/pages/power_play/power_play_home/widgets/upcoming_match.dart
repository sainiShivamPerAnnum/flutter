import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_vm.dart';
import 'package:felloapp/ui/pages/power_play/shared_widgets/ipl_teams_score_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpcomingMatch extends StatefulWidget {
  const UpcomingMatch({
    super.key,
    required this.model,
  });

  final PowerPlayHomeViewModel model;

  @override
  State<UpcomingMatch> createState() => _UpcomingMatchState();
}

class _UpcomingMatchState extends State<UpcomingMatch> {
  String getDate(int index) {
    return DateFormat('d MMM ' 'yy')
        .format(widget.model.upcomingMatchData![index]!.startsAt!);
  }

  String getTime(int index) {
    return DateFormat('hh:mm a')
        .format(widget.model.upcomingMatchData![index]!.startsAt!);
  }

  @override
  Widget build(BuildContext context) {
    return widget.model.state == ViewState.Busy
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: widget.model.upcomingMatchData?.length,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              log('Upcoming Match Data index: ${widget.model.upcomingMatchData?.length}');

              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xff3B4E6E).withOpacity(0.8),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 8),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              color: Color(0xff273C60)),
                          child: Row(
                            children: [
                              Text(
                                widget.model.upcomingMatchData?[index]
                                        ?.matchTitle ??
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
                                  //           matchData: widget.model
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
                                              SizeConfig.screenWidth! * 0.030),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17),
                          child: IplTeamsScoreWidget(
                              matchData:
                                  widget.model.upcomingMatchData![index]!),
                        ),
                        const SizedBox(
                          height: 19,
                        ),
                        Center(
                          child: Text(
                            widget.model.upcomingMatchData?[index]
                                    ?.headsUpText ??
                                '',
                            style: TextStyles.sourceSans.copyWith(
                                fontSize: SizeConfig.screenWidth! * 0.030),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              color: const Color(0xff000000).withOpacity(0.3),
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5))),
                          child: Center(
                            child: index == 0 &&
                                    widget.model.liveMatchData == null
                                ? const TimerWidget()
                                : Text(
                                    'Predictions start in ${getTime(index)}',
                                    style: TextStyles.sourceSans.copyWith(
                                        fontSize:
                                            SizeConfig.screenWidth! * 0.030),
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

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  final MyTimer _timer = MyTimer();

  @override
  void initState() {
    super.initState();
    DateTime timestamp = DateTime.parse('2023-04-04T14:00:00.000Z');
    _timer.startTimer(timestamp);
  }

  @override
  void dispose() {
    _timer.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _timer.timerStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int secondsRemaining = snapshot.data!;
          Duration duration = Duration(seconds: secondsRemaining);
          String formattedTime = DateFormat('hh:mm').format(
            DateTime(0, 0, 0, 0, 0, duration.inSeconds),
          );
          return Text(
            'Time remaining: $formattedTime',
            style: TextStyles.sourceSans
                .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
          );
        }
        return SizedBox();
      },
    );
  }
}

class MyTimer {
  int _secondsRemaining = 60;
  Timer? _timer;
  final StreamController<int> _timerController = StreamController<int>();

  Stream<int> get timerStream => _timerController.stream;

  void startTimer(DateTime timestamp) {
    _secondsRemaining = timestamp.difference(DateTime.now()).inSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        _timerController.sink.add(_secondsRemaining);
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      _timerController.sink.addError('Timer stopped');
    }
  }

  void dispose() {
    _timerController.close();
  }
}
