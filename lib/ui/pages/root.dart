import 'dart:math';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/ui/elements/navbar.dart';
import 'package:felloapp/ui/pages/tabs/home_screen.dart';
import 'package:felloapp/ui/pages/tabs/games_screen.dart';
import 'package:felloapp/ui/pages/tabs/finance_screen.dart';
import 'package:felloapp/ui/pages/tabs/profile_screen.dart';

class NavBarItemData {
  final String title;
  final IconData icon;
  final double width;

  NavBarItemData(this.title, this.icon, this.width);
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  List<NavBarItemData> _navBarItems;
  int _selectedNavIndex = 0;

  List<Widget> _viewsByIndex;

  @override
  void initState() {
    //Declare some buttons for our tab bar
    _navBarItems = [
      NavBarItemData("Home", Icons.home, 110),
      NavBarItemData("Play", Icons.games, 110),
      NavBarItemData("Save", Icons.wallet_giftcard, 115),
      NavBarItemData("Profile", Icons.verified_user, 115),
    ];

    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      HomePage(),
      GamePage(),
      FinancePage(),
      ProfilePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var accentColor = UiConstants.primaryColor;

    //Create custom navBar, pass in a list of buttons, and listen for tap event
    var navBar = NavBar(
      items: _navBarItems,
      itemTapped: _handleNavBtnTapped,
      currentIndex: _selectedNavIndex,
    );
    //Display the correct child view for the current index
    var contentView =
        _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];
    //Wrap our custom navbar + contentView with the app Scaffold
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(),
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
                    Container(
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
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                        child: Container(
                          height: 5,
                          width: 5,
                          padding: EdgeInsets.all(
                            width * 0.03,
                          ),
                          child: Image.asset(
                            "images/menu.png",
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
      _selectedNavIndex = index;
    });
  }
}
