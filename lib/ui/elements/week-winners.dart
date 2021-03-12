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
    currentWeekWinners = [];
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
              "Tambola Winners for week: 15 Feb to 21 Feb", //TODO CHANGE BASED ON WEEK
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
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: currentWeekWinners.length,
                        itemBuilder: (ctx, i) {
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockSizeHorizontal * 8,
                              vertical: SizeConfig.blockSizeVertical * 0.8,
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
              ]),
            )
          ],
        ),
      ),
    );
  }
}
