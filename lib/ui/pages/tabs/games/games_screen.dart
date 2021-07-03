import 'dart:async';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/Fold-Card/card.dart';
import 'package:felloapp/ui/dialogs/feedback_dialog.dart';
import 'package:felloapp/ui/dialogs/ticket_details_dialog.dart';
import 'package:felloapp/ui/elements/Parallax-card/data_model.dart';
import 'package:felloapp/ui/elements/Parallax-card/game_card_list.dart';
import 'package:felloapp/ui/elements/leaderboard.dart';
import 'package:felloapp/ui/elements/week-winners.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';

class GamePage extends StatefulWidget {
  // final ValueChanged<int> tabChange;

  // GamePage({this.tabChange});

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
  AppState appState;

  GlobalKey _showcaseHeader = GlobalKey();
  GlobalKey _showcaseFooter = GlobalKey();

  PageController _controller;

  @override
  void initState() {
    super.initState();
    BaseAnalytics.analytics
        .setCurrentScreen(screenName: BaseAnalytics.PAGE_GAME);
    var data = DemoData();
    _gameList = data.getCities();
    _currentPage = _gameList[1];
    // if (SizeConfig.isGamefirstTime != true) {
    _confeticontroller = new ConfettiController(
      duration: new Duration(seconds: 2),
    );
    _controller = new PageController(
      initialPage: AppState().getCurrentGameIndex,
    );
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateToPage(appState.getCurrentGameTabIndex,
          duration: Duration(milliseconds: 600), curve: Curves.decelerate);
    });
  }

  void _handleGameChange(Game game) {
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
    appState = Provider.of<AppState>(context, listen: false);
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
          borderRadius: SizeConfig.homeViewBorder,
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
            SafeArea(
              child: PageView(
                scrollDirection: Axis.vertical,
                controller: _controller,
                onPageChanged: (int page) {
                  setState(() {
                    appState.setCurrentGameTabIndex = page;
                  });
                  if (appState.getCurrentGameTabIndex == 1 &&
                      SizeConfig.isGamefirstTime == true) {
                    checkConfetti();
                  }
                },
                children: [
                  ClipRRect(
                    borderRadius: SizeConfig.homeViewBorder,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(
                            flex: 2,
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
                                  .getActiveTickets()),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          BaseUtil.buildShowcaseWrapper(
                            _showcaseFooter,
                            'Use the tickets to play exciting weekly games and win fun prizes!',
                            GameCardList(
                              games: _gameList,
                              onGameChange: _handleGameChange,
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Container(
                            height: SizeConfig.screenHeight * 0.2,
                            width: SizeConfig.screenWidth,
                            child: ListView(
                              shrinkWrap: true,
                              itemExtent: SizeConfig.screenWidth * 0.8,
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
                                      onPressed: () => delegate
                                          .parseRoute(Uri.parse("finance")),

                                      ///TODO remove post testing
                                      // onPressed: () => showDialog(
                                      //   context: context,
                                      //   barrierDismissible: false,
                                      //   builder: (ctx) {
                                      //     return Center(
                                      //       child: Material(
                                      //         color: Colors.transparent,
                                      //         child: Stack(
                                      //           children: [
                                      //             Center(child: FCard()),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                      title: "Invest",
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GameOfferCardButton(
                                      onPressed: () => delegate
                                          .parseRoute(Uri.parse("profile")),
                                      title: "Share",
                                    ),
                                  ],
                                ),
                                GameCard(
                                  gradient: [
                                    Color(0xffD4AC5B),
                                    Color(0xffDECBA4),
                                  ],
                                  title: "Share your thoughts",
                                  action: [
                                    GameOfferCardButton(
                                      onPressed: () {
                                        AppState.screenStack
                                            .add(ScreenItem.dialog);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              WillPopScope(
                                            onWillPop: () {
                                              backButtonDispatcher
                                                  .didPopRoute();
                                              return Future.value(true);
                                            },
                                            child: FeedbackDialog(
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
                                                    backButtonDispatcher
                                                        .didPopRoute();
                                                    if (flag) {
                                                      baseProvider
                                                          .showPositiveAlert(
                                                              'Thank You',
                                                              'We appreciate your feedback!',
                                                              context);
                                                    }
                                                  });
                                                }
                                              },
                                            ),
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
                          Spacer(
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: SizeConfig.homeViewBorder,
                    child: Column(
                      children: [
                        Container(
                          height: kToolbarHeight * 0.8,
                        ),
                        WeekWinnerBoard(),
                        Leaderboard(),
                      ],
                    ),
                  )
                ],
              ),
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
            appState.getCurrentGameTabIndex == 0
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
                            style: TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
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
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Tickets",
            style: TextStyle(
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
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 5,
          ),
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
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
          width: SizeConfig.screenWidth * 0.8,
          height: SizeConfig.screenHeight * 0.16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(5, 5),
                        color: Colors.black26,
                        blurRadius: 10,
                      )
                    ],
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.screenWidth * 0.06),
              ),
              SizedBox(height: 10),
              Row(
                children: action,
              )
            ],
          ),
        ),
      ],
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
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            style: TextStyle(
                color: Colors.white, fontSize: SizeConfig.mediumTextSize),
          ),
        ),
      ),
    );
  }
}
