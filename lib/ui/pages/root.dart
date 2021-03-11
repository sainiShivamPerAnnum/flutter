import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/ui/elements/hamburger-dialog.dart';
import 'package:felloapp/ui/elements/navbar.dart';
import 'package:felloapp/ui/pages/tabs/finance_screen.dart';
import 'package:felloapp/ui/pages/tabs/games_screen.dart';
import 'package:felloapp/ui/pages/tabs/home_screen.dart';
import 'package:felloapp/ui/pages/tabs/profile_screen.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  Log log = new Log("Root");
  List<NavBarItemData> _navBarItems;
  static int selectedNavIndex = 0;
  BaseUtil baseProvider;
  HttpModel httpModel;

  List<Widget> _viewsByIndex;

  @override
  void initState() {
    initDynamicLinks();
    //Declare some buttons for our tab bar
    _navBarItems = [
      NavBarItemData("Home", Icons.home, 110, "images/svgs/home.svg"),
      NavBarItemData("Play", Icons.games, 110, "images/svgs/game.svg"),
      NavBarItemData(
          "Save", Icons.wallet_giftcard, 115, "images/svgs/save.svg"),
      NavBarItemData(
          "Profile", Icons.verified_user, 115, "images/svgs/profile.svg"),
    ];

    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      HomePage(
        tabChange: (int i) {
          setState(() {
            selectedNavIndex = i;
          });
        },
      ),
      GamePage(
        tabChange: (int i) {
          setState(() {
            selectedNavIndex = i;
          });
        },
      ),
      FinancePage(),
      ProfilePage(),
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (baseProvider != null) baseProvider.cancelIncomingNotifications();
  }

  Color getBurgerBorder() {
    if (selectedNavIndex == 0 || selectedNavIndex == 1) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  String getBurgerImage() {
    if (selectedNavIndex == 0 || selectedNavIndex == 1) {
      return "images/menu-white.png";
    } else {
      return "images/menu.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    var accentColor = UiConstants.primaryColor;

    //Create custom navBar, pass in a list of buttons, and listen for tap event
    var navBar = NavBar(
      items: _navBarItems,
      itemTapped: _handleNavBtnTapped,
      currentIndex: selectedNavIndex,
    );
    //Display the correct child view for the current index
    var contentView =
        _viewsByIndex[min(selectedNavIndex, _viewsByIndex.length - 1)];
    //Wrap our custom navbar + contentView with the app Scaffold
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            //Wrap the current page in an AnimatedSwitcher for an easy cross-fade effect
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 350),
              //Pass the current accent color down as a theme, so our overscroll indicator matches the btn color
              child: Theme(
                data: ThemeData(accentColor: accentColor),
                child: contentView,
              ),
            ),
          ),
          Positioned(
            child: SafeArea(
              child: Container(
                width: width,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.vibrate();
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) => HamburgerMenu(),
                        );
                      },
                      child: Container(
                        height: height * 0.05,
                        width: height * 0.05,
                        margin: EdgeInsets.only(
                          left: height * 0.016,
                          top: height * 0.016,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // gradient: new LinearGradient(
                          //   colors: [
                          //     kPrimarColor.withGreen(200),
                          //     kPrimarColor.withGreen(400),
                          //     kPrimarColor.withGreen(600)
                          //   ],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          // ),
                          border:
                              Border.all(color: getBurgerBorder(), width: 3),
                        ),
                        child: Container(
                          height: 5,
                          width: 5,
                          padding: EdgeInsets.all(
                            width * 0.03,
                          ),
                          child: Image.asset(
                            getBurgerImage(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: navBar, //Pass our custom navBar into the scaffold
    );
  }

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild
    setState(() {
      //This will be passed into the NavBar and change it's selected state, also controls the active content page
      selectedNavIndex = index;
    });
  }

  Future<dynamic> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      return x(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      log.error('Error in fetching deeplink');
      log.error(e);
      return null;
    });

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      log.debug('Received deep link');
      log.debug(deepLink.toString());
      return submitReferral22(baseProvider.myUser.uid, deepLink).then((value) {
        log.debug(value);
        return value;
      });
    }
  }

  Future<dynamic> x(PendingDynamicLinkData dynamicLink) {
    final Uri deepLink = dynamicLink?.link;
    if (deepLink == null) return null;
    log.debug('Received deep link');
    //log.debug(deepLink.toString());
    return submitReferral22(baseProvider.myUser.uid, deepLink).then((value) {
      log.debug(value);
      return value;
    });
  }

  Future<int> submitReferral22(String userId, Uri deepLink) async {
    String prefix = 'https://fello.in/';
    String dLink = deepLink.toString();
    if (dLink.startsWith(prefix)) {
      String referee = dLink.replaceAll(prefix, '');
      log.debug(referee);
      if (prefix.length > 0 && prefix != userId) {
        return httpModel
            .postUserReferral(userId, referee)
            .then((userTicketUpdateCount) {
          log.debug('User deserves $userTicketUpdateCount more tickets');
          return userTicketUpdateCount;
        });
      } else
        return 0;
    } else
      return 0;
  }
}

class NavBarItemData {
  final String title;
  final IconData icon;
  final String iconImage;
  final double width;

  NavBarItemData(this.title, this.icon, this.width, this.iconImage);
}
