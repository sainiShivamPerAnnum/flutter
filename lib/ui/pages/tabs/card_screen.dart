import 'dart:async';
import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/ui/elements/board_selector.dart';
import 'package:felloapp/ui/elements/contact_dialog.dart';
import 'package:felloapp/ui/elements/guide_dialog.dart';
import 'package:felloapp/ui/elements/onboard_dialog.dart';
import 'package:felloapp/ui/elements/prize_dialog.dart';
import 'package:felloapp/ui/elements/raffle_digit.dart';
import 'package:felloapp/ui/elements/tambola_board_view.dart';
import 'package:felloapp/ui/elements/tambola_dialog.dart';
import 'package:felloapp/ui/elements/weekly_draw_dialog.dart';
import 'package:felloapp/ui/elements/winnings_dialog.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class PlayHome extends StatefulWidget {
  @override
  _HState createState() => _HState();
}

class _HState extends State<PlayHome> {
  Log log = new Log('CardScreen');
  TambolaBoard _currentBoard;
  TambolaBoardView _currentBoardView;
  bool _winnerDialogCalled = false;

  //GlobalKey<TambolaBoardState> _currentKey;
  List<TambolaBoardView> _tambolaBoardViews;
  List<TambolaBoard> _bestTambolaBoards;

  //List<GlobalKey<TambolaBoardState>> _boardKeys;
  var rnd = new Random();
  BaseUtil baseProvider;
  DBModel dbProvider;
  FcmHandler fcmProvider;
  LocalDBModel localDBModel;

  bool prizeButtonUp = false;
  bool ticketsBeingGenerated = false;
  bool dailyPickHeaderWithTimings = false;
  String dailyPickHeaderText = 'Today\'s picks';

  bool temp =false;

  @override
  void initState() {
    super.initState();
    initDailyPickFlags();
    new Timer(const Duration(seconds: 3), () {
      setState(() {
        prizeButtonUp = true;
      });
    });
  }

  initDailyPickFlags() {
    String remoteTime = BaseUtil.remoteConfig.getString('draw_pick_time');
    remoteTime = (remoteTime == null || remoteTime.isEmpty)?'9':remoteTime;
    int tx = 9;
    try{
      tx = int.parse(remoteTime);
    }catch(e) {
      tx = 9;
    }
    DateTime _time = DateTime.now();
    dailyPickHeaderWithTimings = (_time.hour < tx);
    if(dailyPickHeaderWithTimings) {
      String am_pm = (tx > 11) ? 'PM' : 'AM';
      String ttime = (tx > 12) ? (tx - 12).toString() + am_pm : tx.toString() +
          am_pm;
      dailyPickHeaderText = 'Today\'s picks - Drawn at $ttime';
    }else{
      dailyPickHeaderText = 'Today\'s picks';
    }
  }

  _init() {
    if (baseProvider != null && dbProvider != null) {
      if (!baseProvider.weeklyDrawFetched) {
        log.debug('Requesting for weekly picks');
        dbProvider.getWeeklyPicks().then((picks) {
          baseProvider.weeklyDrawFetched = true;
          if (picks != null) baseProvider.weeklyDigits = picks;
          log.debug('Weekly Picks received: $picks');
          setState(() {});
        });
      }

      dbProvider.addUserTicketListener((tickets) {
        baseProvider.weeklyTicksFetched = true;
        if (tickets != null) {
          baseProvider.userWeeklyBoards = tickets;
          baseProvider.userTicketsCount = tickets.length;
          log.debug(
              'User weekly tickets fetched:: Count: ${baseProvider.userWeeklyBoards.length}');
          _tambolaBoardViews = [];

          int cx = baseProvider.checkTicketCountValidity(tickets);
          if (cx > 0) {
            log.debug('Pushing ticket generation request');
            ticketsBeingGenerated = true;
            dbProvider.pushTicketRequest(baseProvider.myUser, cx);
          }
          setState(() {});
        }
      });

      dbProvider.addUserTicketRequestListener(() {
        ticketsBeingGenerated = true;
        setState(() {});
      });

      if (!baseProvider.weeklyTicksFetched)
        dbProvider.subscribeUserTickets(baseProvider.myUser);

      localDBModel.isFreshUser().then((flag) {
        if(flag == 0) {
          new Timer(const Duration(seconds: 4), () {
            showDialog(context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => OnboardDialog()
            );
          });
          localDBModel.saveFreshUserStatus(true);
        }
      });
    }

    if(fcmProvider != null && baseProvider != null) {
      fcmProvider.addIncomingMessageListener((valueMap) {
        if(valueMap['title'] != null && valueMap['body'] != null){
          baseProvider.showPositiveAlert(valueMap['title'], valueMap['body'], context, seconds: 5);
        }
      },0);
    }
  }

  @override
  void dispose() {
    super.dispose();
    //baseProvider.weeklyTicksFetched = false;
    if (dbProvider != null) dbProvider.addUserTicketListener(null);
    if (dbProvider != null) dbProvider.addUserTicketRequestListener(null);
    if (fcmProvider != null) fcmProvider.addIncomingMessageListener(null,0);
  }

  @override
  Widget build(BuildContext c) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    fcmProvider = Provider.of<FcmHandler>(context);
    localDBModel = Provider.of<LocalDBModel>(context);
    _init();
    _processTicketResults();

    return Scaffold(
        //debugShowCheckedModeBanner: false,
        //padding: EdgeInsets.only(top: 48.0),
        body: Stack(
      children: [
        Container(
          height: 200,
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
        ),
        Positioned(
          top: 30,
          left: 5,
          child: IconButton(
            color: Colors.white,
            icon: Icon(Icons.menu),
            onPressed: () {
              HapticFeedback.vibrate();
              Navigator.of(context).pushNamed('/settings');
            },
          ),
        ),
        Positioned(
          top: 30,
          right: 5,
          child: IconButton(
            color: Colors.white,
            icon: Icon(Icons.help_outline),
            onPressed: () {
              HapticFeedback.vibrate();
              showDialog(
                  context: context,
                  builder: (BuildContext context) => GuideDialog());
            },
          ),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 70),
              child: Column(
                children: [
                  Text(
                    baseProvider.userTicketsCount.toString(),
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    (baseProvider.userTicketsCount == 1) ? 'ticket' : 'tickets',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            )),
        SafeArea(
            child: Padding(
                padding: EdgeInsets.only(top: 140),
                child: _buildCardCanvas(context))),
        SafeArea(
            child: Align(
                alignment: Alignment.bottomCenter, child: _buildPrizeButton()))
      ],
    )
        //),
        );
  }

  Widget _buildCardCanvas(BuildContext c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //_buildDashboard(),
        (baseProvider.weeklyDrawFetched)
            ? InkWell(
                child: _buildTodaysPicksWidget(baseProvider.weeklyDigits),
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
          height: 12.0,
        ),
        Center(
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
              child: Text("This week\'s tickets",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.blueGrey[800]))),
        ),
        SizedBox(height: 5.0),
        _buildCards(baseProvider.weeklyTicksFetched,
            baseProvider.userWeeklyBoards, baseProvider.userTicketsCount),
        (baseProvider.weeklyTicksFetched &&
                baseProvider.userWeeklyBoards != null &&
                baseProvider.userTicketsCount > 0)
            ? Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Ticket #${_currentBoard.getTicketNumber()}'),
              )
            : Container(),
        (baseProvider.weeklyTicksFetched &&
                baseProvider.userWeeklyBoards != null &&
                baseProvider.userTicketsCount > 0 &&
                baseProvider.weeklyDrawFetched)
            ? Expanded(
                child: Odds(baseProvider.weeklyDigits, _currentBoard,
                    _refreshBestBoards())
                //Odds(_currentBoardView, baseProvider.weeklyDigits.toList(), _currentKey)
                )
            : Padding(
                //Loader
                padding: EdgeInsets.all(10),
                child: Container(
                  width: double.infinity,
                  height: 50,
                ),
              ),
      ],
    );
  }

  _processTicketResults() {
    if(baseProvider.userWeeklyBoards == null || baseProvider.userWeeklyBoards.isEmpty
    || baseProvider.weeklyDigits == null || baseProvider.weeklyDigits.toList().isEmpty
    || localDBModel == null) {
      log.debug('Testing is not ready yet');
      return false;
    }
    DateTime date = DateTime.now();
    if(date.weekday == 7) {
      if(baseProvider.weeklyDigits.toList().length == 35) {
        localDBModel.isUserOnboarded().then((flag) {
          if(flag == 1) {
            log.debug('Ticket results not yet displayed. Displaying: ');
            _testTickets();
            localDBModel.saveOnboardStatus(false);
          }
        });
      }
    }else{
      localDBModel.isUserOnboarded().then((flag) {
        if(flag == 0)localDBModel.saveOnboardStatus(true);
      });
    }
  }

  _testTickets() {
    if(baseProvider.userWeeklyBoards == null || baseProvider.userWeeklyBoards.isEmpty
        || baseProvider.weeklyDigits == null || baseProvider.weeklyDigits.toList().isEmpty) {
      log.debug('Testing is not ready yet');
      return false;
    }
    Map<String, int> ticketCodeWinIndex = {};
    baseProvider.userWeeklyBoards.forEach((boardObj) {
      if(boardObj.getCornerOdds(baseProvider.weeklyDigits.toList()) == 0) {
        if(boardObj.getTicketNumber() != 'NA')ticketCodeWinIndex[boardObj.getTicketNumber()] = Constants.CORNERS_COMPLETED;
      }
      if(boardObj.getRowOdds(0, baseProvider.weeklyDigits.toList()) == 0) {
        if(boardObj.getTicketNumber() != 'NA')ticketCodeWinIndex[boardObj.getTicketNumber()] = Constants.ROW_ONE_COMPLETED;
      }
      if(boardObj.getRowOdds(1, baseProvider.weeklyDigits.toList()) == 0) {
        if(boardObj.getTicketNumber() != 'NA')ticketCodeWinIndex[boardObj.getTicketNumber()] = Constants.ROW_TWO_COMPLETED;
      }
      if(boardObj.getRowOdds(2, baseProvider.weeklyDigits.toList()) == 0) {
        if(boardObj.getTicketNumber() != 'NA')ticketCodeWinIndex[boardObj.getTicketNumber()] = Constants.ROW_THREE_COMPLETED;
      }
      if(boardObj.getFullHouseOdds(baseProvider.weeklyDigits.toList()) == 0) {
        if(boardObj.getTicketNumber() != 'NA')ticketCodeWinIndex[boardObj.getTicketNumber()] = Constants.FULL_HOUSE_COMPLETED;
      }
    });

    log.debug('Resultant wins: ${ticketCodeWinIndex.toString()}');

    if(!_winnerDialogCalled)new Timer(const Duration(seconds: 4), () {
      showDialog(
          context: context,
          builder: (BuildContext context) => WinningsDialog(winningsMap: ticketCodeWinIndex,));
    });
    _winnerDialogCalled = true;

    if(ticketCodeWinIndex.length > 0) {
      dbProvider.addWinClaim(baseProvider.myUser.uid, ticketCodeWinIndex).then((flag) {
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


  Widget _buildCards(bool fetchedFlag, List<TambolaBoard> boards, int count) {
    Widget _widget;
    if (!fetchedFlag) {
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
      _tambolaBoardViews.add(TambolaBoardView(
        tambolaBoard: baseProvider.userWeeklyBoards[0].tambolaBoard,
        calledDigits: (baseProvider.weeklyDrawFetched)
            ? baseProvider.weeklyDigits.toList()
            : [],
        boardColor: UiConstants
            .boardColors[rnd.nextInt(UiConstants.boardColors.length)],
      ));
      _currentBoardView = _tambolaBoardViews[0];
      _currentBoard = baseProvider.userWeeklyBoards[0];
      _widget = Padding(
          padding: EdgeInsets.all(10),
          child:
              Container(width: double.infinity, child: _tambolaBoardViews[0]));
    } else {
      _tambolaBoardViews = [];
      baseProvider.userWeeklyBoards.forEach((board) {
        _tambolaBoardViews.add(TambolaBoardView(
          tambolaBoard: board.tambolaBoard,
          calledDigits: (baseProvider.weeklyDrawFetched &&
                  baseProvider.weeklyDigits != null)
              ? baseProvider.weeklyDigits.toList()
              : [],
          boardColor: UiConstants
              .boardColors[rnd.nextInt(UiConstants.boardColors.length)],
        ));
      });
      _widget = CardSelector(
          cards: _tambolaBoardViews.toList(),
          mainCardWidth: 380,
          mainCardHeight: 128,
          mainCardPadding: 4.0,
          dropTargetWidth: 0,
          cardAnimationDurationMs: 500,
          onChanged: (i) {
            _currentBoard = baseProvider.userWeeklyBoards[i];
            _currentBoardView = _tambolaBoardViews[i];
            // _currentKey = _boardKeys[i];
            setState(() {});
          });
      if (_currentBoardView == null) _currentBoardView = _tambolaBoardViews[0];
      if (_currentBoard == null)
        _currentBoard = baseProvider.userWeeklyBoards[0];
    }
    return _widget;
  }

  Widget _buildTodaysPicksWidget(DailyPick draws) {
    DateTime date = DateTime.now();
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blueGrey[400],
          boxShadow: [
            new BoxShadow(
              color: Colors.black26,
              offset: Offset.fromDirection(20, 7),
              blurRadius: 5.0,
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.4],
            colors: [Colors.blueGrey[500], Colors.blueGrey[400]],
          ),
        ),
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  dailyPickHeaderText,
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: _getDrawBallRow(draws, date.weekday)),
            ]),
      ),
    );
  }

  Widget _getDrawBallRow(DailyPick draws, int day) {
    List<Widget> balls = [];
    if (draws != null && draws.getWeekdayDraws(day - 1) != null) {
      draws.getWeekdayDraws(day - 1).forEach((element) {
        balls.add(_getDrawBall(element));
      });
    } else {
      for (int i = 0; i < 5; i++) {
        balls.add(_getDrawBall(0));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: balls,
    );
  }

  Widget _getDrawBall(int digit) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        Center(
            child: (digit != null && digit > 0)
                ? Padding(
                    padding: EdgeInsets.only(left: 7, top: 8),
                    child: SingleDigit(
                      initialValue: digit,
                    ))
                : Padding(
                    padding: EdgeInsets.only(left: 16, top: 7),
                    child: Text(
                      '-',
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    )))
      ],
    );
  }

  Widget _buildPrizeButton() {
    return AnimatedContainer(
      height: 40,
      width: 100,
      duration: const Duration(milliseconds: 400),
      margin: (prizeButtonUp)
          ? EdgeInsets.only(bottom: 32)
          : EdgeInsets.only(bottom: 0),
      decoration: (prizeButtonUp)
          ? BoxDecoration(
              color: Colors.blueGrey[300],
              boxShadow: [
                new BoxShadow(
                  color: Colors.black12,
                  offset: Offset.fromDirection(20, 7),
                  blurRadius: 5.0,
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.4],
                colors: [Colors.blueGrey[400], Colors.blueGrey[400]],
              ),
            )
          : BoxDecoration(color: Colors.transparent),
      child: InkWell(
        child: Center(
          child: Text(
            'Prizes',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        onTap: () {
          HapticFeedback.vibrate();
          showDialog(
              context: context,
              builder: (BuildContext context) => PrizeDialog());
        },
      ),
    );
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
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return _buildRow(
                cx,
                Icons.border_top,
                'Top Row',
                _board.getRowOdds(0, _digits).toString() + ' left',
                _bestBoards[0].getRowOdds(0, _digits).toString() + ' left',
                _bestBoards[0], _digits);
          case 1:
            return _buildRow(
                cx,
                Icons.border_horizontal,
                'Middle Row',
                _board.getRowOdds(1, _digits).toString() + ' left',
                _bestBoards[1].getRowOdds(1, _digits).toString() + ' left',
                _bestBoards[1], _digits);
          case 2:
            return _buildRow(
                cx,
                Icons.border_bottom,
                'Bottom Row',
                _board.getRowOdds(2, _digits).toString() + ' left',
                _bestBoards[2].getRowOdds(2, _digits).toString() + ' left',
                _bestBoards[2], _digits);
          case 3:
            return _buildRow(
                cx,
                Icons.border_outer,
                'Corners',
                _board.getCornerOdds(_digits).toString() + ' left',
                _bestBoards[3].getCornerOdds(_digits).toString() + ' left',
                _bestBoards[3], _digits);
          case 4:
            return _buildRow(
                cx,
                Icons.apps,
                'Full House',
                _board.getFullHouseOdds(_digits).toString() + ' left',
                _bestBoards[4].getFullHouseOdds(_digits).toString() + ' left',
                _bestBoards[4], _digits);
          case 5:
            return SizedBox(height: 40,);
          default:
            return _buildRow(
                cx,
                Icons.border_top,
                'Top Row',
                _board.getRowOdds(0, _digits).toString() + ' left',
                _bestBoards[0].getRowOdds(0, _digits).toString() + ' left',
                _bestBoards[0], _digits);
        }
      },
    );
  }

  Widget _buildRow(
      BuildContext cx, IconData _i, String _title, String _tOdd, String _oOdd,
      TambolaBoard _bestBoard, List<int> _digits) {
    var tt = Theme.of(cx).textTheme;
    var pd = EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0);
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
                    Text(_title,
                        style: tt.caption.apply(color: Colors.blueGrey)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(_tOdd, style: tt.title.apply(color: Colors.blueGrey)),
                    Text('This ticket',
                        style: tt.caption.apply(color: Colors.blueGrey))
                  ],
                ),
              ),
              Expanded(
                  child: InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(_oOdd, style: tt.title.apply(color: Colors.blueGrey)),
                        Text('Best ticket',
                            textAlign: TextAlign.center,
                            style: tt.caption.apply(color: Colors.blueGrey))
                      ],
                    ),
                    onTap: () {
                      HapticFeedback.vibrate();
                      showDialog(
                          context: cx,
                          builder: (BuildContext context) => TambolaDialog(board: _bestBoard,digits: _digits,));
                    },
                  )
              ),
            ]));
  }
}
