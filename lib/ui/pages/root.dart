//Project Imports
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/core/fcm_handler.dart';
import 'package:felloapp/core/model/BaseUser.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/golden_ticket_claim.dart';
import 'package:felloapp/ui/elements/navbar.dart';
import 'package:felloapp/ui/modals/security_modal_sheet.dart';
import 'package:felloapp/ui/modals/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/hometabs/widgets.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_view.dart';

import 'package:felloapp/ui/pages/tabs/finance/finance_screen.dart';
import 'package:felloapp/ui/pages/tabs/games/games_screen.dart';
import 'package:felloapp/ui/pages/tabs/home_screen.dart';
import 'package:felloapp/ui/pages/tabs/profile/profile_screen.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';

//Dart & Flutter Imports
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

//Pub Imports
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with SingleTickerProviderStateMixin {
  Log log = new Log("Root");
  List<NavBarItemData> _navBarItems;
  BaseUtil baseProvider;
  HttpModel httpModel;
  DBModel dbProvider;
  FcmHandler fcmProvider;
  LocalDBModel lclDbProvider;
  AppState appState;
  List<Widget> _viewsByIndex;
  List<bool> _showFocuses = List.filled(4, false);
  bool _isInitialized = false;
  bool showTag = true;
  double tagWidth = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController animationController;

  //New
  void _onItemTapped(int index) {
    setState(() {
      AppState().setCurrentTabIndex = index;
    });
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppState().setRootLoadValue = true;
      tagWidth = SizeConfig.screenWidth / 2;
    });
    _initDynamicLinks();
    //Declare some buttons for our tab bar
    _navBarItems = [
      NavBarItemData("Home", Icons.home, SizeConfig.screenWidth * 0.25,
          "images/svgs/home.svg", _showFocuses[0]),
      NavBarItemData("Play", Icons.games, SizeConfig.screenWidth * 0.24,
          "images/svgs/game.svg", _showFocuses[1]),
      NavBarItemData(
          "Save",
          Icons.wallet_giftcard,
          SizeConfig.screenWidth * 0.24,
          "images/svgs/save.svg",
          _showFocuses[2]),
      NavBarItemData(
          "Profile",
          Icons.verified_user,
          SizeConfig.screenWidth * 0.25,
          "images/svgs/profile.svg",
          _showFocuses[3]),
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
  void dispose() {
    super.dispose();
    if (baseProvider != null) baseProvider.cancelIncomingNotifications();
    fcmProvider.addIncomingMessageListener(null);
  }

  void toggleTag() {
    print("show tag toggled");
    setState(() {
      showTag = !showTag;
    });
  }

  _initAdhocNotifications() {
    if (fcmProvider != null && baseProvider != null) {
      fcmProvider.addIncomingMessageListener((valueMap) {
        if (valueMap['title'] != null && valueMap['body'] != null) {
          baseProvider.showPositiveAlert(
              valueMap['title'], valueMap['body'], context,
              seconds: 5);
        }
      });
    }
  }

  void _showSecurityBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        backgroundColor: UiConstants.bottomNavBarColor,
        builder: (context) {
          return const SecurityModalSheet();
        });
  }

  _initialize() {
    if (!_isInitialized) {
      _isInitialized = true;
      lclDbProvider.showHomeTutorial.then((value) {
        if (value) {
          //show tutorial
          lclDbProvider.setShowHomeTutorial = false;
          AppState.delegate.parseRoute(Uri.parse('dashboard/walkthrough'));
          setState(() {});
        }
      });

      _initAdhocNotifications();
      baseProvider.getProfilePicture();
      // show security modal
      if (baseProvider.show_security_prompt &&
          baseProvider.myUser.isAugmontOnboarded &&
          baseProvider.myUser.userPreferences
                  .getPreference(Preferences.APPLOCK) ==
              0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showSecurityBottomSheet();
          lclDbProvider.updateSecurityPrompt(false);
        });
      }
      baseProvider.isUnreadFreshchatSupportMessages().then((flag) {
        if (flag) {
          baseProvider.showPositiveAlert('You have unread support messages',
              'Go to the Contact Us section to view', context,
              seconds: 4);
        }
      });
    }
  }

  showDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  showTicketModal() {
    AppState.screenStack.add(ScreenItem.dialog);
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return WantMoreTicketsModalSheet();
        });
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context);
    httpModel = Provider.of<HttpModel>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    fcmProvider = Provider.of<FcmHandler>(context, listen: false);
    lclDbProvider = Provider.of<LocalDBModel>(context, listen: false);
    appState = Provider.of<AppState>(context, listen: false);
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);
    _initialize();
    var accentColor = UiConstants.primaryColor;
    List<Widget> _pages = <Widget>[Play(), Save(), Win()];

    //Create custom navBar, pass in a list of buttons, and listen for tap event
    var navBar = NavBar(
      items: _navBarItems,
      itemTapped: _handleNavBtnTapped,
      currentIndex: appState.getCurrentTabIndex,
    );
    //Display the correct child view for the current index
    var contentView = _viewsByIndex[min(
        context.watch<AppState>().getCurrentTabIndex,
        _viewsByIndex.length - 1)];
    //Wrap our custom navbar + contentView with the app Scaffold

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: ThemeData().scaffoldBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: showDrawer,
            child: CircleAvatar(
              radius: kToolbarHeight * 0.3,
              backgroundImage: baseProvider.myUserDpUrl == null
                  ? AssetImage(
                      "images/profile.png",
                    )
                  : CachedNetworkImageProvider(
                      baseProvider.myUserDpUrl,
                    ),
            ),
          ),
        ),
        title: Text(
          "Hi, ${baseProvider.myUser.name.split(' ').first ?? "user"}",
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500, fontSize: SizeConfig.largeTextSize),
        ),
        actions: [
          InkWell(
            onTap: showTicketModal,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: UiConstants.primaryColor),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                    baseProvider.userTicketWallet.getActiveTickets().toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.control_point_rounded,
                    color: Colors.white,
                    size: kToolbarHeight / 2.5,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            child: Icon(
              Icons.notifications,
              size: kToolbarHeight * 0.5,
              color: Color(0xff4C4C4C),
            ),
            //icon: Icon(Icons.contact_support_outlined),
            // iconSize: kToolbarHeight * 0.5,
            onTap: () {
              Haptic.vibrate();
              AppState.delegate.appState.currentAction = PageAction(
                  state: PageState.addPage, page: NotificationsConfig);
            },
          ),
          SizedBox(
            width: SizeConfig.globalMargin,
          )
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.globalMargin),
              ListTile(
                onTap: () {
                  AppState.delegate.appState.currentAction = PageAction(
                      state: PageState.addPage, page: UserProfileDetailsConfig);
                },
                leading: CircleAvatar(
                  radius: kToolbarHeight * 0.5,
                  backgroundImage: baseProvider.myUserDpUrl == null
                      ? AssetImage(
                          "images/profile.png",
                        )
                      : CachedNetworkImageProvider(
                          baseProvider.myUserDpUrl,
                        ),
                ),
                title: Widgets().getHeadlineBold(
                    text: baseProvider.myUser.name, color: Colors.black),
                subtitle: Widgets().getBodyLight(
                    "@${baseProvider.myUser.username}", Colors.black),
              ),
              SizedBox(
                height: 16,
              ),
              ListTile(
                title: Widgets().getHeadlineLight("Refer & Earn", Colors.black),
              ),
              ListTile(
                title: Widgets().getHeadlineLight("PAN & KYC", Colors.black),
              ),
              ListTile(
                title: Widgets().getHeadlineLight("Transactions", Colors.black),
              ),
              ListTile(
                title:
                    Widgets().getHeadlineLight("Help & Support", Colors.black),
              ),
              ListTile(
                title:
                    Widgets().getHeadlineLight("How it works?", Colors.black),
              ),
              ListTile(
                title: Widgets()
                    .getHeadlineLight("About Digital Gold", Colors.black),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Widgets().getBodyLight("Version 1.0.0.1", Colors.black),
                ],
              )
            ],
          ),
        ),
      ),
      body:
          IndexedStack(children: _pages, index: AppState().getCurrentTabIndex),
      bottomNavigationBar:
          // SizeTransition(
          //   sizeFactor: animationController,
          //   child:
          BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedFontSize: 16,
        selectedIconTheme:
            IconThemeData(color: UiConstants.primaryColor, size: 32),
        selectedItemColor: UiConstants.primaryColor,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: IconThemeData(
          color: Colors.grey[500],
        ),
        unselectedItemColor: Colors.grey[500],
        currentIndex: AppState().getCurrentTabIndex, //New
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_rounded),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Save',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.celebration_rounded),
            label: 'Win',
          ),
        ],
      ),
      // ),
    );
    // Scaffold(
    //     backgroundColor: UiConstants.bottomNavBarColor,
    //     resizeToAvoidBottomInset: false,
    //     body:
    // Stack(
    //   children: [
    //     Container(
    //       width: double.infinity,
    //       //Wrap the current page in an AnimatedSwitcher for an easy cross-fade effect
    //       child: AnimatedSwitcher(
    //         duration: Duration(milliseconds: 350),
    //         //Pass the current accent color down as a theme, so our overscroll indicator matches the btn color
    //         child: Theme(
    //           data: ThemeData(accentColor: accentColor),
    //           child: contentView,
    //         ),
    //       ),
    //     ),
    //     if (connectivityStatus == ConnectivityStatus.Offline)
    //       Positioned(
    //         child: SafeArea(
    //           child: Container(
    //             alignment: Alignment.center,
    //             height: kToolbarHeight,
    //             width: SizeConfig.screenWidth,
    //             child: NetworkBar(
    //               textColor: (appState.getCurrentTabIndex == 0)
    //                   ? Colors.white
    //                   : Color(0xff4C4C4C),
    //             ),
    //           ),
    //         ),
    //       ),
    //     Positioned(
    //       top: SizeConfig.blockSizeHorizontal * 2,
    //       right: SizeConfig.blockSizeHorizontal * 2,
    //       child: SafeArea(
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             if (appState.getCurrentTabIndex == 3)
    // InkWell(
    //   child: Icon(
    //     Icons.notifications,
    //     size: kToolbarHeight * 0.5,
    //     color: (appState.getCurrentTabIndex == 0)
    //         ? Colors.white
    //         : Color(0xff4C4C4C),
    //   ),
    //   //icon: Icon(Icons.contact_support_outlined),
    //   // iconSize: kToolbarHeight * 0.5,
    //   onTap: () {
    //     Haptic.vibrate();
    //     AppState.delegate.appState.currentAction = PageAction(
    //         state: PageState.addPage,
    //         page: NotificationsConfig);
    //   },
    // ),
    //             SizedBox(
    //               width: kToolbarHeight * 0.2,
    //             ),
    //             InkWell(
    //               child: SvgPicture.asset(
    //                 "images/support-log.svg",
    //                 height: kToolbarHeight * 0.6,
    //                 color: (appState.getCurrentTabIndex == 0)
    //                     ? Colors.white
    //                     : Color(0xff4C4C4C),
    //               ),
    //               //icon: Icon(Icons.contact_support_outlined),
    //               // iconSize: kToolbarHeight * 0.5,
    //               onTap: () {
    //                 Haptic.vibrate();
    //                 AppState.delegate.appState.currentAction = PageAction(
    //                     state: PageState.addPage, page: SupportPageConfig);
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ],
    // ),
    // bottomNavigationBar: navBar //Pass our custom navBar into the scaffold
    //);
  }

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild

    //This will be passed into the NavBar and change it's selected state, also controls the active content page
    appState.setCurrentTabIndex = index;
  }

  Future<dynamic> _initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink == null) return null;

      log.debug('Received deep link. Process the referral');
      return _processDynamicLink(baseProvider.myUser.uid, deepLink);
    }, onError: (OnLinkErrorException e) async {
      log.error('Error in fetching deeplink');
      log.error(e);
      return null;
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      log.debug('Received deep link. Process the referral');
      return _processDynamicLink(baseProvider.myUser.uid, deepLink);
    }
  }

  _processDynamicLink(String userId, Uri deepLink) async {
    String _uri = deepLink.toString();
    if (_uri.startsWith(Constants.GOLDENTICKET_DYNAMICLINK_PREFIX)) {
      //Golden ticket dynamic link
      int flag = await _submitGoldenTicket(userId, _uri);
    } else {
      //Referral dynamic link
      int addUserTicketCount = await _submitReferral(
          baseProvider.myUser.uid, baseProvider.myUser.name, _uri);
      if (addUserTicketCount == null || addUserTicketCount < 0) {
        log.debug('Processing complete. No extra tickets to be added');
      } else {
        log.debug('$addUserTicketCount tickets need to be added for the user');
      }
    }
  }

  Future<int> _submitReferral(
      String userId, String userName, String deepLink) async {
    try {
      String prefix = 'https://fello.in/';
      if (deepLink.startsWith(prefix)) {
        String referee = deepLink.replaceAll(prefix, '');
        log.debug(referee);
        if (prefix.length > 0 && prefix != userId) {
          return httpModel
              .postUserReferral(userId, referee, userName)
              .then((userTicketUpdateCount) {
            log.debug('User deserves $userTicketUpdateCount more tickets');
            return userTicketUpdateCount;
          });
        } else
          return -1;
      } else
        return -1;
    } catch (e) {
      log.error(e);
      return -1;
    }
  }

  Future<int> _submitGoldenTicket(String userId, String deepLink) async {
    try {
      String prefix = "https://fello.in/goldenticketdynlnk/";
      if (!deepLink.startsWith(prefix)) return -1;
      String docId = deepLink.replaceAll(prefix, '');
      if (docId != null && docId.isNotEmpty) {
        return httpModel
            .postGoldenTicketRedemption(userId, docId)
            .then((redemptionMap) {
          // log.debug('Flag is ${tckCount.toString()}');
          if (redemptionMap != null &&
              redemptionMap['flag'] &&
              redemptionMap['count'] > 0) {
            AppState.screenStack.add(ScreenItem.dialog);
            return showDialog(
              context: context,
              builder: (_) => GoldenTicketClaimDialog(
                ticketCount: redemptionMap['count'],
                cashPrize: redemptionMap['amt'],
              ),
            );
          } else {
            AppState.screenStack.add(ScreenItem.dialog);
            return showDialog(
              context: context,
              builder: (_) => GoldenTicketClaimDialog(
                ticketCount: 0,
                failMsg: redemptionMap['fail_msg'],
              ),
            );
          }
        });
      }
      return -1;
    } catch (e) {
      log.error('$e');
      return -1;
    }
  }
}
