import 'dart:async';
import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/tambola_generation_service.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/tambola_board_view.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/show_all_tickets.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/tambola_walkthrough.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/weekly_result.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TambolaHome extends StatefulWidget {
  const TambolaHome({Key key}) : super(key: key);

  @override
  _TambolaHomeState createState() => _TambolaHomeState();
}

class _TambolaHomeState extends State<TambolaHome> {
  double topCardHeight = SizeConfig.screenWidth * 0.76;
  bool isShowingAllPicks = false;
  double titleOpacity = 1;

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta > 1.5) {
      topCardHeight = SizeConfig.screenHeight * 0.76;
      titleOpacity = 0;
      isShowingAllPicks = true;
    } else {
      topCardHeight = SizeConfig.screenWidth * 0.76;
      isShowingAllPicks = false;
      setState(() {});
      Future.delayed(Duration(milliseconds: 500), () {
        titleOpacity = 1;
        setState(() {});
      });
    }
    setState(() {});
  }

  Log log = new Log('CardScreen');
  TambolaBoard _currentBoard;
  Ticket _currentBoardView;
  bool _winnerDialogCalled = false;

  List<Ticket> _tambolaBoardViews;
  List<TambolaBoard> _bestTambolaBoards;
  List<Widget> balls = [];

  var rnd = new Random();
  BaseUtil baseProvider;
  DBModel dbProvider;
  FcmHandler fcmProvider;
  LocalDBModel localDBModel;

  bool ticketsBeingGenerated = true;
  bool dailyPickHeaderWithTimings = false;
  String dailyPickHeaderText = 'Today\'s picks';
  List<String> dailyPickTextList = [];

  TambolaGenerationService _tambolaTicketService;

  @override
  void initState() {
    super.initState();
    initDailyPickFlags();
    BaseAnalytics.analytics
        .setCurrentScreen(screenName: BaseAnalytics.PAGE_TAMBOLA);
    _tambolaTicketService = new TambolaGenerationService();
  }

  initDailyPickFlags() {
    String remoteStr1 = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.TAMBOLA_HEADER_FIRST);
    String remoteStr2 = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.TAMBOLA_HEADER_SECOND);

    dailyPickTextList.add(remoteStr1);
    dailyPickTextList.add(remoteStr2);
  }

  _init() async {
    if (baseProvider == null || dbProvider == null) {
      return;
    }

    ///first get the daily picks of this week
    if (!baseProvider.weeklyDrawFetched) {
      log.debug('Requesting for weekly picks');
      DailyPick _picks = await dbProvider.getWeeklyPicks();
      baseProvider.weeklyDrawFetched = true;
      if (_picks != null) {
        baseProvider.weeklyDigits = _picks;
      }
      setState(() {});
    }

    ///next get the tambola tickets of this week
    if (!baseProvider.weeklyTicksFetched) {
      List<TambolaBoard> _boards =
          await dbProvider.getWeeksTambolaTickets(baseProvider.myUser.uid);
      baseProvider.weeklyTicksFetched = true;
      if (_boards != null) {
        baseProvider.userWeeklyBoards = _boards;
        //refresh current view
        _currentBoard = null;
        _currentBoardView = null;
      }
      setState(() {});
    }

    ///check if new tambola tickets need to be generated
    bool _isGenerating = await _tambolaTicketService
        .processTicketGenerationRequirement(_activeTambolaCardCount);
    if (_isGenerating) {
      ticketsBeingGenerated = true;
      _tambolaTicketService.setTambolaTicketGenerationResultListener((flag) {
        ticketsBeingGenerated = false;
        if (flag == TambolaGenerationService.GENERATION_COMPLETE) {
          //new tickets have arrived
          _refreshTambolaTickets();
          baseProvider.showPositiveAlert('Tickets successfully generated 🥳',
              'Your weekly odds are now way better!', context);
        } else if (flag ==
            TambolaGenerationService.GENERATION_PARTIALLY_COMPLETE) {
          _refreshTambolaTickets();
          baseProvider.showPositiveAlert('Tickets partially generated',
              'The remaining tickets shall soon be credited', context);
        } else {
          baseProvider.showNegativeAlert(
              'Tickets generation failed',
              'The issue has been noted and your tickets will soon be credited',
              context);
        }
      });
    }

    ///check if tickets need to be deleted
    bool _isDeleted = await _tambolaTicketService
        .processTicketDeletionRequirement(_activeTambolaCardCount);
    if (_isDeleted) {
      setState(() {});
    }

    ///Show the onboarding showcase tutorial is user is new
    // localDBModel.isTambolaTutorialComplete.then((flag) {
    //   if (flag == 0) {
    //     new Timer(const Duration(seconds: 4), () {
    //       _showTutorial = true;
    //       setState(() {});
    //     });
    //     localDBModel.saveTambolaTutorialComplete = true;
    //   }
    // });
  }

  _refreshTambolaTickets() async {
    log.debug('Refreshing..');
    baseProvider.weeklyTicksFetched = false;
    setState(() {});
  }

  int get _activeTambolaCardCount {
    if (baseProvider == null || baseProvider.userWeeklyBoards == null) return 0;
    return baseProvider.userWeeklyBoards.length;
  }

  @override
  void dispose() {
    super.dispose();
    if (_tambolaTicketService != null)
      _tambolaTicketService.setTambolaTicketGenerationResultListener(null);
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    fcmProvider = Provider.of<FcmHandler>(context, listen: false);
    localDBModel = Provider.of<LocalDBModel>(context, listen: false);
    _init();
    _checkSundayResultsProcessing();
    return Scaffold(
      backgroundColor: Color(0xffF0F0CB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onVerticalDragUpdate: _onVerticalDragUpdate,
                child: AnimatedContainer(
                  width: SizeConfig.screenWidth,
                  height: topCardHeight,
                  duration: Duration(seconds: 1),
                  curve: Curves.ease,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/Tambola/tranbg.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Color(0xff34C3A7), Color(0xff4AB474)],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        height: kToolbarHeight * 1.2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_rounded,
                              ),
                              color: Colors.white,
                            ),
                            Image.asset(
                              "images/fello-dark.png",
                              height: kToolbarHeight * 0.6,
                            ),
                            IconButton(
                              onPressed: () => delegate.appState.currentAction =
                                  PageAction(
                                      state: PageState.addPage,
                                      page: TWalkthroughPageConfig),
                              icon: Icon(Icons.info),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      !isShowingAllPicks
                          ? AnimatedOpacity(
                              opacity: titleOpacity,
                              duration: Duration(seconds: 1),
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      "TAMBOLA",
                                      style: TextStyle(
                                          fontFamily: "Cucciolo",
                                          color: Color(0xffEEEBDD),
                                          fontSize: 60,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 2,
                                          shadows: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                offset: Offset(1, 1),
                                                blurRadius: 5,
                                                spreadRadius: 5)
                                          ]),
                                    ),
                                    Text(
                                      "[ GLOBAL ]",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 12,
                                        letterSpacing: 5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
                      !isShowingAllPicks
                          ? InkWell(
                              onTap: () => delegate.appState.currentAction =
                                  PageAction(
                                      state: PageState.addPage,
                                      page: TPickDrawPageConfig),
                              child: Text(
                                "Today's Picks",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : SizedBox(),
                      isShowingAllPicks
                          ? Text(
                              "Weekly Picks",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : SizedBox(),
                      !isShowingAllPicks
                          ? Expanded(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                width: SizeConfig.screenWidth,
                                height: SizeConfig.screenHeight * 0.06,
                                child: PageView(
                                  children: [
                                    Container(
                                      width: SizeConfig.screenWidth,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [12, 82, 69, 51, 19]
                                            .map(
                                              (e) => Container(
                                                height: SizeConfig.screenWidth *
                                                    0.14,
                                                width: SizeConfig.screenWidth *
                                                    0.14,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                  gradient: RadialGradient(
                                                    center:
                                                        Alignment(-0.8, -0.6),
                                                    colors: [
                                                      Color(0xff515E63),
                                                      Colors.black
                                                    ],
                                                    radius: 1.0,
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        height: SizeConfig
                                                                .screenWidth *
                                                            0.1,
                                                        width: SizeConfig
                                                                .screenWidth *
                                                            0.1,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 0.5,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: SizeConfig
                                                              .screenWidth *
                                                          0.14,
                                                      width: SizeConfig
                                                              .screenWidth *
                                                          0.14,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        e.toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    PickTimer(),
                                  ],
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 7,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (ctx, i) {
                                    return ListTile(
                                      title: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          "MONDAY",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 12,
                                            letterSpacing: 5,
                                          ),
                                        ),
                                      ),
                                      subtitle: Container(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [12, 2, 39, 43, 55]
                                              .map(
                                                (e) => Container(
                                                  height: 40,
                                                  width: 40,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white
                                                      // gradient: RadialGradient(
                                                      //   center:
                                                      //       Alignment(-0.8, -0.6),
                                                      //   colors: [
                                                      //     Color(0xff515E63),
                                                      //     Colors.black
                                                      //   ],
                                                      //   radius: 1.0,
                                                      // ),
                                                      ),
                                                  child: Text(
                                                    e.toString(),
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                      !isShowingAllPicks
                          ? Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text("Pull to see all the picks"),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "My Tickets (7)",
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _buildCards(
                  baseProvider.weeklyTicksFetched,
                  baseProvider.weeklyDrawFetched,
                  baseProvider.userWeeklyBoards,
                  _activeTambolaCardCount),
              // Container(
              //   height: SizeConfig.screenWidth * 0.9,
              //   width: SizeConfig.screenWidth,
              //   child: ListView(
              //     physics: BouncingScrollPhysics(),
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       Ticket(
              //         odds: odds,
              //         bgColor: Color(0xffD6C481),
              //         boardColorEven: Color(0xffC7B36C),
              //         boardColorOdd: Colors.white,
              //         boradColorMarked: Color(0xffE76F51),
              //       ),
              //       Ticket(
              //         odds: odds,
              //         bgColor: Color(0xff445C3C),
              //         boardColorEven: Color(0xffC9D99E),
              //         boardColorOdd: Color(0xffFAE8C8),
              //         boradColorMarked: Color(0xffFDA77F),
              //       ),
              //       Ticket(
              //         odds: odds,
              //         bgColor: Color(0xffEA907A),
              //         boardColorEven: Color(0xffC56E58),
              //         boardColorOdd: Colors.white,
              //         boradColorMarked: Color(0xffFFD56B),
              //       ),
              //       Ticket(
              //         odds: odds,
              //         bgColor: Color(0xff0C9463),
              //         boardColorEven: Color(0xff09744D),
              //         boardColorOdd: Colors.white,
              //         boradColorMarked: Color(0xffFFD56B),
              //       ),
              //       Container(
              //         width: SizeConfig.screenWidth * 0.5,
              //         alignment: Alignment.center,
              //         child: InkWell(
              //           onTap: () => delegate.appState.currentAction =
              //               PageAction(
              //                   state: PageState.addPage,
              //                   page: TShowAllTicketsPageConfig),
              //           highlightColor: Color(0xff34C3A7).withOpacity(0.3),
              //           borderRadius: BorderRadius.circular(100),
              //           child: Container(
              //             padding: EdgeInsets.symmetric(
              //               horizontal: 16,
              //               vertical: 8,
              //             ),
              //             decoration: BoxDecoration(
              //               border: Border.all(
              //                 color: Color(0xff4AB474),
              //               ),
              //               borderRadius: BorderRadius.circular(100),
              //             ),
              //             child: Text(
              //               "Show All",
              //               style: GoogleFonts.montserrat(
              //                   color: Color(0xff4AB474)),
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 10),
                    child: Text(
                      "* Best 5 Tickets are shown here",
                      style: TextStyle(
                        fontSize: SizeConfig.smallTextSize,
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                  onTap: () => delegate.appState.currentAction = PageAction(
                        state: PageState.addWidget,
                        page: TWeeklyResultPageConfig,
                        widget: WeeklyResult(
                          winningsmap: {
                            "12AB34": 1,
                            "2345BA": 2,
                            "09481M": 3,
                            "4895BM": 4
                          },
                          isEligible: true,
                        ),
                      ),
                  child: PrizeSection()),
              //FAQ SECTION
              FaqSection()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCards(bool fetchedFlag, bool drawFetchedFlag,
      List<TambolaBoard> boards, int count) {
    Widget _widget;
    if (!fetchedFlag || !drawFetchedFlag) {
      _widget = Padding(
        //Loader
        padding: EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          height: 200,
          child: Center(
            child: SpinKitWave(
              color: UiConstants.primaryColor,
            ),
          ),
        ),
      );
    } else if (boards == null || count == 0) {
      _widget = Padding(
          padding: EdgeInsets.all(10),
          child: Container(
              width: double.infinity,
              height: 200,
              child: Center(
                child: (ticketsBeingGenerated)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: SpinKitWave(color: UiConstants.primaryColor),
                          ),
                          Text(
                            'Your tickets are being generated..',
                            style: TextStyle(
                              fontSize: SizeConfig.mediumTextSize,
                            ),
                          )
                        ],
                      )
                    : Text('No tickets yet'),
              )));
    }
    //  else if (count == 1) {
    //   _tambolaBoardViews = [];
    //   _tambolaBoardViews.add(_buildBoardView(
    //       baseProvider.userWeeklyBoards[0], baseProvider.weeklyDigits));
    //   _currentBoardView = _tambolaBoardViews[0];
    //   _currentBoard = baseProvider.userWeeklyBoards[0];
    //   _widget = Padding(
    //       padding: EdgeInsets.all(10),
    //       child:
    //           Container(width: double.infinity, child: _tambolaBoardViews[0]));
    // }
    else {
      _tambolaBoardViews = [];
      for (int i = 0; i < 5; i++) {
        _tambolaBoardViews.add(_buildBoardView(
            baseProvider.userWeeklyBoards[i], baseProvider.weeklyDigits));
      }

      _widget = Container(
        height: SizeConfig.screenWidth * 0.9,
        width: SizeConfig.screenWidth,
        child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: List.generate(
              _tambolaBoardViews.length, (index) => _tambolaBoardViews[index]),
        ),
      );
      // Container(
      //   width: SizeConfig.screenWidth,
      //   height: SizeConfig.screenHeight * 0.16,
      //   child: Swiper(
      //     controller: ticketsController,
      //     itemBuilder: (BuildContext context, int index) {
      //       return _tambolaBoardViews[index];
      //     },
      //     itemCount: _tambolaBoardViews.length,
      //     itemWidth: SizeConfig.screenWidth * 0.78,
      //     physics: BouncingScrollPhysics(),
      //     layout: SwiperLayout.STACK,
      //   ),
      // );
      // BaseUtil.buildShowcaseWrapper(
      //     _showcaseThree,
      //     Assets.showCaseDesc[2],
      //     CardSelector(
      //         cards: _tambolaBoardViews.toList(),
      //         mainCardWidth: SizeConfig.screenWidth * 0.8,
      //         mainCardHeight: SizeConfig.screenHeight * 0.16,
      //         mainCardPadding: 4.0,
      //         dropTargetWidth: 0,
      //         cardAnimationDurationMs: 500,
      //         onChanged: (i) {
      //           _currentBoard = baseProvider.userWeeklyBoards[i];
      //           _currentBoardView = _tambolaBoardViews[i];
      //           setState(() {});
      //         }));
      if (_currentBoardView == null)
        _currentBoardView = Ticket(
          bgColor: tambolaTicketColorList[0].boardColor,
          boardColorEven: tambolaTicketColorList[0].itemColorEven,
          boardColorOdd: tambolaTicketColorList[0].itemColorOdd,
          boradColorMarked: tambolaTicketColorList[0].itemColorMarked,
          calledDigits: [],
          odds: odds,
          board: null,
        );
      if (_currentBoard == null)
        _currentBoard = baseProvider.userWeeklyBoards[0];
    }
    return _widget;
  }

  Ticket _buildBoardView(TambolaBoard board, DailyPick picks) {
    if (board == null || !board.isValid()) return null;
    List<int> _calledDigits;
    if (!baseProvider.weeklyDrawFetched ||
        picks == null ||
        picks.toList().isEmpty)
      _calledDigits = [];
    else {
      _calledDigits = picks.getPicksPostDate(board.generatedDayCode);
    }
    TambolaTicketColor ticketColor =
        tambolaTicketColorList[Random().nextInt(3) + 1];
    return Ticket(
      board: board,
      calledDigits: _calledDigits,
      bgColor: ticketColor.boardColor,
      boardColorEven: ticketColor.itemColorEven,
      boardColorOdd: ticketColor.itemColorOdd,
      boradColorMarked: ticketColor.itemColorMarked,
      odds: odds,
    );

    // TambolaBoardView(
    //   tambolaBoard: board.tambolaBoard,
    //   calledDigits: _calledDigits,
    //   boardColor: UiConstants.primaryColor,
    //   ticketColor1: Color(0xff55C595),
    //   ticketColor2: Color(0xffEEEEEE),
    // );
  }

  _checkSundayResultsProcessing() {
    if (baseProvider.userWeeklyBoards == null ||
        baseProvider.userWeeklyBoards.isEmpty ||
        baseProvider.weeklyDigits == null ||
        baseProvider.weeklyDigits.toList().isEmpty ||
        localDBModel == null) {
      log.debug('Testing is not ready yet');
      return false;
    }
    DateTime date = DateTime.now();
    if (date.weekday == DateTime.sunday) {
      if (baseProvider.weeklyDigits.toList().length ==
          7 * baseProvider.dailyPicksCount) {
        localDBModel.isTambolaResultProcessingDone().then((flag) {
          if (flag == 0) {
            log.debug('Ticket results not yet displayed. Displaying: ');
            _examineTicketsForWins();

            ///save the status that results have been saved
            localDBModel.saveTambolaResultProcessingStatus(true);
          }

          ///also delete all the old tickets while we're at it
          //no need to await
          dbProvider.deleteExpiredUserTickets(baseProvider.myUser.uid);
        });
      }
    } else {
      localDBModel.isTambolaResultProcessingDone().then((flag) {
        if (flag == 1) localDBModel.saveTambolaResultProcessingStatus(false);
      });
    }
  }

  ///check if any of the tickets aced any of the categories.
  ///also check if the user is eligible for a prize
  ///if any did, add it to a list and submit the list as a win claim
  _examineTicketsForWins() {
    if (baseProvider.userWeeklyBoards == null ||
        baseProvider.userWeeklyBoards.isEmpty ||
        baseProvider.weeklyDigits == null ||
        baseProvider.weeklyDigits.toList().isEmpty) {
      log.debug('Testing is not ready yet');
      return false;
    }
    Map<String, int> ticketCodeWinIndex = {};
    baseProvider.userWeeklyBoards.forEach((boardObj) {
      if (boardObj.getCornerOdds(baseProvider.weeklyDigits
              .getPicksPostDate(boardObj.generatedDayCode)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.CORNERS_COMPLETED;
      }
      if (boardObj.getRowOdds(
              0,
              baseProvider.weeklyDigits
                  .getPicksPostDate(boardObj.generatedDayCode)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.ROW_ONE_COMPLETED;
      }
      if (boardObj.getRowOdds(
              1,
              baseProvider.weeklyDigits
                  .getPicksPostDate(boardObj.generatedDayCode)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.ROW_TWO_COMPLETED;
      }
      if (boardObj.getRowOdds(
              2,
              baseProvider.weeklyDigits
                  .getPicksPostDate(boardObj.generatedDayCode)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.ROW_THREE_COMPLETED;
      }
      if (boardObj.getFullHouseOdds(baseProvider.weeklyDigits
              .getPicksPostDate(boardObj.generatedDayCode)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.FULL_HOUSE_COMPLETED;
      }
    });

    double totalInvestedPrinciple =
        baseProvider.userFundWallet.augGoldPrinciple +
            baseProvider.userFundWallet.iciciPrinciple;
    bool _isEligible =
        (totalInvestedPrinciple >= BaseRemoteConfig.UNLOCK_REFERRAL_AMT);

    log.debug('Resultant wins: ${ticketCodeWinIndex.toString()}');

    if (!_winnerDialogCalled)
      delegate.appState.currentAction = PageAction(
          state: PageState.addPage,
          widget: WeeklyResult(
            // winningsmap: ticketCodeWinIndex,
            // isEligible: _isEligible,
            winningsmap: {
              "12AB34": 0,
              "12AB34": 0,
              "12AB34": 0,
              "12AB34": 0,
            },
            isEligible: true,
          ));
    // new Timer(const Duration(milliseconds: 2500), () {
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) => TambolaResultsDialog(
    //             winningsMap: ticketCodeWinIndex,
    //             isEligible: _isEligible,
    //           ));
    // });
    _winnerDialogCalled = true;

    if (ticketCodeWinIndex.length > 0) {
      dbProvider
          .addWinClaim(
              baseProvider.myUser.uid,
              baseProvider.myUser.name,
              baseProvider.myUser.mobile,
              baseProvider.userTicketWallet.getActiveTickets(),
              _isEligible,
              ticketCodeWinIndex)
          .then((flag) {
        baseProvider.showPositiveAlert(
            'Congratulations 🎉',
            'Your tickets have been submitted for processing your prizes!',
            context);
      });
    }
  }

  List<TambolaBoard> _refreshBestBoards() {
    if (baseProvider.userWeeklyBoards == null ||
        baseProvider.userWeeklyBoards.isEmpty) {
      return [];
    }
    //initialise
    _bestTambolaBoards =
        List<TambolaBoard>.filled(5, baseProvider.userWeeklyBoards[0]);

    if (baseProvider.weeklyDigits == null ||
        baseProvider.weeklyDigits.toList().isEmpty) {
      return _bestTambolaBoards;
    }

    baseProvider.userWeeklyBoards.forEach((board) {
      if (_bestTambolaBoards[0] == null) _bestTambolaBoards[0] = board;
      if (_bestTambolaBoards[1] == null) _bestTambolaBoards[1] = board;
      if (_bestTambolaBoards[2] == null) _bestTambolaBoards[2] = board;
      if (_bestTambolaBoards[3] == null) _bestTambolaBoards[3] = board;
      if (_bestTambolaBoards[4] == null) _bestTambolaBoards[4] = board;

      if (_bestTambolaBoards[0].getRowOdds(
              0,
              baseProvider.weeklyDigits
                  .getPicksPostDate(_bestTambolaBoards[0].generatedDayCode)) >
          board.getRowOdds(
              0,
              baseProvider.weeklyDigits
                  .getPicksPostDate(board.generatedDayCode))) {
        _bestTambolaBoards[0] = board;
      }
      if (_bestTambolaBoards[1].getRowOdds(
              1,
              baseProvider.weeklyDigits
                  .getPicksPostDate(_bestTambolaBoards[1].generatedDayCode)) >
          board.getRowOdds(
              1,
              baseProvider.weeklyDigits
                  .getPicksPostDate(board.generatedDayCode))) {
        _bestTambolaBoards[1] = board;
      }
      if (_bestTambolaBoards[2].getRowOdds(
              2,
              baseProvider.weeklyDigits
                  .getPicksPostDate(_bestTambolaBoards[2].generatedDayCode)) >
          board.getRowOdds(
              2,
              baseProvider.weeklyDigits
                  .getPicksPostDate(board.generatedDayCode))) {
        _bestTambolaBoards[2] = board;
      }
      if (_bestTambolaBoards[3].getCornerOdds(baseProvider.weeklyDigits
              .getPicksPostDate(_bestTambolaBoards[3].generatedDayCode)) >
          board.getCornerOdds(baseProvider.weeklyDigits
              .getPicksPostDate(board.generatedDayCode))) {
        _bestTambolaBoards[3] = board;
      }
      if (_bestTambolaBoards[4].getFullHouseOdds(baseProvider.weeklyDigits
              .getPicksPostDate(_bestTambolaBoards[4].generatedDayCode)) >
          board.getFullHouseOdds(baseProvider.weeklyDigits
              .getPicksPostDate(board.generatedDayCode))) {
        _bestTambolaBoards[4] = board;
      }
    });

    return _bestTambolaBoards;
  }
}

List<TicketOdds> odds = [
  TicketOdds(
      color: Color(0xffE76F51),
      icon: Icons.apps,
      title: "Full House",
      left: 12),
  TicketOdds(
      color: Color(0xff264653),
      icon: Icons.border_top,
      title: "Top Row",
      left: 4),
  TicketOdds(
      color: Color(0xff264653),
      icon: Icons.border_horizontal,
      title: "Middle Row",
      left: 3),
  TicketOdds(
      color: Color(0xff264653),
      icon: Icons.border_bottom,
      title: "Bottom Row",
      left: 0),
  TicketOdds(
      color: Color(0xff4AB474),
      icon: Icons.border_outer,
      title: "Corners",
      left: 2),
];

class FaqSection extends StatefulWidget {
  const FaqSection({Key key}) : super(key: key);

  @override
  _FaqSectionState createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  List<bool> detStatus = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(top: 12, left: 10),
      child: Column(
        children: [
          Text(
            "FAQs",
            style: GoogleFonts.montserrat(
              color: Colors.black54,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          _buildPrizePodium()
        ],
      ),
    );
  }

  _buildPrizePodium() {
    List<String> faqLeadIcons = [
      "images/svgs/howitworks.svg",
      "images/svgs/cash-distribution.svg",
      "images/svgs/redeem.svg",
      "images/svgs/winmore.svg",
    ];
    return Container(
      width: SizeConfig.screenWidth,
      child: Column(
        children: [
          ExpansionPanelList(
            animationDuration: Duration(milliseconds: 600),
            expandedHeaderPadding: EdgeInsets.all(0),
            dividerColor: Colors.grey.withOpacity(0.2),
            elevation: 0,
            children: List.generate(
              Assets.tambolaFaqList.length,
              (index) => ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (ctx, isOpen) => _prizeFAQHeader(
                    faqLeadIcons[index],
                    Assets.tambolaFaqList[index].keys.first),
                isExpanded: detStatus[index],
                body: Container(
                  child: Column(
                    children: [
                      Text(
                        Assets.tambolaFaqList[0].values.first,
                        style: TextStyle(
                          height: 1.5,
                          fontSize: SizeConfig.mediumTextSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            expansionCallback: (i, isOpen) {
              print("$i th item is $isOpen");
              setState(() {
                detStatus[i] = !isOpen;
              });
              print(detStatus[i]);
            },
          ),
        ],
      ),
    );
  }

  _prizeFAQHeader(String asset, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset(asset, height: 20, width: 20),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: SizeConfig.mediumTextSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Ticket extends StatefulWidget {
  const Ticket(
      {@required this.odds,
      @required this.bgColor,
      @required this.boardColorEven,
      @required this.boardColorOdd,
      @required this.boradColorMarked,
      @required this.board,
      @required this.calledDigits});

  final List<TicketOdds> odds;
  final bgColor, boardColorOdd, boardColorEven, boradColorMarked;
  final TambolaBoard board;
  final List<int> calledDigits;

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  List<int> markedIndices = [];
  List<int> ticketNumbers = [];

  markItem(int index) {
    print("marked index : $index");
    if (markedIndices.contains(index))
      markedIndices.remove(index);
    else
      markedIndices.add(index);
    setState(() {});
  }

  getColor(int index) {
    if (markedIndices.contains(index)) {
      return widget.boradColorMarked;
    }
    if (index % 2 == 0) {
      return widget.boardColorEven;
    } else {
      return widget.boardColorOdd;
    }
  }

  markStatus(int index) {
    if (markedIndices.contains(index)) {
      return Align(
        alignment: Alignment.center,
        child: Transform.rotate(
          angle: -45,
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.all(2),
            width: 2,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  @override
  void initState() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 9; j++) {
        ticketNumbers.add(widget.board.tambolaBoard[i][j]);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenWidth * 0.9,
      width: SizeConfig.screenWidth * 0.9,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 0,
          color: Color(0xffF0F0CB),
        ),
      ),
      margin: EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
            height: SizeConfig.screenWidth * 0.9,
            width: SizeConfig.screenWidth * 0.9,
            child: Opacity(
              opacity: 0.16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "images/Tambola/ticket-bg.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          CustomPaint(
            painter: TicketPainter(puchRadius: 20),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Ticket #${widget.board.getTicketNumber()}',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: 27,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 9,
                          ),
                          itemBuilder: (ctx, i) {
                            return InkWell(
                              onTap: () => markItem(i),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: getColor(i),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        i.toString(),
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    markStatus(i)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Color(0xffF0F0CB),
                  thickness: 1,
                  indent: 40,
                  endIndent: 40,
                ),
                Expanded(
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    childAspectRatio: 3.5 / 1,
                    crossAxisCount: 2,
                    children: List.generate(5, (index) {
                      return ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: widget.odds[index].color,
                              borderRadius: BorderRadius.circular(4)),
                          child: Icon(
                            widget.odds[index].icon,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        title: Text(
                          widget.odds[index].title,
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontSize: 14),
                        ),
                        subtitle: Text(
                          "${widget.odds[index].left} left",
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: InkWell(
                onTap: () {
                  print(widget.board.getTicketNumber());
                },
                child: Text(
                  "Generated on: 08/08/2021",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TicketOdds {
  final String title;
  final int left;
  final IconData icon;
  final Color color;

  TicketOdds({this.icon, this.left, this.title, this.color});
}

class TicketPainter extends CustomPainter {
  final double puchRadius;

  const TicketPainter({this.puchRadius});
  @override
  void paint(Canvas canvas, Size size) {
    var paintMain = Paint();

    paintMain.color = Color(0xffF0F0CB);
    paintMain.style = PaintingStyle.fill;

    var pathMain = Path();

    pathMain.moveTo(0, 0);

    pathMain.moveTo(size.width, 0);
    pathMain.moveTo(size.width, size.height / 2 - puchRadius);
    pathMain.quadraticBezierTo(size.width - puchRadius * 1.5, size.height / 2,
        size.width, size.height / 2 + puchRadius);
    pathMain.moveTo(size.width, size.height);
    pathMain.moveTo(0, size.height);
    pathMain.moveTo(0, size.height / 2 + puchRadius);
    pathMain.quadraticBezierTo(
        puchRadius * 1.5, size.height / 2, 0, size.height / 2 - puchRadius);
    pathMain.close();

    canvas.drawPath(pathMain, paintMain);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class PrizeSection extends StatelessWidget {
  const PrizeSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Color(0xff7C83FD), Color(0xff96BAFF)],
          begin: Alignment.bottomCenter,
          end: Alignment.topRight,
        ),
      ),
      margin: EdgeInsets.all(10),
      child: Stack(
        children: [
          Positioned(
            bottom: 10,
            child: Opacity(
              opacity: 0.2,
              child: Transform.scale(
                scale: 1.2,
                child: SvgPicture.asset(
                  "images/Tambola/gifts.svg",
                  width: SizeConfig.screenWidth,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                Text(
                  "Prizes",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.apps,
                            color: Colors.white,
                            size: 70,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Full House",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "₹ 10,000",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.border_top_rounded,
                            color: Colors.white,
                            size: 70,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Any Row",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "₹ 500",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.border_outer,
                            color: Colors.white,
                            size: 70,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Corners",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "₹ 100",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _podiumItem(
                      "images/Tambola/fullhouse.png",
                      '₹ ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.TAMBOLA_WIN_FULL)}',
                      "Full House"),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _podiumItem(
                          "images/Tambola/rows.png",
                          "₹ ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.TAMBOLA_WIN_TOP)}",
                          "First/Second/Third Row"),
                    ),
                    Expanded(
                      flex: 4,
                      child: _podiumItem(
                          "images/Tambola/corners.png",
                          "₹ ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.TAMBOLA_WIN_CORNER)}",
                          "Corners"),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _podiumItem(String imagePath, String title, String subtitle) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: UiConstants.primaryColor,
              fontSize: SizeConfig.largeTextSize,
            ),
          ),
          SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.mediumTextSize,
            ),
          )
        ],
      ),
    );
  }
}

class PickTimer extends StatelessWidget {
  const PickTimer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: SizeConfig.screenWidth * 0.16,
            width: SizeConfig.screenWidth * 0.16,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              "12",
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  shadows: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(1, 1),
                        blurRadius: 5,
                        spreadRadius: 5)
                  ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              ":",
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  shadows: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(1, 1),
                        blurRadius: 5,
                        spreadRadius: 5)
                  ]),
            ),
          ),
          Container(
            height: SizeConfig.screenWidth * 0.16,
            width: SizeConfig.screenWidth * 0.16,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              "30",
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  shadows: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(1, 1),
                        blurRadius: 5,
                        spreadRadius: 5)
                  ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              ":",
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  shadows: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(1, 1),
                        blurRadius: 5,
                        spreadRadius: 5)
                  ]),
            ),
          ),
          Container(
            height: SizeConfig.screenWidth * 0.16,
            width: SizeConfig.screenWidth * 0.16,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              "55",
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  shadows: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(1, 1),
                        blurRadius: 5,
                        spreadRadius: 5)
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class TambolaTicketColor {
  Color boardColor;
  Color itemColorEven;
  Color itemColorOdd;
  Color itemColorMarked;

  TambolaTicketColor(
      {@required this.boardColor,
      @required this.itemColorEven,
      @required this.itemColorMarked,
      @required this.itemColorOdd});
}

List<TambolaTicketColor> tambolaTicketColorList = [
  TambolaTicketColor(
    boardColor: Color(0xffD6C481),
    itemColorEven: Color(0xffC7B36C),
    itemColorMarked: Color(0xffE76F51),
    itemColorOdd: Colors.white,
  ),
  TambolaTicketColor(
    boardColor: Color(0xff445C3C),
    itemColorEven: Color(0xffC9D99E),
    itemColorMarked: Color(0xffFDA77F),
    itemColorOdd: Color(0xffFAE8C8),
  ),
  TambolaTicketColor(
    boardColor: Color(0xffEA907A),
    itemColorEven: Color(0xffC56E58),
    itemColorMarked: Color(0xffFFD56B),
    itemColorOdd: Colors.white,
  ),
  TambolaTicketColor(
    boardColor: Color(0xff0C9463),
    itemColorEven: Color(0xff09744D),
    itemColorMarked: Color(0xffFFD56B),
    itemColorOdd: Colors.white,
  ),
];
