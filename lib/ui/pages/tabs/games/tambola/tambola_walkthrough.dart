import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Walkthrough extends StatelessWidget {
  const Walkthrough({Key key}) : super(key: key);

  static const List<String> dailyPicks = [
    "Every day 5 random numbers are picked out from 1 to 90 at 6 pm",
    "You can view all the picks of this week by pulling the card down",
  ];
  static const List<String> tambolatickets = [
    "This is how a Fello Tambola ticket looks which is very simple and easy to understand ",
    "Every card has atleast 15 numbers and based on weekly picks, they get crossed out automagically",
    "Odds section gives the straight forward count of all the winning odds.",
  ];
  static const List<String> prizes = [
    "Every SUNDAY, tickets get processed (only if you open the game on that day).",
    "If any of your tickets clears any of the odds completely, you are awarded with the cash prize",
    "Complete list of all the winners can be seen in the game section",
  ];

  List<Widget> generatePoints(List<String> points) {
    return points
        .map(
          (e) => Container(
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.symmetric(
            vertical: 10, horizontal: SizeConfig.blockSizeHorizontal * 3),
        child: Row(
          children: [
            CircleAvatar(
              radius: 4,
              backgroundColor: Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                e,
                style: TextStyle(fontSize: SizeConfig.mediumTextSize),
              ),
            ),
          ],
        ),
      ),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiConstants.primaryColor,
        elevation: 2,
        shadowColor: Color(0xff0C9463).withOpacity(0.5),
        title: Text(
          "Walkthrough",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              delegate.appState.currentAction =
                  PageAction(state: PageState.addPage, page: SupportPageConfig);
            },
            icon: Icon(Icons.contact_support_outlined),
          ),
        ],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Daily Picks",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Image.asset(
              "images/Tambola/w-picks.png",
              width: SizeConfig.screenWidth,
            ),
            Column(children: generatePoints(dailyPicks)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Tambola tickets",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Image.asset(
              "images/Tambola/w-ticket.png",
              width: SizeConfig.screenWidth,
              fit: BoxFit.cover,
            ),
            Column(children: generatePoints(tambolatickets)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Cash Prizes",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Image.asset(
              "images/Tambola/w-prize.png",
              width: SizeConfig.screenWidth,
              fit: BoxFit.cover,
            ),
            Column(children: generatePoints(prizes)),
          ],
        ),
      ),
    );
  }
}