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
import 'package:felloapp/ui/elements/tambola-global/tambola_daily_draw_timer.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:felloapp/ui/elements/tambola-global/weekly_picks.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/pick_draw.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/show_all_tickets.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/weekly_result.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class TambolaHome extends StatefulWidget {
  const TambolaHome({Key key}) : super(key: key);

  @override
  _TambolaHomeState createState() => _TambolaHomeState();
}

class _TambolaHomeState extends State<TambolaHome> {
  // HEIGHT CALCULATED ACCORDING TO THE ITEMS PRESENT IN THE CONTAINER
  double normalTopCardHeight = SizeConfig.screenWidth * 0.8;
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

  List<Ticket> _tambolaBoardViews, _topFiveTambolaBoards;
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

  void _onVerticalDragUpdate() {
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              GestureDetector(
                onTap: _onVerticalDragUpdate,
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
                      const GameAppBar(),
                      !isShowingAllPicks
                          ? GameTitle(titleOpacity: titleOpacity)
                          : SizedBox(),
                      InkWell(
                        onTap: () =>
                        delegate.appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          page: TPickDrawPageConfig,
                          widget: PicksDraw(
                            picks:
                            List.filled(baseProvider.dailyPicksCount, -1),
                          ),
                        ),
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
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 3,
                    vertical: SizeConfig.blockSizeHorizontal * 2),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Tickets ($_activeTambolaCardCount)",
                          style: GoogleFonts.montserrat(
                            color: Colors.black87,
                            fontSize: SizeConfig.cardTitleTextSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 4,
                          ),
                          child: Text(
                            "Here are your best 5 tickets",
                            style: TextStyle(
                              fontSize: SizeConfig.smallTextSize,
                              color: UiConstants.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        _tambolaBoardViews = [];
                        baseProvider.userWeeklyBoards.forEach((board) {
                          _tambolaBoardViews.add(_buildBoardView(
                              board, baseProvider.weeklyDigits));
                        });
                        delegate.appState.currentAction = PageAction(
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
              _buildTicketSummaryCards(
                  baseProvider.weeklyTicksFetched,
                  baseProvider.weeklyDrawFetched,
                  baseProvider.userWeeklyBoards,
                  _activeTambolaCardCount),
              InkWell(
                  onTap: () => delegate.appState.currentAction = PageAction(
                    state: PageState.addWidget,
                    page: TWeeklyResultPageConfig,
                    widget: WeeklyResult(
                      winningsmap: {},
                      isEligible: false,
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
      if (_topFiveTambolaBoards == null) {
        _topFiveTambolaBoards = [];
        _refreshBestBoards().forEach((element) {
          _topFiveTambolaBoards
              .add(_buildBoardView(element, baseProvider.weeklyDigits));
        });
      }

      _widget = Container(
        height: SizeConfig.screenWidth * 0.95,
        width: SizeConfig.screenWidth,
        child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: List.generate(_topFiveTambolaBoards.length,
                  (index) => _topFiveTambolaBoards[index]),
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
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.blockSizeHorizontal * 3,
              left: SizeConfig.blockSizeHorizontal * 3,
              right: SizeConfig.blockSizeHorizontal * 3,
              bottom: SizeConfig.blockSizeHorizontal * 2,
            ),
            child: Text(
              "Tickets Summary",
              style: GoogleFonts.montserrat(
                color: Colors.black87,
                fontSize: SizeConfig.cardTitleTextSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            height: SizeConfig.screenWidth * 0.5,
            width: SizeConfig.screenWidth,
            child: PageView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                ticketSummaryData.length,
                    (index) => Container(
                  height: SizeConfig.screenWidth * 0.5,
                  width: SizeConfig.screenWidth,
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black,
                    image: DecorationImage(
                      image:
                      NetworkImage(ticketSummaryData[index].bgAsset),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      ticketSummaryData[index].title == "Congratulations"
                          ? Lottie.asset(
                        "images/lottie/reward-claimed.json",
                        height: SizeConfig.screenWidth * 0.5,
                        width: SizeConfig.screenWidth,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        height: SizeConfig.screenWidth * 0.5,
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            SizeConfig.blockSizeHorizontal * 3),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                ticketSummaryData[index].title,
                                style: TextStyle(
                                  fontSize: SizeConfig.largeTextSize,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                shrinkWrap: true,
                                children: List.generate(
                                  ticketSummaryData[index].data.length,
                                      (i) => InkWell(
                                    onTap: () {
                                      _tambolaBoardViews = [];
                                      ticketSummaryData[index]
                                          .data[i]
                                          .boards
                                          .forEach((board) {
                                        _tambolaBoardViews.add(
                                            _buildBoardView(
                                                board,
                                                baseProvider
                                                    .weeklyDigits));
                                      });
                                      delegate.appState.currentAction =
                                          PageAction(
                                            state: PageState.addWidget,
                                            page: TShowAllTicketsPageConfig,
                                            widget: ShowAllTickets(
                                              tambolaBoardView:
                                              _tambolaBoardViews,
                                            ),
                                          );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: SizeConfig
                                              .blockSizeHorizontal *
                                              3,
                                          vertical: SizeConfig
                                              .blockSizeHorizontal *
                                              2.5),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 3,
                                            backgroundColor: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              ticketSummaryData[index]
                                                  .data[i]
                                                  .title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: SizeConfig
                                                    .mediumTextSize,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
      delegate.appState.currentAction = PageAction(
          state: PageState.addPage,
          widget: WeeklyResult(
            winningsmap: ticketCodeWinIndex,
            isEligible: _isEligible,
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

  List<TicketSummaryCardModel> _getTambolaTicketsSummary() {
    List<TicketSummaryCardModel> summary = [];

    List<TambolaBoard> bestCornerBoard = [];
    List<TambolaBoard> bestTopRowBoard = [];
    List<TambolaBoard> bestMiddleRowBoard = [];
    List<TambolaBoard> bestBottomRowBoard = [];
    List<TambolaBoard> bestFullHouseBoard = [];
    List<TambolaBoard> completedCornersBoard = [];
    List<TambolaBoard> completedTopRowBoard = [];
    List<TambolaBoard> completedBottomRowBoard = [];
    List<TambolaBoard> completedMiddleRowBoard = [];
    List<TambolaBoard> completedFullHouseBoard = [];
    List<BestTambolaTicketsSumm> completedBoardCardItems = [];
    List<BestTambolaTicketsSumm> bestChancesBoardCardItems = [];
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
          0) completedCornersBoard.add(board);
      // Checking for best Chances
      if (board.getCornerOdds(baseProvider.weeklyDigits
          .getPicksPostDate(board.generatedDayCode)) <
          2 &&
          board.getCornerOdds(baseProvider.weeklyDigits
              .getPicksPostDate(board.generatedDayCode)) >
              0) bestCornerBoard.add(board);

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
              0) bestTopRowBoard.add(board);

      if (board.getRowOdds(
          0,
          baseProvider.weeklyDigits
              .getPicksPostDate(board.generatedDayCode)) ==
          0) completedTopRowBoard.add(board);

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
              0) bestMiddleRowBoard.add(board);

      if (board.getRowOdds(
          1,
          baseProvider.weeklyDigits
              .getPicksPostDate(board.generatedDayCode)) ==
          0) completedMiddleRowBoard.add(board);

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
              0) bestBottomRowBoard.add(board);

      if (board.getRowOdds(
          2,
          baseProvider.weeklyDigits
              .getPicksPostDate(board.generatedDayCode)) ==
          0) completedBottomRowBoard.add(board);

      // FULL HOUSE CHECK

      // Checking for completed Full House Boards
      if (board.getFullHouseOdds(baseProvider.weeklyDigits
          .getPicksPostDate(board.generatedDayCode)) ==
          0) completedFullHouseBoard.add(board);
      // Checking for best Chances of a Full House Board
      if (board.getFullHouseOdds(baseProvider.weeklyDigits
          .getPicksPostDate(board.generatedDayCode)) <
          5 &&
          board.getFullHouseOdds(baseProvider.weeklyDigits
              .getPicksPostDate(board.generatedDayCode)) >
              0) bestFullHouseBoard.add(board);
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
      bestChancesBoardCardItems.add(BestTambolaTicketsSumm(
          boards: bestCornerBoard,
          title: getBoardTileTitle(
              "Corners", bestCornerBoard.length, true, bestCornerBoard[0])));
    if (bestTopRowBoard.isNotEmpty)
      bestChancesBoardCardItems.add(BestTambolaTicketsSumm(
          boards: bestTopRowBoard,
          title: getBoardTileTitle(
              "Top Row", bestTopRowBoard.length, true, bestTopRowBoard[0])));
    if (bestMiddleRowBoard.isNotEmpty)
      bestChancesBoardCardItems.add(BestTambolaTicketsSumm(
          boards: bestMiddleRowBoard,
          title: getBoardTileTitle("Middle Row", bestMiddleRowBoard.length,
              true, bestMiddleRowBoard[0])));
    if (bestBottomRowBoard.isNotEmpty)
      bestChancesBoardCardItems.add(BestTambolaTicketsSumm(
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
          title: "Jackpot is near",
          bgAsset:
          "https://img.freepik.com/free-vector/realistic-casino-background_52683-7264.jpg?size=626&ext=jpg&uid=P35674521"));

    if (completedBoardCardItems.isNotEmpty)
      summary.add(TicketSummaryCardModel(
          data: completedBoardCardItems,
          title: "Congratulations",
          bgAsset:
          "dsfhttps://media.istockphoto.com/videos/confetti-particle-cg-animation-video-id884038624?b=1&k=6&m=884038624&s=640x640&h=rkbk3IABay83MtXOVJwOpr8-s5RY8t0H3KfT_7dDGZE="));
    if (bestChancesBoardCardItems.isNotEmpty)
      summary.add(TicketSummaryCardModel(
          data: bestChancesBoardCardItems,
          title: "very close to win",
          bgAsset:
          "https://img.freepik.com/free-photo/close-up-strong-male-hand-holding-gold-medal-sporting-achievement_116124-44.jpg?size=626&ext=jpg&uid=P35674521"));
    _isTicketSummaryLoaded = true;
    return summary;
  }

  getBoardTileTitle(
      String category, int length, bool bestCards, TambolaBoard firstCard) {
    String suffix = length > 1 ? "view all tickets" : "see";
    String output;
    if (bestCards) {
      if (category == "Corners") {
        if (length == 1)
          output =
          "Ticket #${firstCard.getTicketNumber()} is just 1 number away from";
        else
          output = "$length of your tickets needs only 1 number to complete";
      } else {
        if (length == 1)
          output =
          "Ticket #${firstCard.getTicketNumber()} is just 1 number away from";
        else
          output = "$length of your tickets needs only 2 numbers to complete";
      }
    } else {
      if (length == 1)
        output = "Ticket #${firstCard.getTicketNumber()} completed";
      else
        output = "$length of your tickets completed";
    }

    return output + " $category. Tap to $suffix";
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
      height: SizeConfig.screenWidth * 0.16,
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
            height: SizeConfig.screenWidth * 0.1,
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(flex: 2),
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
                        Assets.tambolaFaqList[index].values.first,
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
      margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: Text(
                    "Prizes",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("images/Tambola/p-rows.png"),
                          SizedBox(height: 10),
                          Text(
                            "Any Row",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "₹ ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.TAMBOLA_WIN_TOP)}",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: SizeConfig.cardTitleTextSize * 1.2,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        offset: Offset(4, 4),
                                        spreadRadius: 4,
                                        blurRadius: 4)
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                                SizeConfig.blockSizeHorizontal * 2),
                            decoration: BoxDecoration(
                                color: Color(0xff5B51E7),
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.apps,
                              color: Colors.white,
                              size: SizeConfig.screenWidth * 0.14,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Full House",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              '₹ ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.TAMBOLA_WIN_FULL)}',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: SizeConfig.cardTitleTextSize * 2,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        offset: Offset(4, 4),
                                        spreadRadius: 4,
                                        blurRadius: 4)
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                                SizeConfig.blockSizeHorizontal * 1),
                            decoration: BoxDecoration(
                                color: Color(0xffE9E9E9),
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(
                              Icons.border_outer_rounded,
                              color: Color(0xff264653),
                              size: SizeConfig.screenWidth * 0.1,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Corners",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "₹ ${BaseRemoteConfig.remoteConfig.getString(BaseRemoteConfig.TAMBOLA_WIN_CORNER)}",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: SizeConfig.cardTitleTextSize,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        offset: Offset(4, 4),
                                        spreadRadius: 4,
                                        blurRadius: 4)
                                  ]),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TicketSummaryCardModel {
  final List<BestTambolaTicketsSumm> data;
  final String title;
  final String bgAsset;

  TicketSummaryCardModel({this.bgAsset, this.data, this.title});
}

class BestTambolaTicketsSumm {
  final List<TambolaBoard> boards;
  final String title;

  BestTambolaTicketsSumm({@required this.boards, @required this.title});
}