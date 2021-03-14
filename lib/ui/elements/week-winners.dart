import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WeekWinner {
  final name, prize;
  WeekWinner({this.name, this.prize});
}

class WeekWinnerBoard extends StatefulWidget {
  @override
  _WeekWinnerBoardState createState() => _WeekWinnerBoardState();
}

class _WeekWinnerBoardState extends State<WeekWinnerBoard> {
  bool isLoading = false;
  DBModel dbProvider;
  BaseUtil baseProvider;
  List<WeekWinner> currentWeekWinners;

  Future<void> getWeekWinners() async {
    baseProvider.currentWeekWinners = await dbProvider.getWeeklyWinners();
  }

  ScrollController _controller;

  @override
  void initState() {
    currentWeekWinners = [];

    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getMonthName(int monthNum) {
    switch (monthNum) {
      case 1:
        return "Jan";
        break;
      case 2:
        return "Feb";
        break;
      case 3:
        return "Mar";
        break;
      case 4:
        return "Apr";
        break;
      case 5:
        return "May";
        break;
      case 6:
        return "June";
        break;
      case 7:
        return "July";
        break;
      case 8:
        return "Aug";
        break;
      case 9:
        return "Sept";
        break;
      case 10:
        return "Oct";
        break;
      case 11:
        return "Nov";
        break;
      case 12:
        return "Dec";
        break;
      default:
        return "Month";
    }
  }

  List<String> getWeek() {
    int weekNumber = BaseUtil.getWeekNumber();
    var startDate = ((weekNumber - 2) * 7) + (0);
    var endDate = ((weekNumber - 2) * 7) + (6);
    int startDay =
        DateTime.utc(DateTime.now().year, 1, startDate).toLocal().day;
    int endDay = DateTime.utc(DateTime.now().year, 1, endDate).toLocal().day;
    int startMon =
        DateTime.utc(DateTime.now().year, 1, startDate).toLocal().month;
    int endMon = DateTime.utc(DateTime.now().year, 1, endDate).toLocal().month;
    String startMonth = getMonthName(startMon);
    String endMonth = getMonthName(endMon);

    return ["$startDay $startMonth", "$endDay $endMonth"];
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    if (baseProvider.currentWeekWinners == null ||
        baseProvider.currentWeekWinners.isEmpty) {
      isLoading = true;
      getWeekWinners().then((value) {
        if (isLoading) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
    baseProvider.currentWeekWinners.forEach((key, value) {
      currentWeekWinners.add(WeekWinner(
        name: key,
        prize: value.toString(),
      ));
    });
    currentWeekWinners
        .sort((a, b) => int.tryParse(a.prize).compareTo(int.tryParse(b.prize)));
    currentWeekWinners = currentWeekWinners.reversed.toList();
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenWidth * 0.05,
          vertical: SizeConfig.screenHeight * 0.02,
        ),
        padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.03),
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: new LinearGradient(
              colors: [
                Color(0xff1488CC),
                Color(0xff2B32B2),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xff3F7AFF).withOpacity(0.3),
                offset: Offset(0, 5),
                blurRadius: 10,
              ),
              BoxShadow(
                color: Color(0xffECB1B3).withOpacity(0.3),
                offset: Offset(5, 0),
                blurRadius: 10,
              ),
            ]),
        child: Column(
          children: [
            Text(
              "This Week's Winners",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: SizeConfig.largeTextSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Tambola Winners for week: ${getWeek()[0]} to ${getWeek()[1]}", //TODO CHANGE BASED ON WEEK
              style: GoogleFonts.montserrat(
                  color: Colors.white, fontSize: SizeConfig.smallTextSize),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Stack(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: 0.2,
                      child: Image.asset(
                        "images/week-winners.png",
                        height: SizeConfig.screenHeight * 0.35,
                        width: SizeConfig.screenWidth * 0.6,
                      ),
                    )
                  ],
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (currentWeekWinners.length != 0
                        ? Scrollbar(
                            thickness: 20,
                            radius: Radius.circular(100),
                            showTrackOnHover: true,
                            hoverThickness: 10,
                            isAlwaysShown: true,
                            controller: _controller,
                            child: ListView.builder(
                              controller: _controller,
                              physics: BouncingScrollPhysics(),
                              itemCount: currentWeekWinners.length,
                              itemBuilder: (ctx, i) {
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.blockSizeHorizontal * 8,
                                    vertical:
                                        SizeConfig.blockSizeVertical * 0.8,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Text(
                                      '#${i + 1}',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w700,
                                        fontSize: SizeConfig.mediumTextSize,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  //  ClipOval(
                                  //   //TODO
                                  //   child: Image.asset("images/profile.png"),
                                  // ),
                                  title: Text(
                                    "${currentWeekWinners[i].name[0].toUpperCase()}${currentWeekWinners[i].name.substring(1).toLowerCase()}",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: SizeConfig.mediumTextSize,
                                    ),
                                  ),
                                  trailing: Text(
                                    "₹ ${currentWeekWinners[i].prize.toString()}",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: SizeConfig.largeTextSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              "Winners will be updated soon.",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: SizeConfig.largeTextSize,
                              ),
                            ),
                          )),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
