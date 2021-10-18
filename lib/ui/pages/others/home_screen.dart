// //Project Imports
// import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/base_analytics.dart';
// import 'package:felloapp/core/enums/connectivity_status.dart';
// import 'package:felloapp/core/enums/pagestate.dart';
// import 'package:felloapp/core/model/feed_card_model.dart';
// import 'package:felloapp/core/ops/db_ops.dart';
// import 'package:felloapp/core/ops/lcl_db_ops.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/navigator/router/ui_pages.dart';
// import 'package:felloapp/ui/elements/tambola-global/tambola_daily_draw_timer.dart';
// import 'package:felloapp/util/constants.dart';
// import 'package:felloapp/util/haptic.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/ui_constants.dart';

// //Dart and Flutter Imports
// import 'package:flutter/material.dart';

// //Pub Imports
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   bool isImageLoading = false;
//   BaseUtil baseProvider;
//   ConnectivityStatus _connectivityStatus;
//   DBModel dbProvider;
//   AppState appState;
//   LocalDBModel _localDBModel;
//   bool _isInit = false;

//   Future<void> getProfilePicUrl() async {
//     if (baseProvider == null || baseProvider.myUser == null) return;
//     baseProvider.myUserDpUrl =
//         await dbProvider.getUserDP(baseProvider.myUser.uid);
//     if (baseProvider.myUserDpUrl != null) {
//       try {
//         setState(() {
//           isImageLoading = false;
//         });
//       } catch (e) {
//         print('HomeScreen: SetState called after dispose');
//       }
//     }
//   }

//   String getGreeting() {
//     int hour = DateTime.now().hour;
//     if (hour >= 5 && hour <= 12) {
//       return "Good Morning,";
//     } else if (hour > 12 && hour <= 17) {
//       return "Good Afternoon,";
//     } else if (hour > 17 && hour <= 22) {
//       return "Good Evening,";
//     } else
//       return "Hello,";
//   }

//   @override
//   void initState() {
//     super.initState();
//     BaseAnalytics.analytics
//         .setCurrentScreen(screenName: BaseAnalytics.PAGE_HOME);
//   }

//   _init() {
//     if (!baseProvider.isHomeCardsFetched) {
//       dbProvider.getHomeCards().then((cards) {
//         if (cards.length > 0) {
//           baseProvider.feedCards = cards;
//           _isInit = true;
//           baseProvider.isHomeCardsFetched = true;
//           setState(() {});
//         } else {
//           if (mounted) setState(() {});
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     baseProvider = Provider.of<BaseUtil>(context, listen: false);
//     dbProvider = Provider.of<DBModel>(context, listen: false);
//     appState = Provider.of<AppState>(context, listen: false);
//     _connectivityStatus =
//         Provider.of<ConnectivityStatus>(context, listen: true);
//     _localDBModel = Provider.of<LocalDBModel>(context, listen: false);

//     if (baseProvider.myUserDpUrl == null) {
//       isImageLoading = true;
//       getProfilePicUrl();
//     }
//     if (!_isInit || baseProvider.feedCards.length == 0) {
//       _init();
//     }
//     return Container(
//         decoration: BoxDecoration(
//           color: UiConstants.backgroundColor,
//           borderRadius: SizeConfig.homeViewBorder,
//         ),
//         child: Stack(
//           children: [
//             Container(
//               height: SizeConfig.screenHeight * 0.36,
//               width: SizeConfig.screenWidth,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("images/home-asset.png"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SafeArea(
//               child: ClipRRect(
//                 borderRadius: SizeConfig.homeViewBorder,
//                 child: ListView(
//                   controller: AppState.homeCardListController,
//                   physics: BouncingScrollPhysics(),
//                   padding: EdgeInsets.symmetric(
//                       horizontal: SizeConfig.blockSizeHorizontal * 1.6),
//                   children: (!baseProvider.isHomeCardsFetched ||
//                           baseProvider.feedCards.length == 0)
//                       ? _buildLoadingFeed()
//                       : _buildHomeFeed(baseProvider.feedCards),
//                 ),
//               ),
//             )
//           ],
//         ));
//   }

//   void logError(String code, String message) =>
//       print('Error: $code\nError Message: $message');

//   List<Widget> _buildLoadingFeed() {
//     return [
//       Container(
//         height: SizeConfig.screenHeight * 0.04,
//       ),
//       _buildProfileRow(),
//       Padding(
//         padding: EdgeInsets.symmetric(vertical: 30),
//         child: SpinKitWave(
//           color: UiConstants.primaryColor,
//         ),
//       )
//     ];
//   }

//   List<Widget> _buildHomeFeed(List<FeedCard> cards) {
//     ConnectivityStatus connectivityStatus =
//         Provider.of<ConnectivityStatus>(context);

//     if (cards.length == 0) {
//       return [
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: TextButton.icon(
//             onPressed: _init,
//             icon: Icon(
//               Icons.refresh,
//               color: Colors.white,
//             ),
//             label: Text(
//               "Click to reload",
//               style: GoogleFonts.montserrat(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         )
//       ];
//     }
//     List<Widget> _widget = [
//       Container(
//         height: connectivityStatus == ConnectivityStatus.Offline
//             ? kToolbarHeight
//             : SizeConfig.screenHeight * 0.02,
//       ),
//       _buildProfileRow(),
//     ];

//     ///reorder learn card
//     for (FeedCard card in cards) {
//       if (card.type == Constants.LEARN_FEED_CARD_TYPE) {
//         DateTime _now = DateTime.now();
//         DateTime _lastWeek = _now.subtract(Duration(days: 7));
//         if (baseProvider.userCreationTimestamp.isBefore(_lastWeek)) {
//           card.id = 200;
//         }
//       }
//     }
//     if (cards != null && cards.isNotEmpty)
//       cards.sort((a, b) => a.id.compareTo(b.id));

//     ///add to widgets
//     for (FeedCard card in cards) {
//       _widget.add(_buildFeedCard(card));
//     }

//     return _widget;
//   }

//   Widget _buildFeedCard(FeedCard card) {
//     if (card == null) return Container();
//     switch (card.type) {
//       case Constants.LEARN_FEED_CARD_TYPE:
//         return BaseHomeCard(
//           asset: card.assetLocalLink,
//           gradient: [
//             Color(card.clrCodeA),
//             Color(card.clrCodeB),
//           ],
//           child: BaseHomeCardContent(
//             shadowColor: Color(card.clrCodeB),
//             title: card.title,
//             subtitle: card.subtitle,
//             buttonText: card.btnText,
//             isHighlighted: false,
//             onPressed: () async {
//               Haptic.vibrate();
//               AppState.delegate.parseRoute(Uri.parse(card.actionUri));
//             },
//           ),
//         );

//       case Constants.TAMBOLA_FEED_CARD_TYPE:
//         return BaseHomeCard(
//           asset: card.assetLocalLink,
//           gradient: [
//             Color(card.clrCodeA),
//             Color(card.clrCodeB),
//           ],
//           child: TambolaCardContent(
//             shadowColor: Color(card.clrCodeA),
//             title: card.title,
//             subtitle: card.subtitle,
//             buttonText: card.btnText,
//             isHighlighted: false,
//             onPressed: () async {
//               Haptic.vibrate();
//               baseProvider.openTambolaHome();
//             },
//           ),
//         );
//       case Constants.PRIZE_FEED_CARD_TYPE:
//         return BaseHomeCard(
//           asset: card.assetLocalLink,
//           gradient: [
//             Color(card.clrCodeA),
//             Color(card.clrCodeB),
//           ],
//           child: PrizeCardContent(
//             shadowColor: Color(card.clrCodeA),
//             title: card.title,
//             subtitle: card.subtitle,
//             buttonText: card.btnText,
//             isHighlighted: false,
//             dataMap: card.dataMap,
//             onPressed: () async {
//               Haptic.vibrate();
//               AppState.delegate.appState.setCurrentTabIndex = 1;
//               AppState.delegate.appState.setCurrentGameTabIndex = 1;
//             },
//           ),
//         );
//       case Constants.DEFAULT_FEED_CARD_TYPE:
//       default:
//         return BaseHomeCard(
//           asset: card.assetLocalLink,
//           gradient: [
//             Color(card.clrCodeA),
//             Color(card.clrCodeB),
//           ],
//           child: BaseHomeCardContent(
//             shadowColor: Color(card.clrCodeA),
//             title: card.title,
//             subtitle: card.subtitle,
//             buttonText: card.btnText,
//             isHighlighted: false,
//             onPressed: () {
//               Haptic.vibrate();
//               AppState.delegate.parseRoute(Uri.parse(card.actionUri));
//             },
//           ),
//         );
//     }
//   }

//   Widget _buildProfileRow() {
//     return InkWell(
//       onTap: () {
//         AppState.delegate.appState.currentAction = PageAction(
//             state: PageState.addPage, page: UserProfileDetailsConfig);
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         margin: EdgeInsets.symmetric(
//             horizontal: SizeConfig.globalMargin,
//             vertical: SizeConfig.blockSizeHorizontal * 6),
//         width: double.infinity,
//         child: Row(
//           children: [
//             Container(
//               height: SizeConfig.screenWidth * 0.16,
//               width: SizeConfig.screenWidth * 0.16,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: Colors.white,
//                     width: 3,
//                   )),
//               child: baseProvider.myUserDpUrl == null
//                   ? Image.asset(
//                       "images/profile.png",
//                       fit: BoxFit.cover,
//                     )
//                   : ClipOval(
//                       child: CachedNetworkImage(
//                         imageUrl: baseProvider.myUserDpUrl,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//             ),
//             SizedBox(
//               width: 16,
//             ),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     getGreeting(),
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                         fontSize: SizeConfig.largeTextSize * 1.2),
//                   ),
//                   const SizedBox(height: 5),
//                   FittedBox(
//                     child: Text(
//                       baseProvider.myUser?.name ?? 'NA',
//                       maxLines: 1,
//                       textAlign: TextAlign.start,
//                       style: GoogleFonts.montserrat(
//                           color: Colors.white,
//                           fontSize: SizeConfig.largeTextSize),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BaseHomeCard extends StatelessWidget {
//   final String asset;
//   final List<Color> gradient;
//   final Widget child;

//   BaseHomeCard({
//     this.asset,
//     this.gradient,
//     this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(
//           bottom: 20,
//           left: SizeConfig.globalMargin,
//           right: SizeConfig.globalMargin),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
//         gradient: new LinearGradient(
//           colors: gradient,
//           begin: Alignment.bottomLeft,
//           end: Alignment.topRight,
//         ),
//         boxShadow: [
//           BoxShadow(
//               color: gradient[0].withOpacity(0.3),
//               offset: Offset(0, 5),
//               blurRadius: 5,
//               spreadRadius: 2),
//         ],
//       ),
//       width: double.infinity,
//       child: Stack(
//         children: [
//           Positioned(
//             right: 0,
//             bottom: 0,
//             child: Opacity(
//               opacity: 0.3,
//               child: Image.asset(
//                 asset,
//                 //height: height * 0.25,
//                 width: SizeConfig.screenWidth * 0.5,
//               ),
//             ),
//           ),
//           Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(SizeConfig.screenWidth * 0.06),
//               child: child)
//         ],
//       ),
//     );
//   }
// }

// class BaseHomeCardContent extends StatelessWidget {
//   final String title, subtitle, buttonText;
//   final Function onPressed;
//   bool isHighlighted;
//   final Color shadowColor;

//   BaseHomeCardContent({
//     this.buttonText,
//     this.isHighlighted,
//     this.onPressed,
//     this.subtitle,
//     this.title,
//     this.shadowColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     LocalDBModel localDbProvider =
//         Provider.of<LocalDBModel>(context, listen: false);
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title.replaceAll("<br/>", "\n"),
//           style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               shadows: [
//                 Shadow(
//                   offset: Offset(5, 5),
//                   color: Colors.black26,
//                   blurRadius: 10,
//                 )
//               ],
//               fontSize: SizeConfig.cardTitleTextSize),
//         ),
//         SizedBox(
//           height: SizeConfig.blockSizeVertical,
//         ),
//         Container(
//           width: SizeConfig.screenWidth * 0.6,
//           child: Text(
//             subtitle,
//             style: TextStyle(
//                 color: Colors.white,
//                 fontSize: SizeConfig.mediumTextSize * 1.1,
//                 fontWeight: FontWeight.w700),
//           ),
//         ),
//         SizedBox(
//           height: SizeConfig.blockSizeVertical * 1.5,
//         ),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(100),
//           child: GestureDetector(
//             onTap: onPressed,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   width: 2,
//                   color: Colors.white,
//                 ),
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               child: Text(
//                 buttonText,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: SizeConfig.mediumTextSize * 1.3),
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// class TambolaCardContent extends StatelessWidget {
//   BaseUtil baseProvider;
//   LocalDBModel _localDBModel;
//   final String title, subtitle, buttonText;
//   final Function onPressed;
//   bool isHighlighted;
//   final Color shadowColor;

//   TambolaCardContent({
//     this.buttonText,
//     this.isHighlighted,
//     this.onPressed,
//     this.subtitle,
//     this.title,
//     this.shadowColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     baseProvider = Provider.of<BaseUtil>(context);
//     _localDBModel = Provider.of<LocalDBModel>(context);
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title.replaceAll('<br/>', '\n'),
//           style: TextStyle(
//               color: Colors.white,
//               shadows: [
//                 Shadow(
//                   offset: Offset(5, 5),
//                   color: Colors.black26,
//                   blurRadius: 10,
//                 )
//               ],
//               fontWeight: FontWeight.w700,
//               fontSize: SizeConfig.cardTitleTextSize),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Text(
//           subtitle,
//           style: TextStyle(
//               color: Colors.white,
//               shadows: [
//                 Shadow(
//                   color: shadowColor,
//                   offset: Offset(1, 1),
//                 ),
//               ],
//               fontSize: SizeConfig.mediumTextSize * 1.1,
//               fontWeight: FontWeight.w700),
//         ),
//         SizedBox(
//           height: 30,
//         ),
//         InkWell(
//           onTap: onPressed,
//           child: DailyPicksTimer(
//             alignment: MainAxisAlignment.start,
//             bgColor: Color(0xff127C56).withOpacity(0.5),
//             replacementWidget: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   width: 2,
//                   color: Colors.white,
//                 ),
//                 color: Colors.transparent,
//                 boxShadow: [
//                   BoxShadow(
//                       color: Color(0xff197163).withOpacity(0.2),
//                       blurRadius: 20,
//                       offset: Offset(5, 5),
//                       spreadRadius: 10),
//                 ],
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               child: Text(
//                 buttonText,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: SizeConfig.mediumTextSize * 1.3),
//               ),
//             ),
//             additionalWidget: Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: Text(
//                 "Today's draws coming in",
//                 style: TextStyle(
//                     color: Colors.white,
//                     shadows: [
//                       Shadow(
//                         color: Color(0xff343A40),
//                         offset: Offset(1, 1),
//                       ),
//                     ],
//                     fontSize: SizeConfig.mediumTextSize,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// class PrizeCardContent extends StatelessWidget {
//   final String title, subtitle, buttonText;
//   final Function onPressed;
//   bool isHighlighted;
//   final Color shadowColor;
//   final Map<String, dynamic> dataMap;
//   List<Widget> coreContent;

//   PrizeCardContent({
//     this.buttonText,
//     this.isHighlighted,
//     this.onPressed,
//     this.subtitle,
//     this.title,
//     this.shadowColor,
//     this.dataMap,
//   });

//   getCoreContent() {
//     coreContent = [];
//     dataMap.forEach((key, value) {
//       coreContent.add(getSection(value['value'], value['key']));
//     });
//     coreContent = coreContent.reversed.toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     getCoreContent();
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // SizedBox(
//         //   height: 20,
//         // ),
//         Text(
//           title.replaceAll('<br/>', '\n'),
//           style: GoogleFonts.montserrat(
//             color: Colors.white,
//             shadows: [
//               Shadow(
//                 color: shadowColor,
//                 offset: Offset(1, 1),
//               ),
//             ],
//             fontWeight: FontWeight.w500,
//             fontSize: SizeConfig.mediumTextSize * 1.5,
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         Row(children: coreContent),
//         SizedBox(
//           height: 20,
//         ),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(100),
//           child: Shimmer(
//             enabled: isHighlighted,
//             direction: ShimmerDirection.fromLeftToRight(),
//             child: GestureDetector(
//               onTap: onPressed,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     width: 2,
//                     color: Colors.white,
//                   ),
//                   color: Colors.transparent,
//                   boxShadow: [
//                     BoxShadow(
//                         color: shadowColor.withOpacity(0.2),
//                         blurRadius: 20,
//                         offset: Offset(5, 5),
//                         spreadRadius: 10),
//                   ],
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: Text(
//                   buttonText,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: SizeConfig.mediumTextSize * 1.3),
//                 ),
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   getSection(String title, String subtitle) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           FittedBox(
//             child: Text(
//               title,
//               style: TextStyle(
//                   color: Colors.white,
//                   shadows: [
//                     Shadow(
//                       offset: Offset(5, 5),
//                       color: Colors.black26,
//                       blurRadius: 10,
//                     )
//                   ],
//                   fontWeight: FontWeight.w700,
//                   fontSize: SizeConfig.cardTitleTextSize),
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             subtitle,
//             style: TextStyle(
//                 color: Colors.white,
//                 fontSize: SizeConfig.mediumTextSize * 1.1,
//                 fontWeight: FontWeight.w500),
//           )
//         ],
//       ),
//     );
//   }
// }
