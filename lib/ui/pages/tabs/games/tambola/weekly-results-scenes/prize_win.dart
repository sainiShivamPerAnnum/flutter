import 'package:confetti/confetti.dart';
import 'package:felloapp/core/fcm_listener.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/weekly-results-scenes/winnerbox.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PrizeWin extends StatefulWidget {
  final Map<String, int> winningsMap;
  const PrizeWin({Key key, this.winningsMap}) : super(key: key);

  @override
  _PrizeWinState createState() => _PrizeWinState();
}

class _PrizeWinState extends State<PrizeWin> {
  ConfettiController _confettiController;
  FcmListener fcmProvider;
  bool addedSubscription = false;

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
    fcmProvider = Provider.of<FcmListener>(context, listen: false);
    if (!addedSubscription) {
      fcmProvider.addSubscription(FcmTopic.WINNERWINNER);
      addedSubscription = true;
    }
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
                  Spacer(
                    flex: 1,
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
                        fontSize: SizeConfig.largeTextSize * 0.9,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Prizes will be credited in 1-2 business days",
                      style: GoogleFonts.montserrat(
                          fontSize: SizeConfig.mediumTextSize,
                          letterSpacing: 2),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      AppState.backButtonDispatcher.didPopRoute();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff272727),
                    ),
                    child: Container(
                      height: 50,
                      width: SizeConfig.screenWidth / 3,
                      alignment: Alignment.center,
                      child: Text(
                        "DONE",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: SizeConfig.mediumTextSize * 1.2,
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
