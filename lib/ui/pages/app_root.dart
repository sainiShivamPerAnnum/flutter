import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/tabs/card_screen.dart';
import 'package:felloapp/ui/pages/tabs/home_screen.dart';
import 'package:felloapp/ui/pages/tabs/refer_screen.dart';
import 'package:felloapp/ui/pages/tabs/save_tab.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:morpheus/widgets/morpheus_tab_view.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AppRoot extends StatefulWidget{
  @override
  State createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  Log log = new Log("AppRoot");
  BaseUtil baseProvider;
  int _currentIndex = 0;


  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    return
      // WillPopScope(
      //   onWillPop: () async => Navigator.of(context).maybePop(),
      //   child:
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
    //    )
    );
  }

  Widget getTab(int index, BuildContext context) {
    switch(index) {
      case 0: {
        return PlayHome();
      }
      case 1: {
        // return MyHomePage(title: Constants.APP_NAME);
        return SaveScreen();
      }
      case 2: {
        return ReferScreen();
      }
      default: {
        return MyHomePage(title: Constants.APP_NAME);
      }
    }
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          if (deepLink != null) {
            log.debug('Received deep link');
            log.debug(deepLink.toString());
            postReferral(baseProvider.myUser.uid, deepLink);
          }
        },
        onError: (OnLinkErrorException e) async {
          log.error('Error in fetching deeplink');
          log.error(e);
        }
    );

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      log.debug('Received deep link');
      log.debug(deepLink.toString());
      postReferral(baseProvider.myUser.uid, deepLink);
    }
  }

  Future<http.Response> postReferral(String userId, Uri deepLink) {
    String prefix = 'https://fello.in/';
    String dLink = deepLink.toString();
    if(dLink.startsWith(prefix)){
      String referee = dLink.replaceAll(prefix, '');
      log.debug(referee);
      if(prefix.length > 0 && prefix != userId){
        return http.post(
          'https://us-central1-fello-d3a9c.cloudfunctions.net/validateReferral?uid=$userId&rid=$referee',
        );
      }
    }
    return null;
  }
}
