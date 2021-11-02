// //Project Imports
// import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/base_analytics.dart';
// import 'package:felloapp/core/enums/connectivity_status.dart';
// import 'package:felloapp/core/enums/screen_item.dart';
// import 'package:felloapp/core/ops/db_ops.dart';
// import 'package:felloapp/core/ops/lcl_db_ops.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/ui/dialogs/feedback_dialog.dart';
// import 'package:felloapp/ui/dialogs/ticket_details_dialog.dart';
// import 'package:felloapp/ui/elements/Parallax-card/data_model.dart';
// import 'package:felloapp/ui/elements/Parallax-card/game_card_list.dart';
// import 'package:felloapp/ui/elements/leaderboard.dart';
// import 'package:felloapp/ui/elements/week-winners_board.dart';
// import 'package:felloapp/util/haptic.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/ui_constants.dart';

// //Dart and Flutter Imports
// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// //Pub Imports
// import 'package:confetti/confetti.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class GamePage extends StatefulWidget {
//   @override
//   _GamePageState createState() => _GamePageState();
// }

// class _GamePageState extends State<GamePage> {
//   List<Game> _gameList;
//   Game _currentPage;
//   ConfettiController _confeticontroller;
//   LocalDBModel lclDbProvider;
//   BaseUtil baseProvider;
//   DBModel dbProvider;
//   AppState appState;

//   PageController _controller;

//   @override
//   void initState() {
//     super.initState();
//     BaseAnalytics.analytics
//         .setCurrentScreen(screenName: BaseAnalytics.PAGE_GAME);
//     var data = DemoData();
//     _gameList = data.getCities();
//     _currentPage = _gameList[1];
//     // if (SizeConfig.isGamefirstTime != true) {
//     _confeticontroller = new ConfettiController(
//       duration: new Duration(seconds: 2),
//     );
//     _controller = new PageController(
//       initialPage: AppState().getCurrentGameIndex,
//     );
//     // }

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _controller.animateToPage(appState.getCurrentGameTabIndex,
//           duration: Duration(milliseconds: 600), curve: Curves.decelerate);
//     });
//   }

//   void _handleGameChange(Game game) {
//     setState(() {
//       this._currentPage = game;
//     });
//   }

//   void checkConfetti() {
//     // DateTime date = new DateTime.now();
//     // int weekCde = date.year * 100 + BaseUtil.getWeekNumber();
//     // lclDbProvider.isConfettiRequired(weekCde).then((flag) {
//     //   if (flag) {
//     _confeticontroller.play();
//     SizeConfig.isGamefirstTime = false;
//     //     lclDbProvider.saveConfettiUpdate(weekCde);
//     //   }
//     // });
//   }

//   Future<void> _onTicketsRefresh() {
//     print('SCREEN WIDTH IOS: ${SizeConfig.screenWidth}');
//     //TODO ADD LOADER
//     return dbProvider
//         .getUserTicketWallet(baseProvider.myUser.uid)
//         .then((value) {
//       if (value != null) baseProvider.userTicketWallet = value;
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     lclDbProvider = Provider.of<LocalDBModel>(context, listen: false);
//     baseProvider = Provider.of<BaseUtil>(context);
//     dbProvider = Provider.of<DBModel>(context, listen: false);
//     appState = Provider.of<AppState>(context, listen: false);
//     ConnectivityStatus connectivityStatus =
//         Provider.of<ConnectivityStatus>(context);
//     return RefreshIndicator(
//       onRefresh: () async {
//         _onTicketsRefresh();
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: UiConstants.backgroundColor,
//           borderRadius: SizeConfig.homeViewBorder,
//         ),
//         child: Stack(
//           children: [
//             Container(
//               height: SizeConfig.screenHeight * 0.45,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("images/game-asset.png"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SafeArea(
//               child: PageView(
//                 scrollDirection: Axis.vertical,
//                 controller: _controller,
//                 onPageChanged: (int page) {
//                   setState(() {
//                     appState.setCurrentGameTabIndex = page;
//                   });
//                   if (appState.getCurrentGameTabIndex == 1 &&
//                       SizeConfig.isGamefirstTime == true) {
//                     checkConfetti();
//                   }
//                 },
//                 children: [
//                   ClipRRect(
//                     borderRadius: SizeConfig.homeViewBorder,
//                     child: Container(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           InkWell(
//                             onTap: () async {
//                               Haptic.vibrate();
//                               AppState.screenStack.add(ScreenItem.dialog);
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) =>
//                                     TicketDetailsDialog(
//                                         baseProvider.userTicketWallet),
//                               );
//                             },
//                             child: (baseProvider.userTicketWallet != null)
//                                 ? TicketCount(baseProvider.userTicketWallet
//                                     .getActiveTickets())
//                                 : Container(),
//                           ),

//                           GameCardList(
//                             games: _gameList,
//                             onGameChange: _handleGameChange,
//                           ),

//                           //TODO HACKY CODE - REMOVING IDEA SECTION TO MANAGE TABLET SIZE DIMENSIONS
//                           if (SizeConfig.screenWidth < 800) const IdeaSection(),
//                           /////////////////////////////////////////////////////////////
//                         ],
//                       ),
//                     ),
//                   ),
//                   ClipRRect(
//                     borderRadius: SizeConfig.homeViewBorder,
//                     child: Column(
//                       children: [
//                         Container(
//                           height: kToolbarHeight * 0.8,
//                         ),
//                         const WeekWinnerBoard(),
//                         const Leaderboard(),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               height: 100,
//               width: 100,
//               child: ConfettiWidget(
//                 blastDirectionality: BlastDirectionality.explosive,
//                 confettiController: _confeticontroller,
//                 particleDrag: 0.05,
//                 emissionFrequency: 0.05,
//                 numberOfParticles: 25,
//                 gravity: 0.05,
//                 shouldLoop: false,
//                 colors: [
//                   UiConstants.primaryColor,
//                   Color(0xfff7ff00),
//                   Color(0xffFC5C7D),
//                   Color(0xff2B32B2),
//                 ],
//               ),
//             ),
//             appState.getCurrentGameTabIndex == 0
//                 ? Positioned(
//                     bottom: 10,
//                     child: Container(
//                       width: SizeConfig.screenWidth,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           LottieBuilder.asset(
//                             'images/lottie/swipeup.json',
//                             height: SizeConfig.screenHeight * 0.05,
//                           ),
//                           const Text(
//                             "Swipe up to see prizes and leaderboards",
//                             style: TextStyle(
//                               fontSize: 8,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 : SizedBox(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class IdeaSection extends StatelessWidget {
//   const IdeaSection();

//   @override
//   Widget build(BuildContext context) {
//     final baseProvider = Provider.of<BaseUtil>(context, listen: false);
//     final dbProvider = Provider.of<DBModel>(context, listen: false);

//     return Container(
//       height: SizeConfig.screenHeight * 0.16,
//       width: SizeConfig.screenWidth,
//       child: ListView(
//         shrinkWrap: true,
//         itemExtent: SizeConfig.screenWidth * 0.8,
//         scrollDirection: Axis.horizontal,
//         physics: BouncingScrollPhysics(),
//         children: [
//           GameCard(
//             gradient: const [
//               Color(0xffACB6E5),
//               Color(0xff74EBD5),
//             ],
//             title: "Want more tickets?",
//             action: [
//               GameOfferCardButton(
//                 onPressed: () => AppState.delegate
//                     .parseRoute(Uri.parse("finance/augDetails")),
//                 title: "Invest",
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               GameOfferCardButton(
//                 onPressed: () =>
//                     AppState.delegate.parseRoute(Uri.parse("profile")),
//                 title: "Share",
//               ),
//             ],
//           ),
//           GameCard(
//             gradient: const [
//               Color(0xffFFCF41),
//               Color(0xffDE8806),
//             ],
//             title: "Share your thoughts",
//             action: [
//               GameOfferCardButton(
//                 onPressed: () {
//                   AppState.screenStack.add(ScreenItem.dialog);
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) => WillPopScope(
//                       onWillPop: () {
//                         AppState.backButtonDispatcher.didPopRoute();
//                         return Future.value(true);
//                       },
//                       child: FeedbackDialog(
//                         title: "Tell us what you think",
//                         description: "We'd love to hear from you",
//                         buttonText: "Submit",
//                         dialogAction: (String fdbk) {
//                           if (fdbk != null && fdbk.isNotEmpty) {
//                             //feedback submission allowed even if user not signed in

//                             dbProvider
//                                 .submitFeedback(
//                                     (baseProvider.firebaseUser == null ||
//                                             baseProvider.firebaseUser.uid ==
//                                                 null)
//                                         ? 'UNKNOWN'
//                                         : baseProvider.firebaseUser.uid,
//                                     fdbk)
//                                 .then((flag) {
//                               AppState.backButtonDispatcher.didPopRoute();
//                               if (flag) {
//                                 BaseUtil.showPositiveAlert('Thank You',
//                                     'We appreciate your feedback!', context);
//                               } else {
//                                 BaseUtil.showNegativeAlert(
//                                     "Please try again",
//                                     "We were unable to get your feedback",
//                                     context);
//                               }
//                             });
//                           }
//                         },
//                       ),
//                     ),
//                   );
//                 },
//                 title: "Feedback",
//               ),
//               GameOfferCardButton(
//                 onPressed: () {
//                   if (Platform.isAndroid)
//                     WebView.platform = SurfaceAndroidWebView();

//                   return WebView(
//                     initialUrl: "https://play.famobi.com/om-nom-run",
//                   );
//                 },
//                 title: "New game",
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TicketCount extends StatefulWidget {
//   final int totalCount;

//   const TicketCount(this.totalCount);

//   @override
//   _TicketCountState createState() => _TicketCountState();
// }

// class _TicketCountState extends State<TicketCount>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;
//   Animation<double> _animation;
//   double _latestBegin;
//   double _latestEnd;
//   double tagWidth = 0, tagHeight = 0, tagOpacity = 1;
//   bool showTag = false;

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();

//     _controller =
//         AnimationController(duration: Duration(seconds: 2), vsync: this);
//     _latestBegin = 0;
//     _latestEnd = widget.totalCount + .0;
//     if (AppState.isFirstTime) animateTag();
//   }

//   animateTag() {
//     showTag = true;
//     Future.delayed(Duration(milliseconds: 2500), () {
//       if (mounted)
//         setState(() {
//           tagWidth = SizeConfig.screenWidth * 0.7;
//           tagHeight = SizeConfig.cardTitleTextSize * 1.2;
//         });
//     }).then((_) {
//       Future.delayed(Duration(milliseconds: 2500), () {
//         if (mounted)
//           setState(() {
//             tagWidth = 0;
//             tagHeight = 0;
//           });
//         AppState.isFirstTime = false;
//       }).then((value) {
//         Future.delayed(Duration(seconds: 2), () {
//           if (mounted)
//             setState(() {
//               showTag = false;
//             });
//         });
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (SizeConfig.isGamefirstTime == true) {
//       CurvedAnimation curvedAnimation =
//           CurvedAnimation(parent: _controller, curve: Curves.decelerate);
//       _animation =
//           Tween<double>(begin: 0, end: _latestEnd).animate(curvedAnimation);

//       if (0 != _latestBegin || widget.totalCount != _latestEnd) {
//         _controller.reset();
//       }

//       _latestBegin = 0;
//       _latestEnd = widget.totalCount + .0;
//       _controller.addListener(() {
//         setState(() {});
//       });
//       _controller.forward();
//     }

//     return Container(
//       child: Column(
//         children: [
//           Text(
//             _animation != null
//                 ? _animation.value.round().toString()
//                 : "${widget.totalCount}",
//             style: GoogleFonts.montserrat(
//               color: Colors.white,
//               fontSize: SizeConfig.screenHeight * 0.08,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 " Tickets",
//                 style: TextStyle(
//                     color: Colors.white, fontSize: SizeConfig.mediumTextSize),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(left: 1),
//                 child: Icon(
//                   Icons.info_outline,
//                   color: Colors.white60,
//                   size: SizeConfig.mediumTextSize,
//                 ),
//               )
//             ],
//           ),
//           if (showTag)
//             AnimatedContainer(
//               duration: Duration(milliseconds: 600),
//               margin: EdgeInsets.only(top: 10, left: 50, right: 50),
//               width: tagWidth,
//               height: tagHeight,
//               curve: Curves.bounceOut,
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: Colors.yellow[100],
//               ),
//               alignment: Alignment.center,
//               child: AnimatedOpacity(
//                 opacity: tagOpacity,
//                 duration: Duration(seconds: 1),
//                 child: Text(
//                   "🏁 ₹ 100 saved = 1 Ticket",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: SizeConfig.mediumTextSize,
//                     fontWeight: FontWeight.w500,
//                     letterSpacing: 2,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class GameCard extends StatelessWidget {
//   final String title, buttonText;
//   final List<Color> gradient;
//   final List<Widget> action;

//   const GameCard({this.buttonText, this.title, this.gradient, this.action});

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       children: [
//         Container(
//           margin: EdgeInsets.only(
//               left: SizeConfig.globalMargin, right: SizeConfig.globalMargin),
//           padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               gradient: new LinearGradient(
//                 colors: gradient,
//                 begin: Alignment.bottomLeft,
//                 end: Alignment.topRight,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: gradient[0].withOpacity(0.3),
//                   offset: Offset(5, 5),
//                   blurRadius: 10,
//                 ),
//                 BoxShadow(
//                   color: gradient[1].withOpacity(0.3),
//                   offset: Offset(5, 5),
//                   blurRadius: 10,
//                 ),
//               ]),
//           width: SizeConfig.screenWidth * 0.8,
//           height: SizeConfig.screenHeight * 0.14,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                     color: Colors.white,
//                     shadows: [
//                       Shadow(
//                         offset: Offset(5, 5),
//                         color: Colors.black26,
//                         blurRadius: 10,
//                       )
//                     ],
//                     fontWeight: FontWeight.w700,
//                     fontSize: SizeConfig.screenWidth * 0.06),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 children: action,
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class GameOfferCardButton extends StatelessWidget {
//   final Function onPressed;
//   final String title;

//   const GameOfferCardButton({this.onPressed, this.title});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//             horizontal: SizeConfig.blockSizeHorizontal * 6, vertical: 8),
//         decoration: BoxDecoration(
//           border: Border.all(
//             width: 2,
//             color: Colors.white,
//           ),
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(100),
//         ),
//         child: Text(
//           title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               color: Colors.white, fontSize: SizeConfig.mediumTextSize),
//         ),
//       ),
//     );
//   }
// }
