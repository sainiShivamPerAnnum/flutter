import 'dart:async';
import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/service/tambola_generation_service.dart';
import 'package:felloapp/ui/dialogs/tambola_dialog.dart';
import 'package:felloapp/ui/dialogs/weekly_draw_dialog.dart';
import 'package:felloapp/ui/dialogs/winnings_dialog.dart';
import 'package:felloapp/ui/elements/board_selector.dart';
import 'package:felloapp/ui/elements/roulette.dart';
import 'package:felloapp/ui/elements/tambola_board_view.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola-cards.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';

class TambolaHome extends StatefulWidget {
  @override
  _TambolaGameScreen createState() => _TambolaGameScreen();
}

class _TambolaGameScreen extends State<TambolaHome> {
  Log log = new Log('CardScreen');
  TambolaBoard _currentBoard;
  TambolaBoardView _currentBoardView;
  bool _winnerDialogCalled = false;

  //GlobalKey<TambolaBoardState> _currentKey;
  List<TambolaBoardView> _tambolaBoardViews;
  List<TambolaBoard> _bestTambolaBoards;
  List<Widget> balls = [];

  //List<GlobalKey<TambolaBoardState>> _boardKeys;
  var rnd = new Random();
  BaseUtil baseProvider;
  DBModel dbProvider;
  FcmHandler fcmProvider;
  LocalDBModel localDBModel;

  bool ticketsBeingGenerated = false;
  bool dailyPickHeaderWithTimings = false;
  String dailyPickHeaderText = 'Today\'s picks';
  List<String> dailyPickTextList = [];
  List<String> prizeEmoji = ['🥇', '🏆', ' 🎊', ' 🎉'];

  GlobalKey _showcaseOne = GlobalKey();
  GlobalKey _showcaseTwo = GlobalKey();
  GlobalKey _showcaseThree = GlobalKey();
  GlobalKey _showcaseFour = GlobalKey();
  bool _showTutorial = false;
  Timer _prizeTimer;

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
    String remoteTime = BaseUtil.remoteConfig.getString('draw_pick_time');
    remoteTime = (remoteTime == null || remoteTime.isEmpty) ? '18' : remoteTime;
    int tx = 18;
    try {
      tx = int.parse(remoteTime);
    } catch (e) {
      tx = 18;
    }
    DateTime _time = DateTime.now();
    dailyPickHeaderWithTimings = (_time.hour < tx);
    if (dailyPickHeaderWithTimings) {
      String am_pm = (tx > 11) ? 'PM' : 'AM';
      String ttime =
          (tx > 12) ? (tx - 12).toString() + am_pm : tx.toString() + am_pm;
      dailyPickHeaderText = 'Today\'s picks - Drawn at $ttime';
    } else {
      dailyPickHeaderText = 'Today\'s picks';
    }

    dailyPickTextList.add(dailyPickHeaderText);
    dailyPickTextList.add('Click to see the other picks');
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
    // int cx = baseProvider.checkTicketCountValidity(
    //     baseProvider.userWeeklyBoards);
    // if (cx > 0) {
    //   log.debug('Pushing ticket generation request');
    //   ticketsBeingGenerated = true;
    //   dbProvider.pushTicketRequest(baseProvider.myUser, cx);
    // }
    bool _isGenerating = await _tambolaTicketService
        .processTicketGenerationRequirement(_activeTambolaCardCount);
    if (_isGenerating) {
      _tambolaTicketService.setTambolaTicketGenerationResultListener((flag) {
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

    ///Show the onboarding showcase tutorial is user is new
    localDBModel.isFreshUser().then((flag) {
      if (flag == 0) {
        new Timer(const Duration(seconds: 4), () {
          _showTutorial = true;
          setState(() {});
        });
        localDBModel.saveFreshUserStatus(true);
      }
    });
  }

  _refreshTambolaTickets() async {
    log.debug('Refresh this mofo');
    baseProvider.weeklyTicksFetched = false;
    setState(() {});
  }

  bool _startTutorial() {
    if (baseProvider.weeklyDrawFetched &&
        baseProvider.weeklyTicksFetched &&
        _activeTambolaCardCount > 0) {
      //Start showcase view after current widget frames are drawn.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase(
            [_showcaseOne, _showcaseTwo, _showcaseThree, _showcaseFour]);
      });
      _showTutorial = false;
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  var cardMargin = EdgeInsets.symmetric(
      horizontal: SizeConfig.blockSizeHorizontal * 4,
      vertical: SizeConfig.blockSizeVertical * 1);
  var cardPadding = EdgeInsets.symmetric(
      horizontal: SizeConfig.blockSizeHorizontal * 4,
      vertical: SizeConfig.blockSizeVertical * 1);
  var cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      new BoxShadow(
        color: Colors.black26.withOpacity(0.1),
        offset: Offset.fromDirection(20, 7),
        blurRadius: 10.0,
      )
    ],
  );

  @override
  Widget build(BuildContext c) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    fcmProvider = Provider.of<FcmHandler>(context, listen: false);
    localDBModel = Provider.of<LocalDBModel>(context, listen: false);
    _init();
    _processTicketResults();
    if (_showTutorial) _startTutorial();
    return Scaffold(
        //debugShowCheckedModeBanner: false,
        backgroundColor: Color(0xfff1f1f1),
        body: Stack(
          children: [
            Container(
              height: SizeConfig.screenHeight * 0.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 0.6],
                  colors: [
                    UiConstants.primaryColor.withGreen(190),
                    UiConstants.primaryColor,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(
                      MediaQuery.of(context).size.width * 0.50, 18),
                  bottomRight: Radius.elliptical(
                      MediaQuery.of(context).size.width * 0.50, 18),
                ),
              ),
              child: Column(
                children: [
                  Spacer(),
                  _buildTicketCount(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SafeArea(
                child: SingleChildScrollView(child: _buildCardCanvas(context))),
            Positioned(
              top: 5,
              child: SafeArea(
                child: Container(
                  width: SizeConfig.screenWidth,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          HapticFeedback.vibrate();
                          Navigator.of(context).pop();
                        },
                      ),
                      Text('Tambola',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: SizeConfig.largeTextSize)),
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.help_outline),
                        onPressed: () {
                          HapticFeedback.vibrate();
                          _showTutorial = true;
                          if (!_startTutorial()) {
                            //baseProvider.showNegativeAlert('Try soon', message, context)
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // SafeArea(
            //     child: Align(
            //         alignment: Alignment.bottomCenter, child: _buildPrizeButton()))
          ],
        )
        //),
        );
  }

  Widget _buildShowcaseWrapper(
      GlobalKey showcaseKey, String showcaseMsg, Widget body) {
    return Showcase.withWidget(
        key: showcaseKey,
        description: showcaseMsg,
        contentPadding: EdgeInsets.all(20),
        //descTextStyle: TextStyle(fontSize: 20),
        width: 300,
        height: 140,
        container: Container(
          padding: EdgeInsets.all(20),
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(UiConstants.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Container(
            width: SizeConfig.screenWidth * 0.84,
            child: Text(
              showcaseMsg,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  fontWeight: FontWeight.w300,
                  color: UiConstants.accentColor),
            ),
          ),
        ),
        overlayOpacity: 0.6,
        child: body);
  }

  Widget _buildCardCanvas(BuildContext c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //_buildDashboard(),
        //  _buildTicketCount(),
        SizedBox(height: SizeConfig.screenHeight * 0.143),
        (baseProvider.weeklyDrawFetched)
            ? InkWell(
                child: _buildShowcaseWrapper(
                    _showcaseTwo,
                    Assets.showCaseDesc[1],
                    _buildTodaysPicksWidget(baseProvider.weeklyDigits)),
                onTap: () {
                  HapticFeedback.vibrate();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          WeeklyDrawDialog(baseProvider.weeklyDigits));
                },
              )
            : Padding(
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
              ),
        SizedBox(
          height: 24.0,
        ),
        Container(
          margin: cardMargin,
          padding: cardPadding,
          decoration: cardDecoration,
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              _buildTitle('This week\'s tickets'),
              _buildCards(
                  baseProvider.weeklyTicksFetched,
                  baseProvider.weeklyDrawFetched,
                  baseProvider.userWeeklyBoards,
                  _activeTambolaCardCount),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (baseProvider.weeklyTicksFetched &&
                          baseProvider.userWeeklyBoards != null &&
                          _activeTambolaCardCount > 0 &&
                          _currentBoard != null)
                      ? Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Text(
                            'Ticket #${_currentBoard.getTicketNumber()}',
                            style: GoogleFonts.montserrat(
                              fontSize: SizeConfig.smallTextSize,
                            ),
                          ),
                        )
                      : Container(),
                  _activeTambolaCardCount > 10
                      ? GestureDetector(
                          child: Text(
                            "Show All Tickets   ",
                            style: GoogleFonts.montserrat(
                              color: UiConstants.primaryColor.withGreen(600),
                            ),
                          ),
                          onTap: () {
                            _tambolaBoardViews = [];
                            baseProvider.userWeeklyBoards.forEach((board) {
                              _tambolaBoardViews.add(new TambolaBoardView(
                                  tambolaBoard: board.tambolaBoard,
                                  calledDigits:
                                      (baseProvider.weeklyDrawFetched &&
                                              baseProvider.weeklyDigits != null)
                                          ? baseProvider.weeklyDigits.toList()
                                          : [],
                                  boardColor:
                                      UiConstants.primaryColor.withGreen(200)));
                            });
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (ctx) => TambolaCardsList(
                                  tambolaBoardView: _tambolaBoardViews,
                                ),
                              ),
                            );
                          },
                        )
                      : SizedBox(),
                ],
              ),
              SizedBox(
                height: 8,
              )
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        (baseProvider.weeklyTicksFetched &&
                baseProvider.userWeeklyBoards != null &&
                _activeTambolaCardCount > 0 &&
                baseProvider.weeklyDrawFetched)
            ? _buildShowcaseWrapper(
                _showcaseFour,
                Assets.showCaseDesc[3],
                Odds(baseProvider.weeklyDigits, _currentBoard,
                    _refreshBestBoards()))
            : Padding(
                //Loader
                padding: EdgeInsets.all(10),
                child: Container(
                  width: double.infinity,
                  height: 50,
                ),
              ),
        SizedBox(
          height: 16,
        ),
        Container(
          width: SizeConfig.screenWidth,
          margin: cardMargin,
          padding: cardPadding,
          decoration: cardDecoration,
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              _buildTitle('Prizes'),
              Divider(
                height: 0,
                color: Colors.blueGrey.withOpacity(0.5),
                endIndent: SizeConfig.blockSizeHorizontal * 10,
                indent: SizeConfig.blockSizeHorizontal * 10,
              ),
              _buildPrizeTabView(),
            ],
          ),
        )
      ],
    );
  }

  _buildTicketCount() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
            top: AppBar().preferredSize.height * 1.2, bottom: 24),
        child: _buildShowcaseWrapper(
            _showcaseOne,
            Assets.showCaseDesc[0],
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _activeTambolaCardCount.toString(),
                  style: GoogleFonts.montserrat(
                      fontSize: SizeConfig.cardTitleTextSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  (_activeTambolaCardCount == 1)
                      ? 'Tambola ticket'
                      : 'Tambola tickets',
                  style: GoogleFonts.montserrat(
                      fontSize: SizeConfig.smallTextSize, color: Colors.white),
                ),
              ],
            )),
      ),
    );
  }

  _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(title,
          style: GoogleFonts.montserrat(
              color: Colors.blueGrey[800],
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.largeTextSize)),
    );
  }

  _processTicketResults() {
    if (baseProvider.userWeeklyBoards == null ||
        baseProvider.userWeeklyBoards.isEmpty ||
        baseProvider.weeklyDigits == null ||
        baseProvider.weeklyDigits.toList().isEmpty ||
        localDBModel == null) {
      log.debug('Testing is not ready yet');
      return false;
    }
    DateTime date = DateTime.now();
    if (date.weekday == 7) {
      if (baseProvider.weeklyDigits.toList().length == 35) {
        localDBModel.isUserOnboarded().then((flag) {
          if (flag == 1) {
            log.debug('Ticket results not yet displayed. Displaying: ');
            _testTickets();
            localDBModel.saveOnboardStatus(false);
          }
          //also delete all the old tickets here
          //no need to await
          dbProvider.deleteExpiredUserTickets(baseProvider.myUser.uid);
        });
      }
    } else {
      localDBModel.isUserOnboarded().then((flag) {
        if (flag == 0) localDBModel.saveOnboardStatus(true);
      });
    }
  }

  _testTickets() {
    if (baseProvider.userWeeklyBoards == null ||
        baseProvider.userWeeklyBoards.isEmpty ||
        baseProvider.weeklyDigits == null ||
        baseProvider.weeklyDigits.toList().isEmpty) {
      log.debug('Testing is not ready yet');
      return false;
    }
    Map<String, int> ticketCodeWinIndex = {};
    baseProvider.userWeeklyBoards.forEach((boardObj) {
      if (boardObj.getCornerOdds(baseProvider.weeklyDigits.toList()) == 0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.CORNERS_COMPLETED;
      }
      if (boardObj.getRowOdds(0, baseProvider.weeklyDigits.toList()) == 0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.ROW_ONE_COMPLETED;
      }
      if (boardObj.getRowOdds(1, baseProvider.weeklyDigits.toList()) == 0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.ROW_TWO_COMPLETED;
      }
      if (boardObj.getRowOdds(2, baseProvider.weeklyDigits.toList()) == 0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.ROW_THREE_COMPLETED;
      }
      if (boardObj.getFullHouseOdds(baseProvider.weeklyDigits.toList()) == 0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.FULL_HOUSE_COMPLETED;
      }
    });

    log.debug('Resultant wins: ${ticketCodeWinIndex.toString()}');

    if (!_winnerDialogCalled)
      new Timer(const Duration(seconds: 4), () {
        showDialog(
            context: context,
            builder: (BuildContext context) => WinningsDialog(
                  winningsMap: ticketCodeWinIndex,
                ));
      });
    _winnerDialogCalled = true;

    if (ticketCodeWinIndex.length > 0) {
      dbProvider
          .addWinClaim(
              baseProvider.myUser.uid,
              baseProvider.myUser.name,
              baseProvider.myUser.mobile,
              baseProvider.userTicketWallet.getActiveTickets(),
              ticketCodeWinIndex)
          .then((flag) {
        log.debug('Added claim document');
      });
    }
  }

  List<TambolaBoard> _refreshBestBoards() {
    if (baseProvider.userWeeklyBoards == null ||
        baseProvider.userWeeklyBoards.isEmpty) {
      return new List<TambolaBoard>(5);
    }
    _bestTambolaBoards = new List<TambolaBoard>(5);
    //initialise
    _bestTambolaBoards[0] = baseProvider.userWeeklyBoards[0];
    _bestTambolaBoards[1] = baseProvider.userWeeklyBoards[0];
    _bestTambolaBoards[2] = baseProvider.userWeeklyBoards[0];
    _bestTambolaBoards[3] = baseProvider.userWeeklyBoards[0];
    _bestTambolaBoards[4] = baseProvider.userWeeklyBoards[0];

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

      if (_bestTambolaBoards[0]
              .getRowOdds(0, baseProvider.weeklyDigits.toList()) >
          board.getRowOdds(0, baseProvider.weeklyDigits.toList())) {
        _bestTambolaBoards[0] = board;
      }
      if (_bestTambolaBoards[1]
              .getRowOdds(1, baseProvider.weeklyDigits.toList()) >
          board.getRowOdds(1, baseProvider.weeklyDigits.toList())) {
        _bestTambolaBoards[1] = board;
      }
      if (_bestTambolaBoards[2]
              .getRowOdds(2, baseProvider.weeklyDigits.toList()) >
          board.getRowOdds(2, baseProvider.weeklyDigits.toList())) {
        _bestTambolaBoards[2] = board;
      }
      if (_bestTambolaBoards[3]
              .getCornerOdds(baseProvider.weeklyDigits.toList()) >
          board.getCornerOdds(baseProvider.weeklyDigits.toList())) {
        _bestTambolaBoards[3] = board;
      }
      if (_bestTambolaBoards[4]
              .getFullHouseOdds(baseProvider.weeklyDigits.toList()) >
          board.getFullHouseOdds(baseProvider.weeklyDigits.toList())) {
        _bestTambolaBoards[4] = board;
      }
    });

    return _bestTambolaBoards;
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
                child: Text((ticketsBeingGenerated)
                    ? 'Your new tickets are being generated..'
                    : 'No tickets yet'),
              )));
    } else if (count == 1) {
      _tambolaBoardViews = [];
      _tambolaBoardViews.add(new TambolaBoardView(
        tambolaBoard: baseProvider.userWeeklyBoards[0].tambolaBoard,
        calledDigits: (baseProvider.weeklyDrawFetched &&
                baseProvider.weeklyDigits != null)
            ? baseProvider.weeklyDigits.toList()
            : [],
        boardColor: UiConstants
            .boardColors[rnd.nextInt(UiConstants.boardColors.length)],
      ));
      _currentBoardView = _tambolaBoardViews[0];
      _currentBoard = baseProvider.userWeeklyBoards[0];
      _widget = _buildShowcaseWrapper(
          _showcaseThree,
          Assets.showCaseDesc[2],
          Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  width: double.infinity, child: _tambolaBoardViews[0])));
    } else {
      _tambolaBoardViews = [];
      for (int i = 0; i < 5; i++) {
        _tambolaBoardViews.add(new TambolaBoardView(
          tambolaBoard: baseProvider.userWeeklyBoards[i].tambolaBoard,
          calledDigits: (baseProvider.weeklyDrawFetched &&
                  baseProvider.weeklyDigits != null)
              ? baseProvider.weeklyDigits.toList()
              : [],
          boardColor: UiConstants.primaryColor.withGreen(200),
        ));
      }

      _widget = _buildShowcaseWrapper(
          _showcaseThree,
          Assets.showCaseDesc[2],
          CardSelector(
              cards: _tambolaBoardViews.toList(),
              mainCardWidth: SizeConfig.screenWidth * 0.8,
              mainCardHeight: SizeConfig.screenHeight * 0.16,
              mainCardPadding: 4.0,
              dropTargetWidth: 0,
              cardAnimationDurationMs: 500,
              onChanged: (i) {
                _currentBoard = baseProvider.userWeeklyBoards[i];
                _currentBoardView = _tambolaBoardViews[i];
                setState(() {});
              }));
      if (_currentBoardView == null) _currentBoardView = _tambolaBoardViews[0];
      if (_currentBoard == null)
        _currentBoard = baseProvider.userWeeklyBoards[0];
    }
    return _widget;
  }

  Widget _buildTodaysPicksWidget(DailyPick draws) {
    DateTime date = DateTime.now();
    return Roulette(
        dailyPickTextList: dailyPickTextList,
        digits: _getDailyPickData(baseProvider.weeklyDigits, date.weekday));
  }

  Widget _buildPrizeTabView() {
    String win_corner = BaseUtil.remoteConfig.getString('tambola_win_corner');
    String win_top = BaseUtil.remoteConfig.getString('tambola_win_top');
    String win_middle = BaseUtil.remoteConfig.getString('tambola_win_middle');
    String win_bottom = BaseUtil.remoteConfig.getString('tambola_win_bottom');
    String win_full = BaseUtil.remoteConfig.getString('tambola_win_full');
    String referral_bonus = BaseUtil.remoteConfig.getString('referral_bonus');
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _getPrizeRow(
              'Referral',
              (referral_bonus == null || referral_bonus.isEmpty)
                  ? '₹25'
                  : '₹$referral_bonus'),
          _getPrizeRow(
              'Corners',
              (win_corner == null || win_corner.isEmpty)
                  ? '₹500'
                  : '₹$win_corner'),
          _getPrizeRow('First Row',
              (win_top == null || win_top.isEmpty) ? '₹1500' : '₹$win_top'),
          _getPrizeRow(
              'Second Row',
              (win_middle == null || win_middle.isEmpty)
                  ? '₹1500'
                  : '₹$win_middle'),
          _getPrizeRow(
              'Third Row',
              (win_bottom == null || win_bottom.isEmpty)
                  ? '₹1500'
                  : '₹$win_bottom'),
          _getPrizeRow(
              'Full House',
              (win_full == null || win_full.isEmpty)
                  ? '₹10,000'
                  : '₹$win_full'),
        ],
      ),
    );
    // );
  }

  Widget _getPrizeRow(String title, String prize) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 1.6,
          vertical: SizeConfig.blockSizeVertical * 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(title,
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                    fontSize: SizeConfig.mediumTextSize,
                    height: 1.6,
                    color: UiConstants.accentColor)),
          ),
          Expanded(
            child: Text(prize,
                textAlign: TextAlign.end,
                style: GoogleFonts.montserrat(
                    fontSize: SizeConfig.mediumTextSize,
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                    color: UiConstants.primaryColor)),
          ),
        ],
      ),
    );
  }

  List<int> _getDailyPickData(DailyPick draws, int day) {
    List<int> picks = [];
    if (draws != null && draws.getWeekdayDraws(day - 1) != null) {
      draws.getWeekdayDraws(day - 1).forEach((element) {
        picks.add(element);
      });
    } else {
      for (int i = 0; i < 5; i++) {
        picks.add(-1);
      }
    }
    return picks;
  }

  int get _activeTambolaCardCount {
    if (baseProvider == null || baseProvider.userWeeklyBoards == null) return 0;
    return baseProvider.userWeeklyBoards.length;
  }
}

class Odds extends StatelessWidget {
  final DailyPick _digitsObj;
  final TambolaBoard _board;
  final List<TambolaBoard> _bestBoards;

  Odds(this._digitsObj, this._board, this._bestBoards);

  @override
  Widget build(BuildContext cx) {
    if (_board == null) return Container();
    List<int> _digits = (_digitsObj != null) ? _digitsObj.toList() : [];
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 4,
          vertical: SizeConfig.blockSizeVertical * 1),
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 4,
          vertical: SizeConfig.blockSizeVertical * 1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          new BoxShadow(
            color: Colors.black26.withOpacity(0.1),
            offset: Offset.fromDirection(20, 7),
            blurRadius: 10.0,
          )
        ],
      ),
      child: Column(
        children: [
          Center(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 20),
                child: Text("Odds",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: SizeConfig.largeTextSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey[800]))),
          ),
          ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return _buildRow(
                      cx,
                      Icons.border_top,
                      'Top Row',
                      _board.getRowOdds(0, _digits).toString() + ' left',
                      _bestBoards[0].getRowOdds(0, _digits).toString() +
                          ' left',
                      _bestBoards[0],
                      _digits);
                case 1:
                  return _buildRow(
                      cx,
                      Icons.border_horizontal,
                      'Middle Row',
                      _board.getRowOdds(1, _digits).toString() + ' left',
                      _bestBoards[1].getRowOdds(1, _digits).toString() +
                          ' left',
                      _bestBoards[1],
                      _digits);
                case 2:
                  return _buildRow(
                      cx,
                      Icons.border_bottom,
                      'Bottom Row',
                      _board.getRowOdds(2, _digits).toString() + ' left',
                      _bestBoards[2].getRowOdds(2, _digits).toString() +
                          ' left',
                      _bestBoards[2],
                      _digits);
                case 3:
                  return _buildRow(
                      cx,
                      Icons.border_outer,
                      'Corners',
                      _board.getCornerOdds(_digits).toString() + ' left',
                      _bestBoards[3].getCornerOdds(_digits).toString() +
                          ' left',
                      _bestBoards[3],
                      _digits);
                case 4:
                  return _buildRow(
                      cx,
                      Icons.apps,
                      'Full House',
                      _board.getFullHouseOdds(_digits).toString() + ' left',
                      _bestBoards[4].getFullHouseOdds(_digits).toString() +
                          ' left',
                      _bestBoards[4],
                      _digits);
                case 5:
                  return SizedBox(
                    height: 40,
                  );
                default:
                  return _buildRow(
                      cx,
                      Icons.border_top,
                      'Top Row',
                      _board.getRowOdds(0, _digits).toString() + ' left',
                      _bestBoards[0].getRowOdds(0, _digits).toString() +
                          ' left',
                      _bestBoards[0],
                      _digits);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext cx, IconData _i, String _title, String _tOdd,
      String _oOdd, TambolaBoard _bestBoard, List<int> _digits) {
    var pd = EdgeInsets.symmetric(
        vertical: SizeConfig.blockSizeVertical * 0.8, horizontal: 24.0);
    return Padding(
        padding: pd,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Icon(_i, size: 24.0, color: Colors.blueGrey),
                    SizedBox(width: 9.0),
                    Text(
                      _title,
                      style: GoogleFonts.montserrat(
                          color: Colors.blueGrey,
                          fontSize: SizeConfig.smallTextSize),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _tOdd,
                      style: GoogleFonts.montserrat(
                        color: Colors.blueGrey,
                        fontSize: SizeConfig.mediumTextSize,
                      ),
                    ),
                    Text(
                      'This ticket',
                      style: GoogleFonts.montserrat(
                        color: Colors.blueGrey,
                        fontSize: SizeConfig.smallTextSize,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      _oOdd,
                      style: GoogleFonts.montserrat(
                        color: Colors.blueGrey,
                        fontSize: SizeConfig.mediumTextSize,
                      ),
                    ),
                    Text(
                      'Best ticket',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.blue[900],
                        fontSize: SizeConfig.smallTextSize,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  HapticFeedback.vibrate();
                  showDialog(
                      context: cx,
                      builder: (BuildContext context) => TambolaDialog(
                            board: _bestBoard,
                            digits: _digits,
                          ));
                },
              )),
            ]));
  }
}
