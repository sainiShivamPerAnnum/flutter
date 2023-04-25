import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeeklyPicks extends StatelessWidget {
  // final DailyPick? weeklyDraws;

  const WeeklyPicks({
    // this.weeklyDraws,
    Key? key,
  }) : super(key: key);

  static const List<String> _dayNames = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN'
  ];
  static const List<int> _emptyBalls = [-1, -1, -1];

  Widget _getDrawBallRow(DailyPick? draws, int day) {
    final weekdayDraws = draws?.getWeekdayDraws(day - 1) ?? _emptyBalls;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekdayDraws.map((ball) => _getDrawBall(ball, day)).toList(),
    );
  }

  Widget _getDrawBall(int ball, int todayWeekday) {
    // final isNumberPresent = model.isNumberPresent(ball.toString());
    final borderColor = null;
    // isNumberPresent ? const Color(0xffFFD979) : null;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding4,
        vertical: SizeConfig.padding6,
      ),
      width: SizeConfig.screenWidth! * 0.07,
      height: SizeConfig.screenWidth! * 0.07,
      decoration: BoxDecoration(
        color: todayWeekday == DateTime.now().weekday
            ? UiConstants.darkPrimaryColor
            : Colors.white.withOpacity(0.1),
        border: borderColor != null ? Border.all(color: borderColor) : null,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          ball == -1 ? '-' : ball.toString(),
          style: TextStyle(
            fontSize: SizeConfig.mediumTextSize! * 1,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<TambolaService, DailyPick?>(
      selector: (_, tambolaService) => tambolaService.weeklyPicks,
      builder: (context, weeklyPicks, child) {
        final columns = List<Widget>.generate(
          7,
          (i) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _dayNames[i],
                style: TextStyles.sourceSans.body3.colour(Colors.white),
              ),
              SizedBox(width: SizeConfig.padding12),
              _getDrawBallRow(weeklyPicks, i + 1),
            ],
          ),
        );

        // Divide the list in two parts
        final side1 = columns.sublist(0, 4);
        final side2 = columns.sublist(4);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: side1.length,
                itemBuilder: (context, index) => side1[index],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: side2.length,
                itemBuilder: (context, index) => side2[index],
              ),
            ),
          ],
        );
      },
    );
  }
}
