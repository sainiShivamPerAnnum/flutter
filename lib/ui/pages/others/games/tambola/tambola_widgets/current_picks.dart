import 'package:felloapp/core/service/tambola_service.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_daily_draw_timer.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class CurrentPicks extends StatelessWidget {
  const CurrentPicks({this.todaysPicks, this.dailyPicksCount});
  final List<int> todaysPicks;
  final int dailyPicksCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DailyPicksTimer(
            replacementWidget: Container(
              width: SizeConfig.screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: (todaysPicks ?? List.filled(dailyPicksCount, 0))
                    .map(
                      (e) => Container(
                        height: SizeConfig.screenWidth * 0.12,
                        width: SizeConfig.screenWidth * 0.12,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            center: Alignment(-0.8, -0.6),
                            colors: [Color(0xff515E63), Colors.black],
                            radius: 1.0,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: SizeConfig.screenWidth * 0.09,
                                width: SizeConfig.screenWidth * 0.09,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                            Container(
                              height: SizeConfig.screenWidth * 0.12,
                              width: SizeConfig.screenWidth * 0.12,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              child: FittedBox(
                                child: Text(
                                  e.toString() ?? "-",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: SizeConfig.largeTextSize),
                                ),
                              ),
                            ),
                            Container(
                              height: SizeConfig.screenWidth * 0.12,
                              width: SizeConfig.screenWidth * 0.12,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              child: FittedBox(
                                child: Text(
                                  e.toString() ?? "-",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: SizeConfig.largeTextSize),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 2),
            child: Text(
              "Tap to see all picks of this week",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.mediumTextSize,
                  height: 2),
            ),
          ),
        ],
      ),
    );
  }
}
