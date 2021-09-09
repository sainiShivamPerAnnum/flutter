// import 'dart:ui';

// import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/model/DailyPick.dart';
// import 'package:felloapp/main.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/util/logger.dart';
// import 'package:felloapp/util/size_config.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class WeeklyDrawDialog extends StatelessWidget {
//   final Log log = new Log('WeeklyDrawDialog');
//   DailyPick weeklyDraws;
//   BaseUtil baseProvider;

//   WeeklyDrawDialog(this.weeklyDraws);

//   @override
//   Widget build(BuildContext context) {
//     baseProvider = Provider.of<BaseUtil>(context, listen: false);
//     return WillPopScope(
//       onWillPop: () async {
//         AppState.backButtonDispatcher.didPopRoute();
//         return true;
//       },
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//         child: Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           elevation: 0.0,
//           backgroundColor: Colors.white70,
//           child: dialogContent(context),
//         ),
//       ),
//     );
//   }

//   dialogContent(BuildContext context) {
//     if (weeklyDraws == null || weeklyDraws.toList().isEmpty) {
//       return Container(
//         height: 150,
//         child: Center(
//             child: Padding(
//           padding: EdgeInsets.all(10),
//           child: Text(
//             'This week\'s numbers have not been drawn yet.',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.black54),
//           ),
//         )),
//       );
//     }
//     DateTime today = DateTime.now();
//     List<Widget> colElems = [];
//     int colCount = today.weekday;
//     for (int i = 0; i < colCount; i++) {
//       if (weeklyDraws.getWeekdayDraws(i) != null) {
//         colElems.add(new Padding(
//             padding: EdgeInsets.all(10), child: new Text(getDayName(i + 1))));
//         colElems.add(new Padding(
//             padding: EdgeInsets.all(10),
//             child: _getDrawBallRow(weeklyDraws, i + 1)));
//       }
//     }

//     return Container(
//       padding: EdgeInsets.only(top: 30, bottom: 30),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: colElems,
//         ),
//       ),
//     );
//   }

//   String getDayName(int weekday) {
//     switch (weekday) {
//       case 1:
//         return 'Monday';
//       case 2:
//         return 'Tuesday';
//       case 3:
//         return 'Wednesday';
//       case 4:
//         return 'Thursday';
//       case 5:
//         return 'Friday';
//       case 6:
//         return 'Saturday';
//       case 7:
//         return 'Sunday';
//       default:
//         return 'N/A';
//     }
//   }

//   Widget _getDrawBallRow(DailyPick draws, int day) {
//     List<Widget> balls = [];
//     if (draws != null && draws.getWeekdayDraws(day - 1) != null) {
//       draws.getWeekdayDraws(day - 1).forEach((element) {
//         balls.add(_getDrawBall(element.toString()));
//       });
//     } else {
//       for (int i = 0; i < draws.mon.length; i++) {
//         balls.add(_getDrawBall('-'));
//       }
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: balls,
//     );
//   }

//   Widget _getDrawBall(String digit) {
//     return Container(
//       width: SizeConfig.screenWidth * 0.09,
//       height: SizeConfig.screenWidth * 0.09,
//       decoration: new BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//       ),
//       child: Center(
//           child: Text(
//         digit,
//         style: TextStyle(fontSize: SizeConfig.mediumTextSize * 1.2),
//         textAlign: TextAlign.center,
//       )),
//     );
//   }
// }
