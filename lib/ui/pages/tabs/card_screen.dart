import 'dart:async';
import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/model/TambolaBoard.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/board_selector.dart';
import 'package:felloapp/ui/elements/raffle_digit.dart';
import 'package:felloapp/ui/elements/tambola_board_view.dart';
import 'package:felloapp/ui/elements/weekly_draw_dialog.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class MyCardApp extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      body: PlayHome(),
    );
  }
}

class PlayHome extends StatefulWidget {
  @override
  _HState createState() => _HState();
}

class _HState extends State<PlayHome> {
  Log log = new Log('CardScreen');
  TambolaBoard _currentBoard;
  TambolaBoardView _currentBoardView;
  List<TambolaBoardView> _tambolaBoardViews;
  var rnd = new Random();
  BaseUtil baseProvider;
  DBModel dbProvider;
  bool prizeButtonUp = false;

  @override
  void initState() {
    super.initState();
    new Timer(const Duration(seconds: 3), () {
      setState(() {
        prizeButtonUp = true;
      });
    });
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
      if (!baseProvider.weeklyTicksFetched) {
        log.debug('Requesting for weekly tickets');
        dbProvider.refreshUserTickets(baseProvider.myUser).then((tickets) {
          baseProvider.weeklyTicksFetched = true;
          if(tickets != null) {
            baseProvider.userWeeklyBoards = tickets;
            baseProvider.userTicketsCount = tickets.length;
            log.debug('User weekly tickets fetched:: Count: ${baseProvider.userWeeklyBoards.length}');

            _tambolaBoardViews = [];
            baseProvider.userWeeklyBoards.map((ticket) {
              TambolaBoardView(
                boardValueCde:ticket.val,
                calledDigits: (baseProvider.weeklyDrawFetched)?baseProvider.weeklyDigits.toList():[],
                boardColor: UiConstants.boardColors[
                rnd.nextInt(UiConstants.boardColors.length)],
              );
            });
            setState(() {});
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext c) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    _init();
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
              icon: Icon(Icons.settings),
              onPressed: () {
                HapticFeedback.vibrate();
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
                //Navigator.of(context).pushNamed(Settings.id);
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
                        color: Colors.white
                    ),

                  ),
                  Text(
                    'tickets',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
            )
          ),
          SafeArea(child: Padding(
            padding: EdgeInsets.only(top: 140),
              child: _buildCardCanvas(context))
          ),
          SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildPrizeButton()
              )
          )
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
        (baseProvider.weeklyDrawFetched)?InkWell(
          child: _buildTodaysPicksWidget(baseProvider.weeklyDigits),
          onTap: () {
            HapticFeedback.vibrate();
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    WeeklyDrawDialog(baseProvider.weeklyDigits)
            );
          },
        ):Padding(  //Loader
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
            child: Text(
              "This week\'s tickets",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Colors.blueGrey[800]
              )
            )
          ),
        ),
        SizedBox(height: 5.0),
        _buildCards(baseProvider.weeklyTicksFetched,
            baseProvider.userWeeklyBoards,baseProvider.userTicketsCount),
        (baseProvider.weeklyTicksFetched && baseProvider.userTicketsCount>0)?Padding(
          padding: EdgeInsets.only(left: 25),
          child: Text('ID: ${_currentBoard.id}'),
        ):Container(),
        (baseProvider.weeklyTicksFetched && baseProvider.userTicketsCount>0)?
        Expanded(
            child: Odds(_currentBoardView, baseProvider.weeklyDigits.toList())
        ):Padding(  //Loader
          padding: EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: 50,
          ),
        ),
      ],
    );
  }

  Widget _buildCards(bool fetchedFlag, List<TambolaBoard> boards, int count) {
    Widget _widget;
    if(!fetchedFlag) {
      _widget = Padding(  //Loader
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
    }
    else if(boards==null || count==0) {
      _widget = Padding(
          padding: EdgeInsets.all(10),
          child: Container(
              width: double.infinity,
              height: 200,
              child: Center(
                child: Text('No tickets yet'),
              )
          )
      );
    }
    else if(count == 1) {
      _tambolaBoardViews = [];
      _tambolaBoardViews.add(
          TambolaBoardView(
            boardValueCde:baseProvider.userWeeklyBoards[0].val,
            calledDigits: (baseProvider.weeklyDrawFetched)?baseProvider.weeklyDigits.toList():[],
            boardColor: UiConstants.boardColors[
            rnd.nextInt(UiConstants.boardColors.length)],
          )
      );
      _currentBoardView = _tambolaBoardViews[0];
      _currentBoard = baseProvider.userWeeklyBoards[0];
      _widget = Padding(
          padding: EdgeInsets.all(10),
          child: Container(
              width: double.infinity,
              child: _tambolaBoardViews[0])
          );
    }else{
      _tambolaBoardViews = [];
      baseProvider.userWeeklyBoards.map((board) {
          _tambolaBoardViews.add(
              TambolaBoardView(
                boardValueCde:board.val,
                calledDigits: (baseProvider.weeklyDrawFetched)?baseProvider.weeklyDigits.toList():[],
                boardColor: UiConstants.boardColors[
                rnd.nextInt(UiConstants.boardColors.length)],
              )
          );
      });
      _widget = CardSelector(
          cards: _tambolaBoardViews.toList(),
          mainCardWidth: 380,
          mainCardHeight: 128,
          mainCardPadding: 4.0,
          dropTargetWidth: 0,
          cardAnimationDurationMs: 500,
          onChanged: (i){
            _currentBoard = baseProvider.userWeeklyBoards[i];
            _currentBoardView = _tambolaBoardViews[i];
            setState(() {});
          }
      );
    }
    return _widget;
  }

  Widget _buildDashboard() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child:Stack(
          children: [
            Center(
            child:VerticalDivider(
              thickness: 1.5,
              endIndent: 10,indent: 10,
            )),
            Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                      //color: Colors.black54,
                        width: 150,
                        height: 3,
                        child: Divider(
                          color: Colors.grey[300],
                          thickness: 1.5,
                        ),
                  )
            )),
            Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '23',
                            style: TextStyle(fontSize: 38),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'tickets',
                            textAlign: TextAlign.left,
                          ),
                        ],
                      )
                    ),
                    // VerticalDivider(thickness: 1.5,
                    //   endIndent: 10,indent: 10,
                    // ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Rules',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54
                              ),
                            ),
                            Text('Prizes',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54
                              ),
                            ),
                          ],)
                    ),
                  ]),
            ),
          ],
        )
      ),
    );
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
            boxShadow: [new BoxShadow(
              color: Colors.black26,
              offset: Offset.fromDirection(20, 7),
              blurRadius: 5.0,
            )],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.4],
            colors: [
              Colors.blueGrey[500],
              Colors.blueGrey[400]
            ],
          ),
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Today\'s picks',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: _getDrawBallRow(draws, date.weekday))
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
            child:(digit!=null && digit>0)?
            Padding(
              padding: EdgeInsets.only(left: 7, top:8),
              child:SingleDigit(
                initialValue: digit,
              )
            )
            :Text(
              digit.toString(),
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            )
        )
      ],
    );
    return Container(
      width: 40,
      height: 40,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
          child:(digit!=null && digit>0)?
          Stack(
              children: [SingleDigit(initialValue: digit,)],
          ):Text(
            digit.toString(),
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          )
      ),
    );
  }

  Widget _buildPrizeButton() {
    return AnimatedContainer(
      height: 40,
      width: 100,
      duration: const Duration(milliseconds: 400),
      margin: (prizeButtonUp)?EdgeInsets.only(bottom: 32):EdgeInsets.only(bottom: 0),
      decoration: (prizeButtonUp)?BoxDecoration(
        color: Colors.blueGrey[300],
        boxShadow: [new BoxShadow(
          color: Colors.black12,
          offset: Offset.fromDirection(20, 7),
          blurRadius: 5.0,
        )],
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.4],
          colors: [
            Colors.blueGrey[400],
            Colors.blueGrey[400]
          ],
        ),
      ):BoxDecoration(
        color: Colors.transparent
      ),
      child: Center(
        child: Text('Prizes',
          style: TextStyle(
              color: Colors.white70,
              fontSize: 16
          ),
        ),
      ),
    );
  }
}

class Odds extends StatelessWidget {
  final TambolaBoardView _boardView;
  final List<int> _digits;

  Odds(this._boardView, this._digits);

  @override
  Widget build(BuildContext cx) {
    if (_boardView == null || _digits == null) return Container();

    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 5,
        itemBuilder:(context, index) {
          switch(index) {
            case 0: return _buildRow(cx, Icons.border_top, 'Top Row', '5/12', '10/12');
            case 1: return _buildRow(cx, Icons.border_horizontal, 'Middle Row', '5/12', '10/12');
            case 2: return _buildRow(cx, Icons.border_bottom, 'Bottom Row', '5/12', '10/12');
            case 3: return _buildRow(cx, Icons.border_outer, 'Corners', '5/12', '10/12');
            case 4: return _buildRow(cx, Icons.apps, 'Full House', '5/12', '10/12');
            default: return _buildRow(cx, Icons.border_horizontal, 'Middle Row', '5/12', '10/12');
          }
          //return _buildRow(cx, Icons.border_horizontal, 'Middle Row', '5/12', '10/12');
        },
    );
  }

  Widget _buildRow(BuildContext cx, IconData _i, String _title, String _tOdd, String _oOdd) {
    var tt = Theme
        .of(cx)
        .textTheme;
    var pd = EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0);
    return Padding(
      padding: pd,
      child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Icon(_i, size: 24.0, color: Colors.blueGrey),
                SizedBox(width: 9.0),
                Text(_title, style: tt.caption.apply(color: Colors.blueGrey)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_tOdd, style: tt.title.apply(color: Colors.blueGrey)),
                Text('This ticket', style: tt.caption.apply(color: Colors.blueGrey))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_oOdd, style: tt.title.apply(color: Colors.blueGrey)),
                Text('Overall', style: tt.caption.apply(color: Colors.blueGrey))
              ],
            )]
      )
    );
  }
}

