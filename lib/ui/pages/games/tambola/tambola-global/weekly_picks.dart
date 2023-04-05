import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_widgets/picks_card/picks_card_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class WeeklyPicks extends StatelessWidget {
  final DailyPick? weeklyDraws;
  final PicksCardViewModel model;

  const WeeklyPicks({
    this.weeklyDraws,
    Key? key,
    required this.model,
  }) : super(key: key);

  String getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'MON';
      case 2:
        return 'TUE';
      case 3:
        return 'WED';
      case 4:
        return 'THU';
      case 5:
        return 'FRI';

      case 6:
        return 'SAT';
      case 7:
        return 'SUN';
      default:
        return 'N/A';
    }
  }

  Widget _getDrawBallRow(DailyPick? draws, int day) {
    List<Widget> balls = [];
    DateTime today = DateTime.now();
    int colCount = today.weekday;
    if (draws != null &&
        draws.getWeekdayDraws(day - 1) != null &&
        !draws.getWeekdayDraws(day - 1)!.contains(-1)) {
      for (final element in draws.getWeekdayDraws(day - 1)!) {
        balls.add(_getDrawBall(element.toString(), colCount == day));
      }
    } else {
      for (int i = 0; i < 3; i++) {
        balls.add(_getDrawBall('-', colCount == day));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: balls,
    );
  }

  Widget _getDrawBall(String digit, bool isToday) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding4, vertical: SizeConfig.padding6),
      width: SizeConfig.screenWidth! * 0.07,
      height: SizeConfig.screenWidth! * 0.07,
      decoration: BoxDecoration(
        color: isToday ? UiConstants.darkPrimaryColor : Colors.white.withOpacity(0.1),
        border: model.isNumberPresent(digit)
            ? Border.all(color: const Color(0xffFFD979))
            : null,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Text(
        digit,
        style: TextStyle(
            fontSize: SizeConfig.mediumTextSize! * 1,
            fontWeight: FontWeight.w500,
            color: Colors.white),
        textAlign: TextAlign.center,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    List<Widget> colElems = [];
    int colCount = today.weekday;
    for (int i = 0; i < 7; i++) {
      colElems.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(getDayName(i + 1).toUpperCase(),
              style: TextStyles.sourceSans.body3.colour(Colors.white)),
          SizedBox(
            width: SizeConfig.padding12,
          ),
          _getDrawBallRow(weeklyDraws, i + 1),
        ],
      ));
    }

    //Divind the list in two parts
    List<Widget> side1 = colElems.sublist(0, 4);
    List<Widget> side2 = colElems.sublist(4);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: side1,
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: side2,
          ),
        ),
      ],
    );
  }
}
