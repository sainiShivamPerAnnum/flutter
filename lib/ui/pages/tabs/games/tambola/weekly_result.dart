import 'package:confetti/confetti.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class WeeklyResult extends StatefulWidget {
  final Map<String, int> winningsmap;
  final bool isEligible;
  const WeeklyResult({Key key, this.isEligible, this.winningsmap})
      : super(key: key);

  @override
  _WeeklyResultState createState() => _WeeklyResultState();
}

class _WeeklyResultState extends State<WeeklyResult> {
  PageController _pageController;
  @override
  void initState() {
    print(widget.isEligible);
    print(widget.winningsmap);
    _pageController = PageController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Future.delayed(Duration(seconds: 3), () {
      if (!widget.isEligible && widget.winningsmap.isNotEmpty)
        _pageController.jumpToPage(3);
      else if (widget.isEligible && widget.winningsmap.isNotEmpty)
        _pageController.jumpToPage(2);
      else
        _pageController.jumpToPage(1);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          const PrizeProcessing(),
          const Loser(),
          PrizeWin(
            winningsMap: widget.winningsmap,
          ),
          PrizePWin(
            winningsMap: widget.winningsmap,
          )
        ],
      ),
    );
  }
}

class PrizeProcessing extends StatelessWidget {
  const PrizeProcessing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5DFC3),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: kToolbarHeight * 1,
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
              Text(
                "Prize Day",
                style: TextStyle(
                    fontFamily: "Cucciolo",
                    color: Color(0xff272727),
                    fontSize: SizeConfig.cardTitleTextSize * 1.6,
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "It's Sunday, and we are processing your tickets to see if any of your tickets won or not ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: SizeConfig.mediumTextSize,
                      height: 1.5,
                      letterSpacing: 2),
                ),
              ),
              LottieBuilder.asset(
                "images/Tambola/process.json",
                width: SizeConfig.screenWidth * 0.5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "PROCESSING...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xffFCB260),
                      fontSize: SizeConfig.largeTextSize,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 5),
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
                  WonTicketBox(
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

class WonTicketBox extends StatelessWidget {
  final Map<String, int> winningsmap;

  const WonTicketBox({Key key, this.winningsmap}) : super(key: key);
  getValue(int val) {
    switch (val) {
      case 1:
        return "Full House";
        break;
      case 2:
        return "Top Row";
        break;
      case 3:
        return "Bottom Row";
        break;
      case 4:
        return "Middle Row";
        break;
      case 5:
        return "Corner";
        break;
    }
  }

  getWinningTicketTiles() {
    List<ListTile> ticketTiles = [];
    winningsmap.forEach((key, value) {
      ticketTiles.add(ListTile(
        leading: Text("#$key"),
        trailing: Text(getValue(value)),
      ));
    });
    return ticketTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight / 2.5,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "Winning Tickets",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  height: 1.5,
                  letterSpacing: 2),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView(children: getWinningTicketTiles()),
          )
        ],
      ),
    );
  }
}

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
                      fontSize: SizeConfig.mediumTextSize, letterSpacing: 2),
                ),
              ),
              Text(
                "Winner",
                style: TextStyle(
                    fontFamily: "Cucciolo",
                    color: Color(0xff272727),
                    fontSize: SizeConfig.cardTitleTextSize * 1.6,
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
              Container(
                height: SizeConfig.screenHeight / 2.5,
                width: SizeConfig.screenWidth,
                child: Stack(
                  children: [
                    WonTicketBox(
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Sorry but you are not eligible for the prize because you have invested less than 100 on fello",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Color(0xffFB743E),
                    fontSize: SizeConfig.mediumTextSize,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  backButtonDispatcher.didPopRoute();
                  backButtonDispatcher.didPopRoute();
                  delegate.appState.setCurrentTabIndex = 2;
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
      ),
    );
  }
}

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
