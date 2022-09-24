import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/network_bar.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_info_section.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_title.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/all_tambola_tickets.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/game_card_big.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/static/web_game_prize_view.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';

// class TambolaHomeView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BaseView<TambolaHomeViewModel>(
//       onModelReady: (model) {
//         model.init();
//         model.scrollController = new ScrollController();
//         model.scrollController.addListener(() {
//           model.udpateCardOpacity();
//         });
//       },
//       builder: (ctx, model, child) {
//         return RefreshIndicator(
//           onRefresh: model.getLeaderboard,
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
//                           SizedBox(
//                               height: SizeConfig.screenWidth * 0.1 +
//                                   SizeConfig.viewInsets.top),
//                           InkWell(
//                             onTap: model.openGame,
//                             child: AnimatedOpacity(
//                               duration: Duration(milliseconds: 10),
//                               curve: Curves.decelerate,
//                               opacity: model.cardOpacity ?? 1,
//                               child: BigGameCard(
//                                 gameData: model.game,
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
//                                       // GameChips(
//                                       //   model: model,
//                                       //   text: "LeaderBoard",
//                                       //   page: 1,
//                                       // )
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
//                                             : (model.tPrizes == null
//                                                 ? NoRecordDisplayWidget(
//                                                     asset:
//                                                         "images/week-winners.png",
//                                                     text:
//                                                         "Prizes will be updates soon",
//                                                   )
//                                                 : PrizesView(
//                                                     model: model.tPrizes,
//                                                     controller:
//                                                         model.scrollController,
//                                                     subtitle: BaseRemoteConfig
//                                                             .remoteConfig
//                                                             .getString(
//                                                                 BaseRemoteConfig
//                                                                     .GAME_TAMBOLA_ANNOUNCEMENT) ??
//                                                         "Stand to win big prizes every week by matching your tambola tickets! Winners are announced every Monday",
//                                                     leading: [
//                                                       Icons.apps,
//                                                       Icons.border_top,
//                                                       Icons.border_horizontal,
//                                                       Icons.border_bottom,
//                                                       Icons.border_outer
//                                                     ]
//                                                         .map((e) => Icon(
//                                                               e,
//                                                               color: UiConstants
//                                                                   .primaryColor,
//                                                             ))
//                                                         .toList(),
//                                                   )),
//                                         // model.isLeaderboardLoading
//                                         //     ? ListLoader()
//                                         //     : (model.tlboard == null ||
//                                         //             model.tlboard.scoreboard
//                                         //                 .isEmpty
//                                         //         ? NoRecordDisplayWidget(
//                                         //             asset:
//                                         //                 "images/leaderboard.png",
//                                         //             text:
//                                         //                 "Leaderboard will be updated soon",
//                                         //           )
//                                         //         : LeaderBoardView(
//                                         //             controller:
//                                         //                 model.scrollController,
//                                         //             model: model.tlboard,
//                                         //           ))
//                                       ]),
//                                 ),
//                                 SizedBox(height: SizeConfig.padding64)
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   FelloAppBar(
//                     leading: FelloAppBarBackButton(),
//                     actions: [
//                       FelloCoinBar(
//                         svgAsset: Assets.aFelloToken,
//                       ),
//                       SizedBox(width: 16),
//                       NotificationButton(),
//                     ],
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     child: Container(
//                       width: SizeConfig.screenWidth,
//                       padding: EdgeInsets.symmetric(
//                           horizontal: SizeConfig.scaffoldMargin, vertical: 16),
//                       child: FelloButtonLg(
//                         child: Text(
//                           'PLAY',
//                           style: TextStyles.body2.colour(Colors.white),
//                         ),
//                         onPressed: model.openGame,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class TambolaHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);

    return BaseView<TambolaHomeViewModel>(
      onModelReady: (model) {
        model.init();
        model.scrollController = new ScrollController();
        model.scrollController.addListener(() {
          model.udpateCardOpacity();
        });
      },
      builder: (ctx, model, child) {
        return RefreshIndicator(
          onRefresh: model.getLeaderboard,
          child: Scaffold(
            appBar: FAppBar(
              showAvatar: false,
              showCoinBar: false,
              showHelpButton: false,
              title: "Tambola",
              backgroundColor: UiConstants.kArowButtonBackgroundColor,
            ),
            backgroundColor: UiConstants.kBackgroundColor,
            body: Stack(
              children: [
                NewSquareBackground(),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      //Today and Weekly Picks
                      TodayWeeklyPicksCard(
                        model: model,
                      ),
                      //Your best tickets
                      connectivityStatus != ConnectivityStatus.Offline
                          ? buildCards(model)
                          : SizedBox.shrink(),
                      SizedBox(height: SizeConfig.padding20),
                      (Platform.isIOS)
                          ? Text(
                              'Apple is not associated with Fello Tambola',
                              style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: SizeConfig.mediumTextSize,
                                  color: Colors.white),
                            )
                          : Container(),
                      //Buy tickets
                      ButTicketsComponent(
                        model: model,
                      ),
                      //How to play
                      InfoComponent2(
                          heading: model.boxHeading,
                          assetList: model.boxAssets,
                          titleList: model.boxTitlles,
                          height: SizeConfig.screenWidth * 0.35),
                      //Tambola Prizes
                      TambolaPrize(
                        model: model,
                      ),
                      //LeaderBoard
                      TambolaLeaderbBoard(
                        model: model,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //Tambol tickets builder
  Widget buildCards(TambolaHomeViewModel model) {
    Widget _widget;
    if (!model.weeklyTicksFetched || !model.weeklyDrawFetched) {
      _widget = Padding(
        //Loader
        padding: EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          height: SizeConfig.screenWidth * 0.73,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitWave(
                  color: UiConstants.primaryColor,
                ),
                SizedBox(
                  height: SizeConfig.padding16,
                ),
                Text(
                  "Please wait while we fetch your best tickets!",
                  style: TextStyles.sourceSans.body3.colour(Colors.white),
                )
              ],
            ),
          ),
        ),
      );
    } else if (model.userWeeklyBoards == null ||
        model.activeTambolaCardCount == 0) {
      _widget = Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: SizeConfig.screenWidth * 0.5,
            child: Center(
              child: (model.ticketsBeingGenerated)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: SizeConfig.screenWidth * 0.8,
                          height: 4,
                          decoration: BoxDecoration(
                            color: UiConstants.primaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: FractionallySizedBox(
                            heightFactor: 1,
                            widthFactor: model
                                        .tambolaService.ticketGenerateCount ==
                                    model.tambolaService
                                        .atomicTicketGenerationLeftCount
                                ? 0.1
                                : (model.tambolaService.ticketGenerateCount -
                                        model.tambolaService
                                            .atomicTicketGenerationLeftCount) /
                                    model.tambolaService.ticketGenerateCount,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: UiConstants.primaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Generated ${model.tambolaService.ticketGenerateCount - model.tambolaService.atomicTicketGenerationLeftCount} of your ${model.tambolaService.ticketGenerateCount} tickets',
                          style: TextStyles.rajdhani.body2.colour(Colors.white),
                        ),
                      ],
                    )
                  : NoRecordDisplayWidget(
                      assetSvg: Assets.noTickets,
                      text: "You do not have any Tambola tickets",
                    ),
            ),
          ),
        ),
      );
    } else if (model.activeTambolaCardCount == 1) {
      //One tambola ticket
      model.tambolaBoardViews = [];
      model.tambolaBoardViews.add(Ticket(
        bestBoards: model.refreshBestBoards(),
        dailyPicks: model.weeklyDigits,
        board: model.userWeeklyBoards[0],
        calledDigits: (model.weeklyDrawFetched && model.weeklyDigits != null)
            ? model.weeklyDigits.toList()
            : [],
      ));

      _widget = Column(
        children: [
          SizedBox(
            height: SizeConfig.padding34,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    SizeConfig.pageHorizontalMargins + SizeConfig.padding2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Your Best tickets",
                  style: TextStyles.rajdhaniSB.body0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Container(
            width: SizeConfig.screenWidth,
            child: Stack(
              children: [
                Column(
                  children: [
                    PageViewWithIndicator(
                      model: model,
                      showIndicator: false,
                    ),
                  ],
                ),
                if (model.ticketsBeingGenerated &&
                    model.tambolaService.ticketGenerateCount > 0)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: SizeConfig.screenWidth * 0.8,
                            height: 4,
                            decoration: BoxDecoration(
                              color: UiConstants.primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: FractionallySizedBox(
                              heightFactor: 1,
                              widthFactor: model
                                          .tambolaService.ticketGenerateCount ==
                                      model.tambolaService
                                          .atomicTicketGenerationLeftCount
                                  ? 0.1
                                  : (model.tambolaService.ticketGenerateCount -
                                          model.tambolaService
                                              .atomicTicketGenerationLeftCount) /
                                      model.tambolaService.ticketGenerateCount,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: UiConstants.primaryColor,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Generated ${model.tambolaService.ticketGenerateCount - model.tambolaService.atomicTicketGenerationLeftCount} of your ${model.tambolaService.ticketGenerateCount} tickets',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.mediumTextSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    } else {
      //Multuple tickets
      if (!model.ticketsLoaded) {
        model.ticketsLoaded = true;
        model.tambolaBoardViews = [];
        model.userWeeklyBoards.forEach((board) {
          model.tambolaBoardViews.add(
            Ticket(
              bestBoards: model.refreshBestBoards(),
              dailyPicks: model.weeklyDigits,
              board: board,
              calledDigits:
                  (model.weeklyDrawFetched && model.weeklyDigits != null)
                      ? model.weeklyDigits.toList()
                      : [],
            ),
          );
        });
      }

      _widget = Column(
        children: [
          SizedBox(
            height: SizeConfig.padding34,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    SizeConfig.pageHorizontalMargins + SizeConfig.padding2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Your Best tickets",
                  style: TextStyles.rajdhaniSB.body0,
                ),
                TextButton(
                  onPressed: () {
                    AppState.delegate.appState.currentAction = PageAction(
                      state: PageState.addWidget,
                      page: AllTambolaTicketsPageConfig,
                      widget: AllTambolaTickets(
                          ticketList: model.tambolaBoardViews.toList()),
                    );
                  },
                  child: Text(
                    "View All",
                    style: TextStyles.sourceSansSB.body2
                        .colour(UiConstants.kTabBorderColor),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Container(
            width: SizeConfig.screenWidth,
            child: Stack(
              children: [
                Column(
                  children: [
                    PageViewWithIndicator(
                      model: model,
                      showIndicator: true,
                    ),
                  ],
                ),
                if (model.ticketsBeingGenerated &&
                    model.tambolaService.ticketGenerateCount > 0)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: SizeConfig.screenWidth,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: SizeConfig.screenWidth * 0.8,
                            height: 4,
                            decoration: BoxDecoration(
                              color: UiConstants.primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: FractionallySizedBox(
                              heightFactor: 1,
                              widthFactor: model
                                          .tambolaService.ticketGenerateCount ==
                                      model.tambolaService
                                          .atomicTicketGenerationLeftCount
                                  ? 0.1
                                  : (model.tambolaService.ticketGenerateCount -
                                          model.tambolaService
                                              .atomicTicketGenerationLeftCount) /
                                      model.tambolaService.ticketGenerateCount,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: UiConstants.primaryColor,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Generated ${model.tambolaService.ticketGenerateCount - model.tambolaService.atomicTicketGenerationLeftCount} of your ${model.tambolaService.ticketGenerateCount} tickets',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.mediumTextSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    }
    return _widget;
  }
}

class ButTicketsComponent extends StatelessWidget {
  const ButTicketsComponent({
    Key key,
    @required this.model,
  }) : super(key: key);

  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding16, vertical: SizeConfig.padding12),
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
              vertical: SizeConfig.padding16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.roundness12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Get a Tambola ticket",
                    style: TextStyles.rajdhaniSB.body1,
                  ),
                  Text(
                    "Get 1 Ticket for every Rs.500 saved.",
                    style: TextStyles.sourceSans.body5
                        .colour(UiConstants.kTextColor2),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: UiConstants.kArowButtonBackgroundColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeConfig.roundness8),
                  ),
                ),
                height: SizeConfig.screenWidth * 0.14,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      iconSize: SizeConfig.padding20,
                      color: Colors.white,
                      onPressed: model.decreaseTicketCount,
                    ),
                    Container(
                      width: SizeConfig.screenHeight * 0.03,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        controller: model.ticketCountController,
                        enableInteractiveSelection: false,
                        enabled: false,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (String text) {
                          model.updateTicketCount();
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      iconSize: SizeConfig.padding20,
                      color: Colors.white,
                      onPressed: model.increaseTicketCount,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: FelloButtonLg(
            //color: UiConstants.tertiarySolid,
            child: model.ticketBuyInProgress
                ? SpinKitThreeBounce(
                    color: Colors.white,
                    size: SizeConfig.body2,
                  )
                : RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'BUY TICKETS     (',
                            style: TextStyles.sourceSansB.body2
                                .colour(Colors.white)),
                        WidgetSpan(
                            child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding4),
                          height: 16,
                          width: 16,
                          child: SvgPicture.asset(
                            Assets.aFelloToken,
                          ),
                        )),
                        TextSpan(
                            text: '${model.buyTicketCount * 10} )',
                            style: TextStyles.sourceSansB.body2
                                .colour(Colors.white)),
                      ],
                    ),
                  ),
            onPressed: () {
              model.buyTickets(context);
            },
          ),
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
      ],
    );
  }
}

class PageViewWithIndicator extends StatefulWidget {
  const PageViewWithIndicator(
      {Key key, @required this.model, @required this.showIndicator})
      : super(key: key);

  final TambolaHomeViewModel model;
  final bool showIndicator;

  @override
  State<PageViewWithIndicator> createState() => _PageViewWithIndicatorState();
}

class _PageViewWithIndicatorState extends State<PageViewWithIndicator> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.padding4),
        child: CirclePageIndicator(
          itemCount: widget.model.tambolaBoardViews.toList().length,
          currentPageNotifier: _currentPageNotifier,
          selectedDotColor: UiConstants.kSelectedDotColor,
          dotColor: Colors.white.withOpacity(0.5),
          selectedSize: SizeConfig.padding8,
          size: SizeConfig.padding6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: SizeConfig.screenWidth * 0.45,
          child: PageView(
            physics: BouncingScrollPhysics(),
            controller: widget.model.ticketPageController,
            scrollDirection: Axis.horizontal,
            children: widget.model.tambolaBoardViews.toList(),
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            },
          ),
        ),
        SizedBox(
          height: SizeConfig.padding20,
        ),
        if (widget.showIndicator) _buildCircleIndicator(),
      ],
    );
  }
}

class ListLoader extends StatelessWidget {
  final bool bottomPadding;
  const ListLoader({Key key, this.bottomPadding = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.1),
        SpinKitWave(
          color: UiConstants.primaryColor,
        ),
        if (bottomPadding) SizedBox(height: SizeConfig.screenHeight * 0.1),
      ],
    );
  }
}

class GameChips extends StatelessWidget {
  final TambolaHomeViewModel model;
  final String text;
  final int page;
  GameChips({this.model, this.text, this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => model.viewpage(page),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding24, vertical: SizeConfig.padding12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: model.currentPage == page
              ? UiConstants.primaryColor
              : UiConstants.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(text,
            style: model.currentPage == page
                ? TextStyles.body3.bold.colour(Colors.white)
                : TextStyles.body3.colour(UiConstants.primaryColor)),
      ),
    );
  }
}

class TodayWeeklyPicksCard extends StatelessWidget {
  const TodayWeeklyPicksCard({
    Key key,
    @required this.model,
  }) : super(key: key);

  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.pageHorizontalMargins,
        bottom: SizeConfig.pageHorizontalMargins + SizeConfig.padding16,
      ),
      decoration: BoxDecoration(
        color: UiConstants.kArowButtonBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            SizeConfig.roundness32,
          ),
          bottomRight: Radius.circular(
            SizeConfig.roundness32,
          ),
        ),
      ),
      child: PicksCardView(
        showBuyTicketModal: (value) {
          model.showBuyModal = value;
        },
      ),
    );
  }
}

class TambolaLeaderbBoard extends StatelessWidget {
  const TambolaLeaderbBoard({
    Key key,
    @required this.model,
  }) : super(key: key);

  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.pageHorizontalMargins + SizeConfig.padding12,
          ),
          Text(
            "Last week winners",
            style: TextStyles.rajdhaniSB.body0,
          ),
          SizedBox(
            height: SizeConfig.pageHorizontalMargins,
          ),
          model.winners == null
              ? Center(
                  child: Column(
                    children: [
                      SpinKitWave(
                        color: UiConstants.primaryColor,
                      ),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                      Text(
                        "Fetching last week winners.",
                        style: TextStyles.rajdhaniB.body2.colour(Colors.white),
                      ),
                    ],
                  ),
                )
              : (model.winners.isEmpty
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding24),
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      width: SizeConfig.screenWidth,
                      child: NoRecordDisplayWidget(
                        topPadding: false,
                        asset: "images/leaderboard.png",
                        text: "Leaderboard will be updated soon",
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "#",
                              style: TextStyles.sourceSans.body3
                                  .colour(UiConstants.kTextColor2),
                            ),
                            SizedBox(width: SizeConfig.padding12),
                            SizedBox(width: SizeConfig.padding12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Names",
                                      style: TextStyles.sourceSans.body3
                                          .colour(UiConstants.kTextColor2)),
                                  SizedBox(height: SizeConfig.padding4),
                                ],
                              ),
                            ),
                            Text(
                              "Cashprize",
                              style: TextStyles.sourceSans.body3
                                  .colour(UiConstants.kTextColor2),
                            )
                          ],
                        ),
                        Column(
                          children: List.generate(
                            model.winners.length,
                            (i) {
                              return Column(
                                children: [
                                  Container(
                                    width: SizeConfig.screenWidth,
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding12),
                                    margin: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness16),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${i + 1}",
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
                                        ),
                                        SizedBox(width: SizeConfig.padding12),
                                        FutureBuilder(
                                          future: model.getProfileDpWithUid(
                                              model.winners[i].userid),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              int rand =
                                                  1 + math.Random().nextInt(4);
                                              return SvgPicture.asset(
                                                "assets/svg/userAvatars/AV$rand.svg",
                                                width: SizeConfig.iconSize5,
                                                height: SizeConfig.iconSize5,
                                              );
                                            }

                                            String imageUrl =
                                                snapshot.data as String;

                                            return ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrl,
                                                fit: BoxFit.cover,
                                                width: SizeConfig.iconSize5,
                                                height: SizeConfig.iconSize5,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: SizeConfig.iconSize5,
                                                  height: SizeConfig.iconSize5,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                errorWidget: (a, b, c) {
                                                  int rand = 1 +
                                                      math.Random().nextInt(4);
                                                  return SvgPicture.asset(
                                                    "assets/svg/userAvatars/AV$rand.svg",
                                                    width: SizeConfig.iconSize5,
                                                    height:
                                                        SizeConfig.iconSize5,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(width: SizeConfig.padding12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  //"avc",
                                                  model.winners[i].username
                                                          .replaceAll(
                                                              '@', '.') ??
                                                      "username",
                                                  style: TextStyles
                                                      .sourceSans.body2
                                                      .colour(Colors.white)),
                                              SizedBox(
                                                  height: SizeConfig.padding4),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "₹ ${model.winners[i].amount.toInt() ?? "00"}",
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (i + 1 < model.winners.length)
                                    Divider(
                                      color: Colors.white,
                                      thickness: 0.2,
                                    )
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                      ],
                    )),
        ],
      ),
    );
  }
}

class TambolaPrize extends StatelessWidget {
  const TambolaPrize({
    Key key,
    @required this.model,
  }) : super(key: key);

  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: SizeConfig.screenWidth * 0.15),
          decoration: BoxDecoration(
            color: UiConstants.kTambolaMidTextColor,
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenWidth * 0.17,
              ),
              Text(
                "Tambola Prizes",
                style: TextStyles.rajdhaniB.title4.colour(Colors.white),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding54),
                child: Text(
                  BaseRemoteConfig.remoteConfig.getString(
                          BaseRemoteConfig.GAME_TAMBOLA_ANNOUNCEMENT) ??
                      "Stand to win prizes every week. Winners are arrounced every Sunday at midnight",
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSans.body4.colour(
                    Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: model.tPrizes == null
                    ? Center(
                        child: Column(
                          children: [
                            SpinKitWave(
                              color: UiConstants.primaryColor,
                            ),
                            SizedBox(
                              height: SizeConfig.padding16,
                            ),
                            Text(
                              "Fetching Tambola prizes, please wait.",
                              style: TextStyles.rajdhaniB.body2
                                  .colour(Colors.white),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: model.tPrizes.prizesA.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding16),
                            child: Row(
                              children: [
                                Icon(
                                  model.leadingIconList[index],
                                  color: Colors.grey,
                                  size: SizeConfig.padding44,
                                ),
                                SizedBox(
                                  width: SizeConfig.padding10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.tPrizes.prizesA[index].displayName,
                                      style: TextStyles.rajdhaniB.body2
                                          .colour(Colors.white),
                                    ),
                                    Text(
                                      "Win full house to get",
                                      style: TextStyles.sourceSans.body4.colour(
                                          Colors.white.withOpacity(0.5)),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Rs. ${model.tPrizes.prizesA[index].amt}",
                                          style: TextStyles.sourceSans.body3
                                              .colour(Colors.white),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SvgPicture.asset(
                                              Assets.tokens,
                                              width: SizeConfig.padding12,
                                            ),
                                            SizedBox(
                                              width: SizeConfig.padding10,
                                            ),
                                            Text(
                                              "${model.tPrizes.prizesA[index].flc}",
                                              style: TextStyles.sourceSans.body4
                                                  .colour(Colors.white
                                                      .withOpacity(0.5)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding6),
          width: SizeConfig.screenWidth * 0.3,
          height: SizeConfig.screenWidth * 0.3,
          decoration: BoxDecoration(
            color: UiConstants.kTambolaMidTextColor,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            "assets/svg/tambola_prize_asset.svg",
            width: double.maxFinite,
            height: double.maxFinite,
          ),
        ),
      ],
    );
  }
}
