import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/winnerbox.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrizePWin extends StatefulWidget {
  final Map<String, int> winningsMap;
  const PrizePWin({Key key, this.winningsMap}) : super(key: key);

  @override
  _PrizePWinState createState() => _PrizePWinState();
}

class _PrizePWinState extends State<PrizePWin> {
  double slothPos = 0, slothOpacity = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          slothOpacity = 1;
          slothPos = SizeConfig.screenWidth * 0.16;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5DFC3),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Spacer(
                flex: 3,
              ),
              Text(
                "CONGRATULATIONS",
                style: TextStyle(
                    color: Color(0xff272727),
                    fontSize: SizeConfig.cardTitleTextSize,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    shadows: [
                      BoxShadow(
                          color: Color(0xffFCB260).withOpacity(0.8),
                          offset: Offset(1, 1),
                          blurRadius: 5,
                          spreadRadius: 5)
                    ]),
              ),
              Spacer(),
              Container(
                height: SizeConfig.screenHeight / 2.5,
                width: SizeConfig.screenWidth,
                child: Stack(
                  children: [
                    WinnerBox(
                      winningsmap: widget.winningsMap,
                    ),
                    AnimatedPositioned(
                      child: AnimatedOpacity(
                        opacity: slothOpacity,
                        duration: Duration(seconds: 2),
                        child: Image.asset(
                          "images/Tambola/sloth.png",
                          height: SizeConfig.screenHeight / 3.5,
                          width: SizeConfig.screenWidth * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                      top: slothPos,
                      left: -20,
                      duration: Duration(seconds: 2),
                    )
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Sorry but you are not eligible for the prize because you have invested less than 100 on fello",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Color(0xffFB743E),
                    fontSize: SizeConfig.mediumTextSize * 1.2,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "GEAR UP FOR NEXT WEEK",
                  style: GoogleFonts.montserrat(
                      fontSize: SizeConfig.mediumTextSize, letterSpacing: 2),
                ),
              ),
              ElevatedButton(
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
                  width: SizeConfig.screenWidth / 2,
                  alignment: Alignment.center,
                  child: Text(
                    "Invest Now!",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: SizeConfig.mediumTextSize * 1.2,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
              Spacer(
                flex: 3,
              )
            ],
          ),
        ),
      ),
    );
  }
}
