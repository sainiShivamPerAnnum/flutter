import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/ui/elements/timer/app_countdown_timer.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/power_play_vm.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/completed_match.dart';
import 'package:felloapp/ui/pages/power_play/power_play_home/widgets/upcoming_match.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PowerPlayMatches extends StatefulWidget {
  const PowerPlayMatches({required this.model, Key? key}) : super(key: key);
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

  Widget _buildLiveTab() {
    return widget.model.buildLiveTab();
  }

  Widget _buildUpcomingTab() {
    return UpcomingMatch(
      model: widget.model,
    );
  }

  Widget _buildCompletedTab() {
    return CompletedMatch(
      model: widget.model,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: TabBar(
                controller: widget.model.tabController,
                isScrollable: false,
                splashFactory: NoSplash.splashFactory,
                onTap: widget.model.handleTabSwitch,
                labelStyle: TextStyles.sourceSansSB.body3,
                labelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelStyle: TextStyles.sourceSansSB.body3,
                unselectedLabelColor: Colors.white,
                indicator: BoxDecoration(
                  color: Colors.white.withOpacity(.85),
                ),
                tabs: List.generate(
                  3,
                  (i) => Tab(height: 30, text: widget.model.tabs[i]),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (widget.model.state.isBusy && widget.model.isLive)
              const Center(child: CircularProgressIndicator())
            else ...[
              if (widget.model.tabController!.index == 0)
                _buildLiveTab()
              else if (widget.model.tabController!.index == 1)
                _buildUpcomingTab()
              else
                _buildCompletedTab(),
            ]
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
  const NoLiveMatch({
    required this.timeStamp,
    required this.matchStatus,
    super.key,
  });

  final TimestampModel? timeStamp;

  final MatchStatus matchStatus;

  String get text {
    if (matchStatus == MatchStatus.upcoming) {
      return 'upcoming';
    } else if (matchStatus == MatchStatus.active) {
      return 'live';
    } else {
      return 'completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizeConfig.padding54,
          ),
          SvgPicture.asset(
            'assets/svg/ipl_ball.svg',
            height: SizeConfig.padding70,
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          //No Live matches at the moment
          Text(
            'No $text matches at the moment',
            style: TextStyles.rajdhaniB.body1.colour(Colors.white),
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          if (matchStatus != MatchStatus.upcoming) ...[
            if (timeStamp != null)
              Text(
                'Predictions begin in',
                style: TextStyles.rajdhaniB.body1.colour(Colors.white),
              ),
            SizedBox(
              height: SizeConfig.padding20,
            ),
            if (timeStamp != null)
              AppCountdownTimer(
                endTime: timeStamp!,
                backgroundColor: const Color(0xff785353),
              ),
          ]
        ],
      ),
    );
  }
}
