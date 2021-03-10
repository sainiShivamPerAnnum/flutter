import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekWinnerBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
        padding: EdgeInsets.only(top: height * 0.03),
        width: width,
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
                fontSize: height * 0.024,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Tambola Winners for week: 15 Feb to 21 Feb",
              style: GoogleFonts.montserrat(
                color: Colors.black87,
                fontSize: height * 0.012,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: weekWinnersList.length,
                itemBuilder: (ctx, i) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 6,
                      vertical: SizeConfig.blockSizeVertical * 0.8,
                    ),
                    leading: ClipOval(
                      child: Image.network(weekWinnersList[i].avatar),
                    ),
                    title: Text(
                      weekWinnersList[i].name,
                      style: GoogleFonts.montserrat(
                        color: Colors.black87,
                        fontSize: SizeConfig.mediumTextSize,
                      ),
                    ),
                    trailing: Text(
                      weekWinnersList[i].prize,
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

List<WeekWinner> weekWinnersList = [
  WeekWinner(
    avatar:
        "http://t3.gstatic.com/images?q=tbn:ANd9GcQw-reFu5eeRMoSapJYzoDUIxIYosqNkwK63UgUTspEPayytpszE0zNWI6eWwzv",
    name: "Stanlee",
    prize: "200",
  ),
  WeekWinner(
    avatar:
        "http://t3.gstatic.com/images?q=tbn:ANd9GcQw-reFu5eeRMoSapJYzoDUIxIYosqNkwK63UgUTspEPayytpszE0zNWI6eWwzv",
    name: "Stanlee",
    prize: "200",
  ),
  WeekWinner(
    avatar:
        "http://t3.gstatic.com/images?q=tbn:ANd9GcQw-reFu5eeRMoSapJYzoDUIxIYosqNkwK63UgUTspEPayytpszE0zNWI6eWwzv",
    name: "Stanlee",
    prize: "200",
  ),
  WeekWinner(
    avatar:
        "http://t3.gstatic.com/images?q=tbn:ANd9GcQw-reFu5eeRMoSapJYzoDUIxIYosqNkwK63UgUTspEPayytpszE0zNWI6eWwzv",
    name: "Stanlee",
    prize: "200",
  ),
  WeekWinner(
    avatar:
        "http://t3.gstatic.com/images?q=tbn:ANd9GcQw-reFu5eeRMoSapJYzoDUIxIYosqNkwK63UgUTspEPayytpszE0zNWI6eWwzv",
    name: "Stanlee",
    prize: "200",
  ),
  WeekWinner(
    avatar:
        "http://t3.gstatic.com/images?q=tbn:ANd9GcQw-reFu5eeRMoSapJYzoDUIxIYosqNkwK63UgUTspEPayytpszE0zNWI6eWwzv",
    name: "Stanlee",
    prize: "200",
  ),
];
