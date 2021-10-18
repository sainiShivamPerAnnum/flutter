import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/network_bar.dart';
import 'package:felloapp/ui/elements/tambola-global/prize_section.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_game/tambola_game_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/tambola_faq_section.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
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
      onModelReady: (model) => model.init(),
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
                      ? model.buildCards()
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
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: SizeConfig.padding12),
                                      Container(
                                        width: SizeConfig.screenWidth * 0.2,
                                        child: TextField(
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
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.black,
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
}
