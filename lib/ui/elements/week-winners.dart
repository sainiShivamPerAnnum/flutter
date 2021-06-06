import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/TambolaWinnersDetail.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WeekWinnerBoard extends StatefulWidget {
  @override
  _WeekWinnerBoardState createState() => _WeekWinnerBoardState();
}

class _WeekWinnerBoardState extends State<WeekWinnerBoard> {
  bool isLoading = false;
  DBModel dbProvider;
  BaseUtil baseProvider;
  ScrollController _controller;
  List<WeekWinner> _weekPrizeWinnersList;
  
  @override
  void initState() {
    _controller = ScrollController();
    _weekPrizeWinnersList = [];
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> getWeek() {
    int weekNumber = BaseUtil.getWeekNumber(); //12
    var date = ((weekNumber - 2) * 7);
    var weekEnd = DateTime.utc(DateTime.now().year, 1, date).toLocal().weekday;
    var startDate = date - (weekEnd - 1);
    var endDate = date + (7 - weekEnd);
    int startDay =
        DateTime.utc(DateTime.now().year, 1, startDate).toLocal().day;
    int endDay = DateTime.utc(DateTime.now().year, 1, endDate).toLocal().day;
    int startMon =
        DateTime.utc(DateTime.now().year, 1, startDate).toLocal().month;
    int endMon = DateTime.utc(DateTime.now().year, 1, endDate).toLocal().month;
    String startMonth = BaseUtil.getMonthName(startMon);
    String endMonth = BaseUtil.getMonthName(endMon);

    return ["$startDay $startMonth", "$endDay $endMonth"];
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    if (!baseProvider.isWeekWinnersFetched) {
      isLoading = true;
      dbProvider.getWeeklyWinners().then((TambolaWinnersDetail vObj) {
        if (vObj != null && vObj.isWinnerListAvailable) {
          baseProvider.tambolaWinnersDetail = vObj;
          _weekPrizeWinnersList = vObj.winnerList;
        }
        baseProvider.isWeekWinnersFetched = true;
        if (isLoading) {
          isLoading = false;
          setState(() {});
        }
      });
    }
    _weekPrizeWinnersList
        .sort((a, b) => (a.prize).compareTo(b.prize));
    _weekPrizeWinnersList =
        _weekPrizeWinnersList.reversed.toList();
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
              "Last Week's Winners",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: SizeConfig.largeTextSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Tambola Winners for week: ${getWeek()[0]} to ${getWeek()[1]}",
              //TODO CHANGE BASED ON WEEK
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
                    : (_weekPrizeWinnersList.length != 0
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
                              itemCount: baseProvider
                                  .tambolaWinnersDetail.winnerList.length,
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
                                    "${_weekPrizeWinnersList[i].name[0].toUpperCase()}${_weekPrizeWinnersList[i].name.substring(1).toLowerCase()}",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: SizeConfig.mediumTextSize,
                                    ),
                                  ),
                                  trailing: Text(
                                    "₹ ${_weekPrizeWinnersList[i].prize.toString()}",
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
