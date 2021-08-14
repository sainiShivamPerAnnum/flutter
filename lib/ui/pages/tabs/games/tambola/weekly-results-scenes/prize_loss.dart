import 'package:felloapp/main.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Loser extends StatelessWidget {
  const Loser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5DFC3),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  "images/Tambola/loser.png",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: kToolbarHeight * 1.6,
                    width: SizeConfig.screenWidth,
                    child: Center(
                      child: Image.asset(
                        "images/fello_logo.png",
                        height: kToolbarHeight * 0.8,
                      ),
                    ),
                  ),
                  Text(
                    "Oops!",
                    style: GoogleFonts.montserrat(
                        color: Color(0xff272727),
                        fontSize: SizeConfig.cardTitleTextSize * 1.4,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                        shadows: [
                          BoxShadow(
                              color: Color(0xffFCB260).withOpacity(0.8),
                              offset: Offset(1, 1),
                              blurRadius: 5,
                              spreadRadius: 5)
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      "None of your tickets matched this week",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Color(0xffFCB260),
                        fontSize: SizeConfig.largeTextSize,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      "More number of tickets you have, more Is your chances of winning. You can get more tickets by",
                      style: GoogleFonts.montserrat(
                          fontSize: SizeConfig.mediumTextSize,
                          height: 1.5,
                          letterSpacing: 2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                        children: [
                      "Investing in available funds",
                      "Sharing Fello with your friends"
                    ]
                            .map((e) => Container(
                                  height: 40,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 4,
                                        backgroundColor: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        e,
                                        style: GoogleFonts.montserrat(
                                          fontSize: SizeConfig.mediumTextSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList()),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      backButtonDispatcher.didPopRoute();
                      backButtonDispatcher.didPopRoute();
                      delegate.appState.setCurrentTabIndex = 3;
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff53C5AE),
                    ),
                    child: Container(
                      height: 50,
                      width: SizeConfig.screenWidth / 2,
                      alignment: Alignment.center,
                      child: Text(
                        "Share now and get ₹25",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      backButtonDispatcher.didPopRoute();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff272727),
                    ),
                    child: Container(
                      height: 50,
                      width: SizeConfig.screenWidth / 2,
                      alignment: Alignment.center,
                      child: Text(
                        "Back to Game",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
