// //Project Imports
// import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/base_analytics.dart';
// import 'package:felloapp/core/base_remote_config.dart';
// import 'package:felloapp/core/enums/connectivity_status_enum.dart';
// import 'package:felloapp/core/enums/page_state_enum.dart';
// import 'package:felloapp/core/fcm_handler.dart';
// import 'package:felloapp/core/model/daily_pick_model.dart';
// import 'package:felloapp/core/model/tambola_board_model.dart';
// import 'package:felloapp/core/ops/db_ops.dart';
// import 'package:felloapp/core/ops/lcl_db_ops.dart';
// import 'package:felloapp/core/service/tambola_generation_service.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/navigator/router/ui_pages.dart';
// import 'package:felloapp/ui/elements/tambola-global/prize_section.dart';
// import 'package:felloapp/ui/elements/tambola-global/tambola_daily_draw_timer.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
// import 'package:felloapp/ui/elements/tambola-global/weekly_picks.dart';
// import 'package:felloapp/ui/pages/tabs/games/tambola/show_all_tickets.dart';
// import 'package:felloapp/ui/pages/tabs/games/tambola/summary_tickets_display.dart';
// import 'package:felloapp/ui/pages/tabs/games/tambola/weekly_result.dart';
// import 'package:felloapp/ui/elements/network_bar.dart';
// import 'package:felloapp/util/constants.dart';
// import 'package:felloapp/util/logger.dart';
// import 'package:felloapp/util/styles/palette.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/ui_constants.dart';

// //Dart and Flutter Imports
// import 'dart:async';
// import 'dart:math';
import 'package:flutter/material.dart';

// //Pub Imports
// import 'package:flutter_html/shims/dart_ui_real.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class TambolaHome extends StatefulWidget {
//   const TambolaHome({Key key}) : super(key: key);

//   @override
//   _TambolaHomeState createState() => _TambolaHomeState();
// }

// class _TambolaHomeState extends State<TambolaHome> {
//   // HEIGHT CALCULATED ACCORDING TO THE ITEMS PRESENT IN THE CONTAINER
//   double normalTopCardHeight = SizeConfig.screenWidth * 0.76;
//   double expandedTopCardHeight =
//       (SizeConfig.smallTextSize + SizeConfig.screenWidth * 0.1) * 8 +
//           SizeConfig.cardTitleTextSize * 2.4 +
//           kToolbarHeight * 1.5;

//   double topCardHeight;
//   bool isShowingAllPicks = false;
//   double titleOpacity = 1;
//   Log log = new Log('CardScreen');
//   TambolaBoard _currentBoard;
//   Ticket _currentBoardView;
//   bool _winnerDialogCalled = false;
//   bool _isTicketSummaryLoaded = false;
//   List<TicketSummaryCardModel> ticketSummaryData;

//   List<Ticket> _tambolaBoardViews, _topFiveTambolaBoards = [];
//   List<Widget> balls = [];

//   var rnd = new Random();
//   BaseUtil baseProvider;
//   DBModel dbProvider;
//   FcmHandler fcmProvider;
//   LocalDBModel localDBModel;

//   bool ticketsBeingGenerated = false;
//   bool dailyPickHeaderWithTimings = false;
//   int ticketGenerationTryCount = 0;
//   bool showCardSummary = true;
//   //List<String> dailyPickTextList = [];
//   PageController _summaryController = PageController(viewportFraction: 0.94);

//   TambolaGenerationService _tambolaTicketService;

//   void _onTap() {
//     if (!isShowingAllPicks) {
//       topCardHeight = expandedTopCardHeight;
//       titleOpacity = 0;
//       isShowingAllPicks = true;
//     } else {
//       topCardHeight = normalTopCardHeight;
//       isShowingAllPicks = false;
//       Future.delayed(Duration(milliseconds: 500), () {
//         titleOpacity = 1;
//         setState(() {});
//       });
//     }
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     topCardHeight = normalTopCardHeight;
//     // initDailyPickFlags();
//     BaseAnalytics.analytics
//         .setCurrentScreen(screenName: BaseAnalytics.PAGE_TAMBOLA);
//     _tambolaTicketService = new TambolaGenerationService();
//   }

//   _init() async {
//     if (baseProvider == null || dbProvider == null) {
//       return;
//     }

//     ///first get the daily picks of this week
//     //baseProvider.fetchWeeklyPicks();

//     ///next get the tambola tickets of this week
//     if (!baseProvider.weeklyTicksFetched) {
//       List<TambolaBoard> _boards =
//           await dbProvider.getWeeksTambolaTickets(baseProvider.myUser.uid);
//       baseProvider.weeklyTicksFetched = true;
//       if (_boards != null) {
//         baseProvider.userWeeklyBoards = _boards;
//         //refresh current view

//         _currentBoard = null;
//         _currentBoardView = null;
//       }
//       setState(() {});
//     }

//     ///check if new tambola tickets need to be generated
//     if (ticketGenerationTryCount < 3) {
//       ticketGenerationTryCount += 1;
//       bool _isGenerating = await _tambolaTicketService
//           .processTicketGenerationRequirement(_activeTambolaCardCount);
//       if (_isGenerating) {
//         setState(() {
//           ticketsBeingGenerated = true;
//         });
//         _tambolaTicketService.setTambolaTicketGenerationResultListener((flag) {
//           setState(() {
//             ticketsBeingGenerated = false;
//           });
//           if (flag == TambolaGenerationService.GENERATION_COMPLETE) {
//             //new tickets have arrived
//             _refreshTambolaTickets();
//             BaseUtil.showPositiveAlert('Tickets successfully generated 🥳',
//                 'Your weekly odds are now way better!', context);
//           } else if (flag ==
//               TambolaGenerationService.GENERATION_PARTIALLY_COMPLETE) {
//             _refreshTambolaTickets();
//             BaseUtil.showPositiveAlert('Tickets partially generated',
//                 'The remaining tickets shall soon be credited', context);
//           } else {
//             BaseUtil.showNegativeAlert(
//                 'Tickets generation failed',
//                 'The issue has been noted and your tickets will soon be credited',
//                 context);
//           }
//         });
//       }
//     }

//     ///check whether to show summary cards or not
//     DateTime today = DateTime.now();
//     if (today.weekday == 7 && today.hour > 18) {
//       setState(() {
//         showCardSummary = false;
//       });
//     }

//     ///check if tickets need to be deleted
//     bool _isDeleted = await _tambolaTicketService
//         .processTicketDeletionRequirement(_activeTambolaCardCount);
//     if (_isDeleted) {
//       setState(() {});
//     }
//   }

//   _refreshTambolaTickets() async {
//     log.debug('Refreshing..');
//     _topFiveTambolaBoards = [];
//     baseProvider.weeklyTicksFetched = false;
//     setState(() {});
//   }

//   int get _activeTambolaCardCount {
//     if (baseProvider == null || baseProvider.userWeeklyBoards == null) return 0;
//     return baseProvider.userWeeklyBoards.length;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     if (_tambolaTicketService != null)
//       _tambolaTicketService.setTambolaTicketGenerationResultListener(null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     baseProvider = Provider.of<BaseUtil>(context);
//     dbProvider = Provider.of<DBModel>(context, listen: false);
//     fcmProvider = Provider.of<FcmHandler>(context, listen: false);
//     localDBModel = Provider.of<LocalDBModel>(context, listen: false);
//     _init();
//     _checkSundayResultsProcessing();
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: _onTap,
//                 child: AnimatedContainer(
//                   width: SizeConfig.screenWidth,
//                   height: topCardHeight,
//                   duration: Duration(seconds: 1),
//                   curve: Curves.ease,
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage("images/Tambola/tranbg.png"),
//                         fit: BoxFit.cover,
//                       ),
//                       borderRadius:
//                           BorderRadius.circular(SizeConfig.cardBorderRadius),
//                       color: UiConstants.primaryColor),
//                   margin: EdgeInsets.all(SizeConfig.globalMargin),
//                   child: Column(
//                     children: [
//                       Container(),
//                       !isShowingAllPicks
//                           ? GameTitle(titleOpacity: titleOpacity)
//                           : SizedBox(),
//                       isShowingAllPicks
//                           ? Text(
//                               "Weekly Picks",
//                               style: GoogleFonts.montserrat(
//                                 color: Colors.white,
//                                 fontSize: SizeConfig.cardTitleTextSize,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             )
//                           : (baseProvider.todaysPicks != null &&
//                                   baseProvider.todaysPicks.isNotEmpty
//                               ? Text(
//                                   "Today's Picks",
//                                   style: GoogleFonts.montserrat(
//                                     color: Colors.white,
//                                     fontSize: SizeConfig.cardTitleTextSize,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 )
//                               : Text(
//                                   "Today's picks will be drawn at 6 pm.",
//                                   style: GoogleFonts.montserrat(
//                                     color: Colors.white,
//                                     fontSize: SizeConfig.mediumTextSize,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 )),
//                       !isShowingAllPicks
//                           ? const CurrentPicks()
//                           : WeeklyPicks(
//                               weeklyDraws: baseProvider.weeklyDigits,
//                             ),
//                     ],
//                   ),
//                 ),
//               ),
//               // if (showCardSummary)
//               //   _buildTicketSummaryCards(
//               //       baseProvider.weeklyTicksFetched,
//               //       baseProvider.weeklyDrawFetched,
//               //       baseProvider.userWeeklyBoards,
//               //       _activeTambolaCardCount),
//               Container(
//                 margin: EdgeInsets.symmetric(
//                     horizontal: SizeConfig.blockSizeHorizontal * 3,
//                     vertical: SizeConfig.blockSizeHorizontal * 2),
//                 child: Row(
//                   children: [
//                     Text(
//                       "My Tickets ($_activeTambolaCardCount)",
//                       style: GoogleFonts.montserrat(
//                         color: Colors.black87,
//                         fontSize: SizeConfig.cardTitleTextSize,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Spacer(),
//                     InkWell(
//                       onTap: () async {
//                         if (await BaseUtil.showNoInternetAlert()) return;
//                         _tambolaBoardViews = [];
//                         baseProvider.userWeeklyBoards.forEach((board) {
//                           _tambolaBoardViews.add(_buildBoardView(board));
//                         });
//                         if (_tambolaBoardViews.isNotEmpty)
//                           AppState.delegate.appState.currentAction = PageAction(
//                             state: PageState.addWidget,
//                             page: TShowAllTicketsPageConfig,
//                             widget: ShowAllTickets(
//                               tambolaBoardView: _tambolaBoardViews,
//                             ),
//                           );
//                         else
//                           BaseUtil.showNegativeAlert(
//                               "No Tickets to show",
//                               "Currently there are no tickets available",
//                               context);
//                       },
//                       highlightColor: UiConstants.primaryColor.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(100),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: UiConstants.primaryColor,
//                           ),
//                           borderRadius: BorderRadius.circular(100),
//                         ),
//                         child: Text(
//                           "Show All",
//                           style: GoogleFonts.montserrat(
//                             color: UiConstants.primaryColor,
//                             fontSize: SizeConfig.mediumTextSize,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               _buildCards(
//                   baseProvider.weeklyTicksFetched,
//                   baseProvider.weeklyDrawFetched,
//                   baseProvider.userWeeklyBoards,
//                   _activeTambolaCardCount),
//               PrizeSection(),
//               //FaqSection()
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// Widget _buildCards(bool fetchedFlag, bool drawFetchedFlag,
//     List<TambolaBoard> boards, int count) {
//   ConnectivityStatus connectivityStatus =
//       Provider.of<ConnectivityStatus>(context);
//   Widget _widget;
//   if (connectivityStatus == ConnectivityStatus.Offline)
//     _widget = Container(
//       height: SizeConfig.screenHeight * 0.2,
//       child: NetworkBar(
//         textColor: Colors.black87,
//       ),
//     );
//   else if (!fetchedFlag || !drawFetchedFlag) {
//     _widget = Padding(
//       //Loader
//       padding: EdgeInsets.all(10),
//       child: Container(
//         width: double.infinity,
//         height: 200,
//         child: Center(
//           child: SpinKitWave(
//             color: UiConstants.primaryColor,
//           ),
//         ),
//       ),
//     );
//   } else if (boards == null || count == 0) {
//     _widget = Padding(
//       padding: EdgeInsets.all(10),
//       child: Container(
//         width: double.infinity,
//         height: SizeConfig.screenWidth * 0.9,
//         child: Center(
//           child: (ticketsBeingGenerated)
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: connectivityStatus == ConnectivityStatus.Offline
//                       ? [
//                           Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: NetworkBar(),
//                           )
//                         ]
//                       : [
//                           Container(
//                             width: SizeConfig.screenWidth * 0.8,
//                             height: 4,
//                             decoration: BoxDecoration(
//                               color:
//                                   UiConstants.primaryColor.withOpacity(0.3),
//                               borderRadius: BorderRadius.circular(100),
//                             ),
//                             child: FractionallySizedBox(
//                               heightFactor: 1,
//                               widthFactor: BaseUtil.ticketGenerateCount ==
//                                       baseProvider
//                                           .atomicTicketGenerationLeftCount
//                                   ? 0.1
//                                   : (BaseUtil.ticketGenerateCount -
//                                           baseProvider
//                                               .atomicTicketGenerationLeftCount) /
//                                       BaseUtil.ticketGenerateCount,
//                               alignment: Alignment.centerLeft,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: UiConstants.primaryColor,
//                                   borderRadius: BorderRadius.circular(100),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             'Generated ${BaseUtil.ticketGenerateCount - baseProvider.atomicTicketGenerationLeftCount} of your ${BaseUtil.ticketGenerateCount} tickets',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: SizeConfig.mediumTextSize,
//                             ),
//                           ),
//                         ],
//                 )
//               : Text('No tickets yet'),
//         ),
//       ),
//     );
//   } else {
//     if (_topFiveTambolaBoards.isEmpty) {
//       _refreshBestBoards().forEach((element) {
//         _topFiveTambolaBoards.add(_buildBoardView(element));
//       });
//     }

//     _widget = Container(
//       height: SizeConfig.screenWidth * 0.95,
//       child: Stack(
//         children: [
//           Container(
//             height: SizeConfig.screenWidth * 0.95,
//             width: SizeConfig.screenWidth,
//             child: ListView(
//               physics: BouncingScrollPhysics(),
//               scrollDirection: Axis.horizontal,
//               children: List.generate(_topFiveTambolaBoards.length,
//                   (index) => _topFiveTambolaBoards[index]),
//             ),
//           ),
//           if (ticketsBeingGenerated)
//             Align(
//               alignment: Alignment.center,
//               child: Container(
//                 width: SizeConfig.screenWidth,
//                 height: 140,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.7),
//                 ),
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: SizeConfig.screenWidth * 0.8,
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: UiConstants.primaryColor.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       child: FractionallySizedBox(
//                         heightFactor: 1,
//                         widthFactor: BaseUtil.ticketGenerateCount ==
//                                 baseProvider.atomicTicketGenerationLeftCount
//                             ? 0.1
//                             : (BaseUtil.ticketGenerateCount -
//                                     baseProvider
//                                         .atomicTicketGenerationLeftCount) /
//                                 BaseUtil.ticketGenerateCount,
//                         alignment: Alignment.centerLeft,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: UiConstants.primaryColor,
//                             borderRadius: BorderRadius.circular(100),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'Generated ${BaseUtil.ticketGenerateCount - baseProvider.atomicTicketGenerationLeftCount} of your ${BaseUtil.ticketGenerateCount} tickets',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: SizeConfig.mediumTextSize,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );

//     if (_currentBoardView == null)
//       _currentBoardView = Ticket(
//         bgColor: FelloColorPalette.tambolaTicketColorPalettes()[0].boardColor,
//         boardColorEven:
//             FelloColorPalette.tambolaTicketColorPalettes()[0].itemColorEven,
//         boardColorOdd:
//             FelloColorPalette.tambolaTicketColorPalettes()[0].itemColorOdd,
//         boradColorMarked:
//             FelloColorPalette.tambolaTicketColorPalettes()[0].itemColorMarked,
//         calledDigits: [],
//         board: null,
//       );
//     if (_currentBoard == null)
//       _currentBoard = baseProvider.userWeeklyBoards[0];
//   }
//   return _widget;
// }

// Ticket _buildBoardView(TambolaBoard board) {
//   if (board == null || !board.isValid()) return null;
//   List<int> _calledDigits;
//   if (!baseProvider.weeklyDrawFetched ||
//       baseProvider.weeklyDigits == null ||
//       baseProvider.weeklyDigits.toList().isEmpty)
//     _calledDigits = [];
//   else {
//     _calledDigits =
//         baseProvider.weeklyDigits.getPicksPostDate(board.generatedDayCode);
//   }
//   TambolaTicketColorPalette ticketColor =
//       FelloColorPalette.tambolaTicketColorPalettes()[Random().nextInt(
//               FelloColorPalette.tambolaTicketColorPalettes().length - 1) +
//           1];
//   return Ticket(
//     board: board,
//     calledDigits: _calledDigits,
//     bgColor: ticketColor.boardColor,
//     boardColorEven: ticketColor.itemColorEven,
//     boardColorOdd: ticketColor.itemColorOdd,
//     boradColorMarked: ticketColor.itemColorMarked,
//   );
// }

//   _buildTicketSummaryCards(bool fetchedFlag, bool drawFetchedFlag,
//       List<TambolaBoard> boards, int count) {
//     Widget _widget;
//     if (!fetchedFlag || !drawFetchedFlag) {
//       _widget = SizedBox();
//     } else if (boards == null || count == 0) {
//       _widget = SizedBox();
//     } else {
//       if (!_isTicketSummaryLoaded)
//         ticketSummaryData = _getTambolaTicketsSummary();

//       _widget = ticketSummaryData.isEmpty
//           ? SizedBox()
//           : Container(
//               height: SizeConfig.screenWidth * 0.36,
//               width: SizeConfig.screenWidth,
//               margin: EdgeInsets.symmetric(
//                   vertical: SizeConfig.blockSizeHorizontal * 2),
//               child: PageView(
//                 controller: _summaryController,
//                 physics: BouncingScrollPhysics(),
//                 scrollDirection: Axis.horizontal,
//                 children: List.generate(
//                   ticketSummaryData.length,
//                   (index) => Container(
//                     width: SizeConfig.screenWidth,
//                     alignment: Alignment.center,
//                     child: Container(
//                       margin: ticketSummaryData.length == 1
//                           ? EdgeInsets.all(0)
//                           : EdgeInsets.only(
//                               right: SizeConfig.blockSizeHorizontal * 3),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: ticketSummaryData[index].color,
//                         image: DecorationImage(
//                           image: NetworkImage(ticketSummaryData[index].bgAsset),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color:
//                               ticketSummaryData[index].color.withOpacity(0.4),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.all(
//                             SizeConfig.globalMargin,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 ticketSummaryData[index].data[0].title,
//                                 style: TextStyle(
//                                   fontSize: SizeConfig.mediumTextSize * 1.2,
//                                   color: Colors.white,
//                                   height: 1.6,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   AppState.delegate.appState.currentAction =
//                                       PageAction(
//                                     state: PageState.addWidget,
//                                     page: TSummaryDetailsPageConfig,
//                                     widget: SummaryTicketsDisplay(
//                                       summary: ticketSummaryData[index],
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   width: SizeConfig.screenWidth * 0.3,
//                                   alignment: Alignment.center,
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 10),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: Colors.white,
//                                     ),
//                                     borderRadius: BorderRadius.circular(100),
//                                   ),
//                                   child: Text(
//                                     ticketSummaryData[index].data.length == 1
//                                         ? "Show ticket(s)"
//                                         : "Show All",
//                                     style: TextStyle(
//                                       fontSize: SizeConfig.mediumTextSize,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//     }
//     //_isTicketSummaryLoaded = true;
//     return _widget;
//   }

//   // _checkSundayResultsProcessing() {
//   //   if (baseProvider.userWeeklyBoards == null ||
//   //       baseProvider.userWeeklyBoards.isEmpty ||
//   //       baseProvider.weeklyDigits == null ||
//   //       baseProvider.weeklyDigits.toList().isEmpty ||
//   //       localDBModel == null) {
//   //     log.debug('Testing is not ready yet');
//   //     return false;
//   //   }
//   //   DateTime date = DateTime.now();
//   //   if (date.weekday == DateTime.sunday) {
//   //     if (baseProvider.weeklyDigits.toList().length ==
//   //         7 * baseProvider.dailyPicksCount) {
//   //       localDBModel.isTambolaResultProcessingDone().then((flag) {
//   //         if (flag == 0) {
//   //           log.debug('Ticket results not yet displayed. Displaying: ');
//   //           _examineTicketsForWins();

//   //           ///save the status that results have been saved
//   //           localDBModel.saveTambolaResultProcessingStatus(true);
//   //         }

//   //         ///also delete all the old tickets while we're at it
//   //         //no need to await
//   //         dbProvider.deleteExpiredUserTickets(baseProvider.myUser.uid);
//   //       });
//   //     }
//   //   } else {
//   //     localDBModel.isTambolaResultProcessingDone().then((flag) {
//   //       if (flag == 1) localDBModel.saveTambolaResultProcessingStatus(false);
//   //     });
//   //   }
//   // }

//   // ///check if any of the tickets aced any of the categories.
//   // ///also check if the user is eligible for a prize
//   // ///if any did, add it to a list and submit the list as a win claim
//   // _examineTicketsForWins() {
//   //   if (baseProvider.userWeeklyBoards == null ||
//   //       baseProvider.userWeeklyBoards.isEmpty ||
//   //       baseProvider.weeklyDigits == null ||
//   //       baseProvider.weeklyDigits.toList().isEmpty) {
//   //     log.debug('Testing is not ready yet');
//   //     return false;
//   //   }
//   //   Map<String, int> ticketCodeWinIndex = {};
//   //   baseProvider.userWeeklyBoards.forEach((boardObj) {
//   //     if (boardObj.getCornerOdds(baseProvider.weeklyDigits
//   //             .getPicksPostDate(boardObj.generatedDayCode)) ==
//   //         0) {
//   //       if (boardObj.getTicketNumber() != 'NA')
//   //         ticketCodeWinIndex[boardObj.getTicketNumber()] =
//   //             Constants.CORNERS_COMPLETED;
//   //     }
//   //     if (boardObj.getRowOdds(
//   //             0,
//   //             baseProvider.weeklyDigits
//   //                 .getPicksPostDate(boardObj.generatedDayCode)) ==
//   //         0) {
//   //       if (boardObj.getTicketNumber() != 'NA')
//   //         ticketCodeWinIndex[boardObj.getTicketNumber()] =
//   //             Constants.ROW_ONE_COMPLETED;
//   //     }
//   //     if (boardObj.getRowOdds(
//   //             1,
//   //             baseProvider.weeklyDigits
//   //                 .getPicksPostDate(boardObj.generatedDayCode)) ==
//   //         0) {
//   //       if (boardObj.getTicketNumber() != 'NA')
//   //         ticketCodeWinIndex[boardObj.getTicketNumber()] =
//   //             Constants.ROW_TWO_COMPLETED;
//   //     }
//   //     if (boardObj.getRowOdds(
//   //             2,
//   //             baseProvider.weeklyDigits
//   //                 .getPicksPostDate(boardObj.generatedDayCode)) ==
//   //         0) {
//   //       if (boardObj.getTicketNumber() != 'NA')
//   //         ticketCodeWinIndex[boardObj.getTicketNumber()] =
//   //             Constants.ROW_THREE_COMPLETED;
//   //     }
//   //     if (boardObj.getFullHouseOdds(baseProvider.weeklyDigits
//   //             .getPicksPostDate(boardObj.generatedDayCode)) ==
//   //         0) {
//   //       if (boardObj.getTicketNumber() != 'NA')
//   //         ticketCodeWinIndex[boardObj.getTicketNumber()] =
//   //             Constants.FULL_HOUSE_COMPLETED;
//   //     }
//   //   });

//   //   double totalInvestedPrinciple =
//   //       baseProvider.userFundWallet.augGoldPrinciple +
//   //           baseProvider.userFundWallet.iciciPrinciple;
//   //   bool _isEligible =
//   //       (totalInvestedPrinciple >= BaseRemoteConfig.UNLOCK_REFERRAL_AMT);

//   //   log.debug('Resultant wins: ${ticketCodeWinIndex.toString()}');

//   //   if (!_winnerDialogCalled)
//   //     AppState.delegate.appState.currentAction = PageAction(
//   //       state: PageState.addWidget,
//   //       page: TWeeklyResultPageConfig,
//   //       widget: WeeklyResult(
//   //         winningsmap: ticketCodeWinIndex,
//   //         isEligible: _isEligible,
//   //       ),
//   //     );
//   //   _winnerDialogCalled = true;

//   //   if (ticketCodeWinIndex.length > 0) {
//   //     dbProvider
//   //         .addWinClaim(
//   //             baseProvider.myUser.uid,
//   //             baseProvider.myUser.name,
//   //             baseProvider.myUser.mobile,
//   //             baseProvider.userTicketWallet.getActiveTickets(),
//   //             _isEligible,
//   //             ticketCodeWinIndex)
//   //         .then((flag) {
//   //       BaseUtil.showPositiveAlert(
//   //           'Congratulations 🎉',
//   //           'Your tickets have been submitted for processing your prizes!',
//   //           context);
//   //     });
//   //   }
//   // }

//   // List<int> _getDailyPickData(DailyPick draws, int day) {
//   //   List<int> picks = [];
//   //   if (draws != null && draws.getWeekdayDraws(day - 1) != null) {
//   //     draws.getWeekdayDraws(day - 1).forEach((element) {
//   //       picks.add(element);
//   //     });
//   //   } else {
//   //     for (int i = 0; i < baseProvider.dailyPicksCount; i++) {
//   //       picks.add(-1);
//   //     }
//   //   }
//   //   return picks;
//   // }
// }

class TicketSummaryCardModel {
  final List<BestTambolaTicketsSumm> data;
  final String cardType;
  final String bgAsset;
  final Color color;

  TicketSummaryCardModel({this.bgAsset, this.data, this.cardType, this.color});
}

class BestTambolaTicketsSumm {
  final List<Ticket> boards;
  final String title;

  BestTambolaTicketsSumm({@required this.boards, @required this.title});
}
