import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/elements/text_slider.dart';
import 'package:felloapp/ui/pages/tabs/card_screen.dart';
import 'package:felloapp/ui/pages/tabs/home_screen.dart';
import 'package:felloapp/ui/pages/tabs/refer_screen.dart';
import 'package:felloapp/ui/pages/tabs/save_tab.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:morpheus/widgets/morpheus_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcase_widget.dart';

class AppRoot extends StatefulWidget {
  @override
  State createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  Log log = new Log("AppRoot");
  BaseUtil baseProvider;
  int _currentIndex = 0;
  NavySlider _slider;

  @override
  void initState() {
    super.initState();
    initDynamicLinks();

    _slider = new NavySlider(infoList: Assets.bottomSheetDesc,);
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    return Scaffold(
      // appBar: BaseUtil.getAppBar(),
      body:
          Center(child:getTab(_currentIndex, context)),
      bottomSheet: _slider,
      bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: true,
          iconSize: 34.0,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          containerHeight: 70.0,
          onItemSelected: (index){
            HapticFeedback.heavyImpact();
            setState(() {
                _currentIndex = index;
            });
          },
          itemCornerRadius: 20,
          items: [
            BottomNavyBarItem(
                icon: Icon(Icons.play_circle_filled),
                title: Text('Play'),
                textAlign: TextAlign.justify,
                inactiveColor: UiConstants.primaryColor,
                activeColor: UiConstants.primaryColor),
            BottomNavyBarItem(
                icon: Icon(Icons.account_balance_wallet),
                title: Text('Save'),
                inactiveColor: UiConstants.primaryColor,
                activeColor: UiConstants.primaryColor),
            BottomNavyBarItem(
                icon: Icon(Icons.supervised_user_circle),
                title: Text('Refer'),
                inactiveColor: UiConstants.primaryColor,
                activeColor: UiConstants.primaryColor),
          ]),
      //    )
    );
  }

  Widget getTab(int index, BuildContext context) {
    switch (index) {
      case 0:
        {
          return ShowCaseWidget(
            builder: Builder(builder: (context) => PlayHome()),
            autoPlay: true,
            autoPlayDelay: Duration(seconds: 5),
            autoPlayLockEnable: true,
          );
        }
      case 1:
        {
          return SaveScreen();
        }
      case 2:
        {
          return ReferScreen();
        }
      default:
        {
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
    }, onError: (OnLinkErrorException e) async {
      log.error('Error in fetching deeplink');
      log.error(e);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
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
    if (dLink.startsWith(prefix)) {
      String referee = dLink.replaceAll(prefix, '');
      log.debug(referee);
      if (prefix.length > 0 && prefix != userId) {
        return http.post(
          'https://us-central1-fello-d3a9c.cloudfunctions.net/validateReferral?uid=$userId&rid=$referee',
        );
      }
    }
    return null;
  }
}
