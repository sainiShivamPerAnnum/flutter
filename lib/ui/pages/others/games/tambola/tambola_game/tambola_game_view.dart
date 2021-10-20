import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/network_bar.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_game/tambola_game_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
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
                          actions: [FelloCoinBar()],
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
                                    SizedBox(height: SizeConfig.padding16),
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
                          color: Colors.white,
                        ),
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
                                      color: UiConstants.primaryLight,
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
                                  Container(
                                    width: SizeConfig.screenWidth * 0.135,
                                    height: SizeConfig.screenWidth * 0.135,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness12),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.remove),
                                      color: Colors.black,
                                      onPressed: model.decreaseTicketCount,
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
    if (!model.tambolaService.weeklyDrawFetched ||
        !model.tambolaService.weeklyTicksFetched) {
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
    } else if (model.tambolaService.userWeeklyBoards == null ||
        model.activeTambolaCardCount == 0) {
      _widget = Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: model.ticketsBeingGenerated
                ? SizeConfig.screenWidth * 0.9
                : SizeConfig.padding20,
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
                  : Text('No tickets yet'),
            ),
          ),
        ),
      );
    } else {
      if (model.topFiveTambolaBoards.isEmpty) {
        model.refreshBestBoards().forEach((element) {
          model.topFiveTambolaBoards.add(model.buildBoardView(element));
        });
      }

      _widget = Container(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins,
                      vertical: SizeConfig.blockSizeHorizontal * 2),
                  child: Row(
                    children: [
                      Text(
                        "My Tickets (${model.activeTambolaCardCount})",
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: SizeConfig.cardTitleTextSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: model.showAllBoards,
                        highlightColor:
                            UiConstants.primaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: UiConstants.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            "Show All",
                            style: GoogleFonts.montserrat(
                              color: UiConstants.primaryColor,
                              fontSize: SizeConfig.mediumTextSize,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: SizeConfig.screenWidth * 0.95,
                  width: SizeConfig.screenWidth,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: List.generate(model.topFiveTambolaBoards.length,
                        (index) => model.topFiveTambolaBoards[index]),
                  ),
                ),
              ],
            ),
            if (model.ticketsBeingGenerated)
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
      );

      // if (model.currentBoardView == null)
      //   model.currentBoardView = Ticket(
      //     bgColor: FelloColorPalette.tambolaTicketColorPalettes()[0].boardColor,
      //     boardColorEven:
      //         FelloColorPalette.tambolaTicketColorPalettes()[0].itemColorEven,
      //     boardColorOdd:
      //         FelloColorPalette.tambolaTicketColorPalettes()[0].itemColorOdd,
      //     boradColorMarked:
      //         FelloColorPalette.tambolaTicketColorPalettes()[0].itemColorMarked,
      //     calledDigits: [],
      //     board: null,
      //   );
      // if (model.currentBoard == null)
      //   model.currentBoard = model.tambolaService.userWeeklyBoards[0];
    }
    return _widget;
  }
}


// if (showCardSummary)
//   _buildTicketSummaryCards(
//       baseProvider.weeklyTicksFetched,
//       baseProvider.weeklyDrawFetched,
//       baseProvider.userWeeklyBoards,
//       _activeTambolaCardCount),