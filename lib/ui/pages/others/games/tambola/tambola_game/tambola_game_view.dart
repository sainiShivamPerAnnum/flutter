import 'dart:io';

import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
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
                                    // For TESTING
                                    // Padding(
                                    //   padding: EdgeInsets.all(40),
                                    //   child: ElevatedButton(
                                    //     child: Text("Results"),
                                    //     onPressed: () => AppState
                                    //         .delegate
                                    //         .appState
                                    //         .currentAction = PageAction(
                                    //       state: PageState.addWidget,
                                    //       page: TWeeklyResultPageConfig,
                                    //       widget: WeeklyResult(
                                    //         winningsmap: {}, // {"12324": 1},
                                    //         isEligible: false,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    connectivityStatus !=
                                            ConnectivityStatus.Offline
                                        ? buildCards(model)
                                        : Center(
                                            child: NetworkBar(
                                              textColor: Colors.black,
                                            ),
                                          ),
                                    SizedBox(height: SizeConfig.padding20),
                                    (Platform.isIOS)
                                        ? Text(
                                            'Apple is not associated with Fello Tambola',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w100,
                                                fontSize:
                                                    SizeConfig.mediumTextSize,
                                                color: Colors.blueGrey),
                                          )
                                        : Container(),
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
                                        onChanged: (String text) {
                                          model.updateTicketCount();
                                        },
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
                                          model.buyTickets(context);
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
                                  '${model.ticketPurchaseCost} tokens = 1 Tambola ticket',
                                  style: TextStyles.body3.colour(Colors.grey),
                                ),
                                Spacer(),
                                Text(
                                  "Requires ${model.buyTicketCount * 10} ",
                                  style: TextStyles.body3,
                                ),
                                SvgPicture.asset(
                                  Assets.tokens,
                                  height: SizeConfig.iconSize1,
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
    if (!model.weeklyTicksFetched || !model.weeklyDrawFetched) {
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
                      text: "You do not have any Tambola tickets",
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
