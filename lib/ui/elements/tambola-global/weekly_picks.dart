import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeeklyPicks extends StatelessWidget {
  final DailyPick weeklyDraws;
  // BaseUtil baseProvider;

  const WeeklyPicks({
    this.weeklyDraws,
    Key key,
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

  Widget _getDrawBallRow(DailyPick draws, int day) {
    List<Widget> balls = [];
    DateTime today = DateTime.now();
    int colCount = today.weekday;
    if (draws != null && draws.getWeekdayDraws(day - 1) != null) {
      draws.getWeekdayDraws(day - 1).forEach((element) {
        balls.add(
            _getDrawBall(element.toString(), colCount == day ? true : false));
      });
    } else {
      for (int i = 0; i < 3; i++) {
        balls.add(_getDrawBall('-', colCount == day ? true : false));
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
      width: SizeConfig.screenWidth * 0.07,
      height: SizeConfig.screenWidth * 0.07,
      decoration: new BoxDecoration(
        color: isToday
            ? UiConstants.kSnackBarPositiveContentColor
            : Colors.white.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Text(
        digit,
        style: TextStyle(
            fontSize: SizeConfig.mediumTextSize * 1,
            fontWeight: FontWeight.w500,
            color: Colors.white),
        textAlign: TextAlign.center,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("TEsting mon: ${weeklyDraws.mon}");
    print("TEsting tue: ${weeklyDraws.tue}");
    print("TEsting wed: ${weeklyDraws.wed}");
    print("TEsting thu: ${weeklyDraws.thu}");
    print("TEsting fri: ${weeklyDraws.fri}");
    print("TEsting sat: ${weeklyDraws.sat}");
    print("TEsting sun: ${weeklyDraws.sun}");
    print("TEsting wekkcode: ${weeklyDraws.weekCode}");
    if (weeklyDraws == null || weeklyDraws.toList().isEmpty) {
      return Container(
        padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        height: SizeConfig.screenWidth * 0.5,
        decoration: BoxDecoration(
          color: UiConstants.kArowButtonBackgroundColor,
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 0.5,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(SizeConfig.roundness16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.noTickets,
              width: SizeConfig.screenWidth * 0.2,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'This week\'s numbers have not been drawn yet.',
                textAlign: TextAlign.center,
                style: TextStyles.sourceSans.body3.colour(
                  Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      );
    }
    DateTime today = DateTime.now();
    List<Widget> colElems = [];
    int colCount = today.weekday;
    for (int i = 0; i < 7; i++) {
      colElems.add(Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(getDayName(i + 1).toUpperCase(),
                style: TextStyles.sourceSans.body3.colour(i + 1 == colCount
                    ? UiConstants.kSnackBarPositiveContentColor
                    : Colors.white)),
            SizedBox(
              width: SizeConfig.padding12,
            ),
            _getDrawBallRow(weeklyDraws, i + 1),
          ],
        ),
      ));
    }

    //Divind the list in two parts
    List<Widget> side1 = colElems.sublist(0, 4);
    List<Widget> side2 = colElems.sublist(4);

    return Container(
      height: SizeConfig.screenWidth * 0.5,
      decoration: BoxDecoration(
        color: UiConstants.kArowButtonBackgroundColor,
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 0.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConfig.roundness24),
        ),
      ),
      padding: EdgeInsets.only(bottom: 8, top: SizeConfig.screenHeight * 0.02),
      child: Row(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              children: side1,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              children: side2,
            ),
          ),
        ],
      ),
    );
  }
}
