import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/network_bar.dart';
import 'package:felloapp/ui/elements/tambola-global/prize_section.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_game/tambola_game_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/tambola_faq_section.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TambolaGameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);
    return BaseView<TambolaGameViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  PicksCardView(),
                  // if (showCardSummary)
                  //   _buildTicketSummaryCards(
                  //       baseProvider.weeklyTicksFetched,
                  //       baseProvider.weeklyDrawFetched,
                  //       baseProvider.userWeeklyBoards,
                  //       _activeTambolaCardCount),

                  connectivityStatus != ConnectivityStatus.Offline
                      ? buildCards(model)
                      : Center(
                          child: NetworkBar(
                            textColor: Colors.black,
                          ),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    padding: EdgeInsets.all(SizeConfig.padding12),
                    margin: EdgeInsets.all(SizeConfig.globalMargin),
                    child: Column(
                      children: [
                        Text(
                          "Buy Tickets",
                          style: TextStyles.title3.bold.colour(Colors.white),
                        ),
                        SizedBox(height: SizeConfig.padding8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextFieldLabel("Enter the ticket count"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: model.decreaseTicketCount,
                                          icon: Text(
                                            "-",
                                            style: TextStyles.title3.bold
                                                .colour(Colors.black),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.padding12),
                                      Container(
                                        width: SizeConfig.screenWidth * 0.2,
                                        child: TextField(
                                          enabled: false,
                                          controller:
                                              model.ticketCountController,
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.white,
                                          style: TextStyles.body2.bold
                                              .colour(Colors.white),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      SizeConfig.roundness12),
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      SizeConfig.roundness12),
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.padding12),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: model.increaseTicketCount,
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextFieldLabel("Available Coins"),
                                Text(
                                  "200",
                                  style: TextStyles.body1.colour(Colors.white),
                                ),
                                SizedBox(height: SizeConfig.padding16),
                                TextFieldLabel("Required Coins"),
                                Text(
                                  "100",
                                  style: TextStyles.body1.colour(Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.padding16),
                        FelloButtonLg(
                          color: UiConstants.tertiarySolid,
                          child: model.ticketBuyInProgress
                              ? SpinKitThreeBounce(
                                  color: Colors.white,
                                  size: SizeConfig.body2,
                                )
                              : Text("Buy",
                                  style: TextStyles.body2.colour(Colors.white)),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            model.buyTickets();
                          },
                        )
                      ],
                    ),
                  ),
                  PrizeSection(),
                  TambolaFaqSection()
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
      _widget = Padding(
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
                  )
                : Text('No tickets yet'),
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
        height: SizeConfig.screenWidth * 0.95,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 3,
                      vertical: SizeConfig.blockSizeHorizontal * 2),
                  child: Row(
                    children: [
                      Text(
                        "My Tickets ($model.activeTambolaCardCount)",
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

      if (model.currentBoardView == null)
        model.currentBoardView = Ticket(
          bgColor: FelloColorPalette.tambolaTicketColorPalettes()[0].boardColor,
          boardColorEven:
              FelloColorPalette.tambolaTicketColorPalettes()[0].itemColorEven,
          boardColorOdd:
              FelloColorPalette.tambolaTicketColorPalettes()[0].itemColorOdd,
          boradColorMarked:
              FelloColorPalette.tambolaTicketColorPalettes()[0].itemColorMarked,
          calledDigits: [],
          board: null,
        );
      if (model.currentBoard == null)
        model.currentBoard = model.tambolaService.userWeeklyBoards[0];
    }
    return _widget;
  }
}
