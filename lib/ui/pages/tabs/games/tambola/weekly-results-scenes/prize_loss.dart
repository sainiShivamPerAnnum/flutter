import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Loser extends StatelessWidget {
  const Loser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5DFC3),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Spacer(),
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
              Spacer(),
              SvgPicture.asset(
                "images/svgs/tambola-lose.svg",
                width: SizeConfig.screenWidth * 0.8,
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: SizeConfig.blockSizeHorizontal * 5),
                child: Text(
                  "More number of tickets you have, more Is your chances of winning. Get tickets now!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      fontSize: SizeConfig.mediumTextSize,
                      height: 1.5,
                      letterSpacing: 2),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        AppState.backButtonDispatcher.didPopRoute();
                        AppState.backButtonDispatcher.didPopRoute();
                        AppState.delegate.appState.setCurrentTabIndex = 3;
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff272727),
                      ),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Share",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: SizeConfig.mediumTextSize * 1.2,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        AppState.backButtonDispatcher.didPopRoute();
                        AppState.backButtonDispatcher.didPopRoute();
                        AppState.delegate.appState.setCurrentTabIndex = 2;
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff53C5AE),
                      ),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Invest",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: SizeConfig.mediumTextSize * 1.2,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockSizeHorizontal * 3),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "₹ 25 and 10 Tickets\nper share",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      "₹ 100 saved = 1 ticket",
                      textAlign: TextAlign.center,
                    ))
                  ],
                ),
              ),
              Spacer(
                flex: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
