import 'dart:async';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/ui/dialogs/feedback_dialog.dart';
import 'package:felloapp/ui/dialogs/ticket_details_dialog.dart';
import 'package:felloapp/ui/elements/Parallax-card/data_model.dart';
import 'package:felloapp/ui/elements/Parallax-card/game_card_list.dart';
import 'package:felloapp/ui/elements/leaderboard.dart';
import 'package:felloapp/ui/elements/week-winners.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/submit_button.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:felloapp/ui/dialogs/Fold-Card/card.dart';

class GamePage extends StatefulWidget {
  final ValueChanged<int> tabChange;

  GamePage({this.tabChange});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Game> _gameList;
  Game _currentPage;
  ConfettiController _confeticontroller;
  LocalDBModel lclDbProvider;
  BaseUtil baseProvider;
  DBModel dbProvider;
  int currentPage;
  GlobalKey _showcaseHeader = GlobalKey();
  GlobalKey _showcaseFooter = GlobalKey();

  PageController _controller = new PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    BaseAnalytics.analytics
        .setCurrentScreen(screenName: BaseAnalytics.PAGE_GAME);
    var data = DemoData();
    _gameList = data.getCities();
    _currentPage = _gameList[1];
    currentPage = 0;
    // if (SizeConfig.isGamefirstTime != true) {
    _confeticontroller = new ConfettiController(
      duration: new Duration(seconds: 2),
    );
    // }
  }

  void _handleCityChange(Game game) {
    setState(() {
      this._currentPage = game;
    });
  }

  void checkConfetti() {
    // DateTime date = new DateTime.now();
    // int weekCde = date.year * 100 + BaseUtil.getWeekNumber();
    // lclDbProvider.isConfettiRequired(weekCde).then((flag) {
    //   if (flag) {
    _confeticontroller.play();
    SizeConfig.isGamefirstTime = false;
    //     lclDbProvider.saveConfettiUpdate(weekCde);
    //   }
    // });
  }

  Future<void> _onTicketsRefresh() async {
    //TODO ADD LOADER
    return dbProvider
        .getUserTicketWallet(baseProvider.myUser.uid)
        .then((value) {
      if (value != null) baseProvider.userTicketWallet = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    lclDbProvider = Provider.of<LocalDBModel>(context, listen: false);
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    if (baseProvider.show_game_tutorial) {
      Timer(const Duration(milliseconds: 2100), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ShowCaseWidget.of(context)
              .startShowCase([_showcaseHeader, _showcaseFooter]);
        });
      });
    }
    return RefreshIndicator(
      onRefresh: () async {
        await _onTicketsRefresh();
      },
      child: Container(
        decoration: BoxDecoration(
          color: UiConstants.backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: Stack(
          children: [
            Container(
              height: SizeConfig.screenHeight * 0.45,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/game-asset.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            PageView(
              scrollDirection: Axis.vertical,
              controller: _controller,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                  if (currentPage == 1 && SizeConfig.isGamefirstTime == true) {
                    checkConfetti();
                  }
                });
              },
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: AppBar().preferredSize.height * 2,
                        ),
                        InkWell(
                            onTap: () {
                              HapticFeedback.vibrate();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    TicketDetailsDialog(
                                        baseProvider.userTicketWallet),
                              );
                            },
                            child: BaseUtil.buildShowcaseWrapper(
                                _showcaseHeader,
                                'Your game tickets appear here. You receive 1 game ticket for every ₹${Constants.INVESTMENT_AMOUNT_FOR_TICKET} you save. You can also click here to see a further breakdown.',
                                TicketCount(baseProvider.userTicketWallet
                                    .getActiveTickets()))),
                        Expanded(
                          flex: 4,
                          child: BaseUtil.buildShowcaseWrapper(
                              _showcaseFooter,
                              'Use the tickets to play exciting weekly games and win fun prizes!',
                              GameCardList(
                                games: _gameList,
                                onGameChange: _handleCityChange,
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: SizeConfig.screenWidth,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              children: [
                                GameCard(
                                  gradient: [
                                    Color(0xffACB6E5),
                                    Color(0xff74EBD5),
                                  ],
                                  title: "Want more tickets?",
                                  action: [
                                    GameOfferCardButton(
                                      // onPressed: () => widget.tabChange(2),
                                      onPressed: () => showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (ctx) {
                                          // _confeticontroller.play();
                                          return Center(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Stack(
                                                children: [
                                                  // IF CLAIMED THE SHOW CONFETTI
                                                  // Center(
                                                  //   child: Container(
                                                  //     height: 100,
                                                  //     width: 100,
                                                  //     child: ConfettiWidget(
                                                  //       blastDirectionality:
                                                  //           BlastDirectionality
                                                  //               .explosive,
                                                  //       confettiController:
                                                  //           _confeticontroller,
                                                  //       particleDrag: 0.05,
                                                  //       emissionFrequency: 0.05,
                                                  //       numberOfParticles: 25,
                                                  //       gravity: 0.05,
                                                  //       shouldLoop: false,
                                                  //       colors: [
                                                  //         UiConstants
                                                  //             .primaryColor,
                                                  //         Color(0xfff7ff00),
                                                  //         Color(0xffFC5C7D),
                                                  //         Color(0xff2B32B2),
                                                  //       ],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  Center(child: FCard()),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      title: "Invest",
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GameOfferCardButton(
                                      onPressed: () => widget.tabChange(3),
                                      title: "Share",
                                    ),
                                  ],
                                ),
                                GameCard(
                                  gradient: [
                                    Color(0xffD4AC5B),
                                    Color(0xffDECBA4),
                                  ],
                                  title: "Share your thoughts with us",
                                  action: [
                                    GameOfferCardButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              FeedbackDialog(
                                            title: "Tell us what you think",
                                            description:
                                                "We'd love to hear from you",
                                            buttonText: "Submit",
                                            dialogAction: (String fdbk) {
                                              if (fdbk != null &&
                                                  fdbk.isNotEmpty) {
                                                //feedback submission allowed even if user not signed in
                                                dbProvider
                                                    .submitFeedback(
                                                        (baseProvider.firebaseUser ==
                                                                    null ||
                                                                baseProvider
                                                                        .firebaseUser
                                                                        .uid ==
                                                                    null)
                                                            ? 'UNKNOWN'
                                                            : baseProvider
                                                                .firebaseUser
                                                                .uid,
                                                        fdbk)
                                                    .then((flag) {
                                                  Navigator.of(context).pop();
                                                  if (flag) {
                                                    baseProvider.showPositiveAlert(
                                                        'Thank You',
                                                        'We appreciate your feedback!',
                                                        context);
                                                  }
                                                });
                                              }
                                            },
                                          ),
                                        );
                                      },
                                      title: "Feedback",
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: AppBar().preferredSize.height,
                      ),
                      WeekWinnerBoard(),
                      Leaderboard(),
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: 100,
              width: 100,
              child: ConfettiWidget(
                blastDirectionality: BlastDirectionality.explosive,
                confettiController: _confeticontroller,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 25,
                gravity: 0.05,
                shouldLoop: false,
                colors: [
                  UiConstants.primaryColor,
                  Color(0xfff7ff00),
                  Color(0xffFC5C7D),
                  Color(0xff2B32B2),
                ],
              ),
            ),
            currentPage == 0
                ? Positioned(
                    bottom: 10,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LottieBuilder.asset(
                            'images/lottie/swipeup.json',
                            height: SizeConfig.screenHeight * 0.05,
                          ),
                          Text(
                            "Swipe up to see prizes and leaderboards",
                            style: GoogleFonts.montserrat(
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            // Expanded(
            //   child: Container(
            //     child: BackdropFilter(
            //       filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            //       child: Center(
            //         child: Card(
            //           margin: EdgeInsets.symmetric(horizontal: 40),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(20)),
            //           child: Wrap(
            //             children: [
            //               Container(
            //                 padding: EdgeInsets.all(20),
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.center,
            //                   children: [
            //                     LottieBuilder.asset(
            //                       "images/lottie/winner.json",
            //                       width: SizeConfig.screenWidth * 0.4,
            //                       height: SizeConfig.screenWidth * 0.4,
            //                     ),
            //                     SizedBox(
            //                       height: 20,
            //                     ),
            //                     Text(
            //                       "Hurray, You are a Winner",
            //                       style: Theme.of(context).textTheme.headline5,
            //                     ),
            //                     Text("For week 4 June to 11 June"),
            //                     // Padding(
            //                     //   padding: const EdgeInsets.all(8.0),
            //                     //   child: Text(
            //                     //     "Winning amount: \$20",
            //                     //     style: Theme.of(context)
            //                     //         .textTheme
            //                     //         .headline4
            //                     //         .copyWith(
            //                     //             color: UiConstants.primaryColor),
            //                     //   ),
            //                     // ),
            //                     // Container(
            //                     //   decoration: BoxDecoration(
            //                     //     borderRadius: BorderRadius.circular(15),
            //                     //     border: Border.all(
            //                     //       width: 2,
            //                     //       color: UiConstants.primaryColor,
            //                     //     ),
            //                     //   ),
            //                     //   padding: EdgeInsets.symmetric(
            //                     //       horizontal: 20, vertical: 10),
            //                     //   margin: EdgeInsets.all(10),
            //                     //   child: Row(
            //                     //     mainAxisAlignment: MainAxisAlignment.center,
            //                     //     children: [
            //                     //       SvgPicture.asset(
            //                     //           "images/svgs/amazon-gift-voucher.svg",
            //                     //           height: 20,
            //                     //           width: 20),
            //                     //       SizedBox(
            //                     //         width: 10,
            //                     //       ),
            //                     //       Text(
            //                     //           "Reedem it with Amazon gift voucher"),
            //                     //     ],
            //                     //   ),
            //                     // ),
            //                     // Text("Or"),
            //                     // Container(
            //                     //   decoration: BoxDecoration(
            //                     //     borderRadius: BorderRadius.circular(15),
            //                     //     border: Border.all(
            //                     //       width: 2,
            //                     //       color: UiConstants.primaryColor,
            //                     //     ),
            //                     //   ),
            //                     //   padding: EdgeInsets.symmetric(
            //                     //       horizontal: 20, vertical: 10),
            //                     //   margin: EdgeInsets.all(10),
            //                     //   child: Row(
            //                     //     mainAxisAlignment: MainAxisAlignment.center,
            //                     //     children: [
            //                     //       SvgPicture.asset("images/svgs/gold.svg",
            //                     //           height: 20, width: 20),
            //                     //       SizedBox(
            //                     //         width: 10,
            //                     //       ),
            //                     //       Text("Reedem it Augmont Gold"),
            //                     //     ],
            //                     //   ),
            //                     // ),
            //                     SubmitButton(
            //                         action: () {},
            //                         title: "Claim your prize now",
            //                         isDisabled: false)
            //                   ],
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class TicketCount extends StatefulWidget {
  final int totalCount;

  TicketCount(this.totalCount);

  @override
  _TicketCountState createState() => _TicketCountState();
}

class _TicketCountState extends State<TicketCount>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  double _latestBegin;
  double _latestEnd;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _latestBegin = 0;
    _latestEnd = widget.totalCount + .0;
  }

  @override
  Widget build(BuildContext context) {
    if (SizeConfig.isGamefirstTime == true) {
      CurvedAnimation curvedAnimation =
          CurvedAnimation(parent: _controller, curve: Curves.decelerate);
      _animation =
          Tween<double>(begin: 0, end: _latestEnd).animate(curvedAnimation);

      if (0 != _latestBegin || widget.totalCount != _latestEnd) {
        _controller.reset();
      }

      _latestBegin = 0;
      _latestEnd = widget.totalCount + .0;
      _controller.addListener(() {
        setState(() {});
      });
      _controller.forward();
    }

    return Container(
      child: Column(
        children: [
          Text(
            _animation != null
                ? _animation.value.round().toString()
                : "${widget.totalCount}",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: SizeConfig.screenHeight * 0.08,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "Tickets",
            style: GoogleFonts.montserrat(
                color: Colors.white, fontSize: SizeConfig.mediumTextSize),
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title, buttonText;
  final List<Color> gradient;
  final List<Widget> action;

  GameCard({this.buttonText, this.title, this.gradient, this.action});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
        bottom: SizeConfig.screenHeight * 0.05,
        left: width * 0.05,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: new LinearGradient(
            colors: gradient,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
            BoxShadow(
              color: gradient[1].withOpacity(0.3),
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
          ]),
      width: width * 0.8,
      child: Stack(
        children: [
          // Positioned(
          //   right: 10,
          //   bottom: 0,
          //   child: Opacity(
          //     opacity: 0.3,
          //     child: Image.asset(
          //       asset,
          //       height: height * 0.25,
          //       width: width * 0.5,
          //     ),
          //   ),
          // ),
          Container(
            width: width * 0.8,
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(5, 5),
                          color: Colors.black26,
                          blurRadius: 10,
                        )
                      ],
                      fontWeight: FontWeight.w700,
                      fontSize: width * 0.06),
                ),
                Row(
                  children: action,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GameOfferCardButton extends StatelessWidget {
  final Function onPressed;
  final String title;

  GameOfferCardButton({this.onPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.white,
          ),
          color: Colors.transparent,
          // boxShadow: [
          //   BoxShadow(
          //       color: gradient[0].withOpacity(0.2),
          //       blurRadius: 20,
          //       offset: Offset(5, 5),
          //       spreadRadius: 10),
          // ],
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
              color: Colors.white, fontSize: SizeConfig.mediumTextSize),
        ),
      ),
    ));
  }
}
