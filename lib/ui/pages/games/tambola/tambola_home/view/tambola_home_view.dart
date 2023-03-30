import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view_model/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/games/tambola/weekly_results/weekly_result.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

// class TambolaHomeView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     S locale = S.of(context);
//     ConnectivityStatus connectivityStatus =
//         Provider.of<ConnectivityService>(context, listen: true)
//             .connectivityStatus;
//
//     return BaseView<TambolaHomeViewModel>(
//       onModelReady: (model) {
//         model.init();
//         model.scrollController =  ScrollController();
//         model.scrollController.addListener(() {
//           model.udpateCardOpacity();
//         });
//       },
//       builder: (ctx, model, child) {
//         return Scaffold(
//           key: const ValueKey(Constants.TAMBOLA_HOME_SCREEN),
//           appBar: FAppBar(
//             type: FaqsType.play,
//             showAvatar: false,
//             showCoinBar: false,
//             showHelpButton: false,
//             title: locale.tTitle,
//             backgroundColor: UiConstants.kArrowButtonBackgroundColor,
//           ),
//           backgroundColor: UiConstants.kBackgroundColor,
//           body: Stack(
//             children: [
//               const NewSquareBackground(),
//               SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     //Today and Weekly Picks
//                     TodayWeeklyPicksCard(model: model),
//                     //Win Announcement card
//                     if (model.showWinCard) TambolaResultCard(model: model),
//                     SizedBox(height: SizeConfig.screenWidth! * 0.075),
//                     //Your best tickets
//                     connectivityStatus != ConnectivityStatus.Offline
//                         ? model.userWeeklyBoards != null
//                             ? TicketsView(model: model)
//                             : Container(
//                                 width: SizeConfig.screenWidth,
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: SizeConfig.pageHorizontalMargins),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     const FullScreenLoader(),
//                                     SizedBox(height: SizeConfig.padding20),
//                                     Text(
//                                       locale.tFetch,
//                                       style: TextStyles.sourceSans.body2
//                                           .colour(Colors.white),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                         : const SizedBox.shrink(),
//                     (Platform.isIOS)
//                         ? Text(
//                             locale.tAppleInfo,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w100,
//                                 fontSize: SizeConfig.mediumTextSize,
//                                 color: Colors.white),
//                           )
//                         : Container(),
//                     //How to play
//                     InfoComponent2(
//                         heading: model.boxHeading,
//                         assetList: model.boxAssets,
//                         titleList: model.boxTitlles,
//                         height: SizeConfig.screenWidth! * 0.35),
//
//                     //Tambola Prizes
//                     TambolaPrize(
//                       model: model,
//                     ),
//                     //LeaderBoard
//                     TambolaLeaderBoard(
//                       model: model,
//                     ),
//                     SizedBox(
//                       height: SizeConfig.screenWidth! * 0.35,
//                     )
//                   ],
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: ButTicketsComponent(
//                   model: model,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }




// class TicketsView extends StatelessWidget {
//   final TambolaHomeViewModel? model;
//
//   const TicketsView({super.key, this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     S locale = S.of(context);
//     if (!model!.weeklyTicksFetched || !model!.weeklyDrawFetched) {
//       return const SizedBox();
//     } else if (model!.userWeeklyBoards == null ||
//         model!.activeTambolaCardCount == 0) {
//       return Padding(
//         padding: const EdgeInsets.all(10),
//         child: SizedBox(
//           width: SizeConfig.screenWidth,
//           child: Center(
//               child: (model!.ticketsBeingGenerated)
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: SizeConfig.screenWidth! * 0.8,
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: UiConstants.primaryColor.withOpacity(0.3),
//                             borderRadius: BorderRadius.circular(100),
//                           ),
//                           child: FractionallySizedBox(
//                             heightFactor: 1,
//                             widthFactor: model!
//                                         .tambolaService!.ticketGenerateCount ==
//                                     model!.tambolaService!
//                                         .atomicTicketGenerationLeftCount
//                                 ? 0.1
//                                 : (model!.tambolaService!.ticketGenerateCount! -
//                                         model!.tambolaService!
//                                             .atomicTicketGenerationLeftCount) /
//                                     model!.tambolaService!.ticketGenerateCount!,
//                             alignment: Alignment.centerLeft,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: UiConstants.primaryColor,
//                                 borderRadius: BorderRadius.circular(100),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           "${locale.tgenerated} ${model!.tambolaService!.ticketGenerateCount! - model!.tambolaService!.atomicTicketGenerationLeftCount} ${locale.tgeneratedCount(model!.tambolaService!.ticketGenerateCount.toString())}",
//                           style: TextStyles.rajdhani.body2.colour(Colors.white),
//                         ),
//                       ],
//                     )
//                   : const SizedBox()),
//         ),
//       );
//     } else if (model!.activeTambolaCardCount == 1) {
//       //One tambola ticket
//       model!.tambolaBoardViews = [];
//       model!.tambolaBoardViews!.add(TambolaTicket(
//         bestBoards: model!.refreshBestBoards(),
//         dailyPicks: model!.weeklyDigits,
//         board: model!.userWeeklyBoards![0],
//         calledDigits: (model!.weeklyDrawFetched && model!.weeklyDigits != null)
//             ? model!.weeklyDigits!.toList()
//             : [],
//       ));
//
//       return SizedBox(
//         width: SizeConfig.screenWidth,
//         child: TabViewGenerator(
//           model: model,
//           showIndicatorForAll: false,
//         ),
//       );
//     } else {
//       //Multiple tickets
//       if (!model!.ticketsLoaded) {
//         model!.ticketsLoaded = true;
//         model!.tambolaBoardViews = [];
//
//         model!.userWeeklyBoards!.forEach((board) {
//           model!.tambolaBoardViews!.add(
//             TambolaTicket(
//               bestBoards: model!.refreshBestBoards(),
//               dailyPicks: model!.weeklyDigits,
//               board: board,
//               calledDigits:
//                   (model!.weeklyDrawFetched && model!.weeklyDigits != null)
//                       ? model!.weeklyDigits!.toList()
//                       : [],
//             ),
//           );
//         });
//       }
//
//       return Column(
//         children: [
//           // Padding(
//           //   padding: EdgeInsets.symmetric(
//           //       horizontal:
//           //           SizeConfig.pageHorizontalMargins + SizeConfig.padding2),
//           //   child: Row(
//           //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //     crossAxisAlignment: CrossAxisAlignment.center,
//           //     children: [
//           //       // Text(
//           //       //   "Your Best tickets",
//           //       //   style: TextStyles.rajdhaniSB.body0,
//           //       // ),
//           //       // TextButton(
//           //       //     onPressed: () {
//           //       //       AppState.delegate.appState.currentAction = PageAction(
//           //       //         state: PageState.addWidget,
//           //       //         page: AllTambolaTicketsPageConfig,
//           //       //         widget: AllTambolaTickets(
//           //       //             ticketList: model.tambolaBoardViews.toList()),
//           //       //       );
//           //       //     },
//           //       //     child: Row(
//           //       //       mainAxisAlignment: MainAxisAlignment.center,
//           //       //       children: [
//           //       //         Padding(
//           //       //           padding: EdgeInsets.only(
//           //       //             top: SizeConfig.padding2,
//           //       //           ),
//           //       //           child: Text(
//           //       //               'View All (${model.userWeeklyBoards.length})',
//           //       //               style: TextStyles.rajdhaniSB.body2),
//           //       //         ),
//           //       //         SvgPicture.asset(Assets.chevRonRightArrow,
//           //       //             height: SizeConfig.padding24,
//           //       //             width: SizeConfig.padding24,
//           //       //             color: UiConstants.primaryColor)
//           //       //       ],
//           //       //     )
//           //       //     // child: Text(
//           //       //     //   "View All (${model.userWeeklyBoards.length})",
//           //       //     //   style: TextStyles.sourceSansSB.body2
//           //       //     //       .colour(UiConstants.kTabBorderColor),
//           //       //     // ),
//           //       //     )
//           //     ],
//           //   ),
//           // ),
//           // SizedBox(
//           //   height: SizeConfig.padding12,
//           // ),
//           SizedBox(
//             width: SizeConfig.screenWidth,
//             child: TabViewGenerator(
//               model: model,
//               showIndicatorForAll: true,
//             ),
//           ),
//         ],
//       );
//     }
//   }
// }



class TambolaResultCard extends StatelessWidget {
  final TambolaHomeViewModel? model;

  const TambolaResultCard({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return GestureDetector(
      onTap: () => AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: TWeeklyResultPageConfig,
        widget: WeeklyResult(
          winningsmap: model!.ticketCodeWinIndex,
          isEligible: model!.isEligible,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(
            top: SizeConfig.pageHorizontalMargins,
            right: SizeConfig.pageHorizontalMargins,
            left: SizeConfig.pageHorizontalMargins),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
            color: UiConstants.kSnackBarPositiveContentColor),
        padding: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
        child: ListTile(
          leading: SvgPicture.asset(
            Assets.tambolaCardAsset,
            width: SizeConfig.screenWidth! * 0.15,
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              locale.tResultsOut,
              style: TextStyles.rajdhaniB.title3,
            ),
          ),
          subtitle: Text(
            locale.tCheckIfWon,
            style: TextStyles.sourceSans.body2,
          ),
          trailing:
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

/// Old code
// class TabViewGenerator extends StatefulWidget {
//   const TabViewGenerator({
//     Key? key,
//     required this.model,
//     required this.showIndicatorForAll,
//   }) : super(key: key);
//
//   final TambolaHomeViewModel? model;
//   final bool showIndicatorForAll;
//
//   @override
//   State<TabViewGenerator> createState() => _TabViewGeneratorState();
// }
//  Old code
// class _TabViewGeneratorState extends State<TabViewGenerator>
//     with TickerProviderStateMixin {
//   TabController? _tabController;
//   List<TambolaBoard?>? _bestBoards;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController =
//         TabController(vsync: this, length: widget.model!.tabList.length);
//     _tabController!.addListener(_handleTabSelection);
//     _bestBoards = widget.model!.refreshBestBoards();
//   }
//
//   void _handleTabSelection() {
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//         length: widget.model!.tabList.length,
//         child: Column(
//           children: [
//             TabBar(
//               controller: _tabController,
//               labelPadding: EdgeInsets.zero,
//               indicatorColor: Colors.transparent,
//               physics: const BouncingScrollPhysics(),
//               isScrollable: true,
//               tabs: List.generate(
//                 widget.model!.tabList.length,
//                 (index) => Container(
//                   margin: EdgeInsets.only(
//                     right: index == widget.model!.tabList.length - 1
//                         ? SizeConfig.pageHorizontalMargins
//                         : SizeConfig.padding10,
//                     left: index == 0 ? SizeConfig.pageHorizontalMargins : 0.0,
//                   ),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: SizeConfig.padding10,
//                     vertical: SizeConfig.padding16,
//                   ),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(SizeConfig.padding16),
//                       color: UiConstants.gameCardColor,
//                       border: Border.all(
//                           color: _tabController!.index == index
//                               ? Colors.white
//                               : Colors.transparent,
//                           width: _tabController!.index == index ? 0.5 : 0.0)),
//                   child: Text(
//                     widget.model!.tabList[index],
//                     textAlign: TextAlign.center,
//                     style: TextStyles.body4.colour(
//                       Colors.white.withOpacity(
//                           _tabController!.index == index ? 1 : 0.5),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: SizeConfig.padding16,
//             ),
//             SizedBox(
//               height: SizeConfig.screenWidth! * 0.56,
//               child: TabBarView(
//                 controller: _tabController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   //All tickets
//                   PageViewWithIndicator(
//                     model: widget.model,
//                     showIndicator: widget.showIndicatorForAll,
//                   ),
//                   //Corner
//                   widget.model!.userWeeklyBoards != null &&
//                           widget.model!.userWeeklyBoards!.length >= 1
//                       ? Column(
//                           children: [
//                             Ticket(
//                                 dailyPicks: widget.model!.weeklyDigits,
//                                 bestBoards: _bestBoards,
//                                 board: _bestBoards![0],
//                                 showBestOdds: false,
//                                 calledDigits:
//                                     widget.model!.weeklyDigits!.toList()),
//                           ],
//                         )
//                       : const NoTicketWidget(),
//                   //Top row
//                   widget.model!.userWeeklyBoards != null &&
//                           widget.model!.userWeeklyBoards!.length >= 1
//                       ? Column(
//                           children: [
//                             Ticket(
//                                 dailyPicks: widget.model!.weeklyDigits,
//                                 bestBoards: _bestBoards,
//                                 board: _bestBoards![1],
//                                 showBestOdds: false,
//                                 calledDigits:
//                                     widget.model!.weeklyDigits!.toList()),
//                           ],
//                         )
//                       : const NoTicketWidget(),
//                   widget.model!.userWeeklyBoards != null &&
//                           widget.model!.userWeeklyBoards!.length >= 1
//                       ? Column(
//                           children: [
//                             Ticket(
//                                 dailyPicks: widget.model!.weeklyDigits,
//                                 bestBoards: _bestBoards,
//                                 board: _bestBoards![2],
//                                 showBestOdds: false,
//                                 calledDigits:
//                                     widget.model!.weeklyDigits!.toList()),
//                           ],
//                         )
//                       : const NoTicketWidget(),
//                   widget.model!.userWeeklyBoards != null &&
//                           widget.model!.userWeeklyBoards!.length >= 1
//                       ? Column(
//                           children: [
//                             Ticket(
//                                 dailyPicks: widget.model!.weeklyDigits,
//                                 bestBoards: _bestBoards,
//                                 board: _bestBoards![3],
//                                 showBestOdds: false,
//                                 calledDigits:
//                                     widget.model!.weeklyDigits!.toList()),
//                           ],
//                         )
//                       : const NoTicketWidget(),
//                 ],
//               ),
//             )
//           ],
//         ));
//   }
// }

// class Odds extends StatelessWidget {
//   final DailyPick _digitsObj;
//   final TambolaBoard _board;
//   final List<TambolaBoard> _bestBoards;
//   final bool showBestBoard;
//   final int currentIndex;
//
//   const Odds(this._digitsObj, this._board, this._bestBoards, this.showBestBoard,
//       this.currentIndex, {super.key});
//
//   @override
//   Widget build(BuildContext cx) {
//     S locale = S.of(cx);
//     if (_board == null) return Container();
//     List<int> _digits = (_digitsObj != null) ? _digitsObj.toList() : [];
//     switch (currentIndex) {
//       case 0:
//         return _buildRow(
//             cx,
//             Icons.border_top,
//             locale.tTopRow,
//             _board.getRowOdds(0, _digits).toString() + locale.tLeft,
//             _bestBoards[0].getRowOdds(0, _digits).toString() + locale.tLeft,
//             _bestBoards[0],
//             _digits);
//       case 1:
//         return _buildRow(
//             cx,
//             Icons.border_horizontal,
//             locale.tMiddleRow,
//             _board.getRowOdds(1, _digits).toString() + locale.tLeft,
//             _bestBoards[1].getRowOdds(1, _digits).toString() + locale.tLeft,
//             _bestBoards[1],
//             _digits);
//       case 2:
//         return _buildRow(
//             cx,
//             Icons.border_bottom,
//             locale.tBottomRow,
//             _board.getRowOdds(2, _digits).toString() + locale.tLeft,
//             _bestBoards[2].getRowOdds(2, _digits).toString() + locale.tLeft,
//             _bestBoards[2],
//             _digits);
//       case 3:
//         return _buildRow(
//             cx,
//             Icons.border_outer,
//             locale.tCorners,
//             _board.getCornerOdds(_digits).toString() + locale.tLeft,
//             _bestBoards[3].getCornerOdds(_digits).toString() + locale.tLeft,
//             _bestBoards[3],
//             _digits);
//       case 4:
//         return _buildRow(
//             cx,
//             Icons.apps,
//             locale.tFullHouse,
//             _board.getFullHouseOdds(_digits).toString() + locale.tLeft,
//             _bestBoards[4].getFullHouseOdds(_digits).toString() + locale.tLeft,
//             _bestBoards[4],
//             _digits);
//
//       default:
//         return _buildRow(
//             cx,
//             Icons.border_top,
//             locale.tTopRow,
//             _board.getRowOdds(0, _digits).toString() + locale.tLeft,
//             _bestBoards[0].getRowOdds(0, _digits).toString() + locale.tLeft,
//             _bestBoards[0],
//             _digits);
//     }
//   }
//
//   Widget _buildBestTicket(
//       BuildContext cx, TambolaBoard _bestBoard, List<int> _digits) {
//     return Column(
//       children: [
//         Ticket(
//             dailyPicks: _digitsObj,
//             bestBoards: _bestBoards,
//             board: _bestBoard,
//             showBestOdds: false,
//             calledDigits: _digits),
//       ],
//     );
//   }
//
//   Widget _buildRow(BuildContext cx, IconData _i, String _title, String _tOdd,
//       String _oOdd, TambolaBoard _bestBoard, List<int> _digits) {
//     return Column(
//       children: [
//         Ticket(
//             dailyPicks: _digitsObj,
//             bestBoards: _bestBoards,
//             board: _bestBoard,
//             showBestOdds: false,
//             calledDigits: _digits),
//         // SizedBox(
//         //   height: SizeConfig.padding8,
//         // ),
//         // SizedBox(
//         //   height: SizeConfig.padding6,
//         // ),
//       ],
//     );
//   }
// }

// class ButTicketsComponent extends StatelessWidget {
//   ButTicketsComponent({
//     Key? key,
//     required this.model,
//   }) : super(key: key);
//
//   final TambolaHomeViewModel model;
//   final AnalyticsService _analyticsService = locator<AnalyticsService>();
//
//   @override
//   Widget build(BuildContext context) {
//     S locale = S.of(context);
//     return Container(
//       width: SizeConfig.screenWidth,
//       margin: const EdgeInsets.symmetric(horizontal: 18),
//       padding: EdgeInsets.symmetric(
//           horizontal: SizeConfig.pageHorizontalMargins,
//           vertical: SizeConfig.pageHorizontalMargins),
//       decoration: BoxDecoration(
//         color: const Color(0xff30363C),
//         borderRadius: BorderRadius.all(
//           Radius.circular(SizeConfig.roundness16),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       locale.tGetMore,
//                       textAlign: TextAlign.left,
//                       style: TextStyles.rajdhaniSB.body1,
//                     ),
//                     Text(
//                       locale.get1Ticket(
//                           AppConfig.getValue(AppConfigKey.tambola_cost)
//                                   .toString()
//                                   .isEmpty
//                               ? '500'
//                               : AppConfig.getValue(AppConfigKey.tambola_cost)),
//                       style: TextStyles.sourceSans.body4
//                           .colour(UiConstants.kTextColor2),
//                     ),
//                   ]),
//               GestureDetector(
//                 onTap: () {
//                   // AppState.screenStack.add(ScreenItem.dialog);
//                   // _analyticsService.track(
//                   //     eventName: AnalyticsEvents.tambolaHelpTapped,
//                   //     properties: AnalyticsProperties.getDefaultPropertiesMap(
//                   //         extraValuesMap: {
//                   //           "Time left for draw Tambola (mins)":
//                   //               AnalyticsProperties.getTimeLeftForTambolaDraw(),
//                   //           "Tambola Tickets Owned":
//                   //               AnalyticsProperties.getTabolaTicketCount(),
//                   //         }));
//                   // Navigator.of(AppState.delegate.navigatorKey.currentContext)
//                   //     .push(
//                   //   PageRouteBuilder(
//                   //     pageBuilder: (context, animation, anotherAnimation) {
//                   //       return InfoStories(
//                   //         topic: 'tambola',
//                   //       );
//                   //     },
//                   //     transitionDuration: Duration(milliseconds: 500),
//                   //     transitionsBuilder:
//                   //         (context, animation, anotherAnimation, child) {
//                   //       animation = CurvedAnimation(
//                   //           curve: Curves.easeInCubic, parent: animation);
//                   //       return Align(
//                   //         child: SizeTransition(
//                   //           sizeFactor: animation,
//                   //           child: child,
//                   //           axisAlignment: 0.0,
//                   //         ),
//                   //       );
//                   //     },
//                   //   ),
//                   // );
//                   AppState.delegate!.appState.currentAction = PageAction(
//                     state: PageState.addWidget,
//                     page: TambolaNewUser,
//                     widget: TambolaNewUserPage(
//                       model: model,
//                       showPrizeSection: true,
//                     ),
//                   );
//                 },
//                 child: Text(
//                   locale.viewPrizes,
//                   style: TextStyles.rajdhaniSB.body3.copyWith(
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               )
//             ],
//           ),
//           SizedBox(
//             height: SizeConfig.padding16,
//           ),
//           Row(
//             children: [
//               Container(
//                 width: SizeConfig.screenWidth! * 0.25,
//                 decoration: BoxDecoration(
//                   color: const Color(0xff000000).withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(SizeConfig.roundness8),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     GestureDetector(
//                       onTap: model.decreaseTicketCount,
//                       child: Icon(
//                         Icons.remove,
//                         color: Colors.white,
//                         size: SizeConfig.padding16,
//                       ),
//
//                       // iconSize: SizeConfig.padding16,
//                       // color: Colors.white,
//                       // onPressed: model.decreaseTicketCount,
//                     ),
//                     SizedBox(
//                       width: SizeConfig.screenHeight! * 0.03,
//                       height: SizeConfig.padding35,
//                       child: Center(
//                         child: TextField(
//                           style: TextStyles.sourceSans.body2.setHeight(2),
//                           textAlign: TextAlign.center,
//                           controller: model.ticketCountController,
//                           enableInteractiveSelection: false,
//                           enabled: false,
//                           keyboardType: const TextInputType.numberWithOptions(
//                               signed: true),
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                           ],
//                           onChanged: (String text) {
//                             model.updateTicketCount();
//                           },
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             errorBorder: InputBorder.none,
//                             disabledBorder: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: model.increaseTicketCount,
//                       child: Icon(
//                         Icons.add,
//                         size: SizeConfig.padding16,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: SizeConfig.padding8,
//               ),
//               Text(
//                 "= ₹ ${model.ticketSavedAmount.toString()}",
//                 style: TextStyles.sourceSansB.body2.colour(Colors.white),
//               ),
//               const Spacer(),
//               CustomSaveButton(
//                   width: SizeConfig.screenWidth! * 0.25,
//                   height: SizeConfig.screenHeight! * 0.05,
//                   color: const Color(0xff000000).withOpacity(0.5),
//                   onTap: () {
//                     _analyticsService.track(
//                         eventName: AnalyticsEvents.tambolaSaveTapped,
//                         properties: AnalyticsProperties
//                             .getDefaultPropertiesMap(extraValuesMap: {
//                           "Time left for draw Tambola (mins)":
//                               AnalyticsProperties.getTimeLeftForTambolaDraw(),
//                           "Tambola Tickets Owned":
//                               AnalyticsProperties.getTambolaTicketCount(),
//                           "Number of Tickets":
//                               model.ticketCountController!.text ?? "",
//                           "Amount": model.ticketSavedAmount,
//                         }));
//                     BaseUtil().openDepositOptionsModalSheet(
//                         amount: model.ticketSavedAmount);
//                   },
//                   title: 'SAVE')
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class PageViewWithIndicator extends StatefulWidget {
  const PageViewWithIndicator(
      {Key? key, required this.model, required this.showIndicator})
      : super(key: key);

  final TambolaHomeViewModel? model;
  final bool showIndicator;

  @override
  State<PageViewWithIndicator> createState() => _PageViewWithIndicatorState();
}

class _PageViewWithIndicatorState extends State<PageViewWithIndicator> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  int ticketsCount = 0;

  @override
  void initState() {
    ticketsCount = widget.model!.tambolaBoardViews!.length > 5
        ? 5
        : widget.model!.tambolaBoardViews!.length;
    super.initState();
  }

  Padding _buildCircleIndicator() {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.padding4),
      child: CirclePageIndicator(
        itemCount: ticketsCount,
        currentPageNotifier: _currentPageNotifier,
        selectedDotColor: UiConstants.kSelectedDotColor,
        dotColor: Colors.white.withOpacity(0.5),
        selectedSize: SizeConfig.padding8,
        size: SizeConfig.padding6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.screenWidth! * 0.52,
          width: SizeConfig.screenWidth,
          child: PageView(
            physics: const BouncingScrollPhysics(),
            controller: widget.model!.ticketPageController,
            scrollDirection: Axis.horizontal,
            children: widget.model!.tambolaBoardViews!.sublist(0, ticketsCount),
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            },
          ),
        ),
        SizedBox(
          height: SizeConfig.padding8,
        ),
        if (widget.showIndicator) _buildCircleIndicator(),
      ],
    );
  }
}

class ListLoader extends StatelessWidget {
  final bool bottomPadding;

  const ListLoader({Key? key, this.bottomPadding = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight! * 0.1),
        FullScreenLoader(size: SizeConfig.padding80),
        if (bottomPadding) SizedBox(height: SizeConfig.screenHeight! * 0.1),
      ],
    );
  }
}

class GameChips extends StatelessWidget {
  final TambolaHomeViewModel? model;
  final String? text;
  final int? page;

  const GameChips({super.key, this.model, this.text, this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => model!.viewpage(page),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding24, vertical: SizeConfig.padding12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: model!.currentPage == page
              ? UiConstants.primaryColor
              : UiConstants.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(text!,
            style: model!.currentPage == page
                ? TextStyles.body3.bold.colour(Colors.white)
                : TextStyles.body3.colour(UiConstants.primaryColor)),
      ),
    );
  }
}



