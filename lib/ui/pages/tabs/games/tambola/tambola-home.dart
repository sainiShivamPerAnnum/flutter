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
import 'package:felloapp/ui/elements/texts/daily_pick_text_slider.dart';
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
  double topCardHeight = SizeConfig.screenWidth * 0.80;
  bool isShowingAllPicks = false;
  double titleOpacity = 1;

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta > 1.5) {
      topCardHeight = SizeConfig.screenHeight * 0.14 * 7;
      titleOpacity = 0;
      isShowingAllPicks = true;
    } else {
      topCardHeight = SizeConfig.screenWidth * 0.80;
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
                  margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
                  child: Column(
                    children: [
                      !isShowingAllPicks
                          ? const GameAppBar()
                          : SizedBox(height: 8),
                      !isShowingAllPicks
                          ? GameTitle(titleOpacity: titleOpacity)
                          : SizedBox(),
                      InkWell(
                        onTap: () => delegate.appState.currentAction =
                            PageAction(
                                state: PageState.addPage,
                                page: TPickDrawPageConfig),
                        child: Text(
                          !isShowingAllPicks ? "Today's Picks" : "Weekly Picks",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: SizeConfig.cardTitleTextSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      !isShowingAllPicks
                          ? CurrentPicks(
                              dailyPickTextList: dailyPickTextList,
                              digits: _getDailyPickData(
                                  baseProvider.weeklyDigits,
                                  DateTime.now().weekday),
                            )
                          : WeeklyPicks(
                              weeklyDraws: baseProvider.weeklyDigits,
                            ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "My Tickets ($_activeTambolaCardCount)",
                      style: GoogleFonts.montserrat(
                        color: Colors.black87,
                        fontSize: SizeConfig.cardTitleTextSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      _tambolaBoardViews = [];
                      baseProvider.userWeeklyBoards.forEach((board) {
                        _tambolaBoardViews.add(
                            _buildBoardView(board, baseProvider.weeklyDigits));
                      });
                      delegate.appState.currentAction = PageAction(
                        state: PageState.addWidget,
                        page: TShowAllTicketsPageConfig,
                        widget: ShowAllTickets(
                          tambolaBoardView: _tambolaBoardViews,
                        ),
                      );
                    },
                    highlightColor: Color(0xff34C3A7).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff4AB474),
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "Show All",
                        style: GoogleFonts.montserrat(
                          color: Color(0xff4AB474),
                          fontSize: SizeConfig.mediumTextSize,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              _buildCards(
                  baseProvider.weeklyTicksFetched,
                  baseProvider.weeklyDrawFetched,
                  baseProvider.userWeeklyBoards,
                  _activeTambolaCardCount),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 10, right: SizeConfig.blockSizeHorizontal * 3),
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
          ),
        ),
      );
    } else {
      _tambolaBoardViews = [];
      _refreshBestBoards().forEach((element) {
        _tambolaBoardViews
            .add(_buildBoardView(element, baseProvider.weeklyDigits));
      });
      // for (int i = 0; i < 5; i++) {
      //   _tambolaBoardViews.add(_buildBoardView(
      //       baseProvider.userWeeklyBoards[i], baseProvider.weeklyDigits));
      // }

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

      if (_currentBoardView == null)
        _currentBoardView = Ticket(
          bgColor: tambolaTicketColorList[0].boardColor,
          boardColorEven: tambolaTicketColorList[0].itemColorEven,
          boardColorOdd: tambolaTicketColorList[0].itemColorOdd,
          boradColorMarked: tambolaTicketColorList[0].itemColorMarked,
          calledDigits: [],
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
    TambolaTicketColor ticketColor = tambolaTicketColorList[
        Random().nextInt(tambolaTicketColorList.length - 1) + 1];
    return Ticket(
      board: board,
      calledDigits: _calledDigits,
      bgColor: ticketColor.boardColor,
      boardColorEven: ticketColor.itemColorEven,
      boardColorOdd: ticketColor.itemColorOdd,
      boradColorMarked: ticketColor.itemColorMarked,
    );
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

  List<int> _getDailyPickData(DailyPick draws, int day) {
    List<int> picks = [];
    if (draws != null && draws.getWeekdayDraws(day - 1) != null) {
      draws.getWeekdayDraws(day - 1).forEach((element) {
        picks.add(element);
      });
    } else {
      for (int i = 0; i < baseProvider.dailyPicksCount; i++) {
        picks.add(-1);
      }
    }
    return picks;
  }
}

class WeeklyPicks extends StatelessWidget {
  final DailyPick weeklyDraws;
  // BaseUtil baseProvider;

  const WeeklyPicks({
    this.weeklyDraws,
    Key key,
  }) : super(key: key);

  String getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'N/A';
    }
  }

  Widget _getDrawBallRow(DailyPick draws, int day) {
    List<Widget> balls = [];
    if (draws != null && draws.getWeekdayDraws(day - 1) != null) {
      draws.getWeekdayDraws(day - 1).forEach((element) {
        balls.add(_getDrawBall(element.toString()));
      });
    } else {
      for (int i = 0; i < draws.mon.length; i++) {
        balls.add(_getDrawBall('-'));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: balls,
    );
  }

  Widget _getDrawBall(String digit) {
    return Container(
      width: SizeConfig.screenWidth * 0.08,
      height: SizeConfig.screenWidth * 0.08,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Text(
        digit,
        style: TextStyle(
            fontSize: SizeConfig.mediumTextSize * 1.2,
            fontWeight: FontWeight.w500,
            color: Colors.black),
        textAlign: TextAlign.center,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (weeklyDraws == null || weeklyDraws.toList().isEmpty) {
      return Expanded(
        child: Center(
          child: Container(
            height: 150,
            child: Center(
                child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'This week\'s numbers have not been drawn yet.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            )),
          ),
        ),
      );
    }
    DateTime today = DateTime.now();
    List<ListTile> colElems = [];
    int colCount = today.weekday;
    for (int i = 0; i < 7; i++) {
      // if (weeklyDraws.getWeekdayDraws(i) != null) {
      colElems.add(
        ListTile(
          title: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            child: Text(
              getDayName(i + 1).toUpperCase(),
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: SizeConfig.smallTextSize,
                letterSpacing: 5,
              ),
            ),
          ),
          subtitle: _getDrawBallRow(weeklyDraws, i + 1),
        ),
      );
      // }
    }
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(bottom: 8),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: colElems,
        ),
      ),
    );
  }
}

class GameTitle extends StatelessWidget {
  const GameTitle({
    Key key,
    @required this.titleOpacity,
  }) : super(key: key);

  final double titleOpacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
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
                fontSize: SizeConfig.cardTitleTextSize * 1.6,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                shadows: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(1, 1),
                      blurRadius: 5,
                      spreadRadius: 5)
                ],
              ),
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
    );
  }
}

class GameAppBar extends StatelessWidget {
  const GameAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onPressed: () => delegate.appState.currentAction = PageAction(
                state: PageState.addPage, page: TWalkthroughPageConfig),
            icon: Icon(Icons.info),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class CurrentPicks extends StatelessWidget {
  final List<String> dailyPickTextList;
  final List<int> digits;

  const CurrentPicks({Key key, this.dailyPickTextList, this.digits})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            digits[0] < 0
                ? DailyPicksTimer()
                : Container(
                    width: SizeConfig.screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: digits
                          .map(
                            (e) => Container(
                              height: SizeConfig.screenWidth * 0.12,
                              width: SizeConfig.screenWidth * 0.12,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  center: Alignment(-0.8, -0.6),
                                  colors: [Color(0xff515E63), Colors.black],
                                  radius: 1.0,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: SizeConfig.screenWidth * 0.09,
                                      width: SizeConfig.screenWidth * 0.09,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: SizeConfig.screenWidth * 0.12,
                                    width: SizeConfig.screenWidth * 0.12,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(8),
                                    child: FittedBox(
                                      child: Text(
                                        e.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: SizeConfig.largeTextSize),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: DPTextSlider(
                infoList: dailyPickTextList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      {@required this.bgColor,
      @required this.boardColorEven,
      @required this.boardColorOdd,
      @required this.boradColorMarked,
      @required this.board,
      @required this.calledDigits});

  final bgColor, boardColorOdd, boardColorEven, boradColorMarked;
  final TambolaBoard board;
  final List<int> calledDigits;

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  List<int> markedIndices = [];
  List<int> ticketNumbers = [];
  List<TicketOdds> odds = [];

  markItem(int index) {
    print("marked index : $index");
    if (markedIndices.contains(index))
      markedIndices.remove(index);
    else
      markedIndices.add(index);
    setState(() {});
  }

  getColor(int index) {
    if (widget.calledDigits.contains(ticketNumbers[index]))
      return widget.boradColorMarked;
    if (index % 2 == 0) {
      return widget.boardColorEven;
    } else {
      return widget.boardColorOdd;
    }
  }

  markStatus(int index) {
    if (widget.calledDigits.contains(ticketNumbers[index])) {
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

  generateOdds() {
    odds = [
      TicketOdds(
        color: Color(0xffE76F51),
        icon: Icons.apps,
        title: "Full House",
        left: widget.board.getFullHouseOdds(widget.calledDigits),
      ),
      TicketOdds(
          color: Color(0xff264653),
          icon: Icons.border_top,
          title: "Top Row",
          left: widget.board.getRowOdds(0, widget.calledDigits)),
      TicketOdds(
          color: Color(0xff264653),
          icon: Icons.border_horizontal,
          title: "Middle Row",
          left: widget.board.getRowOdds(1, widget.calledDigits)),
      TicketOdds(
          color: Color(0xff264653),
          icon: Icons.border_bottom,
          title: "Bottom Row",
          left: widget.board.getRowOdds(2, widget.calledDigits)),
      TicketOdds(
          color: Color(0xff4AB474),
          icon: Icons.border_outer,
          title: "Corners",
          left: widget.board.getCornerOdds(widget.calledDigits)),
    ];
  }

  @override
  void initState() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 9; j++) {
        ticketNumbers.add(widget.board.tambolaBoard[i][j]);
      }
    }
    generateOdds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenWidth * 0.9,
      width: SizeConfig.screenWidth * 0.9,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          width: 0,
          color: Color(0xffF0F0CB),
        ),
      ),
      margin: EdgeInsets.all(8),
      child: Stack(
        children: [
          Container(
            height: SizeConfig.screenWidth * 0.9,
            width: SizeConfig.screenWidth * 0.9,
            child: Opacity(
              opacity: 0.16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 5,
                        vertical: SizeConfig.blockSizeHorizontal * 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Ticket #${widget.board.getTicketNumber()}',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: SizeConfig.smallTextSize),
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
                              //onTap: () => markItem(i),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: getColor(i),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.blockSizeHorizontal * 3),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        ticketNumbers[i] == 0
                                            ? ""
                                            : ticketNumbers[i].toString(),
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          fontSize: SizeConfig.mediumTextSize,
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
                  indent: 40,
                  endIndent: 40,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 5,
                    ),
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 3.5 / 1,
                      crossAxisCount: 2,
                      children: List.generate(5, (index) {
                        return Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: odds[index].color,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Icon(odds[index].icon,
                                  color: Colors.white,
                                  size: SizeConfig.screenWidth * 0.06),
                            ),
                            SizedBox(width: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  odds[index].title,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: SizeConfig.smallTextSize,
                                  ),
                                ),
                                Text(
                                  "${odds[index].left} left",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: SizeConfig.mediumTextSize),
                                ),
                              ],
                            )
                          ],
                        );

                        // ListTile(
                        //   leading: Container(
                        //     padding: EdgeInsets.all(4),
                        //     decoration: BoxDecoration(
                        //         color: odds[index].color,
                        //         borderRadius: BorderRadius.circular(4)),
                        //     child: Icon(odds[index].icon,
                        //         color: Colors.white,
                        //         size: SizeConfig.screenWidth * 0.05),
                        //   ),
                        //   title: Text(
                        //     odds[index].title,
                        //     style: GoogleFonts.montserrat(
                        //       color: Colors.white,
                        //       fontSize: SizeConfig.smallTextSize,
                        //     ),
                        //   ),
                        //   subtitle: Text(
                        //     "${odds[index].left} left",
                        //     style: GoogleFonts.montserrat(
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.w700,
                        //         fontSize: SizeConfig.mediumTextSize),
                        //   ),
                        // );
                      }),
                    ),
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
                  "Generated on: ${DateTime.fromMillisecondsSinceEpoch(widget.board.assigned_time.millisecondsSinceEpoch).day.toString().padLeft(2, '0')}-${DateTime.fromMillisecondsSinceEpoch(widget.board.assigned_time.millisecondsSinceEpoch).month.toString().padLeft(2, '0')}-${DateTime.fromMillisecondsSinceEpoch(widget.board.assigned_time.millisecondsSinceEpoch).year}",
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
  TambolaTicketColor(
    boardColor: Color(0xffD4A5A5),
    itemColorEven: Color(0xffC59B9B),
    itemColorMarked: Color(0xffFFD56B),
    itemColorOdd: Colors.white,
  ),
  TambolaTicketColor(
    boardColor: Color(0xff086972),
    itemColorEven: Color(0xff118792),
    itemColorMarked: Color(0xffFFD56B),
    itemColorOdd: Colors.white,
  ),
];

class DailyPicksTimer extends StatefulWidget {
  @override
  _DailyPicksTimerState createState() => _DailyPicksTimerState();
}

class _DailyPicksTimerState extends State<DailyPicksTimer> {
  Duration duration;
  Timer timer;

  bool countDown = true;

  @override
  void initState() {
    calculateTime();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
    });
    super.initState();
  }

  void calculateTime() {
    DateTime currentTime = DateTime.now();
    DateTime drawTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 18, 0, 0);
    Duration timeDiff = currentTime.difference(drawTime);
    if (timeDiff.inSeconds < 0) {
      duration = timeDiff.abs();
    }
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        print("Cancle");
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: hours),
      buildDivider(),
      buildTimeCard(time: minutes),
      buildDivider(),
      buildTimeCard(time: seconds),
    ]);
  }

  Widget buildTimeCard({@required String time}) => Container(
        height: SizeConfig.screenWidth * 0.14,
        width: SizeConfig.screenWidth * 0.14,
        decoration: BoxDecoration(
          color: Color(0xff09464B),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          time,
          style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: SizeConfig.cardTitleTextSize,
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
      );

  Widget buildDivider() {
    return Padding(
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
    );
  }
}
