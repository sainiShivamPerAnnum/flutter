import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/tabs/card_screen.dart';
import 'package:felloapp/ui/pages/tabs/home_screen.dart';
import 'package:felloapp/ui/pages/tabs/play_tab.dart';
import 'package:felloapp/ui/pages/tabs/refer_screen.dart';
import 'package:felloapp/ui/pages/tabs/test_screen.dart';
import 'package:felloapp/ui/pages/tabs/upi_screen.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:morpheus/widgets/morpheus_tab_view.dart';

class AppRoot extends StatefulWidget{
  @override
  State createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  Log log = new Log("AppRoot");
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => Navigator.of(context).maybePop(),
        child:
        Scaffold(
          // appBar: BaseUtil.getAppBar(),
          body: Center(
              child:
              MorpheusTabView(
                  child: getTab(_currentIndex, context)
              )),
//      MorpheusTabView(
//        child:
//          Stack(children: <Widget>[
//            _buildOffstageNavigator(0, context),
//            _buildOffstageNavigator(1, context),
//            _buildOffstageNavigator(2, context),
//          ]),
//      ),
          bottomSheet: Container(
              color: Colors.blueGrey[100],
              height: 25.0,
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('We are currently in Beta',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Icon(Icons.info_outline, size: 20,color: Colors.black54,)
                    ],
                  )
              )
          ),
          bottomNavigationBar: BottomNavyBar(
              selectedIndex: _currentIndex,
              showElevation: true,
              iconSize: 34.0,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              containerHeight: 75.0,
              onItemSelected: (index) => setState(() {
                _currentIndex = index;
              }),
              items: [
                BottomNavyBarItem(
                    icon: Icon(Icons.play_circle_filled),
                    title: Text('Play'),
                    inactiveColor: UiConstants.primaryColor,
                    activeColor: UiConstants.primaryColor
                ),
                BottomNavyBarItem(
                    icon: Icon(Icons.account_balance_wallet),
                    title: Text('Save'),
                    inactiveColor: UiConstants.primaryColor,
                    activeColor: UiConstants.primaryColor
                ),
                BottomNavyBarItem(
                    icon: Icon(Icons.supervised_user_circle),
                    title: Text('Refer'),
                    inactiveColor: UiConstants.primaryColor,
                    activeColor: UiConstants.primaryColor
                ),
              ]
          ),
        ));
  }

  Widget getTab(int index, BuildContext context) {
    switch(index) {
      case 0: {
        return PlayHome();
      }
      case 1: {
        // return MyHomePage(title: Constants.APP_NAME);
        return UpiPayment();
      }
      case 2: {
        return ReferScreen();
      }
      default: {
        return MyHomePage(title: Constants.APP_NAME);
      }
    }
  }
}
