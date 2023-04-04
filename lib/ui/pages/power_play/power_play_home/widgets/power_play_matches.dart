import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola-global/tambola_daily_draw_timer.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_vm.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/completed_match.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/live_match.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/upcoming_match.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PowerPlayMatches extends StatefulWidget {
  const PowerPlayMatches({Key? key, required this.model}) : super(key: key);
  final PowerPlayHomeViewModel model;

  @override
  State<PowerPlayMatches> createState() => _PowerPlayMatchesState();
}

class _PowerPlayMatchesState extends State<PowerPlayMatches>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.model.tabController = TabController(vsync: this, length: 3);
    widget.model.tabController!.addListener(() => setState(() {}));
  }

  List<String> getTitle() {
    return ['Live', 'Upcoming', 'Completed'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              controller: widget.model.tabController,
              labelPadding: EdgeInsets.zero,
              indicatorColor: Colors.transparent,
              physics: const BouncingScrollPhysics(),
              isScrollable: true,
              splashFactory: NoSplash.splashFactory,
              onTap: (index) => widget.model.handleTabSwitch(index),
              tabs: List.generate(
                3,
                (index) => Container(
                  width: 105,
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding10,
                    vertical: SizeConfig.padding10,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: widget.model.tabController!.index == index
                          ? Colors.white
                          : Colors.transparent,
                      border: Border.all(color: Colors.white)),
                  child: Text(
                    getTitle()[index],
                    textAlign: TextAlign.center,
                    style: TextStyles.sourceSansSB.body4.colour(
                        widget.model.tabController!.index == index
                            ? Colors.black
                            : Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Builder(builder: (_) {
              if (widget.model.tabController!.index == 0) {
                if (widget.model.state == ViewState.Busy) {
                  return const Center(child: CircularProgressIndicator());
                }

                if ((widget.model.liveMatchData == null ||
                        (widget.model.liveMatchData?.isEmpty ?? true)) &&
                    widget.model.isLive) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    widget.model.tabController?.animateTo(1);
                    widget.model.handleTabSwitch(1);
                    widget.model.isLive = false;
                  });
                }

                return widget.model.liveMatchData?.isEmpty ?? true
                    ? (widget.model.upcomingMatchData!.isEmpty ||
                            widget.model.upcomingMatchData?[0] == null ||
                            (widget.model.upcomingMatchData?[0]?.startsAt ==
                                null))
                        ? const SizedBox()
                        : NoLiveMatch(
                            timeStamp:
                                widget.model.upcomingMatchData![0]!.startsAt!)
                    : LiveMatch(
                        model: widget.model,
                      );
              } else if (widget.model.tabController!.index == 1) {
                return UpcomingMatch(
                  model: widget.model,
                );
              } else {
                return CompletedMatch(
                  model: widget.model,
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.model.tabController?.dispose();
    super.dispose();
  }
}

class NoLiveMatch extends StatelessWidget {
  const NoLiveMatch({Key? key, required this.timeStamp}) : super(key: key);

  final TimestampModel timeStamp;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: SizeConfig.padding54,
        ),
        SvgPicture.asset(
          'assets/svg/ipl_ball.svg',
          height: SizeConfig.padding64,
        ),
        SizedBox(
          height: SizeConfig.padding20,
        ),
        //No Live matches at the moment
        Text(
          'No Live matches at the moment',
          style: TextStyles.rajdhaniB.body1.colour(Colors.white),
        ),
        SizedBox(
          height: SizeConfig.padding20,
        ),
        Text(
          'Next match starts in',
          style: TextStyles.sourceSans.body1.colour(Colors.white),
        ),
        SizedBox(
          height: SizeConfig.padding20,
        ),
        DailyPicksTimer(
            startTime: timeStamp, replacementWidget: const SizedBox()),
      ],
    );
  }
}
