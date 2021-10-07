import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'N/A';
    }
  }

  Widget _getDrawBallRow(DailyPick draws, int day) {
    List<Widget> balls = [];
    if (draws != null && draws.getWeekdayDraws(day - 1) != null) {
      draws.getWeekdayDraws(day - 1).forEach((element) {
        balls.add(_getDrawBall(element.toString()));
      });
    } else {
      for (int i = 0; i < draws.mon.length; i++) {
        balls.add(_getDrawBall('-'));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: balls,
    );
  }

  Widget _getDrawBall(String digit) {
    return Container(
      width: SizeConfig.screenWidth * 0.08,
      height: SizeConfig.screenWidth * 0.08,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Text(
        digit,
        style: TextStyle(
            fontSize: SizeConfig.mediumTextSize * 1.2,
            fontWeight: FontWeight.w500,
            color: Colors.black),
        textAlign: TextAlign.center,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (weeklyDraws == null || weeklyDraws.toList().isEmpty) {
      return Center(
        child: Container(
          height: 150,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'This week\'s numbers have not been drawn yet.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ),
      );
    }
    DateTime today = DateTime.now();
    List<Widget> colElems = [];
    //int colCount = today.weekday;
    for (int i = 0; i < 7; i++) {
      // if (weeklyDraws.getWeekdayDraws(i) != null) {
      colElems.add(Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        height: SizeConfig.smallTextSize + SizeConfig.screenWidth * 0.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              getDayName(i + 1).toUpperCase(),
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: SizeConfig.smallTextSize,
                letterSpacing: 5,
              ),
            ),
            _getDrawBallRow(weeklyDraws, i + 1),
          ],
        ),
      ));
    }
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(bottom: 8),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: colElems,
        ),
      ),
    );
  }
}
