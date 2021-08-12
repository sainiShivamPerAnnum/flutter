import 'package:confetti/confetti.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/weekly-results-scenes/winnerbox.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PrizeWin extends StatefulWidget {
  final Map<String, int> winningsMap;
  const PrizeWin({Key key, this.winningsMap}) : super(key: key);

  @override
  _PrizeWinState createState() => _PrizeWinState();
}

class _PrizeWinState extends State<PrizeWin> {
  ConfettiController _confettiController;

  @override
  void initState() {
    _confettiController = new ConfettiController(
      duration: new Duration(seconds: 2),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _confettiController.play();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5DFC3),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: 0.4,
                child: SvgPicture.asset(
                  "images/Tambola/gifts.svg",
                  width: SizeConfig.screenWidth,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                    width: SizeConfig.screenWidth,
                    child: Center(
                      child: Image.asset(
                        "images/fello_logo.png",
                        height: kToolbarHeight * 0.8,
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "YOU ARE A",
                      style: GoogleFonts.montserrat(
                          fontSize: SizeConfig.mediumTextSize,
                          letterSpacing: 2),
                    ),
                  ),
                  Text(
                    "Winner",
                    style: TextStyle(
                        fontFamily: "Cucciolo",
                        color: Color(0xff272727),
                        fontSize: SizeConfig.cardTitleTextSize * 2,
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
                  WinnerBox(
                    winningsmap: widget.winningsMap,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      "Your tickets have been submitted for processing your prize",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Color(0xff10AB8F),
                        fontSize: SizeConfig.mediumTextSize,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
            Container(
              height: 100,
              width: 100,
              child: ConfettiWidget(
                blastDirectionality: BlastDirectionality.explosive,
                confettiController: _confettiController,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 25,
                gravity: 0.05,
                shouldLoop: false,
                colors: [
                  Color(0xff10AB8F),
                  Color(0xfff7ff00),
                  Color(0xffFC5C7D),
                  Color(0xff2B32B2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
