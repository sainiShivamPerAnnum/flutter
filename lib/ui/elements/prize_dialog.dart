import 'package:confetti/confetti.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'dart:collection';

class PrizeDialog extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PrizeDialogState();
}

class PrizeDialogState extends State<PrizeDialog> {
  final Log log = new Log('PrizeDialog');
  BaseUtil baseProvider;
  DBModel dbProvider;
  LocalDBModel lclDbProvider;
  PageController _pageController;
  ConfettiController _confeticontroller;
  int _pageIndex = 0;
  bool _winnersFetched = false;
  bool _isInitialised = false;
  Map<String, dynamic> _winners = null;

  PrizeDialogState();

  @override
  void initState(){
    _pageController = PageController(initialPage: _pageIndex);
    _confeticontroller = new ConfettiController(
      duration: new Duration(seconds: 2),
    );
    // _confeticontroller.play();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _init(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    lclDbProvider = Provider.of<LocalDBModel>(context);

    DateTime date = new DateTime.now();
    int weekCde = date.year*100 + BaseUtil.getWeekNumber();
    lclDbProvider.isConfettiRequired(weekCde).then((flag) {
      if(flag) {
        _confeticontroller.play();
        lclDbProvider.saveConfettiUpdate(weekCde);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!_isInitialised)_init(context);
    return Dialog(
      insetPadding: EdgeInsets.only(left:20, top:50, bottom: 110, right:20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: 70,
            alignment: Alignment.topCenter,
            child:VerticalDivider(
              color: Colors.grey,
              indent: 10,
            )
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.6,
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                        child:Padding(
                            padding: EdgeInsets.all(15),
                            child: InkWell(
                              child: Text('Last week\'s winners',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: (this._pageIndex==0)?UiConstants.primaryColor:Colors.blueGrey,
                                    fontSize: 20
                                ),
                              ),
                              onTap: () => onTabTapped(0),
                            )
                        )
                    ),
                    Expanded(
                        child:Padding(
                            padding: EdgeInsets.all(15),
                            child: InkWell(
                              child: Text('This week\'s prizes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: (this._pageIndex==1)?UiConstants.primaryColor:Colors.blueGrey,
                                    fontSize: 20
                                ),
                              ),
                              onTap: () => onTabTapped(1)
                            )
                        )
                    ),
                  ]),
                SizedBox(
                  height: 0,
                ),
                Divider(
                  endIndent: 30,
                  indent: 30,
                ),
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: _addPageView()
                    )
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),

        ]
    );
  }

  Widget _addPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildWinnersTabView(),
        _buildPrizeTabView(),
      ],
      onPageChanged: onPageChanged,
      controller: _pageController,
    );
  }

  Widget _buildPrizeTabView() {
    return
        Padding(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getPrizeRow('Referral', '₹25'),
            _getPrizeRow('Corners', '₹500'),
            _getPrizeRow('First Row', '₹1500'),
            _getPrizeRow('Second Row', '₹1500'),
            _getPrizeRow('Third Row', '₹1500'),
            _getPrizeRow('Full House', '₹10,000'),
          ],
        ),
      );
    // );
  }

  Widget _getPrizeRow(String title, String prize) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 30,),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      height: 1.6,
                      color: UiConstants.accentColor)
              ),
            ),
            Expanded(
              child: Text(prize,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 24,
                      height: 1.6,
                      fontWeight: FontWeight.bold,
                      color: UiConstants.primaryColor)
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildWinnersTabView() {
    int weekCode = BaseUtil.getWeekNumber();
    Widget _tWidget;
    if(!_winnersFetched)dbProvider.getWeeklyWinners().then((resWinners) {
      _winnersFetched = true;
      _winners = resWinners;
      setState(() {});
    });

    if(!_winnersFetched) {
      _tWidget = new Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: SpinKitWave(
            color: UiConstants.primaryColor,
          )
        ),
      );
    }
    else if(_winnersFetched && (_winners == null || _winners.length == 0)) {
      _tWidget = new Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Text('The winner list will be updated soon',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: UiConstants.accentColor
            ),
          ),
        ),
      );
    }
    else {
      List<Widget> _winnerList = [];
      // SORTING THE LIST
      var sortedKeys = _winners.keys.toList(growable:false)
        ..sort((k1, k2) => _winners[k1].compareTo(_winners[k2]));
      LinkedHashMap sortedMap = new LinkedHashMap
          .fromIterable(sortedKeys, key: (k) => k, value: (k) => _winners[k]);
      // REVERSING THE LIST
      final reverseM = LinkedHashMap.fromEntries(sortedMap.entries.toList().reversed);
      // DONE
      reverseM.forEach((name, amount) {

        String amt = amount.toString();
        _winnerList.add(_buildWinnerRow(name, amt));
      });

      _tWidget =
      //new Center(child:
      Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30,5,30,10),
            child: Align(
             alignment: Alignment.topCenter,
              child:Text('Here are the winners from Week $weekCode:',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.blueGrey
                ),
              ),
            )
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 55, 20, 20),
              child: SingleChildScrollView(
               physics: BouncingScrollPhysics(),
               child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: _winnerList
               ),
              )
            //),
          ),
          Container(
            height: 100,
              width: 100,
              child: ConfettiWidget( blastDirectionality: BlastDirectionality.explosive,
                confettiController: _confeticontroller,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 25,
                gravity: 0.05,
                shouldLoop: false,
                colors: [
                  UiConstants.primaryColor,
                  Colors.grey,
                  Colors.yellow,
                  Colors.blue,
                ],)
          ),
        ],
      );
    }

    return _tWidget;
  }

  Widget _buildWinnerRow(String name, String amount) {

    String camelCase(String value) {

      var result = value[0].toUpperCase();
      for (int i = 1; i < value.length; i++) {
        if (value[i - 1] == " ") {
          result = result + value[i].toUpperCase();
        } else {
          result = result + value[i].toLowerCase();
        }
      }
      return result;
    }
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 20,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text(camelCase(name),
                textAlign: TextAlign.start,
                style: TextStyle(

                  color: UiConstants.accentColor,
                  fontSize: 22
                ),
              ),
            )
          ),

              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text('₹'+ amount.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: UiConstants.primaryColor,
                      fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )

        ],
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
  }

}
