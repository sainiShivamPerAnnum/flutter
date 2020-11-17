import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class PrizeDialog extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => PrizeDialogState();
}

class PrizeDialogState extends State<PrizeDialog> {
  final Log log = new Log('PrizeDialog');
  BaseUtil baseProvider;
  DBModel dbProvider;
  PageController _pageController;
  int _pageIndex = 0;
  bool _winnersFetched = false;
  Map<String, dynamic> _winners = null;

  PrizeDialogState();

  @override
  void initState(){
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context);
    return Dialog(
      insetPadding: EdgeInsets.only(left:20, top:50, bottom: 80, right:20),
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
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                        child:Padding(
                            padding: EdgeInsets.all(10),
                            child: InkWell(
                              child: Text('This week\'s \nprizes',
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
                            padding: EdgeInsets.all(10),
                            child: InkWell(
                              child: Text('Last week\'s winners',
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
                Divider(),
                Container(
                  height: 500,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                  child: _addPageView()
                ),
              ],
            ),
          )
        ]
    );
  }

  Widget _addPageView() {
    return PageView(
      children: [
        _buildPrizeTabView(),
        _buildWinnersTabView(),
      ],
      onPageChanged: onPageChanged,
      controller: _pageController,
    );
  }

  Widget _buildPrizeTabView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getPrizeRow('Referral', '₹100'),
            _getPrizeRow('Corners', '₹500'),
            _getPrizeRow('First Row', '₹1500'),
            _getPrizeRow('Second Row', '₹1500'),
            _getPrizeRow('Third Row', '₹1500'),
            _getPrizeRow('Full House', '₹10000'),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              child: Image(
                image: AssetImage(Assets.prizesGraphic),
                fit: BoxFit.contain,
              ),
              width: 80,
              height: 80,
            )
          ],
        ),
      ),
    );
  }

  Widget _getPrizeRow(String title, String prize) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(title,
                style: TextStyle(
                    fontSize: 30,
                    color: UiConstants.accentColor)
            ),
          ),
          Expanded(
            child: Text(prize,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: UiConstants.primaryColor)
            ),
          ),
        ],
      );
  }

  Widget _buildWinnersTabView() {
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
      _winners.forEach((name, amount) {
        String amt = amount.toString();
        _winnerList.add(_buildWinnerRow(name, amt));
      });
      _tWidget = new Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _winnerList
          ),
        ),
      );
    }

    return _tWidget;
  }

  Widget _buildWinnerRow(String name, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text(name,
              style: TextStyle(
                color: UiConstants.accentColor,
                fontSize: 20
              ),
            ),
          )
        ),
        Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Text('₹'+ amount.toString(),
                style: TextStyle(
                    color: UiConstants.accentColor,
                    fontSize: 20
                ),
              ),
            )
        ),
      ],
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
