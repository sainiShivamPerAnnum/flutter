import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/view_model/power_play_view_model.dart';
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
  @override
  void initState() {
    super.initState();
    widget.model.getMatchesByStatus(MatchStatus.upcoming.getValue, 10, 0);
  }

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
                                'IPL Match - 4',
                                style: TextStyles.sourceSansB.body2
                                    .colour(Colors.white),
                              ),
                              const Spacer(),
                              Text(
                                getDate(index),
                                style: TextStyles.sourceSans.body5
                                    .colour(Colors.white.withOpacity(0.7))
                                    .copyWith(
                                        fontSize:
                                            SizeConfig.screenWidth! * 0.030),
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
                            team1: widget.model.upcomingMatchData?[index]
                                    ?.teams?[0] ??
                                "",
                            team2: widget.model.upcomingMatchData?[index]
                                    ?.teams?[1] ??
                                "",
                            score1: widget.model.upcomingMatchData?[index]
                                    ?.currentScore?[
                                widget.model.upcomingMatchData?[index]
                                    ?.teams?[0]],
                            score2: widget.model.upcomingMatchData?[index]
                                    ?.currentScore?[
                                widget.model.upcomingMatchData?[index]
                                    ?.teams?[1]],
                          ),
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
                            child: index == 0
                                ? MatchTimer(
                                    startTime: widget.model
                                        .upcomingMatchData![index]!.startsAt!)
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

class MatchTimer extends StatefulWidget {
  const MatchTimer({Key? key, required this.startTime}) : super(key: key);

  final DateTime startTime;

  @override
  State<MatchTimer> createState() => _MatchTimerState();
}

class _MatchTimerState extends State<MatchTimer> with TickerProviderStateMixin {
  Timer? _timer;
  int _start = 0;

  @override
  void initState() {
    super.initState();
    _start = widget.startTime.second;
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Predictions start in ${_start ~/ 3600} : ${(_start % 3600) ~/ 60} : ${_start % 60}',
      style: TextStyles.sourceSans
          .copyWith(fontSize: SizeConfig.screenWidth! * 0.030),
    );
  }
}
