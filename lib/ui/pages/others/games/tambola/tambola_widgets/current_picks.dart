import 'package:felloapp/ui/elements/tambola-global/tambola_daily_draw_timer.dart';
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
            replacementWidget: Container(
              width: SizeConfig.screenWidth * 0.65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: (todaysPicks ?? List.filled(dailyPicksCount, 0))
                    .map(
                      (e) => Row(
                        children: [
                          Container(
                            height: SizeConfig.screenWidth * 0.14,
                            width: SizeConfig.screenWidth * 0.14,
                            decoration: BoxDecoration(
                              color: UiConstants.kBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              height: SizeConfig.screenWidth * 0.1,
                              width: SizeConfig.screenWidth * 0.14,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(SizeConfig.padding8),
                              child: FittedBox(
                                child: Text(
                                  e.toString() ?? "-",
                                  style: TextStyles.rajdhaniB.body0
                                      .colour(Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
