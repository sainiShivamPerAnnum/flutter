import 'package:felloapp/base_util.dart';
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
  List<WeekWinner> weekWinnersList;

  Future<void> getWeekWinners() async {
    baseProvider.currentWeekWinners = await dbProvider.getWeeklyWinners();
    weekWinnersList = [];
    print("Got the list --------------------");
    print(baseProvider.currentWeekWinners);
    baseProvider.currentWeekWinners.forEach((key, value) {
      weekWinnersList.add(WeekWinner(//TODO
          name: key, prize: value.toString(), avatar: "images/profile.png"));
    });
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    if (baseProvider.currentWeekWinners == null || baseProvider.currentWeekWinners.isEmpty) {
      isLoading = true;
      getWeekWinners().then((value) {
        if (isLoading) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
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
                Color(0xfff7797d),
                Color(0xffFBD786),
                Color(0xffC6FFDD),
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
                color: Colors.black87,
                fontSize: SizeConfig.largeTextSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Tambola Winners for week: 15 Feb to 21 Feb", //TODO CHANGE BASED ON WEEK
              style: GoogleFonts.montserrat(
                  color: Colors.black87, fontSize: SizeConfig.smallTextSize),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: weekWinnersList.length,
                      itemBuilder: (ctx, i) {
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 6,
                            vertical: SizeConfig.blockSizeVertical * 0.8,
                          ),
                          leading: ClipOval(//TODO
                            child: Image.asset(weekWinnersList[i].avatar),
                          ),
                          title: Text(
                            weekWinnersList[i].name,
                            style: GoogleFonts.montserrat(
                              color: Colors.black87,
                              fontSize: SizeConfig.mediumTextSize,
                            ),
                          ),
                          trailing: Text(
                            weekWinnersList[i].prize.toString(),
                            style: GoogleFonts.montserrat(
                              color: Colors.black87,
                              fontSize: SizeConfig.mediumTextSize,
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class WeekWinner {
  final String avatar, name, prize;
  WeekWinner({this.avatar, this.name, this.prize});
}

// List<WeekWinner> weekWinnersList = [
//   WeekWinner(
//     avatar:
//         "http://t3.gstatic.com/images?q=tbn:ANd9GcQw-reFu5eeRMoSapJYzoDUIxIYosqNkwK63UgUTspEPayytpszE0zNWI6eWwzv",
//     name: "Stanlee",
//     prize: "200",
//   ),
//   WeekWinner(
//     avatar:
//         "http://t3.gstatic.com/images?q=tbn:ANd9GcQw-reFu5eeRMoSapJYzoDUIxIYosqNkwK63UgUTspEPayytpszE0zNWI6eWwzv",
//     name: "Stanlee",
//     prize: "200",
//   ),
//   WeekWinner(
//     avatar:
//         "http://t3.gstatic.com/images?q=tbn:ANd9GcQw-reFu5eeRMoSapJYzoDUIxIYosqNkwK63UgUTspEPayytpszE0zNWI6eWwzv",
//     name: "Stanlee",
//     prize: "200",
//   ),
//   WeekWinner(
//     avatar:
//         "http://t3.gstatic.com/images?q=tbn:ANd9GcQw-reFu5eeRMoSapJYzoDUIxIYosqNkwK63UgUTspEPayytpszE0zNWI6eWwzv",
//     name: "Stanlee",
//     prize: "200",
//   ),
//   WeekWinner(
//     avatar:
//         "http://t3.gstatic.com/images?q=tbn:ANd9GcQw-reFu5eeRMoSapJYzoDUIxIYosqNkwK63UgUTspEPayytpszE0zNWI6eWwzv",
//     name: "Stanlee",
//     prize: "200",
//   ),
//   WeekWinner(
//     avatar:
//         "http://t3.gstatic.com/images?q=tbn:ANd9GcQw-reFu5eeRMoSapJYzoDUIxIYosqNkwK63UgUTspEPayytpszE0zNWI6eWwzv",
//     name: "Stanlee",
//     prize: "200",
//   ),
// ];
