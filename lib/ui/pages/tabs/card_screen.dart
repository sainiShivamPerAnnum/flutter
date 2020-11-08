import 'dart:convert';
import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/board_selector.dart';
import 'package:felloapp/ui/elements/tambola_board_view.dart';
import 'package:felloapp/ui/elements/weekly_draw_dialog.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyCardApp extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    var t = Theme
        .of(c)
        .textTheme
        .apply(displayColor: Colors.white70, bodyColor: Colors.white70);
    return Scaffold(
      //theme: ThemeData(brightness: Brightness.dark, textTheme: t),
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
  List _cs;
  Map _c;
  double _w = 0;
  var rnd = new Random();
  BaseUtil baseProvider;
  DBModel dbProvider;

  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context).loadString("images/in.json").then((d) {
      _cs = json.decode(d);
      setState(() => _c = _cs[0]);
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
    }
  }

  @override
  Widget build(BuildContext c) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    _init();
    if (_cs == null) return Container();
    if (_w <= 0) _w = MediaQuery
        .of(context)
        .size
        .width - 40.0;
    //return Scaffold(body:
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
                    '23',
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
        InkWell(
          child: _buildTodaysPicksWidget(baseProvider.weeklyDigits),
          onTap: () {
            HapticFeedback.vibrate();
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    WeeklyDrawDialog(baseProvider.weeklyDigits)
            );
          },
        ),
        SizedBox(
          height: 24.0,
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "This week\'s tickets",
            style: Theme
                .of(c)
                .textTheme
                .headline5
                .copyWith(fontFamily: 'rms', color: UiConstants.accentColor),
          ),
        ),
        SizedBox(height: 5.0),
        CardSelector(
            cards: _cs
                .map((c) =>
                TambolaBoardView(
                  boardValueCde:
                  '3a21c43e52f71h19k36m56o61p86r9s24u48w65y88A',
                  boardColor: UiConstants.boardColors[
                  rnd.nextInt(UiConstants.boardColors.length)],
                ))
                .toList(),
            mainCardWidth: 380,
            mainCardHeight: 128,
            mainCardPadding: 4.0,
            dropTargetWidth: 0,
            cardAnimationDurationMs: 500,
            onChanged: (i) => setState(() => _c = _cs[i])),
        Expanded(child: Amounts(_c)),
      ],
    );
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
            borderRadius: BorderRadius.all(Radius.circular(20))),
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
        balls.add(_getDrawBall(element.toString()));
      });
    } else {
      for (int i = 0; i < 5; i++) {
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
      width: 40,
      height: 40,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Text(
            digit,
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          )),
    );
  }
}

class Amounts extends StatelessWidget {
  final Map _c;

  Amounts(this._c);

  @override
  Widget build(BuildContext cx) {
    var tt = Theme
        .of(cx)
        .textTheme;
    var pd = EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0);
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: (_c['tx'] as List).length + 1,
      itemBuilder: (c, i) {
        if (i == 0) {
          return Padding(
            padding: pd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Balance', style: tt.caption),
                SizedBox(height: 8.0),
                Text(_c['bl'], style: tt.display1.apply(color: Colors.white)),
                SizedBox(height: 24.0),
                Text('Today', style: tt.caption),
              ],
            ),
          );
        }
        var tx = _c['tx'][i - 1];
        return Padding(
          padding: pd,
          child: Row(
            children: <Widget>[
              Icon(Icons.shopping_cart, size: 24.0, color: Colors.blueGrey),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(tx['m'], style: tt.title.apply(color: Colors.white)),
                    Text(tx['t'], style: tt.caption)
                  ],
                ),
              ),
              Text(tx['a'], style: tt.body2.apply(color: Colors.deepOrange))
            ],
          ),
        );
      },
    );
  }
}

class Card extends StatelessWidget {
  final Map _c;

  Card(this._c);

  @override
  Widget build(BuildContext context) {
    var tt = Theme
        .of(context)
        .textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        color: Color(_c['co']),
        child: Stack(
          children: <Widget>[
            Image.asset(
              'images/${_c['txt']}.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_c['bk'], style: tt.title),
                  Text(_c['ty'].toUpperCase(), style: tt.caption),
                  Expanded(child: Container()),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Text(_c['nm'],
                            style: tt.subhead, overflow: TextOverflow.ellipsis),
                      ),
                      Image.asset('images/${_c['br']}.png', width: 48.0)
                    ],
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
