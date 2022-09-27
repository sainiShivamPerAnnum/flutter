import 'package:felloapp/ui/elements/tambola-global/tambola_daily_draw_timer.dart';
import 'package:felloapp/ui/widgets/tambola_card/tambola_card_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class CurrentPicks extends StatelessWidget {
  CurrentPicks({this.todaysPicks, this.dailyPicksCount});
  final List<int> todaysPicks;
  final int dailyPicksCount;

  int renderedTimes = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.padding10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DailyPicksTimer(
            replacementWidget: TodayPicksBallsAnimation(
              picksList: todaysPicks,
            ),
          ),
        ],
      ),
    );
  }
}
