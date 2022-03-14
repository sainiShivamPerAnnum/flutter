// import 'package:felloapp/core/model/prizes_model.dart';
// import 'package:felloapp/util/assets.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/textStyles.dart';
// import 'package:felloapp/util/styles/ui_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:lottie/lottie.dart';

// class CricketHomeView extends StatelessWidget {
//   final _analyticsService = locator<AnalyticsService>();
//   @override
//   Widget build(BuildContext context) {
//     return BaseView<CricketHomeViewModel>(
//       onModelReady: (model) {
//         model.init();
//         model.scrollController.addListener(() {
//           model.udpateCardOpacity();
//         });
//       },
//       builder: (ctx, model, child) {
//         return RefreshIndicator(
//           onRefresh: () => model.refreshLeaderboard(),
//           child: Scaffold(
//             backgroundColor: UiConstants.primaryColor,
//             body: HomeBackground(
//               child: Stack(
//                 children: [
//                   WhiteBackground(
//                     color: UiConstants.scaffoldColor,
//                     height: SizeConfig.screenHeight * 0.2,
//                   ),
//                   SafeArea(
//                     child: Container(
//                       width: SizeConfig.screenWidth,
//                       height: SizeConfig.screenHeight,
//                       child: ListView(
//                         controller: model.scrollController,
//                         children: [
//                           SizedBox(height: SizeConfig.screenHeight * 0.1),
//                           InkWell(
//                             onTap: () async {
//                               if (await BaseUtil.showNoInternetAlert()) return;
//                               if (model.state == ViewState.Idle) {
//                                 if (await model.openWebView())
//                                   model.startGame();
//                                 else
//                                   earnMoreTokens();
//                               }
//                             },
//                             child: AnimatedOpacity(
//                               duration: Duration(milliseconds: 10),
//                               curve: Curves.decelerate,
//                               opacity: model.cardOpacity ?? 1,
//                               child: GameCard(
//                                 gameData: BaseUtil.gamesList[0],
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: SizeConfig.padding8),
//                           Container(
//                             height: SizeConfig.screenHeight * 0.86 -
//                                 SizeConfig.viewInsets.top,
//                             padding: EdgeInsets.all(
//                                 SizeConfig.pageHorizontalMargins),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 topLeft:
//                                     Radius.circular(SizeConfig.roundness40),
//                                 topRight:
//                                     Radius.circular(SizeConfig.roundness40),
//                               ),
//                               color: Colors.white,
//                             ),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.only(
//                                       bottom: SizeConfig.padding4),
//                                   alignment: Alignment.center,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       GameChips(
//                                         model: model,
//                                         text: "Prizes",
//                                         page: 0,
//                                       ),
//                                       SizedBox(width: 16),
//                                       GameChips(
//                                         model: model,
//                                         text: "LeaderBoard",
//                                         page: 1,
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: PageView(
//                                       physics: NeverScrollableScrollPhysics(),
//                                       controller: model.pageController,
//                                       children: [
//                                         model.isPrizesLoading
//                                             ? ListLoader()
//                                             : (model.cPrizes == null
//                                                 ? NoRecordDisplayWidget(
//                                                     asset:
//                                                         "images/week-winners.png",
//                                                     text:
//                                                         "Prizes will be updates soon",
//                                                   )
//                                                 : PrizesView(
//                                                     model: model.cPrizes,
//                                                     controller:
//                                                         model.scrollController,
//                                                     subtitle: BaseRemoteConfig
//                                                             .remoteConfig
//                                                             .getString(
//                                                                 BaseRemoteConfig
//                                                                     .GAME_CRICKET_ANNOUNCEMENT) ??
//                                                         'The highest scorers of the week win prizes every Sunday at midnight',
//                                                     leading: List.generate(
//                                                         model.cPrizes.prizesA
//                                                             .length,
//                                                         (i) => Text(
//                                                               "${i + 1}",
//                                                               style: TextStyles
//                                                                   .body3.bold
//                                                                   .colour(UiConstants
//                                                                       .primaryColor),
//                                                             )),
//                                                   )),
//                                         CricketLeaderboardView()
//                                       ]),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (model.state == ViewState.Idle)
//                     Positioned(
//                       bottom: 0,
//                       child: Container(
//                         width: SizeConfig.screenWidth,
//                         padding: EdgeInsets.symmetric(
//                             horizontal: SizeConfig.scaffoldMargin,
//                             vertical: 16),
//                         child: FelloButtonLg(
//                             child:
//                                 //  (model.state == ViewState.Idle)
//                                 //     ?
//                                 Text(
//                               'PLAY',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .button
//                                   .copyWith(color: Colors.white),
//                             ),
//                             // : SpinKitThreeBounce(
//                             //     color: UiConstants.spinnerColor2,
//                             //     size: 18.0,
//                             //   ),
//                             onPressed: () async {
//                               if (model.state == ViewState.Idle) {
//                                 if (await model.openWebView())
//                                   model.startGame();
//                                 else
//                                   earnMoreTokens();
//                               }
//                             }),
//                       ),
//                     ),
//                   if (model.state == ViewState.Busy)
//                     Container(
//                       color: Colors.white.withOpacity(0.5),
//                       child: SafeArea(
//                         child: Center(
//                           child: SpinKitWave(
//                             color: UiConstants.primaryColor,
//                             size: SizeConfig.padding32,
//                           ),
//                         ),
//                       ),
//                     ),
//                   FelloAppBar(
//                     leading: FelloAppBarBackButton(),
//                     actions: [
//                       FelloCoinBar(),
//                       SizedBox(width: 16),
//                       NotificationButton(),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void earnMoreTokens() {
//     _analyticsService.track(eventName: AnalyticsEvents.earnMoreTokens);
//     BaseUtil.openModalBottomSheet(
//       addToScreenStack: true,
//       content: WantMoreTicketsModalSheet(
//         isInsufficientBalance: true,
//       ),
//       hapticVibrate: true,
//       backgroundColor: Colors.transparent,
//       isBarrierDismissable: true,
//     );
//   }
// }


// class GameChips extends StatelessWidget {
//   final CricketHomeViewModel model;
//   final String text;
//   final int page;
//   GameChips({this.model, this.text, this.page});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => model.viewpage(page),
//       child: Container(
//         padding: EdgeInsets.symmetric(
//             horizontal: SizeConfig.padding24, vertical: SizeConfig.padding12),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: model.currentPage == page
//               ? UiConstants.primaryColor
//               : UiConstants.primaryColor.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(100),
//         ),
//         child: Text(text,
//             style: model.currentPage == page
//                 ? TextStyles.body3.bold.colour(Colors.white)
//                 : TextStyles.body3.colour(UiConstants.primaryColor)),
//       ),
//     );
//   }
// }

