import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/network_bar.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_game/tambola_game_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TambolaGameView extends StatefulWidget {
  @override
  _TambolaGameViewState createState() => _TambolaGameViewState();
}

class _TambolaGameViewState extends State<TambolaGameView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);
    return BaseView<TambolaGameViewModel>(
      onModelReady: (model) {
        model.init();
        model.ticketPageController = new PageController()
          ..addListener(() {
            model.currentPage = model.ticketPageController.page.toInt() + 1;
          });
        model.animationController = AnimationController(
            vsync: this, duration: Duration(milliseconds: 300));
        model.animationController.forward();
      },
      builder: (ctx, model, child) {
        return NotificationListener<ScrollNotification>(
          onNotification: model.handleScrollNotification,
          child: Scaffold(
            body: HomeBackground(
              child: Stack(
                children: [
                  Container(
                    height: SizeConfig.screenHeight,
                    child: Column(
                      children: [
                        FelloAppBar(
                          leading: FelloAppBarBackButton(),
                          title: "Tambola",
                          actions: [
                            FelloCoinBar(),
                            SizedBox(width: SizeConfig.padding8),
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              child: IconButton(
                                icon: Icon(Icons.info),
                                color: Colors.white.withOpacity(0.8),
                                onPressed: () {
                                  AppState.delegate.appState.currentAction =
                                      PageAction(
                                    state: PageState.addPage,
                                    page: TWalkthroughPageConfig,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SizeConfig.padding40),
                              topRight: Radius.circular(SizeConfig.padding40),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    PicksCardView(
                                      showBuyTicketModal: (value) {
                                        model.showBuyModal = value;
                                      },
                                    ),
                                    connectivityStatus !=
                                            ConnectivityStatus.Offline
                                        ? buildCards(model)
                                        : Center(
                                            child: NetworkBar(
                                              textColor: Colors.black,
                                            ),
                                          ),
                                    SizedBox(height: SizeConfig.padding20),
                                    // InkWell(
                                    //   onTap: model.showAllBoards,
                                    //   highlightColor: UiConstants.primaryColor
                                    //       .withOpacity(0.3),
                                    //   borderRadius: BorderRadius.circular(100),
                                    //   child: Container(
                                    //     padding: EdgeInsets.symmetric(
                                    //       horizontal: 16,
                                    //       vertical: 8,
                                    //     ),
                                    //     decoration: BoxDecoration(
                                    //       border: Border.all(
                                    //         color: UiConstants.primaryColor,
                                    //       ),
                                    //       borderRadius:
                                    //           BorderRadius.circular(100),
                                    //     ),
                                    //     child: Text(
                                    //       "Show All tickets",
                                    //       style: GoogleFonts.montserrat(
                                    //         color: UiConstants.primaryColor,
                                    //         fontSize: SizeConfig.mediumTextSize,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(height: SizeConfig.padding40),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom:
                        model.showBuyModal ? 0 : -SizeConfig.screenWidth * 0.4,
                    child: SizeTransition(
                      sizeFactor: model.animationController,
                      axisAlignment: -1.0,
                      child: Container(
                        width: SizeConfig.screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.padding40),
                            topRight: Radius.circular(SizeConfig.padding40),
                          ),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                offset: Offset(0, -5),
                                color: Colors.black.withOpacity(0.05),
                                spreadRadius: 5)
                          ],
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.only(top: SizeConfig.padding16),
                        padding:
                            EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                        child: Column(
                          children: [
                            Container(
                              height: SizeConfig.screenWidth * 0.135,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: TextField(
                                        controller: model.ticketCountController,
                                        enableInteractiveSelection: false,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        cursorColor: UiConstants.primaryColor,
                                        decoration: InputDecoration(
                                            hintText: 'Enter no of tickets'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.padding16),
                                  Container(
                                    width: SizeConfig.screenWidth * 0.135,
                                    height: SizeConfig.screenWidth * 0.135,
                                    decoration: BoxDecoration(
                                      color: UiConstants.primaryLight
                                          .withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness12),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      color: UiConstants.primaryColor,
                                      onPressed: model.increaseTicketCount,
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.padding12),
                                  MaterialButton(
                                    onPressed: model.decreaseTicketCount,
                                    splashColor: Colors.grey,
                                    highlightColor: Colors.grey,
                                    child: Container(
                                      width: SizeConfig.screenWidth * 0.135,
                                      height: SizeConfig.screenWidth * 0.135,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.roundness12),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.padding16),
                                  Expanded(
                                    child: Container(
                                      child: FelloButtonLg(
                                        //color: UiConstants.tertiarySolid,
                                        child: model.ticketBuyInProgress
                                            ? SpinKitThreeBounce(
                                                color: Colors.white,
                                                size: SizeConfig.body2,
                                              )
                                            : Text("Buy",
                                                style: TextStyles.body2
                                                    .colour(Colors.white)),
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          model.buyTickets();
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.padding12),
                            Row(
                              children: [
                                Text(
                                  "10 tokens = 1 ticket",
                                  style: TextStyles.body4.colour(Colors.grey),
                                ),
                                Spacer(),
                                Text(
                                  "Requires ${model.buyTicketCount * 10} ",
                                  style: TextStyles.body4,
                                ),
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: SvgPicture.asset(
                                    "assets/vectors/icons/tickets.svg",
                                    height: SizeConfig.iconSize3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.padding16)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCards(TambolaGameViewModel model) {
    Widget _widget;
    if (!model.weeklyTicksFetched) {
      _widget = Padding(
        //Loader
        padding: EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          height: 200,
          child: Center(
            child: SpinKitWave(
              color: UiConstants.primaryColor,
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
            height: SizeConfig.screenWidth * 0.9,
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
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig.mediumTextSize,
                          ),
                        ),
                      ],
                    )
                  : NoRecordDisplayWidget(
                      assetSvg: Assets.noTickets,
                      text: "You have no tickets right now",
                    ),
            ),
          ),
        ),
      );
    } else if (model.activeTambolaCardCount == 1) {
      model.tambolaBoardViews = [];
      model.tambolaBoardViews.add(Ticket(
        bestBoards: model.refreshBestBoards(),
        dailyPicks: model.weeklyDigits,
        board: model.userWeeklyBoards[0],
        calledDigits: (model.weeklyDrawFetched && model.weeklyDigits != null)
            ? model.weeklyDigits.toList()
            : [],
      ));
      // model.currentBoardView = model.tambolaBoardViews[0];
      // model.currentBoard = model.userWeeklyBoards[0];
      _widget = Padding(
          padding: EdgeInsets.all(10),
          child: Container(
              width: double.infinity, child: model.tambolaBoardViews[0]));
    } else {
      model.tambolaBoardViews = [];
      model.userWeeklyBoards.forEach((board) {
        model.tambolaBoardViews.add(Ticket(
          bestBoards: model.refreshBestBoards(),
          dailyPicks: model.weeklyDigits,
          board: board,
          calledDigits: (model.weeklyDrawFetched && model.weeklyDigits != null)
              ? model.weeklyDigits.toList()
              : [],
        ));
      });
      _widget = Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins,
                vertical: SizeConfig.blockSizeHorizontal * 2),
            child: Row(
              children: [
                Text(
                  "My Tickets (${model.totalActiveTickets})",
                  style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: SizeConfig.cardTitleTextSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    model.ticketPageController
                        .previousPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.decelerate)
                        .then((_) {
                      if (model.currentPage > 0) model.currentPage -= 1;
                    });
                  },
                  child: Icon(
                    Icons.arrow_left_rounded,
                    color: Colors.grey.withOpacity(0.3),
                    size: SizeConfig.padding54,
                  ),
                ),
                InkWell(
                  onTap: () {
                    model.ticketPageController
                        .nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.decelerate)
                        .then((_) {
                      if (model.currentPage <= model.activeTambolaCardCount)
                        model.currentPage += 1;
                    });
                  },
                  child: Icon(
                    Icons.arrow_right_rounded,
                    color: UiConstants.primaryColor,
                    size: SizeConfig.padding54,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenWidth * 1.4,
            child: Stack(
              children: [
                Container(
                  height: SizeConfig.screenWidth * 1.4,
                  child: PageView(
                    controller: model.ticketPageController,
                    scrollDirection: Axis.horizontal,
                    children: model.tambolaBoardViews.toList(),
                  ),
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
      // if (model.currentBoardView == null)
      //   model.currentBoardView = model.tambolaBoardViews[0];
      // if (model.currentBoard == null)
      //   model.currentBoard = model.userWeeklyBoards[0];
    }
    return _widget;
  }
}

class Odds extends StatelessWidget {
  final DailyPick _digitsObj;
  final TambolaBoard _board;
  final List<TambolaBoard> _bestBoards;

  Odds(this._digitsObj, this._board, this._bestBoards);

  @override
  Widget build(BuildContext cx) {
    if (_board == null) return Container();
    List<int> _digits = (_digitsObj != null) ? _digitsObj.toList() : [];
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // padding: EdgeInsets.zero,
        // physics: NeverScrollableScrollPhysics(),
        // itemCount: 6,
        children: List.generate(
          5,
          (index) {
            switch (index) {
              case 0:
                return _buildRow(
                    cx,
                    Icons.border_top,
                    'Top Row',
                    _board.getRowOdds(0, _digits).toString() + ' left',
                    _bestBoards[0].getRowOdds(0, _digits).toString() + ' left',
                    _bestBoards[0],
                    _digits);
              case 1:
                return _buildRow(
                    cx,
                    Icons.border_horizontal,
                    'Middle Row',
                    _board.getRowOdds(1, _digits).toString() + ' left',
                    _bestBoards[1].getRowOdds(1, _digits).toString() + ' left',
                    _bestBoards[1],
                    _digits);
              case 2:
                return _buildRow(
                    cx,
                    Icons.border_bottom,
                    'Bottom Row',
                    _board.getRowOdds(2, _digits).toString() + ' left',
                    _bestBoards[2].getRowOdds(2, _digits).toString() + ' left',
                    _bestBoards[2],
                    _digits);
              case 3:
                return _buildRow(
                    cx,
                    Icons.border_outer,
                    'Corners',
                    _board.getCornerOdds(_digits).toString() + ' left',
                    _bestBoards[3].getCornerOdds(_digits).toString() + ' left',
                    _bestBoards[3],
                    _digits);
              case 4:
                return _buildRow(
                    cx,
                    Icons.apps,
                    'Full House',
                    _board.getFullHouseOdds(_digits).toString() + ' left',
                    _bestBoards[4].getFullHouseOdds(_digits).toString() +
                        ' left',
                    _bestBoards[4],
                    _digits);

              default:
                return _buildRow(
                    cx,
                    Icons.border_top,
                    'Top Row',
                    _board.getRowOdds(0, _digits).toString() + ' left',
                    _bestBoards[0].getRowOdds(0, _digits).toString() + ' left',
                    _bestBoards[0],
                    _digits);
            }
          },
        ));
  }

  Widget _buildRow(BuildContext cx, IconData _i, String _title, String _tOdd,
      String _oOdd, TambolaBoard _bestBoard, List<int> _digits) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                      radius: SizeConfig.padding20,
                      backgroundColor:
                          UiConstants.primaryColor.withOpacity(0.1),
                      child: Icon(_i,
                          size: SizeConfig.padding20,
                          color: UiConstants.primaryColor)),
                  SizedBox(width: SizeConfig.padding12),
                  Expanded(
                      child:
                          Text(_title, maxLines: 2, style: TextStyles.body3)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(_tOdd, style: TextStyles.body3),
                  SizedBox(height: SizeConfig.padding2),
                  Text('This ticket',
                      style: TextStyles.body4.colour(Colors.grey))
                ],
              ),
            ),
            Expanded(
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(_oOdd, style: TextStyles.body3),
                    SizedBox(height: SizeConfig.padding4),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding8,
                        vertical: SizeConfig.padding2,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: UiConstants.primaryColor.withOpacity(0.2)),
                      child: Text('Best ticket',
                          textAlign: TextAlign.center,
                          style: TextStyles.body4
                              .colour(UiConstants.primaryColor)),
                    )
                  ],
                ),
                onTap: () {
                  BaseUtil.openDialog(
                    addToScreenStack: true,
                    hapticVibrate: true,
                    isBarrierDismissable: true,
                    content: Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        height: SizeConfig.screenWidth * 1.3,
                        width: SizeConfig.screenWidth -
                            SizeConfig.pageHorizontalMargins * 2,
                        child: Transform.scale(
                          scale: 1.1,
                          child: Ticket(
                              dailyPicks: _digitsObj,
                              bestBoards: _bestBoards,
                              board: _bestBoard,
                              calledDigits: _digits),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
    );
  }
}

//   Widget buildCards(TambolaGameViewModel model) {
//     Widget _widget;
//     if (!model.tambolaService.weeklyDrawFetched ||
//         !model.tambolaService.weeklyTicksFetched) {
//       _widget = Padding(
//         //Loader
//         padding: EdgeInsets.all(10),
//         child: Container(
//           width: double.infinity,
//           height: 200,
//           child: Center(
//             child: SpinKitWave(
//               color: UiConstants.primaryColor,
//             ),
//           ),
//         ),
//       );
//     } else if (model.tambolaService.userWeeklyBoards == null ||
//         model.activeTambolaCardCount == 0) {
//       _widget = Center(
//         child: Padding(
//           padding: EdgeInsets.all(10),
//           child: Container(
//             width: double.infinity,
//             height: model.ticketsBeingGenerated
//                 ? SizeConfig.screenWidth * 0.9
//                 : SizeConfig.padding20,
//             child: Center(
//               child: (model.ticketsBeingGenerated)
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: SizeConfig.screenWidth * 0.8,
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: UiConstants.primaryColor.withOpacity(0.3),
//                             borderRadius: BorderRadius.circular(100),
//                           ),
//                           child: FractionallySizedBox(
//                             heightFactor: 1,
//                             widthFactor: model
//                                         .tambolaService.ticketGenerateCount ==
//                                     model.tambolaService
//                                         .atomicTicketGenerationLeftCount
//                                 ? 0.1
//                                 : (model.tambolaService.ticketGenerateCount -
//                                         model.tambolaService
//                                             .atomicTicketGenerationLeftCount) /
//                                     model.tambolaService.ticketGenerateCount,
//                             alignment: Alignment.centerLeft,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: UiConstants.primaryColor,
//                                 borderRadius: BorderRadius.circular(100),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           'Generated ${model.tambolaService.ticketGenerateCount - model.tambolaService.atomicTicketGenerationLeftCount} of your ${model.tambolaService.ticketGenerateCount} tickets',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: SizeConfig.mediumTextSize,
//                           ),
//                         ),
//                       ],
//                     )
//                   : Text('No tickets yet'),
//             ),
//           ),
//         ),
//       );
//     } else {
//       if (model.topFiveTambolaBoards.isEmpty) {
//         model.refreshBestBoards().forEach((element) {
//           model.topFiveTambolaBoards.add(model.buildBoardView(element));
//         });
//       }

//       _widget = Container(
//         child: Stack(
//           children: [
//             Column(
//               children: [
// Container(
//   margin: EdgeInsets.symmetric(
//       horizontal: SizeConfig.pageHorizontalMargins,
//       vertical: SizeConfig.blockSizeHorizontal * 2),
//   child: Row(
//     children: [
//       Text(
//         "My Tickets (${model.activeTambolaCardCount})",
//         style: GoogleFonts.montserrat(
//           color: Colors.black87,
//           fontSize: SizeConfig.cardTitleTextSize,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       Spacer(),
//       InkWell(
//         onTap: model.showAllBoards,
//         highlightColor:
//             UiConstants.primaryColor.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(100),
//         child: Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 8,
//           ),
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: UiConstants.primaryColor,
//             ),
//             borderRadius: BorderRadius.circular(100),
//           ),
//           child: Text(
//             "Show All",
//             style: GoogleFonts.montserrat(
//               color: UiConstants.primaryColor,
//               fontSize: SizeConfig.mediumTextSize,
//             ),
//           ),
//         ),
//       )
//     ],
//   ),
// ),
//                 Container(
//                   height: SizeConfig.screenWidth * 0.95,
//                   width: SizeConfig.screenWidth,
//                   child: ListView(
//                     physics: BouncingScrollPhysics(),
//                     scrollDirection: Axis.horizontal,
//                     children: List.generate(model.topFiveTambolaBoards.length,
//                         (index) => model.topFiveTambolaBoards[index]),
//                   ),
//                 ),
//               ],
//             ),
            // if (model.ticketsBeingGenerated)
            //   Align(
            //     alignment: Alignment.center,
            //     child: Container(
            //       width: SizeConfig.screenWidth,
            //       height: 140,
            //       decoration: BoxDecoration(
            //         color: Colors.white.withOpacity(0.7),
            //       ),
            //       padding: EdgeInsets.all(20),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Container(
            //             width: SizeConfig.screenWidth * 0.8,
            //             height: 4,
            //             decoration: BoxDecoration(
            //               color: UiConstants.primaryColor.withOpacity(0.3),
            //               borderRadius: BorderRadius.circular(100),
            //             ),
            //             child: FractionallySizedBox(
            //               heightFactor: 1,
            //               widthFactor: model
            //                           .tambolaService.ticketGenerateCount ==
            //                       model.tambolaService
            //                           .atomicTicketGenerationLeftCount
            //                   ? 0.1
            //                   : (model.tambolaService.ticketGenerateCount -
            //                           model.tambolaService
            //                               .atomicTicketGenerationLeftCount) /
            //                       model.tambolaService.ticketGenerateCount,
            //               alignment: Alignment.centerLeft,
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                   color: UiConstants.primaryColor,
            //                   borderRadius: BorderRadius.circular(100),
            //                 ),
            //               ),
            //             ),
            //           ),
            //           SizedBox(height: 16),
            //           Text(
            //             'Generated ${model.tambolaService.ticketGenerateCount - model.tambolaService.atomicTicketGenerationLeftCount} of your ${model.tambolaService.ticketGenerateCount} tickets',
            //             style: TextStyle(
            //               fontWeight: FontWeight.w600,
            //               fontSize: SizeConfig.mediumTextSize,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
//           ],
//         ),
//       );

//       // if (model.currentBoardView == null)
//       //   model.currentBoardView = Ticket(
//       //     bgColor: FelloColorPalette.tambolaTicketColorPalettes()[0].boardColor,
//       //     boardColorEven:
//       //         FelloColorPalette.tambolaTicketColorPalettes()[0].itemColorEven,
//       //     boardColorOdd:
//       //         FelloColorPalette.tambolaTicketColorPalettes()[0].itemColorOdd,
//       //     boradColorMarked:
//       //         FelloColorPalette.tambolaTicketColorPalettes()[0].itemColorMarked,
//       //     calledDigits: [],
//       //     board: null,
//       //   );
//       // if (model.currentBoard == null)
//       //   model.currentBoard = model.tambolaService.userWeeklyBoards[0];
//     }
//     return _widget;
//   }
// }

// if (showCardSummary)
//   _buildTicketSummaryCards(
//       baseProvider.weeklyTicksFetched,
//       baseProvider.weeklyDrawFetched,
//       baseProvider.userWeeklyBoards,
//       _activeTambolaCardCount),
