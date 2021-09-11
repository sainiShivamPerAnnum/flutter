import 'dart:async';
import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/tambola_generation_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/tambola-global/prize_section.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_daily_draw_timer.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:felloapp/ui/elements/tambola-global/weekly_picks.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/show_all_tickets.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/summary_tickets_display.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/weekly_result.dart';
import 'package:felloapp/ui/widgets/network_bar.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class TambolaHome extends StatefulWidget {
  const TambolaHome({Key key}) : super(key: key);

  @override
  _TambolaHomeState createState() => _TambolaHomeState();
}

class _TambolaHomeState extends State<TambolaHome> {
  // HEIGHT CALCULATED ACCORDING TO THE ITEMS PRESENT IN THE CONTAINER
  double normalTopCardHeight = SizeConfig.screenWidth * 0.76;
  double expandedTopCardHeight =
      (SizeConfig.smallTextSize + SizeConfig.screenWidth * 0.1) * 8 +
          SizeConfig.cardTitleTextSize * 2.4 +
          kToolbarHeight * 1.5;

  double topCardHeight;
  bool isShowingAllPicks = false;
  double titleOpacity = 1;
  Log log = new Log('CardScreen');
  TambolaBoard _currentBoard;
  Ticket _currentBoardView;
  bool _winnerDialogCalled = false;
  bool _isTicketSummaryLoaded = false;
  List<TicketSummaryCardModel> ticketSummaryData;

  List<Ticket> _tambolaBoardViews, _topFiveTambolaBoards = [];
  List<Widget> balls = [];

  var rnd = new Random();
  BaseUtil baseProvider;
  DBModel dbProvider;
  FcmHandler fcmProvider;
  LocalDBModel localDBModel;

  bool ticketsBeingGenerated = false;
  bool dailyPickHeaderWithTimings = false;

  //List<String> dailyPickTextList = [];
  PageController _summaryController = PageController(viewportFraction: 0.94);

  TambolaGenerationService _tambolaTicketService;

  void _onTap() {
    if (!isShowingAllPicks) {
      topCardHeight = expandedTopCardHeight;
      titleOpacity = 0;
      isShowingAllPicks = true;
    } else {
      topCardHeight = normalTopCardHeight;
      isShowingAllPicks = false;
      Future.delayed(Duration(milliseconds: 500), () {
        titleOpacity = 1;
        setState(() {});
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    topCardHeight = normalTopCardHeight;
    // initDailyPickFlags();
    BaseAnalytics.analytics
        .setCurrentScreen(screenName: BaseAnalytics.PAGE_TAMBOLA);
    _tambolaTicketService = new TambolaGenerationService();
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
      setState(() {
        ticketsBeingGenerated = true;
      });
      _tambolaTicketService.setTambolaTicketGenerationResultListener((flag) {
        setState(() {
          ticketsBeingGenerated = false;
        });
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
    _topFiveTambolaBoards = [];
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              GestureDetector(
                onTap: _onTap,
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
                      borderRadius:
                          BorderRadius.circular(SizeConfig.cardBorderRadius),
                      color: UiConstants.primaryColor),
                  margin: EdgeInsets.all(SizeConfig.globalMargin),
                  child: Column(
                    children: [
                      const GameAppBar(),
                      !isShowingAllPicks
                          ? GameTitle(titleOpacity: titleOpacity)
                          : SizedBox(),
                      isShowingAllPicks
                          ? Text(
                              "Weekly Picks",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: SizeConfig.cardTitleTextSize,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : (_getDailyPickData(baseProvider.weeklyDigits,
                                      DateTime.now().weekday)[0] >
                                  0
                              ? Text(
                                  "Today's Picks",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: SizeConfig.cardTitleTextSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : Text(
                                  "Today's picks will be drawn at 6 pm.",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: SizeConfig.mediumTextSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                      !isShowingAllPicks
                          ? const CurrentPicks()
                          : WeeklyPicks(
                              weeklyDraws: baseProvider.weeklyDigits,
                            ),
                    ],
                  ),
                ),
              ),
              _buildTicketSummaryCards(
                  baseProvider.weeklyTicksFetched,
                  baseProvider.weeklyDrawFetched,
                  baseProvider.userWeeklyBoards,
                  _activeTambolaCardCount),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 3,
                    vertical: SizeConfig.blockSizeHorizontal * 2),
                child: Row(
                  children: [
                    Text(
                      "My Tickets ($_activeTambolaCardCount)",
                      style: GoogleFonts.montserrat(
                        color: Colors.black87,
                        fontSize: SizeConfig.cardTitleTextSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        if (await baseProvider.isOfflineSnackBar(context))
                          return;
                        _tambolaBoardViews = [];
                        baseProvider.userWeeklyBoards.forEach((board) {
                          _tambolaBoardViews.add(_buildBoardView(board));
                        });
                        AppState.delegate.appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          page: TShowAllTicketsPageConfig,
                          widget: ShowAllTickets(
                            tambolaBoardView: _tambolaBoardViews,
                          ),
                        );
                      },
                      highlightColor: UiConstants.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: UiConstants.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "Show All",
                          style: GoogleFonts.montserrat(
                            color: UiConstants.primaryColor,
                            fontSize: SizeConfig.mediumTextSize,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              _buildCards(
                  baseProvider.weeklyTicksFetched,
                  baseProvider.weeklyDrawFetched,
                  baseProvider.userWeeklyBoards,
                  _activeTambolaCardCount),
              PrizeSection(),
              FaqSection()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCards(bool fetchedFlag, bool drawFetchedFlag,
      List<TambolaBoard> boards, int count) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context, listen: false);
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
          height: SizeConfig.screenWidth * 0.9,
          child: Center(
            child: (ticketsBeingGenerated)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: connectivityStatus == ConnectivityStatus.Offline
                            ? NetworkBar(
                                textColor: Colors.black,
                              )
                            : SpinKitWave(color: UiConstants.primaryColor),
                      ),
                      if (connectivityStatus != ConnectivityStatus.Offline)
                        Text(
                          'Your tickets are being generated..',
                          style: TextStyle(
                            fontSize: SizeConfig.mediumTextSize,
                          ),
                        ),
                    ],
                  )
                : Text('No tickets yet'),
          ),
        ),
      );
    } else {
      if (_topFiveTambolaBoards.isEmpty) {
        _refreshBestBoards().forEach((element) {
          _topFiveTambolaBoards.add(_buildBoardView(element));
        });
      }

      _widget = Container(
        height: SizeConfig.screenWidth * 0.95,
        child: Stack(
          children: [
            Container(
              height: SizeConfig.screenWidth * 0.95,
              width: SizeConfig.screenWidth,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: List.generate(_topFiveTambolaBoards.length,
                    (index) => _topFiveTambolaBoards[index]),
              ),
            ),
            if (ticketsBeingGenerated)
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: SpinKitWave(color: UiConstants.primaryColor),
                      ),
                      Text(
                        'More tickets are being generated. please wait',
                        style: TextStyle(
                            fontSize: SizeConfig.mediumTextSize,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      );

      if (_currentBoardView == null)
        _currentBoardView = Ticket(
          bgColor: tambolaTicketColorPaletteList[0].boardColor,
          boardColorEven: tambolaTicketColorPaletteList[0].itemColorEven,
          boardColorOdd: tambolaTicketColorPaletteList[0].itemColorOdd,
          boradColorMarked: tambolaTicketColorPaletteList[0].itemColorMarked,
          calledDigits: [],
          board: null,
        );
      if (_currentBoard == null)
        _currentBoard = baseProvider.userWeeklyBoards[0];
    }
    return _widget;
  }

  Ticket _buildBoardView(TambolaBoard board) {
    if (board == null || !board.isValid()) return null;
    List<int> _calledDigits;
    if (!baseProvider.weeklyDrawFetched ||
        baseProvider.weeklyDigits == null ||
        baseProvider.weeklyDigits.toList().isEmpty)
      _calledDigits = [];
    else {
      _calledDigits =
          baseProvider.weeklyDigits.getPicksPostDate(board.generatedDayCode);
    }
    TambolaTicketColorPalette ticketColor = tambolaTicketColorPaletteList[
        Random().nextInt(tambolaTicketColorPaletteList.length - 1) + 1];
    return Ticket(
      board: board,
      calledDigits: _calledDigits,
      bgColor: ticketColor.boardColor,
      boardColorEven: ticketColor.itemColorEven,
      boardColorOdd: ticketColor.itemColorOdd,
      boradColorMarked: ticketColor.itemColorMarked,
    );
  }

  _buildTicketSummaryCards(bool fetchedFlag, bool drawFetchedFlag,
      List<TambolaBoard> boards, int count) {
    Widget _widget;
    if (!fetchedFlag || !drawFetchedFlag) {
      _widget = SizedBox();
    } else if (boards == null || count == 0) {
      _widget = SizedBox();
    } else {
      if (!_isTicketSummaryLoaded)
        ticketSummaryData = _getTambolaTicketsSummary();

      _widget = ticketSummaryData.isEmpty
          ? SizedBox()
          : Container(
              height: SizeConfig.screenWidth * 0.36,
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeHorizontal * 2),
              child: PageView(
                controller: _summaryController,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  ticketSummaryData.length,
                  (index) => Container(
                    width: SizeConfig.screenWidth,
                    alignment: Alignment.center,
                    child: Container(
                      margin: ticketSummaryData.length == 1
                          ? EdgeInsets.all(0)
                          : EdgeInsets.only(
                              right: SizeConfig.blockSizeHorizontal * 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ticketSummaryData[index].color,
                        image: DecorationImage(
                          image: NetworkImage(ticketSummaryData[index].bgAsset),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              ticketSummaryData[index].color.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                            SizeConfig.globalMargin,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ticketSummaryData[index].data[0].title,
                                style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize * 1.2,
                                  color: Colors.white,
                                  height: 1.6,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  AppState.delegate.appState.currentAction =
                                      PageAction(
                                    state: PageState.addWidget,
                                    page: TSummaryDetailsPageConfig,
                                    widget: SummaryTicketsDisplay(
                                      summary: ticketSummaryData[index],
                                    ),
                                  );
                                },
                                child: Container(
                                  width: SizeConfig.screenWidth * 0.3,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    ticketSummaryData[index].data.length == 1
                                        ? "Show ticket(s)"
                                        : "Show All",
                                    style: TextStyle(
                                      fontSize: SizeConfig.mediumTextSize,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
    }
    //_isTicketSummaryLoaded = true;
    return _widget;
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
      AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: TWeeklyResultPageConfig,
        widget: WeeklyResult(
          winningsmap: ticketCodeWinIndex,
          isEligible: _isEligible,
        ),
      );
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

  List<TicketSummaryCardModel> _getTambolaTicketsSummary() {
    List<TicketSummaryCardModel> summary = [];

    List<Ticket> bestCornerBoard = [];
    List<Ticket> bestTopRowBoard = [];
    List<Ticket> bestMiddleRowBoard = [];
    List<Ticket> bestBottomRowBoard = [];
    List<Ticket> bestFullHouseBoard = [];
    List<Ticket> completedCornersBoard = [];
    List<Ticket> completedTopRowBoard = [];
    List<Ticket> completedBottomRowBoard = [];
    List<Ticket> completedMiddleRowBoard = [];
    List<Ticket> completedFullHouseBoard = [];
    List<BestTambolaTicketsSumm> completedBoardCardItems = [];
    List<BestTambolaTicketsSumm> bestRowsBoardCardItems = [];
    List<BestTambolaTicketsSumm> bestCornersBoardCardItems = [];
    List<BestTambolaTicketsSumm> fullHouseBoardCardItems = [];

    if (baseProvider.userWeeklyBoards == null ||
        baseProvider.userWeeklyBoards.isEmpty) {
      return summary;
    }

    if (baseProvider.weeklyDigits == null ||
        baseProvider.weeklyDigits.toList().isEmpty) {
      return summary;
    }

    baseProvider.userWeeklyBoards.forEach((board) {
      // CORNERS CHECK
      // Checking for any completed corner borads
      if (board.getCornerOdds(baseProvider.weeklyDigits
              .getPicksPostDate(board.generatedDayCode)) ==
          0) completedCornersBoard.add(_buildBoardView(board));
      // Checking for best Chances
      if (board.getCornerOdds(baseProvider.weeklyDigits
                  .getPicksPostDate(board.generatedDayCode)) <
              2 &&
          board.getCornerOdds(baseProvider.weeklyDigits
                  .getPicksPostDate(board.generatedDayCode)) >
              0) bestCornerBoard.add(_buildBoardView(board));

      // ROWS CHECK
      // TOP ROW
      if (board.getRowOdds(
                  0,
                  baseProvider.weeklyDigits
                      .getPicksPostDate(board.generatedDayCode)) <
              3 &&
          board.getRowOdds(
                  0,
                  baseProvider.weeklyDigits
                      .getPicksPostDate(board.generatedDayCode)) >
              0) bestTopRowBoard.add(_buildBoardView(board));

      if (board.getRowOdds(
              0,
              baseProvider.weeklyDigits
                  .getPicksPostDate(board.generatedDayCode)) ==
          0) completedTopRowBoard.add(_buildBoardView(board));

      // MIDDLE ROW
      if (board.getRowOdds(
                  1,
                  baseProvider.weeklyDigits
                      .getPicksPostDate(board.generatedDayCode)) <
              3 &&
          board.getRowOdds(
                  1,
                  baseProvider.weeklyDigits
                      .getPicksPostDate(board.generatedDayCode)) >
              0) bestMiddleRowBoard.add(_buildBoardView(board));

      if (board.getRowOdds(
              1,
              baseProvider.weeklyDigits
                  .getPicksPostDate(board.generatedDayCode)) ==
          0) completedMiddleRowBoard.add(_buildBoardView(board));

      // BOTTOM ROW
      if (board.getRowOdds(
                  2,
                  baseProvider.weeklyDigits
                      .getPicksPostDate(board.generatedDayCode)) <
              3 &&
          board.getRowOdds(
                  2,
                  baseProvider.weeklyDigits
                      .getPicksPostDate(board.generatedDayCode)) >
              0) bestBottomRowBoard.add(_buildBoardView(board));

      if (board.getRowOdds(
              2,
              baseProvider.weeklyDigits
                  .getPicksPostDate(board.generatedDayCode)) ==
          0) completedBottomRowBoard.add(_buildBoardView(board));

      // FULL HOUSE CHECK

      // Checking for completed Full House Boards
      if (board.getFullHouseOdds(baseProvider.weeklyDigits
              .getPicksPostDate(board.generatedDayCode)) ==
          0) completedFullHouseBoard.add(_buildBoardView(board));
      // Checking for best Chances of a Full House Board
      if (board.getFullHouseOdds(baseProvider.weeklyDigits
                  .getPicksPostDate(board.generatedDayCode)) <
              5 &&
          board.getFullHouseOdds(baseProvider.weeklyDigits
                  .getPicksPostDate(board.generatedDayCode)) >
              0) bestFullHouseBoard.add(_buildBoardView(board));
    });

    // ADDING COMPLETED CATEGORIES TO FORM A LIST OF TILE DATA FOR THE CARD
    if (completedFullHouseBoard.isNotEmpty)
      completedBoardCardItems.add(BestTambolaTicketsSumm(
          boards: completedFullHouseBoard,
          title: getBoardTileTitle("Full House", completedFullHouseBoard.length,
              false, completedFullHouseBoard[0])));
    if (completedTopRowBoard.isNotEmpty)
      completedBoardCardItems.add(BestTambolaTicketsSumm(
          boards: completedTopRowBoard,
          title: getBoardTileTitle("Top Row", completedTopRowBoard.length,
              false, completedTopRowBoard[0])));
    if (completedMiddleRowBoard.isNotEmpty)
      completedBoardCardItems.add(BestTambolaTicketsSumm(
          boards: completedMiddleRowBoard,
          title: getBoardTileTitle("Middle Row", completedMiddleRowBoard.length,
              false, completedMiddleRowBoard[0])));
    if (completedBottomRowBoard.isNotEmpty)
      completedBoardCardItems.add(BestTambolaTicketsSumm(
          boards: completedBottomRowBoard,
          title: getBoardTileTitle("Bottom Row", completedBottomRowBoard.length,
              false, completedBottomRowBoard[0])));
    if (completedCornersBoard.isNotEmpty)
      completedBoardCardItems.add(BestTambolaTicketsSumm(
          boards: completedCornersBoard,
          title: getBoardTileTitle("Corners", completedCornersBoard.length,
              false, completedCornersBoard[0])));

    // ADDING BEST CHANCES CATEGORIES TO FORM A LIST OF TILE DATA FOR THE CARD
    if (bestCornerBoard.isNotEmpty)
      bestCornersBoardCardItems.add(BestTambolaTicketsSumm(
          boards: bestCornerBoard,
          title: getBoardTileTitle(
              "Corners", bestCornerBoard.length, true, bestCornerBoard[0])));
    if (bestTopRowBoard.isNotEmpty)
      bestRowsBoardCardItems.add(BestTambolaTicketsSumm(
          boards: bestTopRowBoard,
          title: getBoardTileTitle(
              "Top Row", bestTopRowBoard.length, true, bestTopRowBoard[0])));
    if (bestMiddleRowBoard.isNotEmpty)
      bestRowsBoardCardItems.add(BestTambolaTicketsSumm(
          boards: bestMiddleRowBoard,
          title: getBoardTileTitle("Middle Row", bestMiddleRowBoard.length,
              true, bestMiddleRowBoard[0])));
    if (bestBottomRowBoard.isNotEmpty)
      bestRowsBoardCardItems.add(BestTambolaTicketsSumm(
          boards: bestBottomRowBoard,
          title: getBoardTileTitle("Bottom Row", bestBottomRowBoard.length,
              true, bestBottomRowBoard[0])));

    // ADDING THE BEST CHANCES OFF FULL HOUSE -SINGLE ITEM
    if (bestFullHouseBoard.isNotEmpty)
      fullHouseBoardCardItems.add(BestTambolaTicketsSumm(
          boards: bestFullHouseBoard,
          title: getBoardTileTitle("Full House", bestFullHouseBoard.length,
              true, bestFullHouseBoard[0])));

    //CREATING CARDS FOR EACH CARD ITEMS
    if (fullHouseBoardCardItems.isNotEmpty)
      summary.add(TicketSummaryCardModel(
          data: fullHouseBoardCardItems,
          color: Color(0xff810000),
          cardType: "Jackpot",
          bgAsset:
              "https://img.freepik.com/free-vector/realistic-casino-background_52683-7264.jpg?size=626&ext=jpg&uid=P35674521"));

    if (completedBoardCardItems.isNotEmpty)
      summary.add(TicketSummaryCardModel(
          data: completedBoardCardItems,
          color: Colors.blue,
          cardType: "Completed",
          bgAsset:
              "https://img.freepik.com/free-vector/blue-halftone-memphis-background-with-yellow-lines-circles-shapes_1017-31954.jpg?size=626&ext=jpg&uid=P35674521"));
    if (bestCornersBoardCardItems.isNotEmpty)
      summary.add(TicketSummaryCardModel(
          data: bestCornersBoardCardItems,
          color: Color(0xff511281),
          cardType: "Best Corners",
          bgAsset:
              "https://img.freepik.com/free-vector/gradient-liquid-abstract-background_52683-60469.jpg?size=626&ext=jpg&uid=P35674521"));
    if (bestRowsBoardCardItems.isNotEmpty)
      summary.add(TicketSummaryCardModel(
          data: bestRowsBoardCardItems,
          color: Color(0xffFFA41B),
          cardType: "Best Rows",
          bgAsset:
              "https://img.freepik.com/free-vector/abstract-low-poly-orange-yellow-background_1017-32111.jpg?size=626&ext=jpg&uid=P35674521"));

    _isTicketSummaryLoaded = true;
    return summary;
  }

  getBoardTileTitle(
      String category, int length, bool bestCards, Ticket firstCard) {
    String output;

    if (bestCards) {
      if (category == "Corners") {
        if (length == 1)
          output =
              "Ticket #${firstCard.board.getTicketNumber()} is just 1 number away from completing its $category!";
        else
          output =
              "$length of your tickets are just 1 number away from completing their $category!";
      } else if (category == "Full House") {
        if (length == 1)
          output =
              "Ticket #${firstCard.board.getTicketNumber()} is just less than 5 numbers away from winning the $category!";
        else
          output =
              "$length of your tickets are less than 5 numbers away from winning the $category!";
      } else {
        if (length == 1)
          output =
              "Ticket #${firstCard.board.getTicketNumber()} is just 2 numbers away from completing its $category!";
        else
          output =
              "$length of your tickets are just 2 numbers away from completing its $category.";
      }
    } else {
      if (length == 1)
        output =
            "Ticket #${firstCard.board.getTicketNumber()} has completed its $category!";
      else
        output = "$length of your tickets have completed their $category!";
    }

    return output;
  }

  List<TambolaBoard> _refreshBestBoards() {
    List<TambolaBoard> _bestTambolaBoards = [];

    // If boards are empty
    if (baseProvider.userWeeklyBoards == null ||
        baseProvider.userWeeklyBoards.isEmpty) {
      return _bestTambolaBoards;
    }
    // If number of boards are less than 5, return all the boards
    if (baseProvider.userWeeklyBoards.length <= 5) {
      _bestTambolaBoards = [];
      baseProvider.userWeeklyBoards.forEach((e) {
        _bestTambolaBoards.add(e);
      });
      return _bestTambolaBoards;
    }
    // If numbers of boards are more than 5

    //initialise bestboards with first 5 board
    // _bestTambolaBoards = List.filled(5, baseProvider.userWeeklyBoards[0]);
    for (int i = 0; i < 5; i++) {
      _bestTambolaBoards.add(baseProvider.userWeeklyBoards[i]);
    }

    // If weekly digits are not announced yet, simply return first 5 tickets
    if (baseProvider.weeklyDigits == null ||
        baseProvider.weeklyDigits.toList().isEmpty) {
      return _bestTambolaBoards;
    }

    for (int i = 5; i < baseProvider.userWeeklyBoards.length; i++) {
      final board = baseProvider.userWeeklyBoards[i];
      if (_bestTambolaBoards[0].getRowOdds(
                  0,
                  baseProvider.weeklyDigits.getPicksPostDate(
                      _bestTambolaBoards[0].generatedDayCode)) >
              board.getRowOdds(
                  0,
                  baseProvider.weeklyDigits
                      .getPicksPostDate(board.generatedDayCode)) &&
          !_bestTambolaBoards.contains(board)) {
        _bestTambolaBoards[0] = board;
      }
      if (_bestTambolaBoards[1].getRowOdds(
                  1,
                  baseProvider.weeklyDigits.getPicksPostDate(
                      _bestTambolaBoards[1].generatedDayCode)) >
              board.getRowOdds(
                  1,
                  baseProvider.weeklyDigits
                      .getPicksPostDate(board.generatedDayCode)) &&
          !_bestTambolaBoards.contains(board)) {
        _bestTambolaBoards[1] = board;
      }
      if (_bestTambolaBoards[2].getRowOdds(
                  2,
                  baseProvider.weeklyDigits.getPicksPostDate(
                      _bestTambolaBoards[2].generatedDayCode)) >
              board.getRowOdds(
                  2,
                  baseProvider.weeklyDigits
                      .getPicksPostDate(board.generatedDayCode)) &&
          !_bestTambolaBoards.contains(board)) {
        _bestTambolaBoards[2] = board;
      }
      if (_bestTambolaBoards[3].getCornerOdds(baseProvider.weeklyDigits
                  .getPicksPostDate(_bestTambolaBoards[3].generatedDayCode)) >
              board.getCornerOdds(baseProvider.weeklyDigits
                  .getPicksPostDate(board.generatedDayCode)) &&
          !_bestTambolaBoards.contains(board)) {
        _bestTambolaBoards[3] = board;
      }
      if (_bestTambolaBoards[4].getFullHouseOdds(baseProvider.weeklyDigits
                  .getPicksPostDate(_bestTambolaBoards[4].generatedDayCode)) >
              board.getFullHouseOdds(baseProvider.weeklyDigits
                  .getPicksPostDate(board.generatedDayCode)) &&
          !_bestTambolaBoards.contains(board)) {
        _bestTambolaBoards[4] = board;
      }
    }

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
              style: GoogleFonts.montserrat(
                // fontFamily: "Cucciolo",
                color: Colors.white,
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
            // Text(
            //   "[ GLOBAL ]",
            //   style: GoogleFonts.montserrat(
            //     color: Colors.white,
            //     fontSize: 12,
            //     letterSpacing: 5,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class GameAppBar extends StatefulWidget {
  const GameAppBar({
    Key key,
  }) : super(key: key);

  @override
  State createState() => _GameAppBarState();
}

class _GameAppBarState extends State<GameAppBar> {
  bool _highlight = false;
  bool _isInit = false;

  @override
  Widget build(BuildContext context) {
    final lclDbModel = Provider.of<LocalDBModel>(context);
    if (!_isInit) {
      lclDbModel.showTambolaTutorial.then((flag) {
        _highlight = flag;
        _isInit = true;
        setState(() {});
      });
    }
    return Container(
      height: SizeConfig.screenWidth * 0.14,
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
          Stack(
            alignment: Alignment.topRight,
            children: [
              _highlight
                  ? Center(
                      child: SpinKitPulse(
                      size: 50,
                      color: Colors.white,
                    ))
                  : Container(),
              Center(
                  child: IconButton(
                onPressed: () {
                  AppState.delegate.appState.currentAction = PageAction(
                      state: PageState.addPage, page: TWalkthroughPageConfig);
                  lclDbModel.setShowTambolaTutorial = false;
                },
                icon: Icon(Icons.info),
                color: Colors.white,
              ))
            ],
          ),
        ],
      ),
    );
  }
}

class CurrentPicks extends StatelessWidget {
  const CurrentPicks();
  @override
  Widget build(BuildContext context) {
    BaseUtil baseProvider = Provider.of<BaseUtil>(context);
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(flex: 2),
            DailyPicksTimer(
              replacementWidget: Container(
                width: SizeConfig.screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: (baseProvider.todaysPicks ??
                          List.filled(baseProvider.dailyPicksCount, 0))
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
                                    borderRadius: BorderRadius.circular(100),
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
                                    e.toString() ?? "-",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: SizeConfig.largeTextSize),
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
                                    e.toString() ?? "-",
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
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 2),
              child: Text(
                "Tap to see all picks of this week",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.mediumTextSize,
                    height: 2),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class FaqSection extends StatefulWidget {
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
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: Offset(5, 5),
                spreadRadius: 5,
                blurRadius: 5)
          ]),
      margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
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
    List<Map<String, String>> _faqList = _buildFaqList();
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
              _faqList.length,
              (index) => ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (ctx, isOpen) => _prizeFAQHeader(
                    faqLeadIcons[index], _faqList[index].keys.first),
                isExpanded: detStatus[index],
                body: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 2,
                    right: SizeConfig.blockSizeHorizontal * 6,
                  ),
                  child: Text(
                    _faqList[index].values.first,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: SizeConfig.mediumTextSize,
                    ),
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

  List<Map<String, String>> _buildFaqList() {
    return [
      {
        'How does one participate in Tambola?':
            '- Everyday, ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.TAMBOLA_DAILY_PICK_COUNT)} random numbers are picked.\n\n- The matching numbers on your tickets get automatically crossed, starting from the day they were generated.\n\n- On Sunday, your tickets are processed to see if they matched a category.'
      },
      {
        'How does one win the game?':
            '- Every Sunday, your winning tickets get processed, and the winnings for that week are shared with you in the next few days. \n\n- If there are more than 1 winners for a category, the prize amount gets equally distributed amongst all the category winners.'
      },
      {
        'How can I redeem my winnings?':
            '- If you\'re a tambola winner, your reward gets credited to your Fello wallet in a few days. \n\n- Once credited, you can choose how you would like to redeem it. It could be as digital gold or as Amazon pay balance.'
      },
      {
        'How can I maximize my winnings ?':
            'As traditional tambola goes, the more tickets you have, the better your odds of stealing a category! 💪\n'
      },
    ];
  }
}

class TicketSummaryCardModel {
  final List<BestTambolaTicketsSumm> data;
  final String cardType;
  final String bgAsset;
  final Color color;

  TicketSummaryCardModel({this.bgAsset, this.data, this.cardType, this.color});
}

class BestTambolaTicketsSumm {
  final List<Ticket> boards;
  final String title;

  BestTambolaTicketsSumm({@required this.boards, @required this.title});
}
